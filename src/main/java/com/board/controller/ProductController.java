package com.board.controller;

import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.board.service.BoardService;
import com.board.vo.ProductVO;


@Controller
public class ProductController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProductController.class);
	private final BoardService productService;
	// 생성자 주입
	@Autowired
	public ProductController(BoardService productService) {this.productService = productService;}
	
	@RequestMapping(value="/productDetail")
	public String detail(Model model, @RequestParam("productIdx") int productIdx) {
		
		ProductVO product = productService.productDetail(productIdx);
		
		model.addAttribute("product", product);
		
		System.out.println("상품 상세 조회 ID: " + productIdx);
		
		return "productDetailPage";
	}
}
