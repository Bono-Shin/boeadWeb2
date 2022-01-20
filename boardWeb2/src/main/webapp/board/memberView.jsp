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
	
	String id_ = "";
	String pass_ = "";
	String name_ = "";
	String addr_ = "";
	String phone_ = "";
	String email_ = "";
	//나중에 필요해짐
	int midx_ = 0;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "select * from member where midx ="+midx;
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			id_ = rs.getString("member_id");
			pass_ = rs.getString("member_password");
			name_ = rs.getString("member_name");
			addr_ = rs.getString("addr");
			phone_ = rs.getString("phone");
			email_ = rs.getString("email");
			//나중에 필요해짐
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
		<h2>회원 상세 조회</h2>
		<table border="1">
			<tr>
				<th>회원 아이디</th>
				<td><%=id_ %></td>
				<th>회원 비밀번호</th>
				<td><%=pass_ %></td>
				<th>주소</th>
				<td><%=addr_ %></td>
			</tr>
			<tr>
				<th>회원명</th>
				<td><%=name_ %></td>
				<th>연락처</th>
				<td><%=phone_ %></td>
				<th>이메일</th>
				<td><%=email_ %></td>
			</tr>
		</table>
		<button onclick="location.href='memberList.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>'">목록</button>
		<button onclick="location.href='memberModify.jsp?midx=<%=midx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
		<button onclick="memberDelFn()">삭제</button>
		<form method="post" name="frm">
			<input type="hidden" name="midx" value="<%=midx_ %>">
		</form>
	</section>
	<script>
		function memberDelFn(){
			//form 태그의 action 경로 숨기는 방법
			//완전히 숨기려면 외부파일로 만들어서 링크를 걸어서 사용해야 한다.
			document.frm.action="memberDelete.jsp";
			document.frm.submit();
		}
	</script>
	<%@ include file = "/footer.jsp" %>
</body>
</html>