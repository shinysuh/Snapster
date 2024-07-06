import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { firestore } from "firebase-admin";
import Timestamp = firestore.Timestamp;

// Firestore 초기화
admin.initializeApp();

const userCollection = 'users';
const videoCollection = 'videos';
const likeCollection = 'likes';
const chatroomCollection = 'chat_rooms';
const textollection = 'texts';
const commonIdDivider = '%00000%';

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
        }
    );

export const onLiked = functions.firestore
    .document(`${ likeCollection }/{likeId}`)
    .onCreate(async (snapshot, context) => {
            const [ videoId, userId ] = snapshot.id.split(commonIdDivider);
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
            
        }
    );

export const onUnliked = functions.firestore
    .document(`${ likeCollection }/{likeId}`)
    .onDelete(async (snapshot, context) => {
            const [ videoId, userId ] = snapshot.id.split(commonIdDivider);
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
        }
    );

export const onChatroomCreated = functions.firestore
    .document(`${ chatroomCollection }/{chatroomId}`)
    .onCreate(async (snapshot, context) => {
            const chatroomId = snapshot.id;
            const chatroomData = snapshot.data() as ChatroomInterface;
            const db = admin.firestore();
            
            const inviter = chatroomData.personA;
            const invitee = chatroomData.personB;
            
            await db.collection(userCollection)
                .doc(inviter.uid)
                .collection(chatroomCollection)
                .doc(chatroomId)
                .set({
                    chatroomId: chatroomId,
                    chatPartner: invitee,
                    updatedAt: chatroomData.updatedAt,
                });
            
            await db.collection(userCollection)
                .doc(invitee.uid)
                .collection(chatroomCollection)
                .doc(chatroomId)
                .set({
                    chatroomId: chatroomId,
                    chatPartner: inviter,
                    updatedAt: chatroomData.updatedAt,
                });
        }
    );

export const onChatroomUpdated = functions.firestore
    .document(`${ chatroomCollection }/{chatroomId}`)
    .onUpdate(async (snapshot, context) => {
        const chatroomId = snapshot.before.id;
        const oldChatroomData = snapshot.before.data() as ChatroomInterface;
        const newChatroomData = snapshot.after.data() as ChatroomInterface;
        const db = admin.firestore();
        
        if(!oldChatroomData || !newChatroomData) return;
        
        const isPersonALeaving = !newChatroomData.personA.isParticipating;
        
        let leaver: ChatterInterface;
        let remainder: ChatterInterface;
        
        if(isPersonALeaving) {
            leaver = newChatroomData.personA;
            remainder = newChatroomData.personB;
        } else {
            leaver = newChatroomData.personB;
            remainder = newChatroomData.personA;
        }
        
        // 나가기 한 사람 user 하위 컬렉션에서 chatroom 정보 삭제
        await db.collection(userCollection)
            .doc(leaver.uid)
            .collection(chatroomCollection)
            .doc(chatroomId)
            .delete();
        
        // 상대방 user 하위 chat_rooms 컬렉션에서 chatPartner - isParticipating=false
        await db.collection(userCollection)
            .doc(remainder.uid)
            .collection(chatroomCollection)
            .doc(chatroomId)
            .update(
                {
                    chatroomId: chatroomId,
                    chatPartner: leaver,
                    updatedAt: newChatroomData.updatedAt,
                }
            );
    });

export const onChatroomDeleted = functions.firestore
    .document(`${ chatroomCollection }/{chatroomId}`)
    .onDelete(async (snapshot, context) => {
            const chatroomId = snapshot.id;
            const chatroomData = snapshot.data() as ChatroomInterface;
            const db = admin.firestore();
            
            const deleteCollections = async (docRef: FirebaseFirestore.DocumentReference, subCollectionName: string) => {
                const subCollectionRef = docRef.collection(subCollectionName);
                const snapshot = await subCollectionRef.get();
                const batch = db.batch();
                
                snapshot.forEach(doc => {
                    batch.delete(doc.ref);
                });
                
                await batch.commit();
            };
            
            // transaction 사용해서 모든 삭제 작업을 처리
            await db.runTransaction(async (transaction) => {
                // 양쪽 대화자 하위 컬렉션에서 해당 chatroom 정보 제거
                const personAChatroomRef = db.collection(userCollection)
                    .doc(chatroomData.personA.uid)
                    .collection(chatroomCollection)
                    .doc(chatroomId);
                const personBChatroomRef = db.collection(userCollection)
                    .doc(chatroomData.personB.uid)
                    .collection(chatroomCollection)
                    .doc(chatroomId);
                
                // 해당 chatroom 문서의 하위 texts 컬렉션 삭제
                await deleteCollections(personAChatroomRef, textollection);
                await deleteCollections(personBChatroomRef, textollection);
                
                // chatroom 문서 삭제
                transaction.delete(personAChatroomRef);
                transaction.delete(personBChatroomRef);
                
                // 상위 chatroom 컬렉션 하위 컬렉션도 삭제
                const chatroomDocRef = db.collection(chatroomCollection).doc(chatroomId);
                await deleteCollections(chatroomDocRef, textollection);
                
                // 최종적으로 상위 chatroom 문서 삭제
                transaction.delete(chatroomDocRef);
            });
        }
    );