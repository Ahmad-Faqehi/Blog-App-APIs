package com.lakshy.blog.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.data.redis.connection.RedisConnectionFactory;

import java.time.Instant;
import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class HealthController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired(required = false)
    private RedisConnectionFactory redisConnectionFactory;

    @Value("${app.cache.use-redis:true}")
    private boolean useRedis;

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        boolean dbUp = false;
        boolean redisUp = false;
        String dbError = null;
        String redisError = null;
        // Check DB health
        try {
            jdbcTemplate.execute("SELECT 1");
            dbUp = true;
        } catch (Exception e) {
            dbError = e.getMessage();
        }
        // Check Redis health if enabled
        if (useRedis && redisConnectionFactory != null) {
            try {
                redisConnectionFactory.getConnection().ping();
                redisUp = true;
            } catch (Exception e) {
                redisError = e.getMessage();
            }
        }
        boolean allUp = dbUp && (!useRedis || redisUp);
        Map<String, Object> body = Map.of(
                "status", allUp ? "UP" : "DOWN",
                "timestamp", Instant.now().toString(),
                "app", "Blog-App-APIs",
                "db", dbUp ? "UP" : ("DOWN: " + dbError),
                "redis", useRedis ? (redisUp ? "UP" : ("DOWN: " + redisError)) : "DISABLED");
        if (allUp) {
            return ResponseEntity.ok(body);
        } else {
            return ResponseEntity.status(500).body(body);
        }
    }
}
