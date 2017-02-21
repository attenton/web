<%@ page language="java" import="java.util.*,java.sql.*,java.text.*" 
         contentType="text/html;charset=gb2312"%>
      <%request.setCharacterEncoding("utf-8");
      response.setContentType("text/html; charset=utf-8");
	String msg ="";
	String topic_title=request.getParameter("title");
	String topic_content=request.getParameter("message");
	String board_id=request.getParameter("board_id");
	String user_name="";
	String board_name="";
	String class_name="";
	String face="";
	user_name = (String)session.getAttribute("username");

	if(user_name==null||user_name.equals("")){
		user_name="anonymous";
		response.setHeader("refresh","3;URL=login.jsp");
	}
	String connectString = "jdbc:mysql://localhost:3306/14353171"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	if(topic_title==null){
		topic_title="";
	}
	if(topic_content==null){
		topic_content="";
	}
	try{
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
	  Statement stmt=con.createStatement();
	  Statement stmt2=con.createStatement();
	  Statement stmt3=con.createStatement();
	  ResultSet rs = stmt2.executeQuery("select * from board,class where board_id="+board_id+" and board.board_classID=class.class_id;");
	  if(rs.next()){
		  board_name=rs.getString("board_name");
		  class_name=rs.getString("class_name");
	  }
	  rs.close();
	  ResultSet rs_face = stmt.executeQuery(String.format("SELECT * FROM bbs_user WHERE username = '%s'",user_name));
	  if(rs_face.next()){
		  face=rs_face.getString("face"); 
	  } 
	  rs_face.close();
	  stmt2.close();
	  if(request.getMethod().toUpperCase().equals("POST")){
		  msg="发帖成功";
		  SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		  java.util.Date currentTime = new java.util.Date();//得到当前系统时间
		  String topic_sendTime = formatter.format(currentTime); //将日期时间格式化 
		  String str_date2 = currentTime.toString(); //将Date型日期时间转换成字符串形式 
		  stmt.executeUpdate("insert into topic(topic_boardID,topic_title,topic_content,topic_sender,topic_sendTime) "+
			   "values('"+board_id+"','"+topic_title+"','"+topic_content+"','"+user_name+"','"+topic_sendTime+"');");
	      ResultSet rs1=stmt3.executeQuery("SELECT @@identity;");
	      String topic_id="";
		  if(rs1.next()){
		     topic_id=rs1.getString("@@identity");
		  }
		  response.sendRedirect("topic.jsp?topic_id="+topic_id);
	  }
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	  msg = "";
	}
%>
<!DOCTYPE html>
<html>
<script>
	function post() {
		var error = document.getElementById("error");
		var title = document.getElementById("topic_title").value;
		var richedit = document.getElementById("richedit").innerHTML;
		var content = document.getElementById("content");
		if(title==""||title==null){
			error.innerHTML="标题不得为空";
		}
		else if(title.length>60){
			error.innerHTML="标题不得超过60个字符";
		}
		else if(richedit.length>2000||richedit.length<6){
			error.innerHTML="您的帖子长度不符合要求。当前长度:"+richedit.length+",规定长度:6到2000";
		}else{
			content.value=richedit;
			error.innerHTML="确认发帖?<input id='ok' type='submit' name='ok' value='确认'> <input id='not' type='button' name='not' onclick='cancel()' value='取消'> ";
		}
	}
	function cancel(){
		document.getElementById("error").innerHTML="";
	}
