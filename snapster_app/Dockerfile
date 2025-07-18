# Flutter SDK를 포함한 베이스 이미지 지정
FROM instrumentisto/flutter:3.29.3 AS build

# 작업 디렉토리 설정
WORKDIR /app

# Flutter 프로젝트 파일 복사
COPY . /app

# Flutter 웹 애플리케이션 빌드
RUN flutter build web

# nginx를 사용하여 Flutter 웹 앱 제공
FROM nginx:alpine

# 빌드된 웹 애플리케이션 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# nginx가 사용하는 포트(기본값 80번 포트) 공개
EXPOSE 80

# nginx 시작 명령어
CMD ["nginx", "-g", "daemon off;"]