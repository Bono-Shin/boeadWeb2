<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*"%>
<%@ page import = "org.json.simple.*" %>

<%	
	request.setCharacterEncoding("UTF-8");
	String ridx = request.getParameter("ridx");
	String rcontent = request.getParameter("rcontent");
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "update reply set rcontent = ? where ridx = ?";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,rcontent);
		psmt.setInt(2,Integer.parseInt(ridx));
		
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