# JDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim

# ffmpeg 설치
# 기본 도구 설치
RUN apt-get update && apt-get install -y curl tar xz-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ffmpet 4.2.2. static build 다운로드 및 설치
RUN apt-get update && apt-get install -y curl xz-utils && \
    curl -L -o /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-4.2.2-amd64-static.tar.xz && \
    mkdir -p /tmp/ffmpeg && \
    tar -xf /tmp/ffmpeg.tar.xz -C /tmp/ffmpeg --strip-components=1 && \
    mv /tmp/ffmpeg/ffmpeg /usr/local/bin/ffmpeg && \
    mv /tmp/ffmpeg/ffprobe /usr/local/bin/ffprobe && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe && \
    rm -rf /var/lib/apt/lists/* /tmp/*


# 썸네일 회전 정보 오류로 보류
#RUN apt-get update && \
#    apt-get install -y ffmpeg && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*


# 작업 디렉토리 생성
WORKDIR /app

# Gradle 빌드 파일 복사
COPY build/libs/snapster-backend-1.0.0.jar app.jar

# 컨테이너에서 실행할 포트 지정 (80번 포트로 변경)
EXPOSE 80

# JAR 실행 명령어 (prod)
CMD ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar"]
