<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 로그인 상태 구분 -->
<%@ page import = "boardWeb2.*" %>
    
<%
	Member login = (Member)session.getAttribute("loginUser");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
<script>
	function goMember(){
		var login = '<%=login%>';
		
		console.log(login);
		console.log(typeof login);
		
		
		if(login == "null"){
			alert("로그인 후 접근 가능");
		}else{
			location.href = 'board/memberList.jsp';
		}
	}
</script>
</head>
<body>
<%@ include file = "header.jsp" %>
	<section>
		<a href="board/list.jsp">게시판으로 이동</a>
		    |<!-- a태그에서 자바스크립트 사용 법  -->
		<a href="javascript:goMember();">회원게시판으로 이동</a>
		<%
			if(login != null){
		%>
			<h2><%=login.getMembername() %>님 로그인을 환영합니다.</h2>
		<%	
			}
		%>
	</section>
<%@ include file = "footer.jsp" %>
</body>
</html>