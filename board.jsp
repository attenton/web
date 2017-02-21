<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html;charset=utf-8"%>
      <%request.setCharacterEncoding("utf-8");
      response.setContentType("text/html; charset=utf-8");
	int board_id = Integer.parseInt(request.getParameter("board_id"));

    String user_name="";
	user_name = (String)session.getAttribute("username");
	if(user_name==null||user_name.equals("")){
		user_name="anonymous";
	}
	String connectString = "jdbc:mysql://localhost:3306/14353171"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	int board_classID = 1;
	String board_name="";
	String class_name="";
	String msg="";
	StringBuilder topic_title_b = new StringBuilder("");
	StringBuilder topic_id_b = new StringBuilder("");
	StringBuilder topic_sender_b = new StringBuilder("");
	StringBuilder topic_sendTime_b = new StringBuilder("");
	int answer_num[] = new int[100];
	String face="";
	try{
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
	  Statement stmt=con.createStatement();	 
	  ResultSet rs = stmt.executeQuery(String.format("SELECT * FROM board WHERE board_id = %d",board_id));
	  if(rs.next()){
		  board_classID=rs.getInt("board_classID");
		  board_name=rs.getString("board_name");
		  
	  } 
	  rs.close();
	  if(user_name != "anonymous"){
		  ResultSet rs_face = stmt.executeQuery(String.format("SELECT * FROM bbs_user WHERE username = '%s'",user_name));
		  if(rs_face.next()){
			  face=rs_face.getString("face"); 
		  } 
		  rs_face.close();}
	  ResultSet rs2 = stmt.executeQuery(String.format("SELECT * FROM topic WHERE topic_boardID = %d",board_id));
	  
	  while(rs2.next())
	  {
	  	topic_title_b.append(rs2.getString("topic_title")+" ");
	  	topic_id_b.append(rs2.getString("topic_id")+" ");
	  	topic_sender_b.append(rs2.getString("topic_sender")+" ");
	  	topic_sendTime_b.append(rs2.getString("topic_sendTime")+" ## ");
	  }
	  rs2.close();
	  //计算每个topic的回复数
	  ResultSet rs3 = stmt.executeQuery("SELECT * FROM answer;");
	  for(int i = 0; i < rs3.getRow()+1;i++)
	  {
		  answer_num[i] = 0;
	  }
	  while(rs3.next())
	  {
		  answer_num[rs3.getInt("answer_topicID")-1] ++;
	  }
	  rs3.close();
	  ResultSet rs4 = stmt.executeQuery(String.format("SELECT * FROM class WHERE class_id = %d;",board_classID));
	  if(rs4.next())
	  {
		  class_name = rs4.getString("class_name");
	  }
	  rs4.close();
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	  msg = e.getMessage();
	}
	String [] topic_title=topic_title_b.toString().split(" ");
	String [] topic_id=topic_id_b.toString().split(" ");
	String [] topic_sender=topic_sender_b.toString().split(" ");
	String [] topic_sendTime=topic_sendTime_b.toString().split(" ## ");
	int topic_num = topic_title.length;
	
	//分页
    Integer pgno = 0; //当前页号
    String param2 = request.getParameter("pgno");
    if(param2 != null && !param2.isEmpty()){
    	pgno = Integer.parseInt(param2);
    }
	int pgcnt=10;
	int pgnum= topic_num/10 + 1; //总页数
	
	//-------------------page_show------------------------
	StringBuilder page_show = new StringBuilder();
	int all_page = (topic_num > 0)?(topic_num-1)/pgcnt:0;
		if(all_page <= 0){page_show.append("<span>1</span>");}
		else{
		if(pgno == 0){
			int pgprev = (pgno>0)?pgno-1:0;
			int pgnext = pgno+1;
			page_show.append("<span>1</span>");
			int i = 1;
			while(i < 9 && i <= all_page){
				page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,i,i+1));
				i++;
			}
			page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>下一页</a></span>",board_id,pgnext));
			page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>尾页</a></span>",board_id,all_page));
		}else if(pgno == all_page){
			int pgprev = (pgno>0)?pgno-1:0;
			page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>首页</a>",board_id,0));
			page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>上一页</a>",board_id,pgprev));
			//尾页大于10
			if(pgno >= 9){
				int i = 8;
				while(i > 0){
					page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,pgno-i,pgno-i+1));
					i--;
				}
			}
			//尾页小于10
			else{
				int i = 0;
				while(i < pgno){
					page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,i,i+1));
					i++;
				}
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));	
		}else{
			int pgprev = (pgno>0)?pgno-1:0;
			int pgnext = pgno+1;
			page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>首页</a>",board_id,0));
			page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>上一页</a>",board_id,pgprev));
			if(pgno < 5){
				int i = 0;
				while(i < pgno){
					page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,i,i+1));
					i++;
				}
				page_show.append(String.format("<span>%d</span>",pgno+1));
				if(all_page - pgno <= 4){
					int w = pgno+1;
					while(w <= all_page){
						page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,w,w+1));
						w++;
					}
				}else{
					int w = pgno+1;
					while(w < pgno + 5){
						page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,w,w+1));
						w++;
					}
				}
				page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>下一页</a>",board_id,pgnext));
				page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>尾页</a>",board_id,all_page));
			}
			else{
				int i = pgno - 4; 
				while(i < pgno){
					page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,i,i+1));
					i++;
				}
				page_show.append(String.format("<span>%d</span>",pgno+1));
				if(all_page - pgno <= 4){
					int w = pgno+1;
					while(w < all_page){
						page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,w,w+1));
						w++;
					}
				}else{
					int w = pgno+1;
					while(w < pgno + 5){
						page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>%d</a>",board_id,w,w+1));
						w++;
					}
				}
				page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>下一页</a>",board_id,pgnext));
				page_show.append(String.format("<a href='board.jsp?board_id=%d&pgno=%d'>尾页</a>",board_id,all_page));
			}
		}}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
	<title><%=board_name %></title>
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
			position: fixed;
			width: 100%;
			height: 46px;
			background: white;
		}
		
		.front{
			width:1160px !important;
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
		}
		#sign-up{
			float: right;
			font-size: 14px;
			line-height: 46px;
			margin-right:10px;
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
		.content{
			width:1160px;
			padding:20px 0;
			margin:20px auto;
			border-radius: 5px;
			box-sizing: border-box;
			background:white;
			box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;
			
		}
		.front_{
			margin:10px 20px 0 20px;
		}
		.theme{
			margin: 20px;
		}
		
		#topic_num{
			color:#FF3030;
		}
		#topic_sender,#topic_sendTime,#answer_num{
			text-align:center;
		}
		#topic_sendTime{
			font-size:0.5em;
		}
		#answer_num{
			color:#3030FF;
		}
		.page{
			float:right;
		}
		.aim_topic{
			border:1px solid #999;
			background:white;
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
			background:rgb(201,202,187)
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
		#reply{
	    	height: 28px !important;
	    	width: 60px;
    		line-height: 28px !important;
    		padding: 0 10px !important;
    		box-sizing: content-box;
    		margin-top:20px;
    		margin-left:20px;
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
			background-color:rgb(201,202,187);
		}
		/*-------------------------各个板块--------------------------*/
		table{
			width:100%;
			border-collapse: collapse;
		}
		tr{
			height:50px;
			box-sizing:border-box;
		}
		td{box-sizing:border-box;}
		tr:hover{
			border:1px solid #999;
			box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;
		}
		#ans_num{
			border:1px solid #999;
			border-radius:15px;
			height:35px;
			line-height:35px;
			width:50px;
		}
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

