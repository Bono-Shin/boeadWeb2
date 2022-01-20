<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//modify 때 정보가 입력되어 있으므로 불러올 수 있다.
	String bidx = request.getParameter("bidx");	
	String subject = request.getParameter("subject");
	String writer = request.getParameter("writer");
	String content = request.getParameter("content");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	try{
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "update board set subject = ?, writer = ?, content = ? where bidx = ?";
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1, subject);
		psmt.setString(2, writer);
		psmt.setString(3, content);
		psmt.setInt(4, Integer.parseInt(bidx));
		
		int result = psmt.executeUpdate();	
		
		out.print(result);
		
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