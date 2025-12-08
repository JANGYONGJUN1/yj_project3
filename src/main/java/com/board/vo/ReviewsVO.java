package com.board.vo;

import java.sql.Date;

import lombok.Data;

@Data
public class ReviewsVO {
	private String userId;
	
	private int score;
	
	private Date regdate;
	
	private int productIdx;
	
	private int reviewIdx;
	
	private String content;
	
	private String kakaoNumber;
}
