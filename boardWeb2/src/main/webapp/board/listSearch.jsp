<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "boardWeb2.*"%>
<%@ page import = "org.json.simple.*"%>

<%
	request.setCharacterEncoding("UTF-8");
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from board";
		
		if(searchValue != null && !searchValue.equals("")){
			if(searchType.equals("writer")){
				sql += " where writer like '%"+searchValue+"%'";
			}else if(searchType.equals("subject")){
				sql += " where subject like '%"+searchValue+"%'";
			}
		}
		
		psmt = conn.prepareStatement(sql);
		System.out.println(sql);
		rs = psmt.executeQuery();
		
		
		JSONArray list = new JSONArray();
		
		while(rs.next()){
			JSONObject jobj = new JSONObject();
			
			jobj.put("bidx", rs.getInt("bidx"));
			jobj.put("subject", rs.getString("subject"));
			jobj.put("writer", rs.getString("writer"));
			
			
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