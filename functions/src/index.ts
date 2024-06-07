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
import * as path from "path";
import * as os from "os";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

export const onVideoCreated = functions.firestore
    .document("videos/{videoId}")
    .onCreate(async (snapshot, context) => {
            const video = snapshot.data();
            console.log('############### video:', video.fileUrl, video);
            
            let videoUrl = video.fileUrl;
            videoUrl = videoUrl.substring(videoUrl.indexOf('/videos') + 1);
            
            const thumbnailLocation = `/tmp/${ snapshot.id }.jpg`;
            const spawn = require("child-process-promise").spawn;
            await spawn("ffmpeg", [
                // 비디오 인풋
                "-i",
                path.join(os.tmpdir(), `${ snapshot.id }.mp4`),
                // 영상의 지정 위치로 이동
                "-ss",
                "00:00:01.000",
                // 원하는 프레임
                "-vframes",
                "1",
                // 비디오 필 -> 화질(scale) > 너비 150 : 높이 비율에 맞춤 -1
                "-vf",
                "scale=150:-1",
                // 저장 위치
                thumbnailLocation,
            ]);
            
            console.log('############### process started');
            const storage = admin.storage();
            const [ file, _ ] = await storage
                .bucket()
                .upload(thumbnailLocation,
                    { destination: `thumbnails/${ snapshot.id }.jpg` }
                );
            
            console.log('###############', file.publicUrl(), file);
            await file.makePublic();
            await snapshot.ref.update({ thumbnailURL: file.publicUrl() });
        }
    );

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
