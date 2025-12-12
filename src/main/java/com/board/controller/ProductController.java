package com.board.controller;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.board.service.BoardService;
import com.board.vo.ProductVO;
import com.board.vo.ReviewsVO;


@Controller
public class ProductController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProductController.class);
	private final BoardService productService;
	// 생성자 주입
	@Autowired
	public ProductController(BoardService productService) {this.productService = productService;}
	
	@RequestMapping(value="/productDetail")
	public String detail(Model model,
			@RequestParam("productIdx") int productIdx, 
			@RequestParam(value = "sort", defaultValue ="latest") String sortType) {
		
		System.out.println("상품 디테일 컨트롤러 진입 ------------------");
		
		ProductVO product = productService.productDetail(productIdx);
		ArrayList<ReviewsVO> review = productService.getReview(productIdx, sortType);
		int getCountReview = productService.getCountReview(productIdx);
		
		model.addAttribute("product", product);
		model.addAttribute("reviewList", review);
		model.addAttribute("countReview", getCountReview);
		model.addAttribute("sortType", sortType);
		
		System.out.println(">>>>>>>> reviewList: " + review);
		
		System.out.println("상품 상세 조회 ID: " + productIdx);
		
		return "productDetailPage";
	}
	
	// 조건별 리뷰 정렬
	@GetMapping(value="/review/list")
	@ResponseBody
	public List<ReviewsVO> getReview (
			@RequestParam("productIdx") int productIdx,
			@RequestParam(value="sort", defaultValue="latest") String sortType){
		
		System.out.println("리뷰 컨트롤러 입성 ");
		return productService.getReview(productIdx, sortType);
	}
	
	
	
	
	
	
	
	
	
}
