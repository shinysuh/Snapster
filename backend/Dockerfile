# JDK 21 기반 이미지 사용
FROM openjdk:21-jdk-slim

# 작업 디렉토리 생성
WORKDIR /app

# Gradle 빌드 파일 복사
COPY build/libs/*.jar app.jar

# 컨테이너에서 실행할 포트 지정 (80번 포트로 변경)
EXPOSE 80

# JAR 실행 명령어 (prod)
CMD ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar"]

# test