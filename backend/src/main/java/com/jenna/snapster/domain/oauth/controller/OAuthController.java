package com.jenna.snapster.domain.oauth.controller;

import com.jenna.snapster.domain.oauth.service.OAuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/oauth2")
@RequiredArgsConstructor
public class OAuthController {

    private final OAuthService oAuthService;

//    @GetMapping("/{provider}")
//    public ResponseEntity<?> oauthLogin(@PathVariable String provider, OAuth2AuthenticationToken token) {
//        return ResponseEntity.ok(oAuthService.processOAuthUserAndGetJwt(provider, token));
//    }
//
//    @GetMapping("/kakao/test")
//    public ResponseEntity<?> kakaoTest() {
//        return ResponseEntity.ok("Kakao 인증 로그인 성공");
//    }


}
