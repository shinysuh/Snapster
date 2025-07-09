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
import java.util.Base64;

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
                // base64 인코딩된 환경 변수 fallback
                String firebaseConfigBase64 = System.getenv("FIREBASE_SERVICE_ACCOUNT_BASE64");
                if (firebaseConfigBase64 == null || firebaseConfigBase64.isEmpty()) {
                    log.error("❌ Firebase config not found at path: {} and FIREBASE_SERVICE_ACCOUNT_BASE64 is empty.", firebaseConfigPath);
                    throw new GlobalException(ErrorCode.FIREBASE_INITIALIZATION_FAILED, "Firebase config not found");
                }

                byte[] decoded = Base64.getDecoder().decode(firebaseConfigBase64);
                serviceAccount = new ByteArrayInputStream(decoded);
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
}
