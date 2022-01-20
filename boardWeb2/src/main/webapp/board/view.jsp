<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import ="java.util.*" %>
<%@ page import="java.sql.*" %>
<!-- 글쓴이와 현재 로그인 유저를 구분하기 위한 로그인 유저 정보 얻기 -->
<%@ page import = "boardWeb2.*" %> <!-- try catch가 상단에서 닫히기 때문에 arraylist 사용해야함 -->

<%
	Member login__ = (Member)session.getAttribute("loginUser");
%>

<%
	request.setCharacterEncoding("UTF-8");
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");

	String bidx = request.getParameter("bidx");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	//connection은 다시 써도 됨
	//reply을 위한 변수 선언
	PreparedStatement psmt2 = null;
	ResultSet rs2 = null;
	
	//db에서 꺼내와서 담을 변수
	String subject_ = "";
	String writer_ = "";
	String content_ = "";
	int bidx_ = 0;
	//로그인 유저와 비교를 위한 midx
	int midx_ = 0;
	//reply 사용
	ArrayList<Reply> rList = new ArrayList<>();
		
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql="select * from board where bidx = "+bidx;
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		//rs.next()가 true인 경우
		if(rs.next()){
			subject_ = rs.getString("subject");
			writer_ = rs.getString("writer");
			content_ = rs.getString("content");
			bidx_ = rs.getInt("bidx");
			//로그인 유저와 비교를 위한 midx
			midx_ = rs.getInt("midx");
		}
		
		//ntt 클래스 생성 후
		//reply 쿼리 한번 더 사용
		sql = "select * from reply r, member m where r.midx=m.midx and bidx="+bidx;
		psmt2 = conn.prepareStatement(sql);
		rs2 = psmt2.executeQuery();
		
		
		while(rs2.next()){
			Reply reply = new Reply();
			//ntt 클래스 사용
			reply.setBidx(rs2.getInt("bidx"));
			reply.setMidx(rs2.getInt("midx"));
			reply.setRidx(rs2.getInt("ridx"));
			reply.setRcontent(rs2.getString("rcontent"));
			reply.setRdate(rs2.getString("rdate"));
			reply.setMembername(rs2.getString("member_name"));
			
			rList.add(reply);
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
		//reply 추가
		if(psmt2 != null){
			psmt2.close();
		}
		if(rs2 != null){
			rs2.close();
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>게시글 상세 조회</h2>
		<article>
			<table border="1" width="70%">
				<tr>
					<th>글제목</th>
					<td colspan="3"><%=subject_ %></td>
				</tr>
				<tr>
					<th>글번호</th>
					<td><%=bidx_ %></td>
					<th>작성자</th>
					<td><%=writer_ %></td>
				</tr>
				<tr>
					<th height="300">글내용</th>
					<td colspan="3"><%=content_ %></td>
				</tr>
			</table>
						<!-- 페이지 이동하는 자바스크립트 명령어 -->
			<button onclick="location.href='list.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>'">목록</button>
	<!-- 로그인 유저만 수정과 삭제가 보이도록 하는 코드 -->
			<%
				if(login__ != null && login__.getMidx() == midx_){
			%>
			<button onclick="location.href='modify.jsp?bidx=<%=bidx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
		<!-- 삭제는 get방식은 위험하므로 form을 사용해 post 방식으로 넘기도록 한다. -->
			<button onclick="deleteFn()">삭제</button>
			<form action = "delete.jsp" method ="post" name="frm">
				<input type = "hidden" name = "bidx" value = "<%=bidx_ %>">
			</form>
			<%
				}else{}
			%>
			
			<div class="replyArea">
				<div class ="replyList">
						<table border="1">
							<tbody id="re">
								<%for(Reply r : rList){ %>
									<tr>
										<td><%=r.getMembername() %><input type="hidden" name="ridx" value="<%=r.getRidx()%>"></td>
										<td><%=r.getRcontent() %></td>
										<td>
										<% if(login__ != null && login__.getMidx() == r.getMidx()){ %>
											<input type="button" value="수정" onclick="modi(this)">
											<input type="button" value="삭제" onclick="del(this)">
										<% } %>
										</td>
									</tr>
									<%} %>
							</tbody>
						</table>
				</div>
				<div class="replytInput">
					<form name="reply">
					<% if(login__ != null){ %>
					<input type="hidden" name="bidx" value="<%=bidx%>">
							<p>
								<label>
									내용 : <input type="text" name="rcontent" size="50">
								</label>
							</p>
							<p>
								<label>
									<input type="button" value="등록" onclick="replyInsert(this)">
								</label>
							</p>
					<% }else{ %>
							<p>
								<label>
									내용 : <input type="text" size="50" value="로그인 후 사용 가능 합니다." readonly>
								</label>
							</p>
					<% } %>
					</form>
				</div>
			</div>
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
	<!-- onclick에 함수 사용하여 submit -->
	<script>
	
		//댓글 등록
		function replyInsert(){
			$.ajax({
				url : "replyInsert.jsp",
				type : "post",
				data : $("form[name='reply']").serialize(),
				success : function(data){
					var json = JSON.parse(data.trim());
						var html = "<tr>";
						html += "<td>"+json[0].member_name+"</td>";
						html += "<td>"+json[0].rcontent+"</td>";
						html += "<td><input type='button' value='수정' onclick='modi(this)'>";
						html += "<input type='button' value='삭제' onclick='del(this)'></td>";
						html += "</tr>"
						
						$("#re").append(html);
						document.reply.reset();
				}
			});
		}
		
		//수정 양식
		function modi(obj){
			var rcontent = $(obj).parent().prev().text();
			console.log(rcontent);											//이전값을 갖고 있을 히든값
			var html = "<input type='text' value='"+rcontent+"'> <input type='hidden' value='"+rcontent+"'>";
			$(obj).parent().prev().html(html);
			
			html = "<input type='button' value='등록' onclick='replyUp(this)'> <input type='button' value='취소' onclick='can(this)'>";
			$(obj).parent().html(html);
			
		}
		
		//수정 댓글 업데이트
		function replyUp(obj){
			var ridx = $(obj).parent().prev().prev().find("input:hidden").val();
			console.log(ridx);
			var rcontent = $(obj).parent().prev().find("input:text").val();
			console.log(rcontent);
			$.ajax({
				url : "replyUpdate.jsp",
				type : "post",
				data : "ridx="+ridx+"&rcontent="+rcontent,
				success : function(data){
					$(obj).parent().prev().html(rcontent);
					
					var html = "<input type='button' value='수정' onclick='modi(this)'> <input type='button' value='삭제' onclick='del(this)'>";
					$(obj).parent().html(html);
				}
			});
		}
		
		//취소 버튼
		function can(obj){
			var prevCon = $(obj).parent().prev().find("input:hidden").val();
			console.log(prevCon);
			$(obj).parent().prev().html(prevCon);
			
			var html = "<input type='button' value='수정' onclick='modi(this)'> <input type='button' value='삭제' onclick='del(this)'>";
			$(obj).parent().html(html);
		}
		
		//삭제 버튼
		function del(obj){
			var YN=confirm("삭제하시겠습니까?");
			var ridx = $(obj).parent().prev().prev().find("input[name='ridx']").val();
			console.log(ridx);
			
			if(YN){
				$.ajax({
					url : "replyDelete.jsp",
					type : "post",
					data : "ridx="+ridx,
					success : function(data){
						$(obj).parent().parent().remove();
					}
				});
			}
		}
	</script>
</body>
</html>