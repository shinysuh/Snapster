package com.jenna.snapster.core.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

@Slf4j
@Configuration
public class FirebaseInitializer {

    @PostConstruct
    public void init() {
        try {
            // 개발
            InputStream serviceAccount = getClass().getClassLoader().getResourceAsStream("firebase/snapster-firebase-service-account.json");

            if (serviceAccount == null) {
                // 운영: 환경변수에서 Firebase JSON 내용 읽기 (예: FIREBASE_CONFIG_JSON)
                String firebaseConfigJson = System.getenv("FIREBASE_CONFIG_JSON");
                if (firebaseConfigJson == null || firebaseConfigJson.isEmpty()) {
                    throw new GlobalException(ErrorCode.FIREBASE_INITIALIZATION_FAILED, "Firebase config JSON environment variable is empty");
                }

                // JSON 문자열을 InputStream으로 변환
                serviceAccount = new ByteArrayInputStream(firebaseConfigJson.getBytes(StandardCharsets.UTF_8));
            }


            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

            if (FirebaseApp.getApps().isEmpty()) {
                log.info("\n\n========================== Firebase Initialization Called ==========================\n");
                FirebaseApp.initializeApp(options);
            }
        } catch (IOException e) {
            throw new GlobalException(ErrorCode.FIREBASE_INITIALIZATION_FAILED, e.getMessage());
        }
    }

}
