<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import = "java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
									//name 값을 확인할 것
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	
	String bidx = request.getParameter("bidx");
			
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "update board set subject = '"+subject+"' ,content = '"+content+"' where bidx = "+bidx;
					//"updatd board set subject = '??' , content='??' where bidx=? "
		
		psmt = conn.prepareStatement(sql);
		
		int result = psmt.executeUpdate();
		//업데이트가 되면 1, 안되면 0을 반환
		
		if(result > 0){
			//out.print("<script>alert('수정완료!');</script>");
			response.sendRedirect("view.jsp?bidx="+bidx);
		}else{
			//out.print("<script>alert('수정실패!');</script>");
			response.sendRedirect("list.jsp");
		}
					
		//update나 delete 에선 필요 없음
		//rs = psmt.executeQuery();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null){
			conn.close();
		}
		if(psmt != null){
			psmt.close();
		}
		if(rs != null){
			rs.close();
		}
	}
%>