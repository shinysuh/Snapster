import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Firestore 초기화
admin.initializeApp();

export const onVideoCreated = functions.firestore
    .document("videos/{videoId}")
    .onCreate(async (snapshot, context) => {
        const video = snapshot.data();
        
        if(!video) {
            console.error('No video data found');
            return;
        }
        
        // console.log('*************** video:', video.fileUrl, video);
        
        const id = snapshot.id;
        let videoUrl = video.fileUrl;
        
        const thumbnailLocation = `/tmp/${ id }.jpg`;
        const spawn = require("child-process-promise").spawn;
        
        try {
            await spawn("ffmpeg", [
                "-i",
                videoUrl,
                "-ss",
                "00:00:01.000",
                "-vframes",
                "1",
                "-vf",
                "scale=150:-1",
                thumbnailLocation,
            ]);
            
            const storage = admin.storage();
            const [ file ] = await storage.bucket().upload(thumbnailLocation, {
                destination: `thumbnails/${ id }.jpg`
            });
            
            await file.makePublic();
            
            await snapshot.ref.update({ thumbnailURL: file.publicUrl() });
            
            const db = admin.firestore();
            console.log(`Updating user's video collection for uploaderUid: ${ video.uploaderUid }`);
            
            // Firestore operation
            try {
                await db.collection('users')
                    .doc(video.uploaderUid)
                    .collection('videos')
                    .doc(id)
                    .set({
                        thumbnailUrl: file.publicUrl(),
                        videoId: id,
                    });
                console.log(`******** User's video document created successfully`);
            } catch(error) {
                console.error("Error creating user's video document:", error);
            }
        } catch(e) {
            console.error("Error processing video:", e);
        }
    });
