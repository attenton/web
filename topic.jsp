<%@ page import="java.util.*,java.sql.*,java.text.*" language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <% request.setCharacterEncoding("utf-8");
		String msg ="";
		
		String user_name="";
		String topic_sender="";
		user_name = (String)session.getAttribute("username");
		if(user_name==null||user_name.equals("")){
			user_name="anonymous";
		}
		Integer pgno = 0; //当前页号
		Integer pgcnt = 10; //每页行数
		String param = request.getParameter("pgno");
		if(param != null && !param.isEmpty()){
			pgno = Integer.parseInt(param);
		}
		param = request.getParameter("pgcnt");
		if(param != null && !param.isEmpty()){
		pgcnt = Integer.parseInt(param);
		}
		String connectString = "jdbc:mysql://localhost:3306/14353171"
		+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
		String user="user";
		String pwd="123";
		StringBuilder topic_send_show = new StringBuilder();
		StringBuilder answer_send_show = new StringBuilder();
		int answer_count = 1; 
		String title = "";
		int boardID =1;
		String board_name ="";
		String face ="";
		String class_name ="";
		int topic_id = Integer.parseInt(request.getParameter("topic_id"));
		try{
			Class.forName("com.mysql.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString, user, pwd);
			Statement stmt=con.createStatement();
			String sql_count=String.format("select count(answer_id) as count_id from answer where answer_topicID= %d",topic_id);
			ResultSet rs_count=stmt.executeQuery(sql_count);
			while(rs_count.next()){
				answer_count = rs_count.getInt("count_id") + 1;
			}
			rs_count.close();
			if(user_name != "anonymous"){
				  ResultSet rs_face = stmt.executeQuery(String.format("SELECT * FROM bbs_user WHERE username = '%s'",user_name));
				  if(rs_face.next()){
					  face=rs_face.getString("face"); 
				  } 
				  rs_face.close();}
			if(request.getParameter("memo") != null){
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				java.util.Date currentTime = new java.util.Date();//得到当前系统时间
				String topic_sendTime = formatter.format(currentTime); //将日期时间格式化 
				String str_date2 = currentTime.toString(); //将Date型日期时间转换成字符串形式
				String sql_re = String.format("insert into answer(answer_topicID,answer_content,answer_sender,answer_sendTime) value('"+topic_id+"','"+request.getParameter("memo")+"','"+user_name+"','"+topic_sendTime+"');");
				stmt.execute(sql_re);
				response.sendRedirect("topic.jsp?topic_id="+topic_id);
			}
			if(pgno == 0){
			String sql=String.format("select * from topic where topic_id= %d",topic_id);
			ResultSet rs=stmt.executeQuery(sql);
			while(rs.next()) {
				Statement stmt_img=con.createStatement();
				String sql_img=String.format("select * from bbs_user where username= '%s'",rs.getString("topic_sender"));
				ResultSet rs_img = stmt_img.executeQuery(sql_img);
				String face_ = "";
				if(rs_img.next()){
					face_ = rs_img.getString("face");
				}
				title = rs.getString("topic_title");
				boardID = rs.getInt("topic_boardID");
				topic_send_show.append(String.format(
				"<div class='_show'><div id='answer_sender'><img src=\"image/%s\" width='100px'><div id='sender'><span>%s</span></div>",
				face_,rs.getString("topic_sender"))
				);	
				if(user_name.equals("admin")&&rs.getString("topic_sender").equals("admin")==false){
					topic_send_show.append(String.format("<div><input id='deleteUser' type='Button' value='删除用户' onclick='delete(%s)'></div>",
							"deleteUser("+rs_img.getInt("id")+")"));	
				}
				topic_send_show.append(String.format("</div><div id='answer_content'><div id='ans_con'><span>%s</span></div>",rs.getString("topic_content"))
						);	
				if(user_name.equals("admin")||user_name.equals(rs.getString("topic_sender"))){  //管理员admin、发帖人
					topic_send_show.append(String.format("<div><input id='delete' type='Button' style='float:right' value='删除帖子' onclick='%s'></div>",
						"deleteTopic("+topic_id+")"));	
				}
				topic_send_show.append(String.format("<div id='ans_con_footer'><div id='data'><span id='rel_time'>%s</span><span id='floor'>#%d</span></div></div></div></div>",rs.getString("topic_sendTime"),1));
			}
			rs.close();
			
			}else{
				String sql=String.format("select * from topic where topic_id= %d",topic_id);
				ResultSet rs=stmt.executeQuery(sql);
				while(rs.next()) {
					title = rs.getString("topic_title");
					boardID = rs.getInt("topic_boardID");
				}
				rs.close();
			}
			int classID = 0;
			String sql_board=String.format("select * from board where board_id= %d", boardID);
			ResultSet rs_board=stmt.executeQuery(sql_board);
			while(rs_board.next()){
				board_name = rs_board.getString("board_name");
				classID = rs_board.getInt("board_classID");
			}
			rs_board.close();
			String sql_class=String.format("select * from class where class_id= %d", classID);
			ResultSet rs_class=stmt.executeQuery(sql_class);
			while(rs_class.next()){
				class_name = rs_class.getString("class_name");
			}
			rs_class.close();
			String sql_ans =String.format("select * from answer where answer_topicID=%d order by answer_sendTime limit %d,%d ",topic_id,pgno*pgcnt,pgcnt);
			ResultSet rs_ans = stmt.executeQuery(sql_ans);
			int flo = 2;
			while(rs_ans.next()){
				Statement stmt_img=con.createStatement();
				String sql_img=String.format("select * from bbs_user where username= '%s'",rs_ans.getString("answer_sender"));
				ResultSet rs_img = stmt_img.executeQuery(sql_img);
				String face_ = "";
				if(rs_img.next()){
					face_ = rs_img.getString("face");
				}
				answer_send_show.append(String.format(
						"<div class='_show'><div id='answer_sender'><img src=\"image/%s\" width='100px'><div id='sender'><span>%s</span></div>",
						face_,rs_ans.getString("answer_sender"))
						);
				if(user_name.equals("admin")&&rs_ans.getString("answer_sender").equals("admin")==false){
					answer_send_show.append(String.format("<div><input id='deleteUser' type='Button' value='删除用户' onclick='delete(%s)'></div>",
							"deleteUser("+rs_img.getInt("id")+")"));	
				}
				answer_send_show.append(String.format("</div><div id='answer_content'><div id='ans_con'><span>%s</span></div>",rs_ans.getString("answer_content")));
				if(user_name.equals("admin")||user_name.equals(rs_ans.getString("answer_sender")) || user_name.equals(topic_sender)){  //管理员admin、回复人、发帖人
					answer_send_show.append(String.format("<div><input id='delete' type='Button' style='float:right' value='删除' onclick='%s'></div>",
						"deleteanswer("+rs_ans.getInt("answer_id")+")"));	
				}
				answer_send_show.append(String.format("<div id='ans_con_footer'><div id='data'><span id='rel_time'>%s</span><span id='floor'>#%d</span></div></div></div></div>",rs_ans.getString("answer_sendTime"),pgno*pgcnt+flo));
				flo++;
			}
			rs_ans.close();
			stmt.close(); 
			con.close();
		}catch(Exception e){
			msg = e.getMessage();

		}
		//分页
		StringBuilder page_show = new StringBuilder();
		int all_page = (answer_count > 10)?(answer_count-1)/pgcnt:0;
		if(all_page <= 0){page_show.append("<span>1</span>");}
		else{
		if(pgno == 0){
			int pgprev = (pgno>0)?pgno-1:0;
			int pgnext = pgno+1;
			page_show.append("<span>1</span>");
			int i = 1;
			while(i < 9 && i <= all_page){
				page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,i,i+1));
				i++;
			}
			page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>下一页</a></span>",topic_id,pgnext));
			page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>尾页</a></span>",topic_id,all_page));
		}else if(pgno == all_page){
			int pgprev = (pgno>0)?pgno-1:0;
			page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>首页</a>",topic_id,0));
			page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>上一页</a>",topic_id,pgprev));
			//尾页大于10
			if(pgno >= 9){
				int i = 8;
				while(i > 0){
					page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,pgno-i,pgno-i+1));
					i--;
				}
			}
			//尾页小于10
			else{
				int i = 0;
				while(i < pgno){
					page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,i,i+1));
					i++;
				}
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));	
		}else{
			int pgprev = (pgno>0)?pgno-1:0;
			int pgnext = pgno+1;
			page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>首页</a>",topic_id,0));
			page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>上一页</a>",topic_id,pgprev));
			if(pgno < 5){
				int i = 0;
				while(i < pgno){
					page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,i,i+1));
					i++;
				}
				page_show.append(String.format("<span>%d</span>",pgno+1));
				if(all_page - pgno <= 4){
					int w = pgno+1;
					while(w <= all_page){
						page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,w,w+1));
						w++;
					}
				}else{
					int w = pgno+1;
					while(w < pgno + 5){
						page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,w,w+1));
						w++;
					}
				}
				page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>下一页</a>",topic_id,pgnext));
				page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>尾页</a>",topic_id,all_page));
			}
			else{
				int i = pgno - 4; 
				while(i < pgno){
					page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,i,i+1));
					i++;
				}
				page_show.append(String.format("<span>%d</span>",pgno+1));
				if(all_page - pgno <= 4){
					int w = pgno+1;
					while(w < all_page){
						page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,w,w+1));
						w++;
					}
				}else{
					int w = pgno+1;
					while(w < pgno + 5){
						page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>%d</a>",topic_id,w,w+1));
						w++;
					}
				}
				page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>下一页</a>",topic_id,pgnext));
				page_show.append(String.format("<a href='topic.jsp?topic_id=%d&pgno=%d'>尾页</a>",topic_id,all_page));
			}
		}}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
	function post() {
		var error = document.getElementById("error");
		var richedit = document.getElementById("richedit").innerHTML;
		var content = document.getElementById("content");
		content.value=richedit;
		error.innerHTML="<a style='font-size:0.8em'>确认回复?</a><input id='ok' type='submit' name='ok' value='确认' style='border:none;cursor: pointer;'> <input id='not' style='border:none;cursor: pointer;' type='button' name='not' onclick='cancel()' value='取消'> ";
	}
	function cancel(){
		document.getElementById("error").innerHTML="";
	}
	function deleteanswer(answer_id){
		var xmlhttp=new XMLHttpRequest();
		xmlhttp.onreadystatechange = function () {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status >= 200 && 
						(xmlhttp.status < 300 || xmlhttp.status >= 304)){
					alert(xmlhttp.responseText);
					window.location.reload();
				} else {
					alert("Server error");
				}
			};
		};
		var param = "answer_id="+answer_id;//汉字需要编码
		//alert(param);
		xmlhttp.open("post", "deleteAnswer.jsp", true);
		xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xmlhttp.send(param); // 没有参数就用null	
	}
	function deleteTopic(topic_id){
		var xmlhttp=new XMLHttpRequest();
		xmlhttp.onreadystatechange = function () {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status >= 200 && 
						(xmlhttp.status < 300 || xmlhttp.status >= 304)){
					alert(xmlhttp.responseText);
					window.location.href="board.jsp?board_id="+<%=boardID%>; 
				} else {
					alert("Server error");
				}
			};
		};
		var param = "topic_id="+topic_id;//汉字需要编码
		//alert(param);
		xmlhttp.open("post", "deleteTopic.jsp", true);
		xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xmlhttp.send(param); // 没有参数就用null	
	}
	function deleteUser(user_id){
		var xmlhttp=new XMLHttpRequest();
		xmlhttp.onreadystatechange = function () {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status >= 200 && 
						(xmlhttp.status < 300 || xmlhttp.status >= 304)){
					alert(xmlhttp.responseText);
					window.location.href = document.referrer;
				} else {
					alert("Server error");
				}
			};
		};
		var param = "id="+user_id;//汉字需要编码
		//alert(param);
		xmlhttp.open("post", "deleteUser.jsp", true);
		xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xmlhttp.send(param); // 没有参数就用null	
	}
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
<title></title>
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
			background: rgba(255, 255,255, 1);
			
		}
		.head{
			position: fixed;
			width: 100%;
			height: 46px;
			background: rgba(255, 255, 255, 1);
			z-index:9; 
		}
		
		.front{
			width: 1160px;
			height: 46px;
			margin: 0 auto;
		}
		#home{
			float: left;
		}
		#home_text{
			float: left;
			line-height: 46px;
			font-size: 1.17em;
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
		
		.login>ul{
			display:none;
			margin:0;
			padding:0;
		}
		.login>ul>li{
			width:120px;
			display: list-item;
			
		}
		.login>ul>li:hover{
			background:rgb(201,202,187);
		}
		.login>ul>li:hover#user{
			background:rgb(201,202,187);
		}
		a#down{
			display:block;
		}
		#fa{
			margin-left:20px;
		}
	/*-----------------content-----------------*/
	.content{
		width: 1160px;
		margin: 20px auto;
		border-radius: 5px;
		box-sizing: border-box;
		background-color: white;
		box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;
		padding-top: 20px;
	}
	.content ._back{
		margin-left: 20px;
		box-sizing: border-box;
		margin-bottom:20px;
	}
	
	#page_show{
		    border: none;
    		width: 100%;
    		position: relative;
    		margin: 0;
    		padding: 0;
    		height: 45px;
    		background-color: white;
    		border-bottom: 1px solid rgba(0,0,0,.1);
    		border-top: 1px solid rgba(0,0,0,.1);
    		color: #666;
	}
	#page_num{
		    padding-top: 10px;
    		padding-left: 20px;
	}
	#page_num a{
		    float: none !important;
    		display: inline-block !important;
    		text-align: center;
    		min-width: 13px;
    		line-height: 25px;
    		height: 25px;
    		padding: 0 10px;
    		margin: 0 0 0 8px;
    		color: inherit;
    		background-color: rgba(0, 0, 0, .05);
    		border-radius: 12.5px;	
	}
	#page_num a:hover{
		background:rgb(201,202,187);
	}
	#page_num span{
			display: inline-block !important;
    		text-align: center;
    		min-width: 13px;
    		line-height: 25px;
    		padding: 0 10px;
    		height: 25px;
		    color: #fff;
    		background-color: rgba(0, 0, 0, .3) ;
    		width: auto !important;
    		border-radius: 12.5px;
    		margin: 0 0 0 8px;
	}
	#title_show{
	    	height: 56px;
    		line-height: 56px;
    		border: none !important;
    		overflow: visible !important;
    		width: 100% !important;
    		background: none;
    		box-sizing: content-box;
    		border-bottom: 1px solid rgba(0,0,0,.1)!important ;
	}
	#title_text{
		margin:0 !important ;
		padding:0 !important ;
		margin-left: 30px !important ;
    	position: relative;
    	font-weight: 400;
    	font-size: 1.17em;
    	white-space: nowrap;
    	line-height: 56px;
    	box-sizing: content-box;
	}
	/*----------------------------content and answer -----------*/
	._show{
		border: none !important;
    	border-bottom: 1px solid rgba(0,0,0,.1) !important;
    	background: transparent !important;
    	width: 100%!important;
    	position: relative;
    	box-sizing: border-box;
    	display: flex;
    	flex-wrap: wrap;
    	
	}
	#answer_sender{
		width:20%;
		box-sizing:border-box;
		text-align: center;
		border-right:1px solid rgba(0,0,0,.1);
		float:left;
	}
	#answer_content{
		width:80%;
		float:left;
	}
	#answer_sender img{
		margin-top:30px;
	}
	#sender{
		margin:10px auto;
	}
	#ans_con{
		padding:30px 20px;
		min-height:170px;
	}
	#ans_con_footer{
		    width: 100% !important;
    		position: relative !important;
    		margin: 10px 0 !important;
    		color: #bbb !important;
    		float: right;
    		box-sizing: border-box;
	}
	#data{
		display: block;
    	padding: 0 !important;
    	height: 28px;
    	line-height: 28px;
    	margin: 0 !important;
	}
	#rel_time{
		display: inline-block;
    	margin: 0;
    	padding-left: 4px !important;
    	padding-right: 15px !important;
    	background: rgba(0, 0, 0, .04);
    	border-radius: 0 16px 16px 0;
	}
	#floor{
		position: absolute;
    	top: 0;
    	right: 0;
    	display: block;
    	background: rgba(0, 0, 0, .04);
    	border-radius: 16px 0 0 16px;
    	padding: 0 !important;
    	padding-left: 10px !important;
    	padding-right: 10px !important;
    	font-size: 14px;
    	height: 28px;
    	line-height: 28px;
    	margin: 0 !important;
	}
	
	#delete{
		border:none;
		cursor:pointer;
		margin-bottom:0px;
		position: absolute;
    	top: 0;
    	right: 0;
    	display: block;
    	background: rgba(0, 0, 0, .04);
    	padding: 0 !important;
    	padding-left: 10px !important;
    	padding-right: 10px !important;
    	font-size: 14px;
    	height: 28px;
    	line-height: 28px;
    	margin: 0 !important;
    	color: #bbb !important;
	}
	#deleteUser{
		border:none;
		cursor:pointer;
    	background: rgba(0, 0, 0, .04);
    	padding: 0 !important;
    	padding-left: 10px !important;
    	padding-right: 10px !important;
    	font-size: 14px;
    	height: 28px;
    	line-height: 28px;
    	margin: 0 !important;
    	color: #bbb !important;
	}
	#answer_frame{
		width: 1100px; !important;
		margin: 20px 30px !important;
		
	}
	#poster{
    	
    	padding: 0 !important;
    	margin-bottom: 10px !important;
    	height:28px;
    	line-height: 28px;
    	clear: both;
	}
	#poster_head{
		padding: 0 10px !important;
    	background: rgba(0,0,0,.06);
    	border-radius: 6px;
    	color: #999;
    	font-weight: normal !important;
    	font-size: 14px !important;
    	float: left;
	}
	#poster_head a{
		margin-right: 4px !important;
		line-height:28px;
		text-align:center;
	}
	#textarea{
		width: 100% !important;
    	margin: 0 !important;
    	padding: 0 !important;
    	
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
	#reply{
	    height: 28px !important;
	    width: 60px;
    	line-height: 28px !important;
    	padding: 0 10px !important;
    	box-sizing: content-box;
    	margin:20px 0;
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
	#reply:hover{
		background: rgb(201,202,187);
	}
	</style>
