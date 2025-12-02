package com.board.vo;

import lombok.Data;

@Data
public class SessionUserDTO {
	
	// JSP에 표시할 사용자 이름 (MemberVO의 name 또는 KakaoDTO의 kakaoName)
	private String loginName;
	// 로그인 주체 ID (MemberVO의 memberId 또는 KakaoDTO의 kakaoId)
	private String userId;
	
	// 로그인 타입 구분 (필수)
    private String loginType; // "GENERAL" 또는 "KAKAO"
}
