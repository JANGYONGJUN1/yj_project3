package com.board.service;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.board.mapper.ProductMapper;
import com.board.vo.ProductVO;
import com.board.vo.ReviewsVO;


@Service
public class BoardServiceImpl implements BoardService{
	
/* 
	 Autowired 말고 생성자 주입으로 
	 이유: final로 불변성 유지 (의존성은 애플리케이션 구동 중 바뀌면 안됨), 테스트 코드 작성 쉬움(Mock객체를 넣어줘 테스트 코드 작성 쉬움), 
	 	 컴파일 단계에서 누락된 의존성 체크 가능, 현대 srping 스타일 
*/
	private final ProductMapper pMapper;
	
	public BoardServiceImpl(ProductMapper pMapper) { this.pMapper = pMapper; }
	

	// 상품전체
	@Override
	public ArrayList<ProductVO> productAllList(Integer category) {
		
		return pMapper.getProductAll(category);
	}



	@Override
	public ArrayList<ProductVO> productSearchList(Map<String, Object> params) {
		
		return pMapper.getSearchList(params);
	}


	@Override
	public ProductVO productDetail(Integer productIdx) {
		
		return pMapper.getProductByIdx(productIdx);
	}


	@Override
	public ArrayList<ReviewsVO> getReview(Integer productIdx) {
		return pMapper.getReview(productIdx);
	}


	@Override
	public int getCountReview(Integer productIdx) {
		return pMapper.getCountReview(productIdx);
	}

}
