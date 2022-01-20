<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
</head>
<body>
	<%@ include file ="/header.jsp" %>
	<section>
		<h2>회원 등록</h2>
		<article>
			<form action="memberInsertOk.jsp" method="post">
			<table border="1">
				<tr>
					<th>회원이름</th>
					<td><input type="text" name="name"></td>
					<th>아이디</th>
					<td><input type="text" name="id"></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="pass"></td>
					<th>주소</th>
					<td><input type="text" name="addr"></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td><input type="text" name="phone"></td>
					<th>성별</th>
					<td>
					<!-- 체크박스로 하게 되면 name값이 키값이 되고 option값이 value값이 된다 -->
					<!-- 만약 option값에 value값을 넣게 되면 value값이 넘어가게 된다. -->
						<select name="gender">
							<option>m</option>
							<option>f</option>
						</select>
					</td>
				</tr>
			</table>
			<input type="button" onclick="location.href='memberList.jsp'" value="취소">
			<input type="submit" value="등록"> <!-- required 속성을 입력하면 빈칸이 있으면 submit이 안된다. -->
			</form>
		</article>
	</section>
	<%@ include file ="/footer.jsp" %>
</body>
</html>