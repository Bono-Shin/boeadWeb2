<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<!-- 로그인한 유저의 midx 추출 -->
<%@ page import = "boardWeb2.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");
%>

<%
	request.setCharacterEncoding("UTF-8");

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
																		//외부에서 값을 받아서 넣는 곳에 ? 입력
		String sql = "insert into board(bidx,subject,writer,content,midx) values(bidx_seq.nextval,?,?,?,?)";
		psmt = conn.prepareStatement(sql);
		//물음표는 1부터 시작
		psmt.setString(1,subject);
		psmt.setString(2,writer);
		psmt.setString(3,content);
		//로그인 한 유저 midx
		psmt.setInt(4,login.getMidx());
		
		//컬럼명에는 물음표를 쓸 수 없다
		//작은따옴표를 붙이지 않아도 String의 경우 setString에서 자동으로 붙여준다.
		
		int result = psmt.executeUpdate();
		
		response.sendRedirect("list.jsp");
		
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