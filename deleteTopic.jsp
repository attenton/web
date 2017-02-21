<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");%>
<%  String msg="";
	String topic_id=request.getParameter("topic_id");
	String connectString = "jdbc:mysql://localhost:3306/14353171"
	+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
	String user="user";
	String pwd="123";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, user, pwd);
		Statement stmt=con.createStatement();
		stmt.executeUpdate("delete from answer where answer_topicID="+topic_id);
		stmt.executeUpdate("delete from topic where topic_id="+topic_id);
		msg = "成功删除帖子!";
		stmt.close(); 
		con.close();
	}catch(Exception e){
		msg = e.getMessage();
	}
	out.print(msg);
%>