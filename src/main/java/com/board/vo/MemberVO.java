package com.board.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class MemberVO {
	
	// id
	private String memberId;

	// 회원 password
	private String password;

	// 회원 이름
	private String name;

	// email
	private String email;

	// 가입날짜
	private int regdate;

	// 관리자 여부 (1: 관리자, 2: 일반)
	private int adminCk;

	// 회원 포인트
	private int point;

}
