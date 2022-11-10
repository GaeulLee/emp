<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 안전장치(넘어온 값이 없다면 입력창으로 돌아가게)
	if(request.getParameter("deptNo") == null || request.getParameter("deptName") == null || deptNo.equals("") || deptName.equals("")){
		String msg = URLEncoder.encode("부서번호와 이름을 입력하세요.", "utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청처리
	// 이미 존재하는 key(dept_no)값이 등록되면 예외(에러) 발생 -> 동일 값 입력 시 예외 발생하지 않도록
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertDeptAction.jsp 드라이버 로딩 성공"); // 드라이버 로딩 확인
	// db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인"); // db 접속 확인
	
	
	// 2-1. dept_no, dept_name 유효성검사
	String sqlNo = "SELECT dept_no FROM departments WHERE dept_no = ? OR dept_name = ?"; // 입력하기 전에 동일한 dept_no가 존재하는지 확인
	PreparedStatement stmtNo = conn.prepareStatement(sqlNo);
	stmtNo.setString(1, deptNo);
	stmtNo.setString(2, deptName);
	ResultSet rsNo = stmtNo.executeQuery();
	if(rsNo.next()){ // 결과물이 있다 = 같은 dept_no가 존재함을 의미
		String msg = URLEncoder.encode("부서이름 또는 부서번호가 중복되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 2-2. 입력
	
	// 쿼리문 입력
	String sql2 = "INSERT INTO departments (dept_no, dept_name) VALUES (?,?);";
	PreparedStatement stmt2 = conn.prepareStatement(sql2); // 쿼리문 저장
	
	// ?에 값 대입
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	
	// 값이 잘 들어갔는지 확인
	int row = stmt2.executeUpdate();
	if(row == 1){
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	// 3. 요청출력
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
%>