package com.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.board.mapper.KakaoMapper;
import com.board.vo.KakaoDTO;
import com.board.vo.KakaoTokenResponseDTO;
import com.board.vo.KakaoUserInfoResponseDTO;
import com.board.vo.KakaoUserInfoResponseDTO.KakaoAccount;
import com.board.vo.KakaoUserInfoResponseDTO.KakaoAccount.Profile;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Service
@Slf4j 
public class KakaoService {
	
	private final KakaoMapper kMapper;
    
    // 카카오 설정 값 주입용 필드
    private final String clientId; // ⭐️ final로 선언하여 불변성 확보
    private final String redirectUri; // ⭐️ final로 선언하여 불변성 확보

    // 카카오 API 고정 호스트 URL
    private final String KAUTH_TOKEN_URL_HOST = "https://kauth.kakao.com";
    private final String KAUTH_USER_URL_HOST = "https://kapi.kakao.com";

    // ⭐️ WebClient 재사용을 위한 필드 (성능 개선) ⭐️
    private final WebClient tokenWebClient;
    private final WebClient userWebClient;
    
    // ⭐️ 생성자(@Autowired) - 필드 초기화 및 WebClient 객체 생성 ⭐️
    @Autowired
    public KakaoService(@Value("${kakao.client_id}") String clientId,
                        @Value("${kakao.redirect_uri}") String redirectUri,
                        KakaoMapper kMapper									) {
        
        this.clientId = clientId;
        this.redirectUri = redirectUri;
        this.kMapper = kMapper;
        
        // WebClient 객체를 생성자에서 한 번만 초기화
        this.tokenWebClient = WebClient.create(KAUTH_TOKEN_URL_HOST);
        this.userWebClient = WebClient.create(KAUTH_USER_URL_HOST);
    }
    
    
    // 1. Access Token 발급
    public String getAccessTokenFromKakao(String code) {
        
        KakaoTokenResponseDTO kakaoTokenResponseDto = tokenWebClient.post() // ⭐️ tokenWebClient 재사용
            .uri(uriBuilder -> uriBuilder
                .path("/oauth/token")
                .queryParam("grant_type", "authorization_code")
                .queryParam("client_id", clientId)
                .queryParam("redirect_uri", redirectUri) 
                .queryParam("code", code)
                .build())
            .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
            .retrieve()
            
            // 4xx/5xx 에러 처리 (Spring 5.3.22 호환)
            .onStatus(HttpStatus::is4xxClientError, clientResponse -> {
                log.error("Kakao Token 4xx Error: {}", clientResponse.statusCode());
                return Mono.error(new RuntimeException("Kakao Token Exchange Failed: Invalid Parameter or Code"));
            })
            .onStatus(HttpStatus::is5xxServerError, clientResponse -> {
                log.error("Kakao Token 5xx Error: {}", clientResponse.statusCode());
                return Mono.error(new RuntimeException("Kakao Server Internal Error"));
            })
            
            .bodyToMono(KakaoTokenResponseDTO.class)
            .block();

        log.info(" [Kakao Service] Access Token ------> {}", kakaoTokenResponseDto.getAccessToken());

        return kakaoTokenResponseDto.getAccessToken();
    }
    
    
    // 2. 사용자 정보 조회
    public KakaoUserInfoResponseDTO getUserInfo(String accessToken) {

        KakaoUserInfoResponseDTO userInfo = userWebClient // ⭐️ userWebClient 재사용
                .get()
                .uri(uriBuilder -> uriBuilder
                        // scheme("https") 제거 (Base URL이 이미 HTTPS)
                        .path("/v2/user/me")
                        .build()) // build(true) 제거
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken) // access token 인가
                // ❌ 제거: .header(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.APPLICATION_X_WWW_FORM_URLENCODED.toString()) 
                // Spring 5.3.22 오류 유발 및 GET 요청에 불필요
                .retrieve()
                
