<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*"%>

<%
	request.setCharacterEncoding("UTF-8");

	String pass_ = request.getParameter("pass+");
	String phone_ = request.getParameter("phone+");
	String email_ = request.getParameter("email+");
	String addr_ = request.getParameter("addr+");
	
	String midx = request.getParameter("midx");
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	//업데이트 및 삭제는 ResultSet 필요 없음
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "update member set MEMBER_PASSWORD = '"+pass_+"' ,PHONE = '"+phone_+"' ,EMAIL = '"+email_+"' ,ADDR = '"+addr_+"' where midx ="+midx;
		psmt = conn.prepareStatement(sql);
		
		System.out.println(sql);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			response.sendRedirect("memberView.jsp?midx="+midx);
		}else{
			response.sendRedirect("memberList.jsp");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null){
			conn.close();
		}
		if(psmt != null){
			psmt.close();
		}
	}
	
%>