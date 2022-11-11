<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String commentWriter = request.getParameter("commentWriter");
	String commentPw = request.getParameter("commentPw");
	
	if(request.getParameter("commentContent") == null || request.getParameter("commentWriter") == null || request.getParameter("commentPw") == null
		|| commentContent.equals("") || commentWriter.equals("") || commentPw.equals("")){
		String msg = URLEncoder.encode("모든 항목을 입력하세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?msg=" + msg + "&boardNo=" + boardNo);
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); 
	System.out.println("insertCommentAction.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	String sql = "INSERT INTO comment (board_no, comment_content, comment_writer, comment_pw, createdate) VALUES (?,?,?,?,CURDATE())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentContent);
	stmt.setString(3, commentWriter);
	stmt.setString(4, commentPw);
	
	int row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("입력성공");
	} else{
		System.out.println("입력실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo);
%>