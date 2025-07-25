import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Firestore 초기화
admin.initializeApp();

const userCollection = 'users';
const videoCollection = 'videos';
const likeCollection = 'likes';
const commentCollection = 'comments';
const chatroomCollection = 'chat_rooms';
const textCollection = 'texts';
const commonIdDivider = '%00000%';
const systemId = 'system_message';

export const onVideoCreated = functions
    .runWith({ memory: '512MB' }) // 메모리 한도를 512MB로 증가
    .firestore
    .document(`${ videoCollection }/{videoId}`)
    .onCreate(async (snapshot, context) => {
            const video = snapshot.data() as VideoInterface;
            
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
                
                const dataSet: ThumbnailLinkInterface = {
                    thumbnailUrl: file.publicUrl(),
                    videoId: id,
                    createdAt: video.createdAt,
                };
                // Firestore operation
                try {
                    await db.collection(userCollection)
                        .doc(video.uploaderUid)
                        .collection(videoCollection)
                        .doc(id)
                        .set(dataSet);
                    
                    console.log(`******** User's video document created successfully`);
                } catch(error) {
                    console.error("Error creating user's video document:", error);
                }
            } catch(e) {
                console.error("Error processing video:", e);
            }
        }
    );

export const onVideoDeleted = functions.firestore
    .document(`${ videoCollection }/{videoId}`)
    .onDelete(async (snapshot, context) => {
            // TODO - 비디오 삭제 시, like / comment 관련 데이터 및 컬렉션 삭제 필요
            // const video = snapshot.data();
        }
    );


export const onLiked = functions.firestore
    .document(`${ likeCollection }/{likeId}`)
    .onCreate(async (snapshot, context) => {
            const [ videoId, userId ] = snapshot.id.split(commonIdDivider);
            const likeData = snapshot.data() as ThumbnailLinkInterface;
            
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
                        videoId: videoId,
                        thumbnailUrl: likeData.thumbnailUrl,
                        createdAt: likeData.createdAt,
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

export const onCommentAdded = functions.firestore
    .document(`${ videoCollection }/{videoId}/${ commentCollection }/{commentId}`)
    .onCreate(async (snapshot, context) => {
            const videoId = context.params.videoId;
            let comment = snapshot.data() as CommentInterface;
            comment = { ...comment, commentId: snapshot.id };
            
            const db = admin.firestore();
            
            await db.collection(videoCollection)
                .doc(videoId)
                .update({ comments: admin.firestore.FieldValue.increment(1) });
            
            await
                db.collection(userCollection)
                    .doc(comment.userId)
                    .collection(commentCollection)
                    .doc(videoId)
                    .collection(commentCollection)
                    .doc(comment.commentId)
                    .set(comment);
        }
    );

export const onCommentUpdated = functions.firestore
    .document(`${ videoCollection }/{videoId}/${ commentCollection }/{commentId}`)
    .onUpdate(async (snapshot, context) => {
            const videoId = context.params.videoId;
            let comment = snapshot.after.data();
            
            const db = admin.firestore();
            
            await
                db.collection(userCollection)
                    .doc(comment.userId)
                    .collection(commentCollection)
                    .doc(videoId)
                    .collection(commentCollection)
                    .doc(comment.commentId)
                    .update(comment);
        }
    );

export const onCommentDeleted = functions.firestore
    .document(`${ videoCollection }/{videoId}/${ commentCollection }/{commentId}`)
    .onDelete(async (snapshot, context) => {
            const videoId = context.params.videoId;
            const comment = snapshot.data() as CommentInterface;
            
            const db = admin.firestore();
            
            await db.collection(videoCollection)
                .doc(videoId)
                .update({ comments: admin.firestore.FieldValue.increment(-1) });
            
            await db.collection(userCollection)
                .doc(comment.userId)
                .collection(commentCollection)
                .doc(videoId)
                .collection(commentCollection)
                .doc(comment.commentId)
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
            
            const inviterChatPartnerInfo: ChatPartnerInterface = {
                chatroomId: chatroomId,
                chatPartner: invitee,
                updatedAt: chatroomData.updatedAt,
                showMsgFrom: 0,
            }
            const inviteeChatPartnerInfo: ChatPartnerInterface = {
                chatroomId: chatroomId,
                chatPartner: inviter,
                updatedAt: chatroomData.updatedAt,
                showMsgFrom: 0,
            }
            
            
            await db.collection(userCollection)
                .doc(inviter.uid)
                .collection(chatroomCollection)
                .doc(chatroomId)
                .set(inviterChatPartnerInfo);
            
            await db.collection(userCollection)
                .doc(invitee.uid)
                .collection(chatroomCollection)
                .doc(chatroomId)
                .set(inviteeChatPartnerInfo);
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
        
        const isPersonAUpdated = JSON.stringify(oldChatroomData.personA) !== JSON.stringify(newChatroomData.personA);
        
        let updatedOne: ChatterInterface;
        let notUpdatedOne: ChatterInterface;
        if(isPersonAUpdated) {
            updatedOne = newChatroomData.personA;
            notUpdatedOne = newChatroomData.personB;
        } else {
            updatedOne = newChatroomData.personB;
            notUpdatedOne = newChatroomData.personA;
        }
        
        const isPersonAParticipating = newChatroomData.personA.isParticipating;
        const isPersonBParticipating = newChatroomData.personB.isParticipating;
        
        if(isPersonAParticipating && isPersonBParticipating) {
            await db.collection(userCollection)
                .doc(updatedOne.uid)
                .collection(chatroomCollection)
                .doc(chatroomId)
                .set({
                    chatroomId: chatroomId,
                    chatPartner: notUpdatedOne,
                    updatedAt: newChatroomData.updatedAt,
                    showMsgFrom: updatedOne.showMsgFrom,
                });
        } else {
            await db.collection(userCollection)
                .doc(updatedOne.uid)
                .collection(chatroomCollection)
                .doc(chatroomId)
                .delete();
            
            const textCollectionRef = db.collection(chatroomCollection).doc(chatroomId).collection(textCollection);
            let hasMore = true;
            while(hasMore) {
                const textDocs = await textCollectionRef.where('createdAt', '<', notUpdatedOne.showMsgFrom).limit(500).get();
                if(textDocs.empty) {
                    hasMore = false;
                } else {
                    const batch = db.batch();
                    textDocs.forEach(doc => batch.delete(doc.ref));
                    await batch.commit();
                }
            }
        }
        
        await db.collection(userCollection)
            .doc(notUpdatedOne.uid)
            .collection(chatroomCollection)
            .doc(chatroomId)
            .update({
                chatroomId: chatroomId,
                chatPartner: updatedOne,
                updatedAt: newChatroomData.updatedAt,
            });
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
                await deleteCollections(personAChatroomRef, textCollection);
                await deleteCollections(personBChatroomRef, textCollection);
                
                // chatroom 문서 삭제
                transaction.delete(personAChatroomRef);
                transaction.delete(personBChatroomRef);
                
                // 상위 chatroom 컬렉션 하위 컬렉션도 삭제
                const chatroomDocRef = db.collection(chatroomCollection).doc(chatroomId);
                await deleteCollections(chatroomDocRef, textCollection);
                
                // 최종적으로 상위 chatroom 문서 삭제
                transaction.delete(chatroomDocRef);
            });
        }
    );

