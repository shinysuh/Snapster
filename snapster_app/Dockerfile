# Flutter 3.19.6 버전을 사용하는 공식 Cirrus CI Flutter SDK 이미지로 베이스 이미지 지정
FROM ghcr.io/flutter/flutter:3.19.6 AS build

# 작업 디렉토리를 /app으로 설정 (이 위치에서 모든 명령어가 실행됨)
WORKDIR /app

# 현재 도커 빌드 컨텍스트의 모든 파일을 /app 디렉토리에 복사
COPY . .

# Flutter 프로젝트의 의존성들을 다운로드하고 설정
RUN flutter pub get

# Flutter 웹 빌드를 수행하여 /app/build/web에 결과물 생성
RUN flutter build web

# 실제 웹서버 역할을 할 nginx의 alpine 경량 이미지를 사용
FROM nginx:alpine

# build 단계에서 생성한 빌드 결과물을 nginx 기본 서비스 경로로 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# nginx가 사용하는 80번 포트를 외부에 노출
EXPOSE 80

# 컨테이너 시작 시 nginx를 포그라운드에서 실행 (데몬 모드 off)
CMD ["nginx", "-g", "daemon off;"]
