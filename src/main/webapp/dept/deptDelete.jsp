<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	System.out.println("deptNo --> " + deptNo);
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); //드라이버 로딩 
	System.out.println("deptDelete.jsp 드라이버 로딩 성공");
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234"); // db 접속 
	System.out.println(conn + "<-- employees db 접속 확인");
	
	String sql = "DELETE FROM departments WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql); // 쿼리문 입력
	
	stmt.setString(1, deptNo); // 쿼리문의 ?부분에 deptNo 대입
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("삭제 성공");
	} else {
		System.out.println("삭제 실패");
	}
	
	// 3. 요청출력
	// 삭제 성공 후 deptList.jsp로 돌아가기
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
%>