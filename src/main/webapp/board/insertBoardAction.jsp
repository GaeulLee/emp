<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	
	if(request.getParameter("boardTitle") == null || request.getParameter("boardContent") == null || 
		request.getParameter("boardWriter") == null || request.getParameter("boardPw") == null ||
		boardTitle.equals("") || boardContent.equals("") || boardWriter.equals("") || boardPw.equals("")){
		String msg = URLEncoder.encode("모든 항목을 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertboardForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertBoardAction.jsp 드라이버 로딩 성공");
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	String sql = "INSERT INTO board (board_title, board_content, board_writer, board_pw, createdate) VALUES (?,?,?,?,CURDATE());";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	stmt.setString(4, boardPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("입력성공");
	} else{
		System.out.println("입력실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
%>