<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	
	// 비빌번호가 공백이여도 아래 비밀번호 확인 과정에서 공백인 비밀번호는 없기 때문에 공백 오류 처리를 하지 않아도 됨
	if(request.getParameter("boardPw") == null || request.getParameter("boardNo") == null || boardPw.equals("")){
		String msg = URLEncoder.encode("비밀번호를 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버 로딩 
	System.out.println("boardDelete.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234"); // db 접속 
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// 2-1. 비밀번호 확인
	String pwSql = "SELECT board_pw FROM board WHERE board_no = ? AND board_pw = ?";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setInt(1, boardNo);
	pwStmt.setString(2, boardPw);
	ResultSet pwRs = pwStmt.executeQuery();
	
	if(pwRs.next()==false){
		String msg = URLEncoder.encode("비밀번호가 일치하지 않습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/deleteBoardForm.jsp?msg=" + msg + "&boardNo=" + boardNo);
		return;
	}
	
	// 2-2. 비밀번호 일치하면 삭체 요청 처리
	String sql = "DELETE FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	int row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("삭제 성공");
	} else {
		System.out.println("삭제 실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");

%>