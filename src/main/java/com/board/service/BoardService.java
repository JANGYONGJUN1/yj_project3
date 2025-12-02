package com.board.service;

import java.util.ArrayList;
import java.util.Map;

import com.board.vo.ProductVO;

public interface BoardService {
	
	// 상품 전체
	ArrayList<ProductVO> productAllList(Integer category);
	
	// 검색 상품
	ArrayList<ProductVO> productSearchList(Map<String, Object> params);
	
	// 상품 상세
	ProductVO productDetail(Integer productIdx);

}
