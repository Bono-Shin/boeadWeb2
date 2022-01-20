<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- DB를 사용하기 위해 import -->
<%@ page import = "java.sql.*" %>
<!-- 로그인 안하면 등록버튼 막기 -->
<%@ page import = "boardWeb2.*" %>

<% 
	Member login = (Member)session.getAttribute("loginUser");
%>

<!-- 
또한 ojdbc7.jar 파일이 이클립스의 workspace\boardWeb2\src\main\webapp\WEB-INF\lib 안에 있어야 함
-->

<!-- DB에 연결하는 소스 -->
<%
	//검색 하기
	request.setCharacterEncoding("UTF-8");
	//searchValue가 null이면 검색버튼을 누르지 않고 화면으로 들어옴.
	String searchValue = request.getParameter("searchValue");
	//작성자 추가
	String searchType = request.getParameter("searchType");
	
	//nowpage
	String nowPage = request.getParameter("nowPage");
	int nowPageI = 1;
	if(nowPage != null){
		nowPageI = Integer.parseInt(nowPage);
	}

	//jdbc 참조변수
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	//jdbc:oracle:thin -> jdbc의 드라이버 타입이 thin 이라는 뜻
	//@localhost -> 본래는 ip 자리이나 localhost는 로컬에서 사용한다는 뜻
	//1521 -> oracle 포트번호
	//xe : oracle database의 고유 service name
	String user = "system";
	String pass = "1234";
	//DB에 연결할 변수
	Connection conn = null;
	//sql 데이터를 담을 변수
	PreparedStatement psmt = null;
	//응답 데이터를 가지고 있을 변수
	ResultSet rs = null;
	
	PagingUtil paging = null;
	
	try{
		//jdbc 드라이버 로딩
		Class.forName("oracle.jdbc.driver.OracleDriver");
		//db 연결
		conn = DriverManager.getConnection(url,user,pass);
		//sql문 준비
		String sql = ""; //sql 구문 입력
		
		//게시글 total 계산
		sql = "select count(*) as total from board";
		
		if(searchValue != null && !searchValue.equals("")){
			//콤보박스는 null값이 들어올 일은 없다
			if(searchType.equals("subject")){
				//앞에 한칸 띄워줘야 board where가 된다
				sql += " where subject like '%"+searchValue+"%'";				
			}else if(searchType.equals("writer")){
				sql += " where writer like '%"+searchValue+"%'";								
			}
		}
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		int total = 0;
		if(rs.next()){
			total = rs.getInt("total");
		}
		
		//paging 클래스의 생성자 paging 생성
		paging = new PagingUtil(total,nowPageI,5);
		
		//페이징 처리
		sql = " select * from ";
		sql += " (select rownum r, b.* from ";
		sql += " (select * from board";
		//검색 조건이 붙는 조건
		if(searchValue != null && !searchValue.equals("")){
			//콤보박스는 null값이 들어올 일은 없다
			if(searchType.equals("subject")){
				//앞에 한칸 띄워줘야 board where가 된다
				sql += " where subject like '%"+searchValue+"%'";				
			}else if(searchType.equals("writer")){
				sql += " where writer like '%"+searchValue+"%'";								
			}
		}
		//리스트 정렬
		sql += " order by bidx desc) b)";
		sql += " where r>="+paging.getStart()+" and r<="+paging.getEnd();
		
		psmt = conn.prepareStatement(sql);
		//sql 실행 (출력은 본문에서 한다)
		rs = psmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href = "<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<script>
	//검색을 json으로 비동기 처리 하기 위한 작업
	function SCH(){
		$.ajax({
			url : "listSearch.jsp",
			type : "get",
			data : $("form[name='search']").serialize(),
			success : function(data){
				var json = JSON.parse(data.trim());
				console.log(json);
				
				var html = "<thead>";
				html += "<tr><th>글번호</th><th>제목</th><th>작성자</th></tr>";
				html += "</thead>";
				html += "<tbody>";
				for(var i=0; i<json.length; i++){
					html += "<tr><td>"+json[i].bidx+"</td><td>"+json[i].subject+"</td><td>"+json[i].writer+"</td></tr>";
				}
				html += "</tbody>";
				
				$("#LS").html(html);
			}
		});
	}
	
</script>
</head>
<body>
<%@ include file = "/header.jsp" %> <!-- include 시 자기 프로젝트 기준이기 때문에 /를 붙이면 자기 프로젝트를 받아옴 -->
	<section>
		<h2>게시글 목록</h2>
		<article>
			<div class="searchArea">
			
			<!-- 자기 페이지(list.jsp)와 동기처리 하는 코드 -->
			<%--
				<!-- 검색 기능 : 본인 페이지에서 검색함 -->
				<form action="list.jsp">
					<select name="searchType">
						<!-- 검색한 콤보박스를 유지시키는 방법 -->
						<option value="subject" <%if(searchType != null && searchType.equals("subject")) out.print("selected"); %>>글제목</option>
						<option value="writer" <%if(searchType != null && searchType.equals("writer")) out.print("selected"); %>>작성자</option>
						
						<%-- 이렇게도 쓸 수 있다.
						<%
						if(searchType != null){
							if(searchType.equals("subject")){
						%>
							<option value="subject" selected>글제목</option>
							<option value="writer">작성자</option>
						<%		
							}else if(searchType.equals("writer"){
						%>	
							<option value="subject">글제목</option>
							<option value="writer" selected>작성자</option>
						<%
							}else{
							<option value="subject">글제목</option>
							<option value="writer">작성자</option>
							}
						}
						%>
					</select>
					<!-- 검색어 유지 추가하기 -->
					<input type="text" name="searchValue" <%if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")) out.print("value='"+searchValue+"'"); %>>
					<input type="submit" value="검색">
				</form>
						--%>
			<!-- json을 이용한 비동기 처리 코드 -->
				<form name="search">
					<select name="searchType">
			 			<option value="subject" <%if(searchType != null && searchType.equals("subject")) out.print("selected"); %>>글제목</option>
						<option value="writer" <%if(searchType != null && searchType.equals("writer")) out.print("selected"); %>>작성자</option>
			 		</select>
			 		<input type="text" name="searchValue" <%if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")) out.print("value='"+searchValue+"'"); %>>
					<input type="button" value="검색" onclick="SCH()">
			 	</form>
			 
			</div>
			<table class="table table-bordered" id="LS">
				<thead>
					<tr>
						<th width="7%">글번호</th>
						<th>제목</th>
						<th width="7%">작성자</th>
					</tr>
				</thead>
				<tbody>
					<%	//sql 실행 결과 출력
						while(rs.next()){
					%>
						<tr>
							<td><%=rs.getInt("bidx") %></td>
							<!-- 제목에 링크 걸기 및 pk값을 이용한 데이터 구분-->
							<!-- 데이터를 전송할때 uri 뒤에 ?로 시작한다-->
							<!-- 목록 버튼을 눌렀을 때, 검색한 내용 유지하며 되돌아가기 하기 위한 &seartchType, &searchValue 값을 넘김 -->
							<td><a href="view.jsp?bidx=<%=rs.getInt("bidx")%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=rs.getString("subject") %></a></td>
							<td><%=rs.getString("writer") %></td>
						</tr>
					<%		
						}
					%>
				</tbody>
			</table>
			
			<!-- 페이징 영역 -->
			<div id="pagingArea" style="text-align:center;">
				<% if(paging.getStartPage() > 1){ %>
					<a href="list.jsp?nowPage=<%=paging.getStartPage()-1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">&lt;</a>
				<%} %>
				
				<%
					for(int i=paging.getStartPage(); i<=paging.getEndPage(); i++){
						if(i==paging.getNowPage()){
				%>
						<b><%=i %></b>
				<%
					}else{		
				%>
						<a href="list.jsp?nowPage=<%=i%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=i %></a>
				<%
					}
				}
				%>
				
				<!-- cntPage가 넘어갈 경우 -->
				<% if(paging.getEndPage() != paging.getLastPage()){ %>
					<a href="list.jsp?nowPage=<%=paging.getEndPage()+1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">&gt;</a>
				<%} %>
			</div>
			
			<!-- 로그인 해야 보임 -->
			<%
				if(login != null){
			%>
			<button onclick="location.href='insert.jsp'">등록</button>
			<%
				}
			%>
		</article>
	</section>
<%@ include file = "/footer.jsp" %>
</body>
</html>

<%
	}catch(Exception e){
		e.printStackTrace();
	
	//반드시 필요한 부분이다.
	//접속 개수가 제한 되어 있기 때문에 사용 후 닫아줘야 한다.
	//닫지 않으면 나중에 모든 데이터베이스 사용 불가능
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