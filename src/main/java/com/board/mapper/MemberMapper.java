package com.board.mapper;

import org.apache.ibatis.annotations.Param;

import com.board.vo.MemberVO;

public interface MemberMapper {
	
	//회원가입
	public void memberJoin(MemberVO mVO);
	
	public MemberVO findById(String memberId);
	
	
	
	
}
