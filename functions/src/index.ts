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
        
        console.log('############### video:', video.fileUrl, video);
        
        const id = snapshot.id;
        let videoUrl = video.fileUrl;
        videoUrl = `${ videoUrl.substring(videoUrl.indexOf('/videos') + 1) }.mp4`;
        
        const thumbnailLocation = `/tmp/${ id }.jpg`;
        const spawn = require("child-process-promise").spawn;
        
        try {
            await spawn("ffmpeg", [
                "-i",
                // path.join(os.tmpdir(), `${ id }.mp4`),
                videoUrl,
                "-ss",
                "00:00:01.000",
                "-vframes",
                "1",
                "-vf",
                "scale=150:-1",
                thumbnailLocation,
            ]);
            
            console.log('############### process started');
            const storage = admin.storage();
            const [ file ] = await storage.bucket().upload(thumbnailLocation, {
                destination: `thumbnails/${ id }.jpg`
            });
            
            console.log('###############', file.publicUrl());
            await file.makePublic();
            
            await snapshot.ref.update({ thumbnailURL: file.publicUrl() });
            
            /* 계속되는 컬럭션 미생성 및 콘솔 에러 로그 미출력으로 인해 VM단(프론트단)으로 로직 이동 */
            // const db = admin.firestore();
            // console.log(`Updating user's video collection for uploaderUid: ${ video.uploaderUid }`);
            //
            // // Firestore operation
            // try {
            //     await db.collection('users')
            //         .doc(video.uploaderUid)
            //         .collection('videos')
            //         .doc(id)
            //         .set({
            //             thumbnailUrl: file.publicUrl(),
            //             videoId: id,
            //         });
            //     console.log(`######## User's video document created successfully`);
            // } catch(error) {
            //     console.error("Error creating user's video document:", error);
            // }
        } catch(e) {
            console.error("Error processing video:", e);
        }
    });


// // 니코쌤 코드
// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
//
// admin.initializeApp();
//
// export const onVideoCreated = functions.firestore
//     .document("videos/{videoId}")
//     .onCreate(async (snapshot, context) => {
//         const spawn = require("child-process-promise").spawn;
//         const video = snapshot.data();
//         await spawn("ffmpeg", [
//             "-i",
//             video.fileUrl,
//             "-ss",
//             "00:00:01.000",
//             "-vframes",
//             "1",
//             "-vf",
//             "scale=150:-1",
//             `/tmp/${ snapshot.id }.jpg`,
//         ]);
//         const storage = admin.storage();
//         const [ file, _ ] = await storage.bucket().upload(`/tmp/${ snapshot.id }.jpg`, {
//             destination: `thumbnails/${ snapshot.id }.jpg`,
//         });
//         await file.makePublic();
//         await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });
//         const db = admin.firestore();
//         await db
//             .collection("users")
//             .doc(video.uploaderUid)
//             .collection("videos")
//             .doc(snapshot.id)
//             .set({
//                 thumbnailUrl: file.publicUrl(),
//                 videoId: snapshot.id,
//             });
//     });