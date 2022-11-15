<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 파티션 jsp 페이지 사용할 코드 -->
<nav class="navbar navbar-expand-sm bg-light navbar-light">
	<div class="container-fluid">
		<ul class="navbar-nav w-75 mx-auto">
			<li class="nav-item">
				<a href="<%=request.getContextPath()%>/index.jsp" class="nav-link">홈으로</a>
			</li>
			<li class="nav-item">
				<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="nav-link" >부서관리</a>
			</li>
			<li class="nav-item">
				<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="nav-link">사원관리</a>
			</li>
			<li class="nav-item">
				<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" class="nav-link">부서별 사원</a>
			</li>
			<li class="nav-item">
  				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp" class="nav-link">연봉관리</a>
			</li>
			<li class="nav-item">
  				<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="nav-link">게시판관리</a>
			</li>
		</ul>
	</div>
</nav>