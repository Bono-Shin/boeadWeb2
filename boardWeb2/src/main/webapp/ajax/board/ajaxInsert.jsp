<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%@ page import = "boardWeb2.*" %>
<%@ page import = "java.sql.* " %>
<%@ page import = "org.json.simple.*" %>
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
//등록 실시간을 위한
ResultSet rs = null;

try{
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);
	
	String sql = "insert into board(bidx,subject,writer,content,midx) values(bidx_seq.nextval,?,?,?,25)";
	psmt = conn.prepareStatement(sql);
	psmt.setString(1,subject);
	psmt.setString(2,writer);
	psmt.setString(3,content);
	
	int result = psmt.executeUpdate();
	
	//등록 실시간 (쿼리가 불확실 할때는 db에서 확인 후 사용) - 가장 큰 bidx 찾기 -> 최신글
	sql = "select * from board where bidx = (select max(bidx) from board)";
												//bidx 최대값
	psmt = null;
	psmt = conn.prepareStatement(sql);
	
	rs = psmt.executeQuery();
	
	JSONArray list = new JSONArray();
	
	if(rs.next()){
		JSONObject obj = new JSONObject();
		
		obj.put("bidx", rs.getInt("bidx"));
		obj.put("subject", rs.getString("subject"));
		obj.put("writer", rs.getString("writer"));
		
		list.add(obj);
	}
	
	out.print(list.toJSONString());
	
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
