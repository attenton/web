<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html;charset=gb2312"%>
      <%request.setCharacterEncoding("utf-8");
      response.setContentType("text/html; charset=utf-8");
	String msg ="";
	String msg2="";
	String msg3="";
	String user_name="";
	String face="";
	StringBuilder table=new StringBuilder();
	
	user_name = (String)session.getAttribute("username");

	if(user_name==null||user_name.equals("")){
		user_name="anonymous";
	}
	String connectString = "jdbc:mysql://localhost:3306/14353171"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	StringBuilder board_id0=new StringBuilder("");
	StringBuilder board_classID0=new StringBuilder("");
	StringBuilder board_name0=new StringBuilder("");
	try{
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
	  Statement stmt=con.createStatement();	 
	  Statement stmt1=con.createStatement();
	  if(user_name != "anonymous"){
	  ResultSet rs_face = stmt.executeQuery(String.format("SELECT * FROM bbs_user WHERE username = '%s';",user_name));
	  if(rs_face.next()){
		  face=rs_face.getString("face"); 
	  } 
	  rs_face.close();}
	  ResultSet rs = stmt.executeQuery("SELECT * FROM class;");
	  while(rs.next()){
		  table.append(String.format("<div class=\"section\"><div id=\"sec_head\"><span id=\"sec_text\"><i class=\"fa fa-comment-o\" aria-hidden=\"true\"></i>&nbsp;%s</span></div>",
				  rs.getString("class_name")));
		  ResultSet rs1 = stmt1.executeQuery("select * from board where board_classID="+rs.getInt("class_id")+";");
		  table.append("<div id='sec_content'><table cellspacing='0' cellpadding='0'>");
		  int cnt = 0;
		  while(rs1.next()){
			  cnt = cnt+1;
			  if(cnt % 2 == 1){
				  table.append("<tr>");
			  }
			  table.append(String.format("<td ><a href=\"%s\"><div id=\"sec_td_content\"><span id=\"sec_td_content_text\">%s</span></div>	</a></td>"
					  ,"board.jsp?board_id="+rs1.getInt("board_id"),rs1.getString("board_name")));
			  if(cnt % 2 == 0){
				  table.append("</tr>");
			  }
		  }
		  if(cnt%2==0) table.append("</tr>");
		  table.append("</table></div></div>");
	  }
	  rs.close();
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	  msg = e.getMessage();
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
<link type="text/css" href="style_css.css" rel="stylesheet" />
	<title>主页</title>
	<style >

	</style>
</head>
<body>
<div id="head">
<div class="head">
	<div class="front">
	<a href="" title="主页" ><img src="image/4.png" height="46"id="title"><span id="title_text">4点IT</span></a>
	<div id="search" class="search-box">
	<form  target="_blank" method="get" action="search.jsp" enctype="text/plain">
	<input id="search-text" name="search_title" type="text" placeholder="搜索你感兴趣的内容..."  value="" autocomplete="off">
	<button id="search-btn" class="search-btn"><i class="fa fa-search fa-1x" aria-hidden="true"></i></button>
	</form>
	</div>
	<div class="login">
		<%if(user_name.equals("anonymous")){ %>
	<a href="sign_up.jsp" id="sign-up"><i class="fa fa-user-circle fa-lg" aria-hidden="true"></i>&nbsp;注册</a>
	<a href="login.jsp" id="login"><i class="fa fa-user-circle-o fa-lg" aria-hidden="true"></i>&nbsp;登录</a>
		<%}else {%>
		
		<a href="mytheme.jsp" id="user"><img src="image/<%=face%>" style="border-radius:20px" width="40px" height="40px" id="tou"><span class="user_name"><%=user_name%></span></a>
		<ul>
		<li><a href="mytheme.jsp" id="down"><i class="fa fa-user-o" aria-hidden="true" id="fa"></i>&nbsp;&nbsp;个人主页</a></li>
		<li><a href="MySetting.jsp" id="down"><i class="fa fa-cog" aria-hidden="true" id="fa"></i>&nbsp;&nbsp;设置</a></li>
		<li><a href="logout.jsp" id="down"><i class="fa fa-power-off" aria-hidden="true" id="fa"></i>&nbsp;&nbsp;退出 </a></li>
		</ul>
		<%}%>
	</div>
	</div>
</div>
</div>
<%=table %>
<%=msg %>
</body>
</html>