</head>
<body>
<div id="head">
<div class="head">
	<div class="front">
	<a href="index.jsp" title="主页" ><img src="image/4.png" height="46"  id="home"><span id="home_text">4点IT</span></a>
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

<div class="content">

	<div class="_back">
		<span><a href="index.jsp"><i class="fa fa-home fa-1x"></i>&nbsp;论坛首页</a>></span>
		<span><%=class_name%>></span>
		<span><a href="board.jsp?board_id=<%=boardID %>"><%=board_name%></a>></span>
		<span><%=title%></span>
	</div>

	<div id="page_show">
		<div id="page_num">
			<%=page_show %>
		</div>
	</div>
	<div id="title_show">
		<h3 id="title_text"><%=title %></h3>
	</div>
	<div id="answer_show">
		<div id="answer">
			<%=topic_send_show%>
			<%=answer_send_show %>
		</div>
	</div>
	<div id="page_show" >
		<div id="page_num">
			<%=page_show %>
		</div>
	</div>
	<form action="topic.jsp" method="get">
	<input type="hidden" name="topic_id" value="<%=topic_id %>">
	<div id="answer_frame">
		<div id="poster">
			<div id="poster_head">
				<a>
				<span><i class="fa fa-comment-o"></i>&nbsp;发表回复</span>
				</a>
			</div>
		</div>
		<div id="textarea">
		
<div style="background-color:rgba(0,0,0,0.2);  width:350px;margin:20px 0 0px;" >
<input type="button" style="background:url(image/edit/left.png);background-size:30px 30px;border:none;padding:0,0;cursor: pointer;vertical-align:middle;" onclick="left()">
<input type="button"  style="background:url(image/edit/center.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="center()">
<input type="button"  style="background:url(image/edit/right.png);border:none;padding:0,0;cursor: pointer;vertical-align:middle" onclick="right()">  
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
<div class="editable" id="richedit" contenteditable="true" style="WORD-BREAK: break-all;min-width:200px;max-width:800px;min-height:200px;">
</div><br>
<input id="content" name="memo" type="hidden" value="">
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
var o = document.getElementById("richedit");
alert(o.innerHTML);
}
</script>

		</div>
		<%if(user_name.equals("anonymous")){%>
     		<h3>游客您好，请点击<a href="login.jsp" style="color:blue">这里</a>登陆后回复</h3>
		<%}else {%>
			<div id="re">
			<input id="reply" type="button" name="reply" onclick="post()" value="回复">
			<span id="error" style="color:red;"></span>
			</div>
		<%}%>
	</div>
	</form>
</div>
<%=msg %>
</body>
</html>