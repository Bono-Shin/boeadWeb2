<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>

<%
	String bidx = request.getParameter("bidx");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "delete from board where bidx ="+bidx;
		psmt = conn.prepareStatement(sql);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			response.sendRedirect("list.jsp");
		}else{
			response.sendRedirect("view.jsp");
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