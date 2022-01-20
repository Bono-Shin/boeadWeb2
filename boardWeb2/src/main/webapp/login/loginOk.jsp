
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "boardWeb2.*" %>
<!-- boardWeb2.util = DBManager 같은 클래스 분류 -->
<!-- boardWeb2.vo -> ntt 클래스 분류 -->

<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id");
	String password = request.getParameter("pass");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from member where member_id = ? and member_password = ?";
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,id);
		psmt.setString(2,password);
		
		rs = psmt.executeQuery();
		
		//우선 bean을 만들어야 함 (ntt 클래스 생성 먼저) -> 사용하려면 import 해야함
		Member m = null;
		
		//rs에 들어있는 데이터는 한 건 뿐(id,pass 일치)
		if(rs.next()){
			//위에 m=null 이므로 새로운 m 객체를 생성한다.
			m = new Member();
			//sessoin에 담을 데이터이기 때문에 개인정보는 담으면 안된다.
			m.setMidx(rs.getInt("midx"));
			m.setMemberid(rs.getString("member_id"));
			m.setMembername(rs.getString("member_name"));
			
			//http sesstion
			//Attribute는 Object 이므로 객체를 담을 수 있음
			session.setAttribute("loginUser",m);
		}
		
		if(m != null){
			response.sendRedirect(request.getContextPath());
		}else{
			response.sendRedirect("login.jsp");
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
	}
	
	
%>