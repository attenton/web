<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");%>
<%  String msg="";
	String id=request.getParameter("id");
	String username="";
	String connectString = "jdbc:mysql://localhost:3306/14353171"
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	String user="user";
	String pwd="123";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, user, pwd);
		Statement stmt=con.createStatement();
		ResultSet rs = stmt.executeQuery("select * from bbs_user where id="+id);
		if(rs.next()){
			username = rs.getString("username");
		}
		rs.close();
		stmt.executeUpdate("delete from answer where answer_sender='"+username+"'");
		stmt.executeUpdate("delete from topic where topic_sender='"+username+"'");
		stmt.executeUpdate("delete from bbs_user where id="+id);
		msg = "成功删除用户!";
		stmt.close(); 
		con.close();
	}catch(Exception e){
		msg = e.getMessage();
	}
	out.print(msg);
%>