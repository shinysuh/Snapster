package com.jenna.snapster.core.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.io.*;
import java.nio.charset.StandardCharsets;

@Slf4j
@Configuration
public class FirebaseInitializer {

    @Value("${firebase.config.path}")
    private String firebaseConfigPath;

    @PostConstruct
    public void init() {
        try {
            InputStream serviceAccount;

            // application.yaml 에서 경로 로드
            File file = new File(firebaseConfigPath);

            if (file.exists()) {
                // 운영 또는 로컬에서 경로가 유효하면 그대로 사용
                serviceAccount = new FileInputStream(file);
                log.info("✅ Firebase config loaded from file: {}", firebaseConfigPath);
            } else {
                // 환경 변수 fallback
                String firebaseConfigJson = System.getenv("FIREBASE_CONFIG_JSON");
                if (firebaseConfigJson == null || firebaseConfigJson.isEmpty()) {
                    log.error("❌ Firebase config not found at path: {} and FIREBASE_CONFIG_JSON is empty.", firebaseConfigPath);
                    throw new GlobalException(ErrorCode.FIREBASE_INITIALIZATION_FAILED, "Firebase config not found");
                }
                serviceAccount = new ByteArrayInputStream(firebaseConfigJson.getBytes(StandardCharsets.UTF_8));
                log.info("✅ Firebase config loaded from environment variable.");
            }

            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                log.info("🎉 Firebase initialized successfully");
            }
        } catch (IOException e) {
            throw new GlobalException(ErrorCode.FIREBASE_INITIALIZATION_FAILED, e.getMessage());
        }
    }

//    @PostConstruct
//    public void init() {
//        try {
//            // 개발
//            InputStream serviceAccount = getClass().getClassLoader().getResourceAsStream(firebaseConfigPath);
//
//            if (serviceAccount == null) {
//                // 운영: 환경변수에서 Firebase JSON 내용 읽기 (예: FIREBASE_CONFIG_JSON)
//                String firebaseConfigJson = System.getenv("FIREBASE_CONFIG_JSON");
//                if (firebaseConfigJson == null || firebaseConfigJson.isEmpty()) {
//                    log.error("Firebase config JSON not found in classpath and environment variable FIREBASE_CONFIG_JSON is empty.");
//                    throw new GlobalException(ErrorCode.FIREBASE_INITIALIZATION_FAILED, "Firebase config JSON not found");
//                }
//                serviceAccount = new ByteArrayInputStream(firebaseConfigJson.getBytes(StandardCharsets.UTF_8));
//            }
//
//            FirebaseOptions options = FirebaseOptions.builder()
//                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
//                .build();
//
//            if (FirebaseApp.getApps().isEmpty()) {
//                log.info("\n\n========================== Firebase Initialization Called ==========================\n");
//                FirebaseApp.initializeApp(options);
//            }
//        } catch (IOException e) {
//            throw new GlobalException(ErrorCode.FIREBASE_INITIALIZATION_FAILED, e.getMessage());
//        }
//    }

}
