package com.board.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
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

	// 관리자 여부 (0: 일반, 1: 관리자)
	private int adminCk;

	// 회원 포인트
	private int point;

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getRegdate() {
		return regdate;
	}

	public void setRegdate(int regdate) {
		this.regdate = regdate;
	}

	public int getAdminCk() {
		return adminCk;
	}

	public void setAdminCk(int adminCk) {
		this.adminCk = adminCk;
	}

	public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}

	
	
	
}
