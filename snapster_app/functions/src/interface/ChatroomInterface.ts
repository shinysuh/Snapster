interface ChatroomInterface {
    chatroomId: string;
    personA: ChatterInterface;
    personB: ChatterInterface;
    createdAt: number;
    updatedAt: number;
}

interface ChatterInterface {
    uid: string;
    name: string;
    username: string;
    hasProfileImage: boolean;
    isParticipating: boolean;
    recentlyReadAt: number;
    showMsgFrom: number;
}

interface ChatPartnerInterface {
    chatroomId: string;
    chatPartner: ChatterInterface;
    updatedAt: number;
    showMsgFrom: number;
}

interface MessageInterface {
    text: string;
    userId: string;
    createdAt: number;
}
