<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");

	String name_ = request.getParameter("name");
	String id_ = request.getParameter("id");
	String pass_ = request.getParameter("pass");
	String addr_ = request.getParameter("addr");
	String phone_ = request.getParameter("phone");
	String gender_ = request.getParameter("gender");
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "insert into member(midx,member_name,member_id,member_password,addr,phone,gender) values(midx_seq.nextval,?,?,?,?,?,?)";
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,name_);
		psmt.setString(2,id_);
		psmt.setString(3,pass_);
		psmt.setString(4,addr_);
		psmt.setString(5,phone_);
		psmt.setString(6,gender_);
		
		int result = psmt.executeUpdate();
		
		response.sendRedirect("memberList.jsp");
		
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