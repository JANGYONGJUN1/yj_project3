package com.board.vo;

import lombok.Data;

@Data
public class ProductCartListVO {
	
    private String img1;

    private String productName; 
    
    private int productIdx; 
    
    private int quantity; 
    
    private int price;
    
    private int cartIdx;
}
