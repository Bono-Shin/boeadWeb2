package boardWeb2;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBManager {

	// static으로 두는 이유는 매번 객체화 하지 않으려고
	public static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	public static String user = "system";
	public static String pass = "1234";
	
	public static Connection getConnection() {
		Connection conn = null;
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url,user,pass);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	
	//오버로딩 사용
	public static void close(PreparedStatement psmt, Connection conn, ResultSet rs) {
		try {
			if(psmt != null) psmt.close();
			if(conn != null) conn.close();
			if(rs != null) rs.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}
