<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html;charset=gb2312"%>
      <%request.setCharacterEncoding("utf-8");
      response.setContentType("text/html; charset=utf-8");
	String msg ="";
	String msg2="";
	String user_name="";
	String pwd="";
	String repwd="";
	String phone="";
	String email="";
	String sex="boy";
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
	  if(request.getMethod().toUpperCase().equals("POST")){
		user_name=request.getParameter("user_name");
		pwd=request.getParameter("pwd");
		repwd=request.getParameter("repwd");
	    
		phone=request.getParameter("phone");
		email=request.getParameter("email");
		if(user_name==null || user_name==""){
			out.print("<script type='text/javascript'>alert('请输入用户名')</script>");
		}else if(pwd==null||pwd==""||repwd==""||repwd==null){
			out.print("<script type='text/javascript'>alert('请输入密码')</script>");
		}else{
			ResultSet rs=stmt.executeQuery("select * from bbs_user where username='"+user_name+"';");
			if(rs.next()){
				out.print("<script type='text/javascript'>alert('用户名已被占用')</script>");
			}
			else{
			  	stmt.executeUpdate("insert into bbs_user(username,pwd,sex,face,phone,email) values('"
				  		+user_name+"','"+pwd+"','"+sex+"','"+sex+face+"','"+phone+"','"+email+"');");
				session.setAttribute("username", user_name);
				response.sendRedirect("index.jsp");
			}
		}
	}
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	}
%><!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml">
<script>
	var sex="boy";
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
		var index=face.selectedIndex;//所选下拉选框索引值
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
				if(password.length>16||password.length<6){
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>立即注册</title>
<style type="text/css">
	body{background:#D1EEEE;}
	.bm{border:1px solid #CDCDCD;background:#FFF;width: 760px;margin: 0 auto}
	.rfm{margin:0 auto;width:760px;border-bottom:1px dotted #CDCDCD;}
	.rfm th,.rfm td{padding:10px 2px;vertical-align:top;line-height:24px;}
	.rfm th{padding-right:10px;width:13em;text-align:right;}
	.rfm .px{width:220px;}
	.bm_h{padding:0 10px;height:31px;border-top:1px solid #FFF;border-bottom:1px solid #C2D5E3;background:#F2F2F2;line-height:31px;white-space:nowrap;overflow:hidden;}
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
<a href="login.jsp" class="xi2">已有帐号？现在登录</a>
</span>
<h3 class="xs2">立即注册</h3>
</div>
<form method="post"  class="cl"  action="sign_up.jsp">
<div class="rfm">
<table>
<tr>
<th><span class="rq">*</span>用户名:</th>
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
<th><span class="rq">*</span>密码:</th>
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
<th><span class="rq">*</span>确认密码:</th>
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
	<td>男<input id="boy" name="sex" type="radio" value="boy"  checked="checked" onclick="changeSex(0)"/>
		女<input id="girl" name="sex" type="radio" value="girl" onclick="changeSex(1)"/> </td>
	</label>	<br/><br/>
</div>

<div class="rfm">
<table>
<tr>
    <th>头像:</th>     
    <td><select id="face" name="face" onchange="select()"> 
           <option value="0.jpg" >face0.jpg</option>
           <option value="1.jpg" >face1.jpg</option>
           <option value="2.jpg" >face2.jpg</option>
           <option value="3.jpg" >face3.jpg</option>
           <option value="4.jpg" >face4.jpg</option>
           <option value="5.jpg" >face5.jpg</option>
        </select>
    </td>
    <td> <img id="icon" src="<%="image/"+sex+face %>"> </img> </td> 
    </tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>手机:</th>
<td><input id="phone" type="text"  name="phone" class="px" 
	onfocus="document.getElementById('phoneTint').innerText='请输入11位手机号码';"
	onblur="test(3)" value="">
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
	onblur="test(4)" value="">
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