<div class = "content">
<div class="front_">
	<a href="index.jsp"><i class="fa fa-home fa-1x"></i>&nbsp;论坛首页</a>
	<a>&nbsp;>&nbsp;</a>
	<a><%=class_name%></a>
	<a>&nbsp;>&nbsp;</a>
	<a><%=board_name%></a>
</div> 
<hr>
<%if(topic_title[0].length()!=0) {%>
<div class="theme">
	<a>主题:</a>
	<a id="topic_num"><%=topic_num%></a>
</div>
<div class="table">
<table>
	<!-- <tr id="table_title">
		<th>标题</th>
		<th>作者</th>
		<th>发帖时间</th>
		<th>回复</th>
	</tr> -->
	<%for(int i = pgno*10; i < topic_num && i < (pgno+1)*10; i++){%>
	<tr id="aim_topic">
		<td id="answer_num"><div id="ans_num" style="margin-left:20px;"><%=answer_num[Integer.parseInt(topic_id[i])-1]%></div></td>
		<td><a href="topic.jsp?topic_id=<%=topic_id[i]%>"><div id="top_title" "><%=topic_title[i]%></div> </a></td>
		<td id="topic_sender"><div id="top_sender"><%=topic_sender[i]%></div></td>
		<td id="topic_sendTime"><div id="top_sendTime"><%=topic_sendTime[i]%></div></td>

	</tr>
	<% } %>
</table>
</div >

<div id="page_show" >
		<div id="page_num">
			<%=page_show %>
		</div>
	</div>
<%}else {%>
	<div id = "aim_topic" > 该板块暂无帖子  </div>
<%} %>
<a href ="sendtopic.jsp?board_id=<%=board_id%>&pgno=0"><button type="button" id="reply">我要发帖</button></a>

</div>

<%=msg %>
</body>
</html>