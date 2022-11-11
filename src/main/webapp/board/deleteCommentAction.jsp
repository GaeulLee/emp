<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석 - 댓글을 삭제 하기 위해서 해당 게시물 번호와 그 안의 댓글 번호, 비밀번호를 가져오기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentNo = request.getParameter("commentNo");
	String commentPw = request.getParameter("commentPw");
	
	// 안전장치
	if(request.getParameter("boardNo") == null || request.getParameter("commentNo") == null || request.getParameter("commentPw") == null || commentPw.equals("")){
		String msg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/deleteCommentForm.jsp?msg=" + msg + "&boardNo=" + boardNo + "&commentNo=" + commentNo);
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); 
	System.out.println("deleteCommentAction.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2-1. 비밀번호 확인과 삭제 처리를 동시에 할 수 있음
	String sql = "DELETE FROM comment WHERE board_no = ? AND comment_no = ? AND comment_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentNo);
	stmt.setString(3, commentPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?&boardNo=" + boardNo);
		return;
	}else{
		String msg = URLEncoder.encode("비밀번호가 일치하지 않습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/deleteCommentForm.jsp?msg=" + msg + "&boardNo=" + boardNo + "&commentNo=" + commentNo);
		return;
	}
	
	
	
	// 3. 요청출력
%>