/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";
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
            
            /* 계속되는 컬럭션 미생성 및 콘솔 에러 로그 미출력으로 인해 VM 단으로 로직 이동 */
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


// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// import * as path from "path";
// import * as os from "os";
// import * as fs from "fs";
// import * as ffmpeg from "fluent-ffmpeg";
// import * as ffmpegPath from "ffmpeg-static";
//
// admin.initializeApp();
//
// // @ts-ignore
// ffmpeg.setFfmpegPath(ffmpegPath);
//
// export const onVideoCreated = functions.firestore
//     .document("videos/{videoId}")
//     .onCreate(async (snapshot, context) => {
//         const video = snapshot.data();
//         if(!video) {
//             console.error("No video data found in snapshot");
//             return;
//         }
//
//         const fileUrl = video.fileUrl;
//         const bucketName = "tiktok-clone-jenn.appspot.com";
//
//         let filePath: string;
//         try {
//             const url = new URL(fileUrl);
//             const pathname = decodeURIComponent(url.pathname);
//             filePath = pathname.split('/o/')[1].split('?')[0];
//         } catch(error) {
//             console.error("Error parsing file URL:", error);
//             return;
//         }
//
//         const tempLocalFile = path.join(os.tmpdir(), `${ snapshot.id }.mp4`);
//         const tempLocalThumbFile = path.join(os.tmpdir(), `${ snapshot.id }.jpg`);
//
//         const bucket = admin.storage().bucket(bucketName);
//         try {
//             await bucket.file(filePath).download({ destination: tempLocalFile });
//         } catch(error) {
//             console.error("Error downloading video file:", error);
//             return;
//         }
//
//         return new Promise<void>((resolve, reject) => {
//             ffmpeg(tempLocalFile)
//                 .screenshots({
//                     timestamps: [ '1' ],
//                     filename: `${ snapshot.id }.jpg`,
//                     folder: os.tmpdir(),
//                     size: '150x?'
//                 })
//                 .on('end', async () => {
//                     try {
//                         await bucket.upload(tempLocalThumbFile, {
//                             destination: `thumbnails/${ snapshot.id }.jpg`
//                         });
//
//                         fs.unlinkSync(tempLocalFile);
//                         fs.unlinkSync(tempLocalThumbFile);
//
//                         const thumbnailURL = `https://storage.googleapis.com/${ bucketName }/thumbnails/${ snapshot.id }.jpg`;
//                         await snapshot.ref.update({ thumbnailURL });
//                         resolve();
//                     } catch(error) {
//                         console.error("Error uploading thumbnail or updating Firestore:", error);
//                         reject(error);
//                     }
//                 })
//                 .on('error', (error) => {
//                     console.error("Error creating thumbnail:", error);
//                     reject(error);
//                 });
//         });
//     });
//


///////
// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// import * as path from "path";
// import * as os from "os";
// import * as fs from "fs";
// import * as ffmpeg from "fluent-ffmpeg";
// import * as ffmpegPath from "ffmpeg-static";
//
// admin.initializeApp();
//
// // @ts-ignore
// ffmpeg.setFfmpegPath(ffmpegPath);
//
// export const onVideoCreated = functions.firestore
//     .document("videos/{videoId}")
//     .onCreate(async (snapshot, context) => {
//         const video = snapshot.data();
//         if(!video) {
//             console.log("No video data found in snapshot");
//             return;
//         }
//
//         console.log('############### video:', video.fileUrl, video);
//
//         // Firebase Storage URL에서 파일 경로 추출
//         const fileUrl = video.fileUrl;
//         const bucketName = "tiktok-clone-jenn.appspot.com";
//
//         let filePath: string;
//         try {
//             const url = new URL(fileUrl);
//             const pathname = decodeURIComponent(url.pathname);
//             filePath = pathname.split('/o/')[1].split('?')[0];
//         } catch(error) {
//             console.error("Error parsing file URL:", error);
//             return;
//         }
//
//         const tempLocalFile = path.join(os.tmpdir(), `${ snapshot.id }.mp4`);
//         const tempLocalThumbFile = path.join(os.tmpdir(), `${ snapshot.id }.jpg`);
//
//         // 비디오 파일 다운로드
//         const bucket = admin.storage().bucket(bucketName);
//         try {
//             console.log(`Downloading video file from gs://${ bucketName }/${ filePath } to ${ tempLocalFile }`);
//             await bucket.file(filePath).download({ destination: tempLocalFile });
//             console.log("Video file downloaded successfully");
//         } catch(error) {
//             console.error("Error downloading video file:", error);
//             return;
//         }
//
//         return new Promise<void>((resolve, reject) => {
//             ffmpeg(tempLocalFile)
//                 .screenshots({
//                     timestamps: [ '1' ],
//                     filename: `${ snapshot.id }.jpg`,
//                     folder: os.tmpdir(),
//                     size: '150x?'
//                 })
//                 .on('end', async () => {
//                     console.log("Thumbnail created successfully");
//                     try {
//                         console.log(`Uploading thumbnail to thumbnails/${ snapshot.id }.jpg`);
//                         await bucket.upload(tempLocalThumbFile, {
//                             destination: `thumbnails/${ snapshot.id }.jpg`
//                         });
//                         console.log("Thumbnail uploaded successfully");
//
//                         fs.unlinkSync(tempLocalFile);
//                         fs.unlinkSync(tempLocalThumbFile);
//
//                         const thumbnailURL = `https://storage.googleapis.com/${ bucketName }/thumbnails/${ snapshot.id }.jpg`;
//                         console.log(`Updating Firestore document with thumbnail URL: ${ thumbnailURL }`);
//                         await snapshot.ref.update({ thumbnailURL });
//                         resolve();
//                     } catch(error) {
//                         console.error("Error uploading thumbnail or updating Firestore:", error);
//                         reject(error);
//                     }
//                 })
//                 .on('error', (error) => {
//                     console.error("Error creating thumbnail:", error);
//                     reject(error);
//                 });
//         });
//     });