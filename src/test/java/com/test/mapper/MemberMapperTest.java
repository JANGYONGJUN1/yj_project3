package com.test.mapper;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.board.mapper.MemberMapper;
import com.board.vo.MemberVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class MemberMapperTest {

	@Autowired
		private MemberMapper memberMapper;
	
		@Test
		public void memberJoin() throws Exception {
			MemberVO member = new MemberVO();
			
			member.setMemberId("test2");
			member.setPassword("test2");
			member.setName("test2");
			member.setEmail("test2");
			
			memberMapper.memberJoin(member);
	}
}
