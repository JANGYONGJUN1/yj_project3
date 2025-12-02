package com.board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.board.service.KakaoService;
import com.board.vo.KakaoDTO;
import com.board.vo.KakaoUserInfoResponseDTO;
import com.board.vo.SessionUserDTO;


@Controller
@RequestMapping("")
public class KakaoLoginController {
	
	private final KakaoService kakaoService;
	
	@Autowired
	public KakaoLoginController(KakaoService kakaoService) {this.kakaoService = kakaoService; }
	
	@GetMapping(value = {"/callback", "/callback/"})
	 public String callback(@RequestParam("code") String code, HttpSession session) {
		
		SessionUserDTO sessionUser = new SessionUserDTO();

		
		try {
			// 1. 인가 코드로 액세스 토큰 발급 및 액세스 토큰으로 사용자 정보 조회
			String accessToken = kakaoService.getAccessTokenFromKakao(code); // ⭐️ 서비스 호출 ⭐️
			KakaoUserInfoResponseDTO userInfo = kakaoService.getUserInfo(accessToken);
			
			// DB에 사용자 정보 (userInfo) 저장
			KakaoDTO loginUser = kakaoService.loginOrJoin(userInfo);
			
			sessionUser.setUserId(String.valueOf(loginUser.getKakaoId()));
			sessionUser.setLoginName(loginUser.getKakaoName());
			sessionUser.setLoginType("KAKAO");
			
			// 2. ⭐️ 로그아웃 시 사용하기 위해 토큰을 세션에 저장합니다. ⭐️
			session.setAttribute("loginUser", sessionUser);
            session.setAttribute("kakaoAccessToken", accessToken);
            
			// 3. 로그인 성공 후 메인 페이지로 리다이렉트
            System.out.println(">>>>>>>>  로그인 성공 ");
			return "redirect:/";
			
		} catch(Exception e) {
			// 오류 발생 시 로그인 페이지로 돌려보내거나 에러 페이지 표시
			// 로그에 자세한 예외 기록
			System.err.println("카카오 로그인 콜백 처리 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
			return "redirect:/login?error=kakao_auth_failed";
		}
    }
	
	
	

	
}
