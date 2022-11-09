<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.Department"%>
<%@ page import="java.net.URLEncoder"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 안전장치
	if(request.getParameter("deptNo") == null || request.getParameter("deptName") == null || deptNo.equals("") || deptName.equals("")){
		String msg = URLEncoder.encode("부서이름을 입력하세요.", "utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath() + "/dept/deptUpdateForm.jsp?msg=" + msg + "&deptNo=" + deptNo);
		return;
	}
	
	System.out.println("deptNo: " + deptNo + " deptName: " + deptName); // 값을 잘 받아왔는지 확인
	
	// 데이터 묶기
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); 
	System.out.println("deptUpdateAction.jsp 드라이버 로딩 성공"); // 드라이버 로딩 확인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인"); // db 접속 확인
	
	// 2-1. 중복확인
	String sqlName = "SELECT dept_name FROM departments WHERE dept_name = ?";
	PreparedStatement stmtName = conn.prepareStatement(sqlName);
	stmtName.setString(1, dept.deptName);
	ResultSet rsName = stmtName.executeQuery();
	if(rsName.next()){
		String msg = URLEncoder.encode("부서이름이 중복되었습니다.", "utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath() + "/dept/deptUpdateForm.jsp?msg=" + msg + "&deptNo=" + deptNo);
		return;
	}

	// 2-2. 입력
	String sql = "UPDATE departments SET dept_name=? WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql); // 쿼리문 저장
	
	// n번째 ?에 updateForm에서 받아온 값 넣기
	stmt.setString(1, dept.deptName);
	stmt.setString(2, dept.deptNo);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
	
%>