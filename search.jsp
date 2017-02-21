<%@ page language="java" import="java.util.*,java.lang.*,java.sql.*,java.net.*"  contentType="text/html; charset=gb2312"
    pageEncoding="utf-8"%>
<%  request.setCharacterEncoding("utf-8");
    response.setContentType("text/html; charset=utf-8");
	
    String user_name="";
	user_name = (String)session.getAttribute("username");
	if(user_name==null||user_name.equals("")){
		user_name="anonymous";
	}
	
    //分页
    Integer pgno = 0; //当前页号
    String param = request.getParameter("pgno");
    if(param != null && !param.isEmpty()){
    	pgno = Integer.parseInt(param);
    }
	int count=0;  //记录总个数
	int pgcnt=10;
	String search_title="";
	String message="";
	String face="";
	StringBuilder table=new StringBuilder();
	search_title=request.getParameter("search_title");
	if(search_title==null||search_title.equals("")){
		message="对不起，没有您想要的搜索结果";
	}else{
		String connectString = "jdbc:mysql://localhost:3306/14353171"
				+ "?autoReconnect=true&useUnicode=true"
				+ "&characterEncoding=UTF-8&useSSL=false"; 
		try{
  			Class.forName("com.mysql.jdbc.Driver");
  			Connection con=DriverManager.getConnection(connectString, 
                 "user", "123");
  			Statement stmt=con.createStatement();
  			if(user_name != "anonymous"){
  			  ResultSet rs_face = stmt.executeQuery(String.format("SELECT * FROM bbs_user WHERE username = '%s'",user_name));
  			  if(rs_face.next()){
  				  face=rs_face.getString("face"); 
  			  } 
  			  rs_face.close();}
  			ResultSet rs=stmt.executeQuery(
  	  			"select topic_id,board_name,topic_title,topic_sender,topic_sendTime from topic natural join board where topic_boardId = board_id and topic_title like "
  				+ "'%"+search_title+"%' limit "+pgno*10+","+"10;");
  			table.append("<table>");
  			
  			while(rs.next()){
  				Statement stmt1=con.createStatement();	 
	  			ResultSet rs1=stmt1.executeQuery(
	    			"select count(answer_topicID) as answercnt from answer where answer_topicID="
	    			+rs.getInt("topic_id")+"; ");
	  			rs1.next();
	  			table.append(String.format("<tr><th class=\"topic_replynum\">%s</th>",
	  				rs1.getString("answercnt")));
	  			rs1.close();
  				table.append(String.format(
  						"<th class=\"topic_title\"> <a href=\"%s\">%s</a></th><th class=\"topic_board\">%s</th><th class=\"topic_sender\">%s<br/><span class=\"time\">%s</span></th></tr>",
  						"topic.jsp?topic_id="+rs.getInt("topic_id"),
  						rs.getString("topic_title"),rs.getString("board_name"),
  						rs.getString("topic_sender"),rs.getString("topic_sendTime")
  				));
  				
  	  			stmt1.close();
  			}
  			table.append("</table>");
  			
  		  	rs=stmt.executeQuery("select count(*) from topic natural join board where topic_boardId = board_id and topic_title like "
  	  				+ "'%"+search_title+"%';"); 
  		  	if(rs.next()) count = rs.getInt(1); 
  			rs.close();
  			stmt.close();
  			con.close();
		}
		catch (Exception e){
  			message = "连接数据库失败";
		}		
	}
	StringBuilder page_show = new StringBuilder();
	int all_page = (count > 10)?(count-1)/pgcnt:0;
	if(all_page <= 0){page_show.append("<span>1</span>");}
	else{
	if(pgno == 0){
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;
		page_show.append("<span>1</span>");
		int i = 1;
		while(i < 9 && i <= all_page){
			page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",i,i+1));
			i++;
		}
		page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>下一页</a></span>",pgnext));
		page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>尾页</a></span>",all_page));
	}else if(pgno == all_page){
		int pgprev = (pgno>0)?pgno-1:0;
		page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>首页</a>",0));
		page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>上一页</a>",pgprev));
		//尾页大于10
		if(pgno >= 9){
			int i = 8;
			while(i > 0){
				page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",pgno-i,pgno-i+1));
				i--;
			}
		}
		//尾页小于10
		else{
			int i = 0;
			while(i < pgno){
				page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",i,i+1));
				i++;
			}
		}
		page_show.append(String.format("<span>%d</span>",pgno+1));	
	}else{
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;
		page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>首页</a>",0));
		page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>上一页</a>",pgprev));
		if(pgno < 5){
			int i = 0;
			while(i < pgno){
				page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",i,i+1));
				i++;
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));
			if(all_page - pgno <= 4){
				int w = pgno+1;
				while(w <= all_page){
					page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}else{
				int w = pgno+1;
				while(w < pgno + 5){
					page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}
			page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>下一页</a>",pgnext));
			page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>尾页</a>",all_page));
		}
		else{
			int i = pgno - 4; 
			while(i < pgno){
				page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",i,i+1));
				i++;
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));
			if(all_page - pgno <= 4){
				int w = pgno+1;
				while(w < all_page){
					page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}else{
				int w = pgno+1;
				while(w < pgno + 5){
					page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}
			page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>下一页</a>",pgnext));
			page_show.append(String.format("<a href='mytheme.jsp?pgno=%d'>尾页</a>",all_page));
		}
	}}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
<title>搜索</title>
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
		#content{
			width: 1160px;
			margin: 0 auto;
			margin-top: 20px;
		}
		#topiclist{
			width:100%;
		}
		.th{
			width:1160px;		
		}
		#page_show{
		    border: none;
    		width: 100%;
    		position: relative;
    		margin: 0;
    		padding: 0;
    		height: 45px;
    		background-color: rgba(0,0,0,.02);
    		border-bottom: 1px solid rgba(0,0,0,.1);
    		color: #666;
	}
	#page_num{
		    padding-top: 10px;
    		padding-left: 20px;
    		float:right;
    		margin-right:20px;
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
	#page_num span{
			display: inline-block !important;
    		text-align: center;
    		min-width: 13px;
    		line-height: 25px;
    		padding: 0 10px;
    		height: 25px;
		    color: #fff;
    		background-color: rgba(0, 0, 0, .3);
    		width: auto !important;
    		border-radius: 12.5px;
    		margin: 0 0 0 8px;
	}
		.td{
			width:100%;
			box-sizing:border-box;
		}
		tr{
			width:100%;
			box-sizing:border-box;
		}
		.td tr:hover{
			box-shadow: 1px 1px 2px #D4D4D4,  1px -1px 2px #D4D4D4;
		}
		#page_num a:hover{
		background:rgb(201,202,187);
	}
		#content{
			width:1160px;
			padding:20px 0 0 0;
			margin:20px auto;
			border-radius: 5px;
			box-sizing: border-box;
			background:white;
			box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;
			
		}
		.topic_title{ width:800px; }
		.topic_board{width:160px; }
		.topic_sender{ width:100px; }
		.topic_replynum{ width: 100px; }
		.time{ font-size:0.6em;}
		.page{ float: right;}
		.pageinput{ width: 30px;}
		#error { color: red; text-align: center;}
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
	<div id="route" style="margin-left:20px;margin-bottom:20px;">
		<span>	
		<i class="fa fa-home" aria-hidden="true"></i>
		<a href="index.jsp">论坛主页 </a> 
		<i class="fa fa-angle-right" aria-hidden="true"></i> 关键词"<%=search_title%>"的搜索结果
		</span>
	</div>
	<div id="topiclist">
		<div>
			<p id="error"> <%=message%> </p>
		</div>
		<div class="th">
			<table>
				<tr> 
					<th class="topic_replynum">回复</th>
					<th class="topic_title">标题 <th>
					<th class="topic_board">版块</th>
					<th class="topic_sender">作者</th>
					
				</tr>	
			</table>
		</div>
		<div class="td">
			<%=table%>
		</div>
		<div id="page_show" >
		<div id="page_num">
			<%=page_show %>
		</div>
	</div>
	</div>
</div>

</body>
</html>