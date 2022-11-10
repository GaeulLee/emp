<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.Board" %>
<%@ page import="java.net.URLEncoder"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");
	
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");   
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	
	// 안전장치
	if(request.getParameter("boardNo") == null || request.getParameter("boardTitle") == null ||
	request.getParameter("boardContent") == null || request.getParameter("boardWriter") == null ||
	request.getParameter("boardPw") == null || boardTitle.equals("") || boardContent.equals("") ||
	boardWriter.equals("") || boardPw.equals("")){
		String msg = URLEncoder.encode("모든 항목을 입력하세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?msg=" + msg + "&boardNo=" + boardNo);
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); 
	System.out.println("updateBoardAction.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2-1. 패스워드 확인
	String pwSql = "SELECT board_pw FROM board WHERE board_no = ? AND board_pw = ?";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setInt(1, boardNo);
	pwStmt.setString(2, boardPw);
	ResultSet pwRs = pwStmt.executeQuery();
	
	if(pwRs.next()==false){
		String msg = URLEncoder.encode("비밀번호가 일치하지 않습니다.", "utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?msg=" + msg + "&boardNo=" + boardNo);
		return;
	}
	
	// 2-2. 비밀번호가 맞다면 수정요청 처리
	String updateSql = "UPDATE board SET board_title=?, board_content=? WHERE board_no = ?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, boardTitle);
	updateStmt.setString(2, boardContent);
	updateStmt.setInt(3, boardNo);
	ResultSet updateRs = updateStmt.executeQuery();
	
	int row = updateStmt.executeUpdate();
	if(row == 1){
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
	
%>