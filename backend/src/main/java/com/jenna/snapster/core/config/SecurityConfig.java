package com.jenna.snapster.core.config;

import com.jenna.snapster.core.security.jwt.JwtAuthenticationFilter;
import com.jenna.snapster.core.security.jwt.JwtProvider;
import com.jenna.snapster.core.security.oauth.CustomAuthorizationRequestResolver;
import com.jenna.snapster.core.security.oauth.OAuth2SuccessHandler;
import com.jenna.snapster.domain.user.service.UserService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestResolver;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.filter.ForwardedHeaderFilter;

@Slf4j
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtProvider jwtProvider;
    private final UserService userService;
    private final OAuth2SuccessHandler oAuth2SuccessHandler;
    private final ClientRegistrationRepository clients;

    @Value("${spring.security.oauth2.client.registration.kakao.redirect-uri}")
    private String kakaoRedirectUri;

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter() {
        return new JwtAuthenticationFilter(jwtProvider, userService);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        log.info("\n\n========================== SecurityFilterChain Called ==========================\n");

        OAuth2AuthorizationRequestResolver customResolver =
            new CustomAuthorizationRequestResolver(
                clients,
                "/oauth2/authorization",
                kakaoRedirectUri
            );

        http.csrf(AbstractHttpConfigurer::disable)
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            ).authorizeHttpRequests(auth ->
                auth.requestMatchers(
                        "/api/auth/dev",        // TODO: 개발 완료 후 제거
                        "/api/debug/headers",
                        "/",
                        "/api/oauth2/**",
                        "/oauth2/redirect",
                        "/api/login",
                        "/api/user/login/**",
                        "/api/file/streaming"
                    ).permitAll()
                    .anyRequest()
                    .authenticated()
            ).oauth2Login(oauth -> oauth
                .authorizationEndpoint(endpoint -> endpoint.authorizationRequestResolver(customResolver))
                .successHandler(oAuth2SuccessHandler)
            ).formLogin(AbstractHttpConfigurer::disable)     // 로그인 관련 리다이렉트/폼 로그인 비활성화
            .addFilterBefore(
                jwtAuthenticationFilter(),
                UsernamePasswordAuthenticationFilter.class
            );

        // 향후 로그인 페이지 리다이렉트를 원할 경우 제거
        // 인증되지 않은 사용자는 로그인 페이지로 리다이렉트하지 않고 401 응답을 반환하도록 설정
        http.exceptionHandling(configurer -> configurer.authenticationEntryPoint((request, response, authException) -> {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
        }));

        return http.build();
    }

    @Bean
    public FilterRegistrationBean<ForwardedHeaderFilter> forwardedHeaderFilter() {
        FilterRegistrationBean<ForwardedHeaderFilter> filter = new FilterRegistrationBean<>();
        filter.setFilter(new ForwardedHeaderFilter());
        return filter;
    }

}
