<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	String searchValue = request.getParameter("searchValue");
	String searchType = request.getParameter("searchType");
	

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		//sql 구문 입력
		String sql = "select * from member";
		// null 부터 조건을 따져야 nullPointException이 발생하지 않음
		if(searchValue != null && !searchValue.equals("")){
			if(searchType.equals("member_name")){
				sql += " where member_name = '"+ searchValue +"'";
			}else if(searchType.equals("addr")){
				sql += " where addr like '%" + searchValue + "%'";
			}
		}
		
		sql += " order by midx desc";
		
		psmt = conn.prepareStatement(sql); //prepare'd' d가 빠져야하는걸 주의하자
		
		rs = psmt.executeQuery();
					
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href = "<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
</head>
<body>
	<%@ include file = "/header.jsp" %>
	<section>
		<h2>회원 리스트 목록</h2>
		검색기능 추가 : 회원명이 일치하는 경우 검색, 주소 부분 검색
		<article>
			<div>
				<form action="memberList.jsp">
					<select name="searchType">
						<option value="member_name" <%if(searchType != null && searchType.equals("member_name")) out.print("selected"); %>)>회원명</option>
						<option value="addr" <%if(searchType != null && searchType.equals("addr")) out.print("selected"); %>>주소</option>
					</select>
					<input type="text" name="searchValue" <%if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")) out.print("value='"+searchValue+"'"); %>>
					<input type="submit" value="검색">
				</form>
			</div>
			회원명 클릭 시 상세페이지 이동 -> 회원 id, 회원 비밀번호, 회원명, 주소, 연락처, 이메일 출력
			<table border="1">
				<thead>
					<tr>
						<th>midx</th>
						<th>id</th>
						<th>name</th>
						<th>gender</th>
						<th>addr</th>
					<tr>
				</thead>
				<tbody>
						<%
						while(rs.next()){			
						%>
					<tr>
						<td><%=rs.getInt("midx") %></td>
						<td><%=rs.getString("member_id") %></td>
						<td><a href="memberView.jsp?midx=<%=rs.getInt("midx") %>&searchType=<%=searchType%>&searchValue=<%=searchValue %>"><%=rs.getString("member_name") %></a></td>
						<td><%=rs.getString("gender") %></td>
						<td><%=rs.getString("addr") %></td>
					</tr>
						<% 
						}
						%>
				</tbody>
			</table>
			<button onclick="location.href='memberInsert.jsp'">등록</button>
		</article>
	</section>
	<%@ include file = "/footer.jsp" %>
</body>
</html>
<%
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