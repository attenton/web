<%@ page language="java" import="java.util.*,java.lang.*,java.sql.*,java.net.*"  contentType="text/html; charset=gb2312"
    pageEncoding="utf-8"%>
<%  request.setCharacterEncoding("utf-8");
    response.setContentType("text/html; charset=utf-8");
    String user_name="";
	user_name = (String)session.getAttribute("username");
	if(user_name==null||user_name.equals("")){
		user_name="anonymous";
	}
	String pwd="";
	String phone="";
	String email="";
	String sex="boy";
	String sexs[]={"",""};
	String face_ ="";
	String Faces[]={"","","","","",""};
	String face="0.jpg";
	int i=0;
	String connectString = "jdbc:mysql://localhost:3306/14353171"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	try{
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
	  Statement stmt=con.createStatement();	
	  if(user_name != "anonymous"){
			  ResultSet rs_face = stmt.executeQuery(String.format("SELECT * FROM bbs_user WHERE username = '%s'",user_name));
			  if(rs_face.next()){
				  face_ =rs_face.getString("face"); 
			  } 
			  rs_face.close();}
	  ResultSet rs=stmt.executeQuery("select * from bbs_user where username='"+user_name+"';");
	  if(rs.next()){
		  pwd = rs.getString("pwd");
		  sex = rs.getString("sex");
		  sexs[0] = sex.equals("boy")?"checked":"";
		  sexs[1] = sex.equals("girl")?"checked":"";
		  face = rs.getString("face");
		  Faces[0] = face.indexOf("0.jpg")>=0?"selected":"";
		  Faces[1] = face.indexOf("1.jpg")>=0?"selected":"";
		  Faces[2] = face.indexOf("2.jpg")>=0?"selected":"";
		  Faces[3] = face.indexOf("3.jpg")>=0?"selected":"";
		  Faces[4] = face.indexOf("4.jpg")>=0?"selected":"";
		  Faces[5] = face.indexOf("5.jpg")>=0?"selected":"";
		  phone = rs.getString("phone")==null?"":rs.getString("phone");
		  email = rs.getString("email")==null?"":rs.getString("email");
	  }
	  rs.close();
	  if(request.getMethod().toUpperCase().equals("POST")){
		String username=request.getParameter("user_name");
		String pwd1=request.getParameter("pwd")==null||request.getParameter("pwd")==""?pwd:request.getParameter("pwd");
	    String sex1=request.getParameter("sex");
	    String face1=request.getParameter("face");
		String phone1=request.getParameter("phone")==null||request.getParameter("phone")==""?phone:request.getParameter("phone");
		String email1=request.getParameter("email")==null||request.getParameter("email")==""?email:request.getParameter("email");
		if(username==null || username==""){
			out.print("<script type='text/javascript'>alert('请输入用户名')</script>");
		}else{
			ResultSet rs1=stmt.executeQuery("select * from bbs_user where username='"+username+"';");
			if(!username.equals(user_name) && rs1.next()){
				out.print("<script type='text/javascript'>alert('用户名已被占用')</script>");
			}
			else{
				Statement stmt1=con.createStatement();
			  	stmt1.executeUpdate(String.format("update bbs_user set username='%s',pwd='%s',face='%s',sex='%s',phone='%s',email='%s' where username='%s';",
			  			username,pwd1,sex1+face1,sex1,phone1,email1,user_name));
				session.setAttribute("username", username);
				response.sendRedirect("index.jsp");
			}
			rs1.close();
		}
	}
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
	var sex = "<%=sex%>";
	function changeSex(which){
		switch(which){
			case 0:
				sex="boy"; break;
			case 1:
				sex="girl"; break;		
			default: sex="boy"; break;
		}
		select();
	}
	function select(){
		var face=document.getElementById("face");
		var index=face.selectedIndex; //所选下拉选框索引值
		var image=document.getElementById("icon");
		image.src="image/"+sex+index+".jpg";
	}
	function test(which){
		switch(which){
			case 0: 		
				var username=document.getElementById('user_name').value;
				var tint=document.getElementById('usernameTint')
				if(username.length>20||username.length<3){
					tint.style.color="red";
					document.getElementById("sub").setAttribute("disabled",true);
				}else{
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}
				break;
			case 1: 		
				var password=document.getElementById('pwd').value;
				var tint=document.getElementById('pwdTint')
				if(password != null && password!="" && (password.length>16||password.length<6)){
					tint.style.color="red";
					document.getElementById("sub").setAttribute("disabled",true);
				}else{
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}
				break;
			case 2: 		
				var password=document.getElementById('pwd').value;
			    var repassword=document.getElementById('repwd').value;
				var tint=document.getElementById('repwdTint');
				if(repassword==password){
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}else{
					tint.style.color="red";
					tint.innerText="两次输入密码不一致";
					document.getElementById("sub").setAttribute("disabled",true);
				}				
				break;
			case 3: 		
				var phone=document.getElementById('phone').value;
				var tint=document.getElementById('phoneTint');
				if(phone=="" || (/^1[34578]\d{9}$/.test(phone))){
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}else{
					tint.style.color="red";
					tint.innerText="手机格式不正确";
					document.getElementById("sub").setAttribute("disabled",true);
				}				
				break;
			case 4: 		
				var email=document.getElementById('email').value;
				var tint=document.getElementById('emailTint');
				if(email=="" || (/^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/.test(email))){
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}else{
					tint.style.color="red";
					tint.innerText="邮箱格式不正确";
					document.getElementById("sub").setAttribute("disabled",true);
				}				
				break;
			default: break;
		}
	}
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
<title>设置</title>
	<style >
		html body, html input, html textarea, html select, html button {
			font-family: '.SFNSText-Regular', 'Helvetica Neue', Helvetica, Arial, "Hiragino Sans GB", "Microsoft YaHei", "WenQuanYi Micro Hei", sans-serif;
			text-rendering: optimizeLegibility;
		}
		body{
			margin: 0 0;
			background: #D1EEEE;
		}
		a{
			text-decoration:none;
			color:black;
		}
		#login:hover,#sign-up:hover{
			color: 	#2C93EE;
		}
		/*-------------------头部-------------------*/
		#head{
			width: 100%;
			height: 46px;
			background: white;
		}
		.head{
			width: 100%;
			height: 46px;
			background: white;
		}
		
		.front{
			width: 1160px;
			height: 46px;
			margin: 0 auto;
    		
		}
		#title{
			float: left;
		}
		#title_text{
			float: left;
			line-height: 46px;
			font-family: ;
			margin-left: 5px; 
		}
		#search{
			position: absolute;
			margin-left: 340px;
			margin-top: 8px;
			margin-bottom: 8px;
		}
		#search-text{
			height: 31px;
			box-sizing: border-box;
    		padding: 0px 50px 0px 10px;
    		box-shadow: none;
    		border: 1px solid #999;
    		border-radius: 3px 4px 4px 3px;
    		line-height: 17px!important;
    		color: #999;
    		outline: none;
		}
		#search-btn{
			width: 40px;
    		height: 31px;
    		padding:0;
    		margin: 0;
    		background: white;
    		border: 1px solid #999;
    		border-left:none;
    		box-shadow: none;
    		border-top-right-radius: 3px;
    		border-bottom-right-radius: 3px;
    		position: absolute;
    		top: 0;
    		right: 0;
    		cursor: pointer;
    		outline: none;
    		color: black;
		}
		.login{
			float: right;
			font-size: 14px;
			line-height: 46px;
			position: relative;
		}
		
		#tou{
			position: absolute;
    		left: 10px;
    		top:3px;
		}
		#login{
			float: right;
			font-size: 14px;
			line-height: 46px;
			margin-right:10px;
		}
		#sign-up{
			float: right;
			font-size: 14px;
			line-height: 46px;
		}
		a#user{
			position: relative;
			display: block;
			text-indent:55px;
			width: 120px;
			line-height:46px;
		}
		.login:hover ul{
			display:block;
			background:white;
			list-style:none;
			position: absolute;
			top:46px;
		}
		
		ul{
			display:none;
			margin:0;
			padding:0;
		}
		li{
			width:120px;
			display: list-item;
			
		}
		li:hover{
			background:rgb(201,202,187);
		}
		li:hover#user{
			background:rgb(201,202,187);
		}
		a#down{
			display:block;
		}
		#fa{
			margin-left:20px;
		}
	#content{width:760px;padding:20px 20px 0 20px;margin:20px auto;border-radius: 5px;box-sizing: border-box;background:white;box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;}
	.rfm{margin:20px auto;width:760px;border-bottom:1px dotted #CDCDCD;}
	.rfm th,.rfm td{padding:10px 2px;vertical-align:top;line-height:24px;}
	.rfm th{padding-right:10px;width:13em;text-align:right;}
	.rfm .px{width:220px;}
	.rq{color:red;}
	.pnc{border-color:#235994;background-color:#06C;background-position:0 -48px;color:#FFF !important;}
	.pnc:active{background-position:0 -71px;}
	</style>
</head>
<body>
<div id="head">
	<div class="head">
		<div class="front">
			<a href="index.jsp" title="主页" ><img src="image/4.png" height="46" height="46" id="title"><span id="title_text">4点IT</span></a>
			<div id="search" class="search-box">
				<form  target="_blank" method="get" action="search.jsp" enctype="text/plain">
					<input id="search-text" name="search_title" type="text" placeholder="搜索你感兴趣的内容..."  value="" autocomplete="off">
					<button id="search-btn" class="search-btn" type="submit"><i class="fa fa-search fa-1x" aria-hidden="true"></i></button>
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
<div id="content">
<form method="post"  class="cl">
<div class="rfm">
<table>
<tr>
<th>用户名:</th>
<td><input id="user_name" type="text"  name="user_name" class="px" 
	onfocus="document.getElementById('usernameTint').innerText='用户名长度在3-20个字符之间';"
	onblur="test(0)" value=<%=user_name%> >
 <label id="usernameTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>新密码:</th>
<td><input id="pwd" type="password"  name="pwd"  class="px" 
	onfocus="document.getElementById('pwdTint').innerText='密码长度在6-16个字符之间';"
	onblur="test(1)"  value="">
<label id="pwdTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>确认密码:</th>
<td><input id="repwd" type="password"  name="repwd" class="px"
	onfocus="document.getElementById('repwdTint').innerText='请确认密码';"
	onblur="test(2)"  value="">
<label id="repwdTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
	<th>性别:</th>
	<td>男<input id="boy" name="sex" type="radio" value="boy"  onclick="changeSex(0)" <%=sexs[0] %>/>
		女<input id="girl" name="sex" type="radio" value="girl" onclick="changeSex(1)" <%=sexs[1] %>/> </td>
	</label>	<br/><br/>
</div>

<div class="rfm">
<table>
<tr>
    <th>头像:</th>     
    <td><select id="face" name="face" onchange="select()"> 
           <option value="0.jpg" <%=Faces[0] %> >face0.jpg</option>
           <option value="1.jpg" <%=Faces[1] %> >face1.jpg</option>
           <option value="2.jpg" <%=Faces[2] %> >face2.jpg</option>
           <option value="3.jpg" <%=Faces[3] %> >face3.jpg</option>
           <option value="4.jpg" <%=Faces[4] %> >face4.jpg</option>
           <option value="5.jpg" <%=Faces[5] %> >face5.jpg</option>
        </select>
    </td>
    <td> <img id="icon" src="<%="image/"+face %>"> </img> </td> 
    </tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>手机:</th>
<td><input id="phone" type="text"  name="phone" class="px" 
	onfocus="document.getElementById('phoneTint').innerText='请输入11位手机号码';"
	onblur="test(3)" value="<%=phone%>">
<label id="phoneTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>邮箱:</th>
<td><input id="email" type="text"  name="email" class="px" 
	onfocus="document.getElementById('emailTint').innerText='请输入可用邮箱';"
	onblur="test(4)" value="<%=email%>">
<label id="emailTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<div class="rfm">
<table width="100%">
<tr>
<th>&nbsp;</th>
<td>
<span>
<em>&nbsp;</em><button id="sub" class="pnc"  type="submit" value="true" name="sub"><strong>提交</strong></button>
</span>

</td>
</tr>
</table>
</div>
</form>
</div>
</body>
</html>