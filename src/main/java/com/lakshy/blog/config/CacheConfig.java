package com.lakshy.blog.config;

import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableCaching
public class CacheConfig {
    // Enables Spring's cache abstraction globally. Specific CacheManager
    // beans (e.g., Redis) are provided conditionally by other configs.
}