</script>
<head>
<link type="text/css" href="style_css.css" rel="stylesheet" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
	<title>发帖</title>
	<style >
		.content{width:1160px;margin:20px auto;padding:20px 0;border-radius: 5px;box-sizing: border-box;background-color: white;box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;}
		#menu{margin-bottom:20px!important;margin-left:20px;}
		#sen{padding:0 20px;}
		.thbgimg{background-image:url(../images/th_linebg.jpg); background-repeat:repeat-y; background-position:right center;}
		.tdbgimg{background-image:url(../images/td_linebg.jpg); background-repeat:repeat-y; background-position:right center;}
		.td_color01{ background-color:#edf8fe;}
		.tr_bgf7 td{ background-color:#f7f7f7;}
		.tr_bgff td{ background-color:#fff;}
		.input-sty{ height:18px; line-height:18px; padding:0 3px;border:1px solid #7f9db9;}
		.w430{width:430px;}
		.area720{width:720px; height:70px; border:1px solid #d4d4d4;}
		.order_sty{ display:block;width:34px; height:20px; border:1px solid #95b6ce; text-align:center; font-weight:bold; margin:5px auto;margin-left:0px;}
		.black_a a{ color:#000;}
		
		#tt{
			background:rgba(0, 0, 0, 0.04);
		}
		#topic_title{
			border:none;
			outline:none;
			background:rgba(0, 0, 0, 0.04);
		}
		#richedit{
			width:1080px;
			height:200px;
			overflow-x: hidden;
    		overflow-y: auto;
    		resize: vertical;
    		outline: none !important;
    		border: none !important;
    		background: rgba(0, 0, 0, 0.04) !important;
    		border-bottom: 4px solid rgba(0, 0, 0, .04) !important;
    		padding: 10px 10px !important;
		}
		#submit{
	    	height: 28px !important;
	    	width: 60px;
    		line-height: 28px !important;
    		padding: 0 10px !important;
    		box-sizing: content-box;
    		margin-top:20px;
			border: none !important;
    		border-radius: 13px;
    		text-indent: 3px;
    		text-align: center;
    		transition-property: background, box-shadow;
    		transition-duration: .4s;
    		transition-timing-function: ease;
    		cursor: pointer;
    		outline: none !important;
		}
		#submit:hover{
			background: rgb(201,202,187);
		} 
	</style>
</head>
<body>
<div id="head">
<div class="head">
	<div class="front">
	<a href="index.jsp" title="主页" ><img src="image/4.png" height="46" height="46" id="title"><span id="title_text">4点IT</span></a>
	<div id="search" class="search-box">
	<form  target="_blank" method="get" action="search.jsp"  enctype="text/plain">
	<input id="search-text" type="text" placeholder="搜索你感兴趣的内容..." name="search_title" autocomplete="off">
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
<div class="content" >
<div id="menu">
	<a href="index.jsp?user_name=<%=user_name %>"><i class="fa fa-home fa-1x"></i>&nbsp;论坛首页</a> >
	<span><%=class_name%></span> >
	<a href="board.jsp?board_id=<%=board_id%>"><%=board_name%></a> >
	<span>发表帖子</span>
</div>
<%if(user_name.equals("anonymous")){%>
     <h3>游客您好，请登陆后发帖，3秒后为您跳到登陆页面</h3>
     <h3>如果没有跳转请点击<a href="login.jsp">这里</a></h3>
<%}else {%>
<hr>
<div id="sen">
<form method="post" class="sub">
<table width="800px" border="0" cellpadding="0" cellspacing="0">
	<tr>
	
	<td style=" line-height:40px; height:'40px'"   align="left" valign="middle">
		<input line-height:30px; height:'30px'; font-size:'25px';font:'bold'" name="title" id="topic_title" type="text" class="title"  value=<%=topic_title %>>
		<span class="write_title">(1-15字)</span>
	</td>
	</tr>
</table>
<div style="background-color:rgba(0,0,0,0.2);  width:350px;margin:20px 0 0px;" >
<input type="button" style="background:url(image/edit/left.png);background-size:30px 30px;border:none;padding:0,0;cursor: pointer;vertical-align:middle;" onclick="left()">
<input type="button" style="background:url(image/edit/center.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="center()">
<input type="button" style="background:url(image/edit/right.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="right()">  
<input type="button" style="background:url(image/edit/indent.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="indent()">
<input type="button" style="background:url(image/edit/outdent.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="outdent()">  
<input type="button" style="background:url(image/edit/bold.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="bold()">
<input type="button" style="background:url(image/edit/italic.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="italic()">
<input type="button" style="background:url(image/edit/underline.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="underline()">
<input type="button" style="background:url(image/edit/strike.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="strikeThrough()">  
<input type="button" style="background:url(image/edit/copy.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="copy()">
<input type="button" style="background:url(image/edit/paste.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="paste()">
<input type="button" style="background:url(image/edit/cut.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="cut()">
</div>
<div class="editable" id="richedit" contenteditable="true" style="border:solid 1px black;WORD-BREAK: break-all;min-width:200px;max-width:800px;min-height:200px;">
</div><br>
<input id="content" name="message" type="hidden" value="">
<script>
function left() {
	document.execCommand("JustifyLeft", false, null);
	}
function center() {
	document.execCommand("JustifyCenter", false, null);
	}
function right() {
	document.execCommand("JustifyRight", false, null);
	}
function full() {
	document.execCommand("JustifyFull", false, null);
	}
function indent() {
	document.execCommand('Indent');
	}
function outdent() {
	document.execCommand('Outdent');
	}
function bold() {
	document.execCommand('Bold');
	}
function italic() {
document.execCommand("italic", false, null);
}
function underline() {
	document.execCommand('Underline');
	}
function strikeThrough() {
	document.execCommand('StrikeThrough');
	}
function copy() {
	document.execCommand("Copy",false,null);
	}
function paste() {
	document.execCommand('Paste');
	}
function cut() {
	document.execCommand('Cut');
	}

function show() {
varo = document.getElementById("richedit");
alert(o.innerHTML);
}
</script>
<input id="submit" type="button" name="submit"  onclick="post()" value="发表帖子">
<span id="error" style="color:red;"></span>
</form>

</div>
<%}%>
</div>
</body>
</html>