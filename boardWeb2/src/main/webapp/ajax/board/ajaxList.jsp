<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "boardWeb2.*" %>
<%@ page import = "org.json.simple.*" %>
<%@ page import = "java.sql.*" %>

<%
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from board order by bidx desc";
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		//json 만들기 (라이브러리가 있어야 사용가능)
		JSONArray list = new JSONArray();
		
		while(rs.next()){
			JSONObject jobj = new JSONObject();
					//json 데이터의 키값 , db에서 가져올 정보값
			jobj.put("subject", rs.getString("subject"));
			jobj.put("writer", rs.getString("writer"));
			jobj.put("bidx", rs.getInt("bidx"));
			jobj.put("midx", rs.getInt("midx"));
			
			//위에 상태로 놔두면 while문이 끝나고 사라지므로 list에 add로 담는다
			list.add(jobj);
		}
		
		out.print(list.toJSONString());
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
%>