<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	System.out.println("deptNo: " + deptNo + " deptName: " + deptName); // 값을 잘 받아왔는지 확인
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); 
	System.out.println("deptUpdateAction.jsp 드라이버 로딩 성공"); // 드라이버 로딩 확인
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인"); // db 접속 확인
	
	String sql = "UPDATE departments SET dept_name=? WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql); // 쿼리문 저장
	
	// n번째 ?에 updateForm에서 받아온 값 넣기
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
	
%>