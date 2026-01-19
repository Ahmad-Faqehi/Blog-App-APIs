package com.lakshy.blog.config;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.support.NoOpCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;

@Configuration
@EnableCaching
public class CacheConfig {
    // Enables Spring's cache abstraction globally. Specific CacheManager
    // beans (e.g., Redis) are provided conditionally by other configs.

    @Bean
    @ConditionalOnProperty(name = "app.cache.use-redis", havingValue = "false")
    public CacheManager noOpCacheManager() {
        return new NoOpCacheManager();
    }
}
