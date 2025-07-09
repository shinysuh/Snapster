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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

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
                // 운영에서 EC2에 있는 파일 복사해 온 파일 있음
                serviceAccount = new FileInputStream(file);
                log.info("✅ Firebase config loaded from file: {}", firebaseConfigPath);
            } else {
                // 개발
                serviceAccount = getClass().getClassLoader().getResourceAsStream(firebaseConfigPath);
                log.info("✅ Firebase config loaded from getClass().getClassLoader().getResourceAsStream().");
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
