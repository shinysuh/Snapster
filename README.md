# tiktok_clone

Flutter & Firebase 를 사용한 TikTok 클론 프로젝트

(강의: 노마드코더 https://nomadcoders.co/tiktok-clone/lobby)

<img width="475" alt="image" src="https://github.com/user-attachments/assets/9b226f9a-b9dc-4473-a125-eb5d299a6b5b">

### 👩‍🏫 PROJECT 소개

틱톡 클론은 **TikTok 앱의 UI 및 기능**(영상 녹화, 업로드, 유저 프로필, 댓글, 좋아요, DM 등)을 구현한 프로젝트입니다.

**✅ Github link**: [github.com/shinysuh/tiktok_clone](https://github.com/shinysuh/tiktok_clone)

📌 **프로젝트 목적**:

- **Flutter를 사용한 실제 모바일 애플리케이션 개발 경험**을 쌓기 위해 인기 앱인 **TikTok의 주요 기능을 복제**하여 기술 역량을 향상
- **동영상 소셜 네트워킹의 주요 요소**를 학습 및 구현

📒 **주요 업무**

- **회원가입, 로그인:**
    - **이메일/비밀번호**를 비롯한 **소셜 로그인** 기능 구현
- **Main navigation 구현:**
    - Riverpod의 Provider와 GoRouter를 결합하여 **상태 기반 라우팅 설정**
- **동영상 기능:**
    - **동영상 업로드:**
        - 동영상 업로드 시 **썸네일 생성** 및 Firebase 유저 하위 컬렉션에 **비디오 정보 저장**
        - 앱에서 직접 촬영한 경우, 촬영된 동영상 **다운로드 기능** 제공
        - 기기 앨범에서 **동영상 선택 후 업로드** 기능 구현
    - **동영상 화면:**
        - **좋아요, 댓글** 기능을 통해 다른 유저와 소통하는 기능 구현
        - 동영상 캡션 출력 시, 텍스트 길이에 따라 **최대 높이 조정 및 스크롤** 기능 적용
- **사용자 프로필:**
    - 프로필 페이지에 사용자가 **업로드한 게시물**과 **좋아요를 누른 게시물**의 썸네일 출력
    - 프로필 수정 페이지에서 **기본 정보 및 프로필 사진 편집** 기능 구현
- **다이렉트 메시지(DM):**
    - **대화 상대방** **선택 및 채팅방 생성** 기능 구현
    - 채팅방 **나가기 및 재참여** 기능 구현
    - 채팅방을 나간 대화 상대 **재초대** 기능 구현
    - 전송된 **메시지 삭제** 기능 구현 (전송 3분 이내)
- **기타 기능:**
    - 동영상 **음소거 및 자동 플레이 기본값 설정** 기능 지원
    - **l10n(Localization)**을 적용해 다중언어 지원
    - **테마 모드(다크모드)** 지원

👨‍💻 **투입 인원** :  

- **개발자** **(100%)** ✔️

**🌱  결과**

- **Flutter 실습 경험**:
    - 모바일 애플리케이션의 UI와 주요 기능을 구현함으로써 Flutter 개발 경험을 쌓음
- **주요 기능 구현**:
    - TikTok의 주요 기능을 성공적으로 복제하여 기술 역량을 향상
- **UI/UX 이해도 향상**:
    - 동영상 소셜 네트워킹 애플리케이션의 UI/UX 디자인에 대한 이해도 중가

### 1. 회원가입 / 로그인

- **이메일/비밀번호**를 비롯한 **소셜 로그인** 기능 구현

<img width="582" alt="image" src="https://github.com/user-attachments/assets/f77d0e5e-bac4-461e-a9bc-ee241fbc7278">


- **작업 내용:** Firebase 의 signInWithProvider() 함수 사용
    
![image](https://github.com/user-attachments/assets/d930cc45-a45b-454a-acba-b91b89f1ec47)

### 2. Main navigation

- 하단의 **navigation** 버튼을 통해 홈, Discover, 카메라 및 업로드, Inbox, 프로필 페이지로 이동 기능 구현

<img width="688" alt="image" src="https://github.com/user-attachments/assets/65cf4f40-d222-45e0-9498-4df4acf30b8c">

- **작업 내용:** Riverpod의 Provider와 GoRouter를 결합하여 상태 기반 라우팅 설정

<img width="729" alt="image" src="https://github.com/user-attachments/assets/28bff702-06dd-49cb-b3e9-52dd95bd2484">

### 3-1. 동영상 업로드

- **기기에서 동영상 촬영 및 업로드**
    - 촬영 버튼을 클릭 후, 세로방향으로 드래그해서 **zoom 기능** 사용
    - 미리보기 화면에서 촬영한 동영상 **다운로드 기능** 제공
    - 업로드 버튼을 클릭해 **동영상** **업로드**
        
<img width="652" alt="image" src="https://github.com/user-attachments/assets/e6344c90-7c83-42ff-aac1-201076039f65">

- 기기 앨범에서 **동영상 선택 후 업로드** 기능 구현

<img width="547" alt="image" src="https://github.com/user-attachments/assets/48fefe95-f3b9-4776-ad58-a71a6fabebef">
    

- **작업 내용:**
    - FirebaseStorage 에 동영상 파일 업로드
    - Firestore Database 에 videos 컬렉션에 동영상 정보 저장
    - 
<img width="645" alt="image" src="https://github.com/user-attachments/assets/061078b6-a718-4115-8ec7-d057de156712">

- **작업 내용: videos 컬렉션에 동영상 정보가 추가되면 index.ts 에서 썸네일 생성**
    - ffmpeg를 사용하여 썸네일 생성 & Firebase Storage 에 저장
    - 업로드된 썸네일 이미지의 공개 URL을 Firestore 문서에 업데이트
    - 비디오 id 와 썸네일 정보를 업로드 한 유저 정보 하위에 저장

<img width="333" alt="image" src="https://github.com/user-attachments/assets/9283fcf0-6139-4f7a-ae32-ee14e6579bf5">

### 3-2. 동영상 화면

- **좋아요, 댓글** 기능을 통해 다른 유저와 소통하는 기능 구현
- 동영상 캡션 출력 시, 텍스트 길이에 따라 **최대 높이 조정 및 스크롤** 기능 적용

<img width="582" alt="image" src="https://github.com/user-attachments/assets/1c79e2a0-ed75-4a4e-9ef2-02f91e3dadab">

- **작업 내용 (좋아요):**
    - 좋아요 toggle: Firestore Databse의 likes 컬렉션에 동영상 id 및 사용자 id 저장
    - likes 컬렉션에 문서가 추가되면 index.ts 에서 추가 작업 진행
        - videos 동영상 문서에 likes count + 1
        - 동영상 id와 썸네일URL을 좋아요 한 유저 정보 하위에 저장
    - 좋아요 취소 시, 위 정보 일괄 삭제

<img width="621" alt="image" src="https://github.com/user-attachments/assets/96aa85a7-37e3-471e-9593-ad0d38e204de">

- **작업 내용 (댓글):**
    - 댓글: videos 문서 하위에 comments 컬렉션을 생성해 댓글 정보 저장
    - comments 컬렉션에 문서가 추가되면 index.ts 에서 추가 작업 진행
        - videos 동영상 문서에 comments count + 1
        - 동영상 id와 댓글 정보를 유저 정보 하위에 저장
    - 댓글 삭제 시, 위 정보 일괄 삭제

<img width="649" alt="image" src="https://github.com/user-attachments/assets/36c2de2b-26d1-4bce-be6b-77e59b9621a1">

- **작업 내용 (캡션):**
    - 캡션 출력 시,
        - _calculateTextHeight(): 텍스트의 높이 계산
        - 계산된 높이에 따른 maxHeight 도출
        - AnimatedContainer 에 높이 적용
            
<img width="386" alt="image" src="https://github.com/user-attachments/assets/efb5be9c-cf56-49ed-a085-1dac650fee17">
            

### 4. 사용자 프로필

- 프로필 페이지에 사용자가 **업로드한 게시물**과 **좋아요를 누른 게시물**의 썸네일 출력
    
<img width="364" alt="image" src="https://github.com/user-attachments/assets/ed082b50-a465-4a64-abe7-3d91ab530564">

    
- **작업 내용:**
    - Riverpod 의 StreamProvider로 실시간 데이터 조회
    - ref.watch()로 데이터를 구독하여 각 데이터별 GridView 렌더링

<img width="562" alt="image" src="https://github.com/user-attachments/assets/c99b5150-23d0-45f8-983c-6de0de6afc84">


- 프로필 수정 페이지에서 **기본 정보 및 프로필 사진 삭제, 변경** 기능 구현

<img width="868" alt="image" src="https://github.com/user-attachments/assets/48ab6351-990f-45ec-8f2b-91d97b757c57">

- **작업 내용:**
    - FirebaseStorage 에 사용자 id로 프로필 사진(avatar) 저장
        - 프로필 이미지 파일 업로드
        - 사용자 정보 hasProfileImage: true 로 업데이트
    - 프로필 사진 삭제
        - 프로필 이미지 파일 삭제
        - 사용자 정보 hasProfileImage: false 로 업데이트

<img width="392" alt="image" src="https://github.com/user-attachments/assets/0b28eb24-5f84-4bd2-be42-b047dad04405">

### 5. 다이렉트 메시지(DM)

- 대화 상태 선택 후 **채팅방 개설** 혹은 기존 채팅방이 있을 경우 **채팅방으로 이동**
- 목록에서 채팅방 길게 누르면 **나가기 기능** 제공
- 방을 나간 후, 해당 대화 상대 재선택 시, 대화방 **재참여** 가능

<img width="772" alt="image" src="https://github.com/user-attachments/assets/2d92a174-cb50-41a5-b474-a2fa238a4692">

- **작업 내용: 채팅방 정보 생성**
    - 두 대화자의 채팅방 존재 여부 확인
    - 기존 채팅방이 있으면 채팅방으로 이동
    - 기존 채팅방이 있지만 이미 나온 경우, 재참여
    - 기존 채팅방이 없을 경우 생성 후 채팅방으로 이동

<img width="575" alt="image" src="https://github.com/user-attachments/assets/dad726f6-9944-46e3-928c-120731b47a5e">

- 채팅방 나간 상대방 **재초대** 기능
    - 대화 상대가 나간 후 메시지 전송 시도 시, 상대방 재초대 컨펌 요청
- 채팅방 재참여 시점부터 메시지 확인 기능

<img width="630" alt="image" src="https://github.com/user-attachments/assets/998756ee-9aa9-47c0-acef-9f5e73b1a03f">

- **작업 내용: 채팅방을 나간 상대 재초대**
    - 상대가 나간 상태에서 메시지 전송 시, 상대방 재초대
    - 재초대 후 메시지 전송

<img width="376" alt="image" src="https://github.com/user-attachments/assets/599cbc6a-d621-4bca-afe1-13d5bc7fec1e">

- 전송된 **메시지 삭제** 기능  (전송 3분 이내)
    
<img width="377" alt="image" src="https://github.com/user-attachments/assets/096e6baf-58da-43f6-8ce0-95a4efcf5bba">

- **작업 내용: 전송된 메시지 삭제**
    - 삭제 가능한 메시지인지 확인 (전송 3분 이내)
    - 메시지 작성자 본인 확인
    - ‘Deleted message’ 로 구문 업데이트

<img width="639" alt="image" src="https://github.com/user-attachments/assets/657b4320-8c5e-49b9-a801-8a6eea3d4457">

### 6. 기타 기능

- 동영상 **음소거 및 자동 재생 기본값 설정** 기능 지원

<img width="802" alt="image" src="https://github.com/user-attachments/assets/1a04b05c-cdfa-4084-ad38-062f7ae547f8">


- **작업 내용**
    - Riverpod의 Notifier를 사용하여 재생 설정 상태 관리 구현
    - main.dart 파일에서 runApp() 호출 시, playbackConfigProvider를 override하여
    재생 설정 View Model을 초기화하고, 재생 설정 상태 관리

<img width="692" alt="image" src="https://github.com/user-attachments/assets/ddae80de-1553-4856-ac6e-e04207594f11">

- **다중 언어(l10n) 및** **다크모드** 지원

<img width="660" alt="image" src="https://github.com/user-attachments/assets/a9065ec8-750b-4b26-8cad-a8b311974a2a">

- **작업 내용: 다중 언어**
    - flutter_localizations 패키지로 localization 활성화 및 intl 패키지로 국제화 기능을 지원하도록 설정
    - Localization Delegates 설정
    - arb 파일을 생성해 각 언어에 대한 번역 문자열 정의

<img width="677" alt="image" src="https://github.com/user-attachments/assets/2d99dde7-2f76-4f12-9b55-fd95dd98cc77">

- **작업 내용:** **테마 모드 제어 - 다크모드**
    - ValueNotifier 로 테마 모드 상태 관리 (초기값 light 모드)
    - ValueListenableBuilder 를 사용하여 테마 모드 변경 사항 구독
    - 환경 설정에서 모드 설정 toggle

<img width="787" alt="image" src="https://github.com/user-attachments/assets/6067f547-e28b-4adc-b06a-bcf6936d7222">

