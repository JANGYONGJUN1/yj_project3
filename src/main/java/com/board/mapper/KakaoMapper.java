package com.board.mapper;

import com.board.vo.KakaoDTO;

public interface KakaoMapper {
	
	// 카카오 고유 ID를 사용하여 DB에서 회원 정보를 조회
	// @param kakaoId 카카오 고유 ID, @return 회원이 존재하면 KakaoDTO, 없으면 null
	public KakaoDTO findByKakaoId(Long KakaodId);
	
	//신규 카카오 회원을 db에 저장,  k_number는 DB (시퀀스/트리거)에 의해 자동 채워짐
	public KakaoDTO save(KakaoDTO dto);
	

}
