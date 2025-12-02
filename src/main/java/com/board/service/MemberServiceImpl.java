package com.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.board.mapper.MemberMapper;
import com.board.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService{
	
	private final MemberMapper memberMapper;
	
	// BCryptPasswordEncoder 주입 (빈 등록 필수)
    @Autowired 
    private BCryptPasswordEncoder passwordEncoder;
	
	public MemberServiceImpl(MemberMapper memberMapper) { this.memberMapper = memberMapper; }

	
	@Override
	public void signUp(MemberVO mVO) {
		
		// 회원가입시 입력한 패스워드
		String inputPassword = mVO.getPassword();
		
		// 입력된 패스워드를 암호화
		String encodPassword = passwordEncoder.encode(inputPassword);
		
		// 암호화된 패스워드를 mVO에 다시 저장
		mVO.setPassword(encodPassword);
		
		memberMapper.memberJoin(mVO);
		
	}
	
	/**
	 * 로그인
	 * @Param loginId - 로그인 ID
	 * @Param password - 비밀번호
	 * @return 회원 상세정보
	 */
	@Override
	public MemberVO signIn(String memberId, String password) {
		
		MemberVO member = memberMapper.findById(memberId);
		
		System.out.println("로그인 서비스 진입");
		System.out.println("member : " + member);
		
		if(member == null) {
			System.out.println("member가 null??? : " + member);
			return null;   
		}
		
		System.out.println("DB에서 가져온 PW : " + member.getPassword()); // DB 비밀번호 확인
		if(passwordEncoder == null) {
			System.out.println("🚨 BCryptPasswordEncoder 객체가 NULL입니다. 빈 등록 설정을 다시 확인하세요.");
			return null;
		}
		
		// 비밀번호 비교 (BCryptPasswordEncoder 사용)
        // input PW (평문) vs DB PW (해시)
		if(passwordEncoder.matches(password, member.getPassword())) {
			System.out.println("비밀번호 비교");
			// 인증성공
			return member;
		}else {
			System.out.println("비밀번호 불일치 또는 DB 비밀번호가 NULL입니다.");
			return null;
		}
	}

}