export const onTextCreated = functions.firestore
    .document(`${ chatroomCollection }/{chatroomId}/${ textCollection }/{textId}`)
    .onCreate(async (snapshot, context) => {
        // const chatroomId = context.params.chatroomId;
        // const textId = context.params.textId;  // snapshot.id
        // const textData = snapshot.data() as MessageInterface;
        // const db = admin.firestore();
        
        // chatroom - updatedAt 업데이트 => updatedAt 만 남고 다 사라짐
        // TODO => 그렇다고 매번 vm 단에서 채팅방 업데이트 하기는 비효율적
        // await db.collection(chatroomCollection)
        //     .doc(chatroomId)
        //     .set({ updatedAt: Timestamp.now().toMillis() });
    });

export const onTextUpdated = functions.firestore
    .document(`${ chatroomCollection }/{chatroomId}/${ textCollection }/{textId}`)
    .onUpdate(async (snapshot, context) => {
        /* TODO
            1) chatroom - updatedAt 업데이트 하기
            2) SystemMessage => {systemId}:::deleted (userId 는 유저 본인 거로)
            3) 출력 시, [삭제된 메세지입니다] / [Deleted message] 로 변경
        *    */
        
        console.log(systemId);
        
        
        // const chatroomId = snapshot.before.id;
        // console.log('###################### updated id:', snapshot.before.id);
        // console.log('###################### before:', snapshot.before.data())
        // console.log('###################### after:', snapshot.after.data())
        const oldText = snapshot.before.data() as ChatroomInterface;
        const newText = snapshot.after.data() as ChatroomInterface;
        // const db = admin.firestore();
        
        if(!oldText || !newText) return;
        
        // const isPersonALeaving = !newChatroomData.personA.isParticipating;
        //
        // let leaver: ChatterInterface;
        // let remainder: ChatterInterface;
        //
        // if(isPersonALeaving) {
        //     leaver = newChatroomData.personA;
        //     remainder = newChatroomData.personB;
        // } else {
        //     leaver = newChatroomData.personB;
        //     remainder = newChatroomData.personA;
        // }
        //
        // // 나가기 한 사람 user 하위 컬렉션에서 chatroom 정보 삭제
        // await db.collection(userCollection)
        //     .doc(leaver.uid)
        //     .collection(chatroomCollection)
        //     .doc(chatroomId)
        //     .delete();
        //
        // // 상대방 user 하위 chat_rooms 컬렉션에서 chatPartner - isParticipating=false
        // await db.collection(userCollection)
        //     .doc(remainder.uid)
        //     .collection(chatroomCollection)
        //     .doc(chatroomId)
        //     .update(
        //         {
        //             chatroomId: chatroomId,
        //             chatPartner: leaver,
        //             updatedAt: newChatroomData.updatedAt,
        //         }
        //     );
    });