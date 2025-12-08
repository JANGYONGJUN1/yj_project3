package com.board.mapper;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.board.vo.ProductVO;
import com.board.vo.ReviewsVO;

public interface ProductMapper {
	
	//상품 전체
	public ArrayList<ProductVO> getProductAll(@Param("category") Integer category);
	
	//검색 상품
	public ArrayList<ProductVO> getSearchList(Map<String, Object> params);
	
	//상품 상세
	public ProductVO getProductByIdx(@Param("productIdx") Integer productIdx);
	
	public ArrayList<ReviewsVO> getReview(@Param("productIdx") Integer productIdx);
	
}
