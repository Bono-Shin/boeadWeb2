<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%
	session.invalidate();
							//index로 보내기
	response.sendRedirect(request.getContextPath());
%>