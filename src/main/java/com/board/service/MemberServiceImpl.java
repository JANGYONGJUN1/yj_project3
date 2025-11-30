package com.board.service;

import org.springframework.stereotype.Service;

import com.board.mapper.MemberMapper;
import com.board.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService{
	
private final MemberMapper memberMapper;
	
	public MemberServiceImpl(MemberMapper memberMapper) { this.memberMapper = memberMapper; }

	@Override
	public void signUp(MemberVO mVO) {
		
		memberMapper.memberJoin(mVO);
		
	}

}
