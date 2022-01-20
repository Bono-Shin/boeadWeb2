<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ page import = "java.sql.*"%>
<%@ page import = "org.json.simple.*" %>
<%@ page import = "boardWeb2.*" %>

<%
	request.setCharacterEncoding("UTF-8");

	Member login__ = (Member)session.getAttribute("loginUser");
	int midx= login__.getMidx();

	String rcontent = request.getParameter("rcontent");
	String bidx = request.getParameter("bidx");
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "insert into reply(ridx,rcontent,midx,bidx) values(ridx_seq.nextval,?,?,?)";
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,rcontent);
		psmt.setInt(2,midx);
		psmt.setInt(3,Integer.parseInt(bidx));
		
		int result = psmt.executeUpdate();
		
		//------------------------ 여기까지가 insert ---------------------------
		
		
		
		sql = "select * from reply r, member m where r.midx=m.midx and r.ridx=(select max(ridx) from reply)";
		psmt = null;
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		JSONArray list = new JSONArray();
		if(rs.next()){
			JSONObject jobj = new JSONObject();
			jobj.put("ridx",rs.getInt("ridx"));
			jobj.put("midx",rs.getInt("midx"));
			jobj.put("bidx",rs.getInt("bidx"));
			jobj.put("member_name",rs.getString("member_name"));
			jobj.put("rcontent",rs.getString("rcontent"));
			
			list.add(jobj);
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