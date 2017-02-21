<%@ page language="java" import="java.util.*,java.sql.*,java.net.*" 
         contentType="text/html;charset=gb2312"%>
      <%request.setCharacterEncoding("utf-8");
      response.setContentType("text/html; charset=utf-8");
      response.setCharacterEncoding("utf-8");
	String msg ="";
	String msg2="";
	String msg3="";
	String user_name="";
	String pwd="";
	String repwd="";
	String name="1";
	String sub="";//=request.getParameter("sub");
	int i=0;
	int id=0;
	String connectString = "jdbc:mysql://localhost:3306/14353171"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	try{
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
	  Statement stmt=con.createStatement();	  
	  if(request.getMethod().toUpperCase().equals("POST")){
		user_name=request.getParameter("user_name");
		pwd=request.getParameter("pwd");
		ResultSet rs=stmt.executeQuery("select * from bbs_user where username='"+user_name+"';");
	  if(!user_name.equals("")){
		  if(!pwd.equals("")){
		      if(rs.next()){
				repwd=rs.getString("pwd");
				name=rs.getString("username");	
				id=rs.getInt("id");
			}	
		      if(!user_name.equals(name)){
		    	  msg="用户名不存在";
		      }
		      else{
		      if(!pwd.equals(repwd)){
					msg2="密码错误";
				}
		      else if(pwd.equals(repwd)&&user_name.equals(name)&&!pwd.equals("")){
					msg3="登陆成功";
					user_name=URLEncoder.encode(user_name,"utf-8");
					
					session.setAttribute("username", user_name);
					response.sendRedirect("index.jsp");
				}
		    }
		  } 
		  else{
			msg2="密码不能为空";
		  }
	  }
	  else{
		msg="用户名不能为空";
	   }
	  rs.close();
	}
	  
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	}
%><!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>登录</title>

<style type="text/css">
	body{background:#D1EEEE;}
	.bm{border:1px solid #CDCDCD;background:#FFF;width: 760px;margin: 0 auto;position:absolute;top:50%;left:50%;margin:-15% 0 0 -25%;}
	.rfm{margin:0 auto;width:760px;border-bottom:1px dotted #CDCDCD;}
	.rfm th,.rfm td{padding:10px 2px;vertical-align:top;line-height:24px;}
	.rfm th{padding-right:10px;width:12em;text-align:right;}
	.rfm .px{width:220px;}
	.bm_h{padding:0 10px;height:31px;border-top:1px solid #FFF;border-bottom:1px solid #C2D5E3;background:#F2F2F2;line-height:31px;white-

space:nowrap;overflow:hidden;}
	.xs2{font-size:14px !important;}
	.y{float:right;}
	.rq{color:red;}
	h3{margin:0;padding:0;}
	.pnc{border-color:#235994;background-color:#06C;background-position:0 -48px;color:#FFF !important;}
	.pnc:active{background-position:0 -71px;}
</style>
</head>
<body>
<div class="bm">

<div class="bm_h">
<span class="y">
<a href="sign_up.jsp" class="xi2">没有帐号？立即注册</a>
</span>
<h3 class="xs2">登录</h3>
</div>



<form method="post" class="cl"  action="login.jsp">



<div class="rfm">
<table>
<tr>
<th>用户名:</th>
<td><input type="text" name="user_name"   class="px"  value=<%=user_name%>></td>
<td style="color:red;"><%=msg%></td>
<td></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>密码:</th>
<td><input type="password"   class="px" name="pwd"></td>
<td style="color:red;"><%=msg2%></td>
<td></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th></th>
<td><button class="pn pnc" type="submit" name="lostpwsubmit" value="true" ><span>提交</span></button></td>
<td></td>
<td style="color:red;"><%=msg3%></td>
</tr>
</table>
</div>

</form>
</div>
</body>
</html>