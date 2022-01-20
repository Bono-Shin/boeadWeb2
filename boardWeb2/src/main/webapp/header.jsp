<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "boardWeb2.*" %>

<%
	//헤더는 include 되기 때문에 include 되는 곳의 변수명과 겹치지 않게 해야 한다.
	Member login_ = (Member)session.getAttribute("loginUser");
%>

<header>
	<h1>게시판 만들기</h2>
	<%
		if(login_ == null){
	%>
	<div class="loginArea">
	<a href="<%=request.getContextPath()%>/login/login.jsp">로그인</a>
	|
	<a href="<%=request.getContextPath()%>/login/join.jsp">회원가입</a>
	</div>
	<%
		}else{
	%>
	<div class="loginArea">
	<a href="<%=request.getContextPath()%>/login/logout.jsp">로그아웃</a>
	|
	<a href="<%=request.getContextPath()%>/login/mypage.jsp">마이페이지</a>
	</div>
	<%
		}
	%>
</header>