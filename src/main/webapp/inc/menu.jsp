<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 파티션 jsp 페이지 사용할 코드 -->
<ul class="nav nav-tabs">
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/index.jsp" class="nav-link" data-bs-toggle="tab" href="#home">홈으로</a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="nav-link active" data-bs-toggle="tab" href="#deptList">부서관리</a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/dept/empList.jsp" class="nav-link" data-bs-toggle="tab" href="#empList">사원관리</a>
	</li>
	<li class="nav-item">
		<a href="<%=request.getContextPath()%>/index.jsp" class="nav-link" data-bs-toggle="tab" href="#salaryList">연봉관리</a>
	</li>
</ul>