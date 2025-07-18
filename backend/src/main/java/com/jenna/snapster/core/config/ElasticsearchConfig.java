package com.jenna.snapster.core.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ElasticsearchConfig {

    @Value("${elasticsearch.host}")
    private String hostname;

    @Value("${elasticsearch.port}")
    private int port;


    @Bean
    public ElasticsearchClient elasticsearchClient() {
        RestClient restClient = RestClient.builder(
            new HttpHost(hostname, port, "http")
        ).build();

        RestClientTransport transport = new RestClientTransport(
            restClient, new JacksonJsonpMapper()
        );

        return new ElasticsearchClient(transport);
    }
}
