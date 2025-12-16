package com.board.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.board.vo.ProductCartListVO;
import com.board.vo.ProductVO;
import com.board.vo.ReviewsVO;

public interface BoardService {
	
	// 상품 전체
	ArrayList<ProductVO> productAllList(Integer category);
	
	// 검색 상품
	ArrayList<ProductVO> productSearchList(Map<String, Object> params);
	
	// 상품 상세
	ProductVO productDetail(Integer productIdx);
	
	ArrayList<ReviewsVO> getReview(Integer productIdx, String sortType);
	
	int getCountReview(Integer productIdx);

	ArrayList<ProductCartListVO> productCartList(Integer userIdx);
	
	void saveCart(int userIdx, int productIdx, int quantity);
	
	void deleteCartItem(int cartIdx, int userIdx);
	
	void deleteSelectedCartItem(int userIdx, List<Integer> cartIdxList);
}
