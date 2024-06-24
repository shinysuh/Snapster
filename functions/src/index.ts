import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { firestore } from "firebase-admin";
import Timestamp = firestore.Timestamp;

// Firestore 초기화
admin.initializeApp();

const userCollection = 'users';
const videoCollection = 'videos';
const likeCollection = 'likes';

export const onVideoCreated = functions.firestore
    .document(`${ videoCollection }/{videoId}`)
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
                await db.collection(userCollection)
                    .doc(video.uploaderUid)
                    .collection(videoCollection)
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

export const onLiked = functions.firestore
    .document(`${ likeCollection }/{likeId}`)
    .onCreate(async (snapshot, context) => {
        const [ videoId, userId ] = snapshot.id.split('000000');
        const db = admin.firestore();
        
        await db.collection(videoCollection)
            .doc(videoId)
            .update({ likes: admin.firestore.FieldValue.increment(1) });
        
        await
            db.collection(userCollection)
                .doc(userId)
                .collection(likeCollection)
                .doc(videoId)
                .set({
                    createdAt: Timestamp.now().toMillis(),
                });
        
    });

export const onUnliked = functions.firestore
    .document(`${ likeCollection }/{likeId}`)
    .onDelete(async (snapshot, context) => {
        const [ videoId, userId ] = snapshot.id.split('000000');
        const db = admin.firestore();
        
        await db.collection(videoCollection)
            .doc(videoId)
            .update({ likes: admin.firestore.FieldValue.increment(-1) });
        
        await
            db.collection(userCollection)
                .doc(userId)
                .collection(likeCollection)
                .doc(videoId)
                .delete();
    });
