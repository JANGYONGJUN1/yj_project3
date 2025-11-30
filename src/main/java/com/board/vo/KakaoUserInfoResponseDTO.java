package com.board.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date; // java.sql.Date 대신 java.util.Date 사용 권장
import java.util.HashMap;

// DTO 자체의 Getters/Setters를 Lombok으로 자동 생성
@Getter
@Setter 
@NoArgsConstructor // 역직렬화를 위한 기본 생성자
@JsonIgnoreProperties(ignoreUnknown = true)
public class KakaoUserInfoResponseDTO {

    // 회원 번호 (카카오 고유 ID)
    @JsonProperty("id")
    private Long id;

    // 서비스 연결 완료된 시각. UTC
    @JsonProperty("connected_at")
    private Date connectedAt; 

    // 카카오싱크 간편가입을 통해 로그인한 시각. UTC
    @JsonProperty("synched_at")
    private Date synchedAt;

    // 사용자 프로퍼티 (사용자 정의 필드)
    @JsonProperty("properties")
    private HashMap<String, String> properties;

    // 카카오 계정 정보 (가장 중요한 정보)
    @JsonProperty("kakao_account")
    private KakaoAccount kakaoAccount;

    // uuid 등 추가 정보 (파트너 용도)
    @JsonProperty("for_partner")
    private Partner partner;


    // --- 내부 클래스 1: KakaoAccount ---
    @Getter
    @Setter
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class KakaoAccount { // 내부 클래스를 static으로 선언해야 더 안전함

        @JsonProperty("profile_needs_agreement")
        private Boolean profileNeedsAgreement;

        @JsonProperty("profile")
        private Profile profile;

        @JsonProperty("name_needs_agreement")
        private Boolean nameNeedsAgreement;
        
        @JsonProperty("name")
        private String name;

        // 이메일 관련
        @JsonProperty("email_needs_agreement")
        private Boolean emailNeedsAgreement;
        @JsonProperty("is_email_valid")
        private Boolean isEmailValid;
        @JsonProperty("is_email_verified")
        private Boolean isEmailVerified;
        @JsonProperty("email")
        private String email;

        // 연령대
        @JsonProperty("age_range_needs_agreement")
        private Boolean ageRangeNeedsAgreement;
        @JsonProperty("age_range")
        private String ageRange;

        // 생일/성별 등 나머지 필드는 유지
        @JsonProperty("birthyear")
        private String birthYear;
        @JsonProperty("birthday")
        private String birthday;
        @JsonProperty("gender")
        private String gender;

        // CI (연계 정보)
        @JsonProperty("ci_needs_agreement")
        private Boolean ciNeedsAgreement;
        @JsonProperty("ci")
        private String ci;
        @JsonProperty("ci_authenticated_at")
        private Date ciAuthenticatedAt;
        
        // --- 내부 클래스 2: Profile ---
        @Getter
        @Setter
        @NoArgsConstructor
        @JsonIgnoreProperties(ignoreUnknown = true)
        public static class Profile { // 내부 클래스를 static으로 선언

            @JsonProperty("nickname")
            private String nickname;
            
            @JsonProperty("thumbnail_image_url")
            private String thumbnailImageUrl;
            
            @JsonProperty("profile_image_url")
            private String profileImageUrl;

            @JsonProperty("is_default_image")
            private Boolean isDefaultImage; // String이 아닌 Boolean 타입이 더 정확함
        }
    }
    
    // --- 내부 클래스 3: Partner ---
    @Getter
    @Setter
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Partner {
        @JsonProperty("uuid")
        private String uuid;
    }
}