package com.jenna.snapster.core.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.io.InputStream;

@Slf4j
@Configuration
public class FirebaseInitializer {

    @PostConstruct
    public void init() {
        try {
            InputStream serviceAccount = getClass().getClassLoader().getResourceAsStream("firebase/snapster-firebase-service-account.json");

            assert serviceAccount != null;
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
