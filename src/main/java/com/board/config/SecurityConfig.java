package com.board.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Configuration // 이 클래스를 설정 파일로 인식하게 함
public class SecurityConfig {

    @Bean // 이 메서드가 반환하는 객체를 스프링 빈으로 등록
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}