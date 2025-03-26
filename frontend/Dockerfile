# Flutter SDK 이미지를 사용
FROM cirrusci/flutter:latest

# 작업 디렉토리 생성
WORKDIR /app

# Flutter 프로젝트 파일 복사
COPY frontend/ /app

# Flutter 앱 빌드 (웹용)
RUN flutter build web

# nginx를 사용해서 Flutter Web 앱을 제공
FROM nginx:alpine

# 빌드된 웹 애플리케이션 복사
COPY --from=0 /app/build/web /usr/share/nginx/html

# nginx가 사용하는 포트(기본값 80번 포트) 공개
EXPOSE 80

# nginx 시작 명령어
CMD ["nginx", "-g", "daemon off;"]
