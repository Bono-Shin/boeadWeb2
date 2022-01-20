<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");
	
	String midx = request.getParameter("midx");
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	String pass_ = "";
	String addr_ = "";
	String phone_ = "";
	String email_ = "";
	String id_ = "";
	String name_ = "";
	int midx_ = 0;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "select * from member where midx ="+midx;
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			id_ = rs.getString("member_id");
			name_ = rs.getString("member_name");
			pass_ = rs.getString("member_password");
			phone_ = rs.getString("phone");
			email_ = rs.getString("email");
			addr_ = rs.getString("addr");
			midx_ = rs.getInt("midx");
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
		if(rs != null){
			rs.close();
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
</head>
<body>
	<%@ include file = "/header.jsp" %>
	<section>
		<!-- post 방식일 때는 jsp 뒤에 ? 를 붙이지 말 것 -->
		<form action="memberModifyOk.jsp" method="post">
		<input type="hidden" name="midx" value="<%=midx_%>">
		<h2>회원 정보 수정</h2>
		<table border="1">
			<tr>
				<th>회원 아이디</th>
				<td><%=id_ %></td>
				<th>회원 비밀번호</th>
				<td><input type="password" name="pass+" value="<%=pass_%>"></td>
				<th>주소</th>
				<td><input type="text" name="addr+" value="<%=addr_ %>"></td>
			</tr>
			<tr>
				<th>회원명</th>
				<td><%=name_ %></td>
				<th>연락처</th>
				<td><input type="phone" name="phone+" value="<%=phone_ %>"></td>
				<th>이메일</th>
				<td><input type="email" name="email+" value="<%=email_ %>"></td>
			</tr>
		</table>
		<button type="button" onclick="location.href='memberView.jsp?midx=<%=midx %>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">취소</button>
		<button>저장</button>
		</form>
	</section>
	<%@ include file = "/footer.jsp" %>
</body>
</html>