package com.jenna.snapster.core.security.oauth;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;
import org.springframework.util.Assert;

@RequiredArgsConstructor
public class CustomAuthorizationRequestResolver implements OAuth2AuthorizationRequestResolver {

    private final OAuth2AuthorizationRequestResolver defaultResolver;
    private final ClientRegistrationRepository clientRegistrationRepository;
    private final String forcedRedirectUriTemplate;

    public CustomAuthorizationRequestResolver(
        ClientRegistrationRepository clientRegistrationRepository,
        String authorizationRequestBaseUri,
        String forcedRedirectUriTemplate
    ) {
        Assert.hasText(forcedRedirectUriTemplate, "forcedRedirectUriTemplate must not be empty");
        this.defaultResolver = new DefaultOAuth2AuthorizationRequestResolver(clientRegistrationRepository, authorizationRequestBaseUri);
        this.clientRegistrationRepository = clientRegistrationRepository;
        this.forcedRedirectUriTemplate = forcedRedirectUriTemplate;
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request) {
        OAuth2AuthorizationRequest req = defaultResolver.resolve(request);
        return customizeRedirectUriIfNeeded(req);
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request, String clientRegistrationId) {
        OAuth2AuthorizationRequest req = defaultResolver.resolve(request, clientRegistrationId);
        return customizeRedirectUriIfNeeded(req);
    }

    private OAuth2AuthorizationRequest customizeRedirectUriIfNeeded(OAuth2AuthorizationRequest req) {
        if (req == null) return null;

        // Spring Security 6.2+에서는 ClientRegistration을 따로 찾아야 함
        String clientId = req.getClientId();
        ClientRegistration registration = findClientRegistrationByClientId(clientId);
        if (registration == null) return req;

        String registrationId = registration.getRegistrationId();
        String resolvedRedirectUri = forcedRedirectUriTemplate.replace("{registrationId}", registrationId);

        return OAuth2AuthorizationRequest.from(req)
            .redirectUri(resolvedRedirectUri)
            .build();
    }

    private ClientRegistration findClientRegistrationByClientId(String clientId) {
        if (clientRegistrationRepository instanceof Iterable) {
            for (Object obj : (Iterable<?>) clientRegistrationRepository) {
                ClientRegistration registration = (ClientRegistration) obj;
                if (registration.getClientId().equals(clientId)) {
                    return registration;
                }
            }
        }
        return null;
    }
}