                // 4xx/5xx 에러 처리
                .onStatus(HttpStatus::is4xxClientError, clientResponse -> {
                    log.error("Kakao User 4xx Error: {}", clientResponse.statusCode());
                    return Mono.error(new RuntimeException("Kakao User Info Failed: Invalid Access Token"));
                })
                .onStatus(HttpStatus::is5xxServerError, clientResponse -> {
                    log.error("Kakao User 5xx Error: {}", clientResponse.statusCode());
                    return Mono.error(new RuntimeException("Kakao Server Internal Error"));
                })
                
                .bodyToMono(KakaoUserInfoResponseDTO.class)
                .block();

        log.info("[ Kakao Service ] Auth ID ---> {} ", userInfo.getId());
        // ⚠️ 주의: 카카오 응답 JSON의 필드명에 따라 getNickName() 대신 getNickname() 일 수 있습니다.
        log.info("[ Kakao Service ] NickName ---> {} ", userInfo.getKakaoAccount().getProfile().getNickname());
        log.info("[ Kakao Service ] ProfileImageUrl ---> {} ", userInfo.getKakaoAccount().getProfile().getProfileImageUrl());

        return userInfo;
    }
    
    
 // ⭐️ 3. 로그아웃 핵심 Access Token 무효화 (카카오 서버 POST 요청) ⭐️
    public void kakaoLogout(String accessToken) {
        log.info("[Kakao Service] Starting token invalidation for token: {}", accessToken);
        
        try {
            userWebClient.post() // 로그아웃은 POST 요청입니다.
                .uri("/v1/user/logout")
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .retrieve()
                
                .onStatus(HttpStatus::is4xxClientError, clientResponse -> {
                    log.error("Kakao Logout 4xx Error: {}", clientResponse.statusCode());
                    return Mono.error(new RuntimeException("Kakao Logout Failed: Invalid Token or Parameter"));
                })
                .onStatus(HttpStatus::is5xxServerError, clientResponse -> {
                    log.error("Kakao Logout 5xx Error: {}", clientResponse.statusCode());
                    return Mono.error(new RuntimeException("Kakao Server Internal Error during Logout"));
                })
                
                .bodyToMono(Void.class) 
                .block(); 
                
            log.info("[Kakao Service] Access Token successfully invalidated.");
        } catch (RuntimeException e) {
             log.error("[Kakao Service] 카카오 로그아웃 API 호출 중 오류 발생: {}", e.getMessage());
             throw e;
        }
    }
    
    
    public KakaoDTO loginOrJoin (KakaoUserInfoResponseDTO kakaoUserInfo) {
    	System.out.println(">>>>>> 카카오 로그인 or 조인 진입");
    	//1. 카카오 고유 ID로 DB에서 회원조회
    	Long kakaoId = kakaoUserInfo.getId();
    	
    	//maapper 호출: DB에 해당 ID가 있는지 확인
    	KakaoDTO kUser = kMapper.findByKakaoId(kakaoId);
    	
    	if(kUser != null) {
    		//2. 기존 회원: 로그인 성공(DB에서 조회된 DTO 반환)
    		log.info("[Kakao Service] 기존 회원 로그인 성공. ID: {}", kUser.getKakaoId());
    		return kUser;
    	}else {
    		//3. 신규 회원: 회원가입 실행
    		
    		System.out.println(">>>>>>>>   신규회원");
    		KakaoDTO newUser = new KakaoDTO();
    		
    		newUser.setKakaoId(kakaoId);
    		
    		//닉네임 (Null 체크 및 값 할당)
    		Profile profile = kakaoUserInfo.getKakaoAccount().getProfile();
    		
    		if(profile != null && profile.getNickname() != null) {
    			newUser.setKakaoName(profile.getNickname());
    		} else {
    			newUser.setKakaoName("카카오사용자" + kakaoId); //닉네임 미제공시 ID로 대체
    		}
    		
    		// DB에 신규 회원 정보 저장(insert)
    		KakaoDTO saveUser = kMapper.save(newUser);
    		
    		 log.info("[Kakao Service] 신규 회원 가입 성공. K_NUMBER: {}", saveUser.getKakaoNumber());
             return saveUser;
    	}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}