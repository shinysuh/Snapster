package com.jenna.snapster.core.config;

import com.jenna.snapster.core.security.jwt.JwtAuthenticationFilter;
import com.jenna.snapster.core.security.jwt.JwtProvider;
import com.jenna.snapster.core.security.oauth.OAuth2SuccessHandler;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtProvider jwtProvider;
    private final UserService userService;
    private final OAuth2SuccessHandler oAuth2SuccessHandler;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(AbstractHttpConfigurer::disable)
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            ).authorizeHttpRequests(auth ->
                auth.requestMatchers(
                        "/",
                        "/api/oauth2/**",
                        "/api/user/login/**"
                    ).permitAll()
                    .anyRequest()
                    .authenticated()
            ).oauth2Login(oauth -> oauth.successHandler(oAuth2SuccessHandler))
            .addFilterBefore(
                new JwtAuthenticationFilter(jwtProvider, userService),
                UsernamePasswordAuthenticationFilter.class
            );

        return http.build();
    }
}
