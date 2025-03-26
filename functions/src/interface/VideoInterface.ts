interface VideoInterface {
    id: string;
    title: string;
    description: string;
    fileUrl: string;
    thumbnailURL: string;
    uploader: string;
    uploaderUid: string;
    likes: number;
    comments: number;
    createdAt: number;
}

interface CommentInterface {
    videoId: string;
    commentId: string;
    text: string;
    userId: string;
    username: string;
    likes: number;
    createdAt: number;
    updatedAt: number;
}

interface ThumbnailLinkInterface {
    videoId: string;
    thumbnailUrl: string;
    createdAt: number;
}
