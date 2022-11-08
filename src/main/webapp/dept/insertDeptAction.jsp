<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 안전장치
	if(request.getParameter("deptNo") == null || request.getParameter("deptName") == null){
		response.sendRedirect(request.getContextPath() + "/insertdeptForm.jsp");
		return;
	}

	// 1. 요청처리
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	System.out.println("deptNo: " + deptNo + " deptName: " + deptName); // 값이 잘 들어왔는지 확인
	
	// 2. 요청분석
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertDeptAction.jsp 드라이버 로딩 성공"); // 드라이버 로딩 확인
	
	// db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인"); // db 접속 확인
	
	// 쿼리문 입력
	String sql = "INSERT INTO departments (dept_no, dept_name) VALUES (?,?);";
	PreparedStatement stmt = conn.prepareStatement(sql); // 쿼리문 저장
	
	// ?에 값 대입
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	
	// 값이 잘 들어갔는지 확인
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
%>