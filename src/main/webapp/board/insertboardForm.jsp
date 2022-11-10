<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>InsertBoard</title>
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			#title{
				height: 50px;
				line-height: 50px;
				background-color: lightgrey;
				text-align: center;
			}
			th{
				text-align: center;
			}
		</style>
	</head>
	<body>
		<div class="container w-75 mx-auto">
			<div class="rounded mt-1 h4 text-white" id="title">새 게시물 작성</div>
			<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
				<table class="table table-borderless shadow-sm p-4 mb-4 bg-white align-middle">
					<!-- msg파라메터 값이 있으면 출력 -->
					<%
						String msg = request.getParameter("msg");
						if(msg != null){
						%>
						<tr>
							<td colspan="2" class="text-primary"> &#10069;<%=msg%></td>
						</tr>
						<%
						}
					%>
					<tr>
						<th class="w-25">게시글 제목</th>
						<td>
							<input type="text" name="boardTitle" class="form-control" placeholder="제목을 입력하세요.">
						</td>
					</tr>
					<tr>
						<th class="w-25">내용</th>
						<td>
							<textarea name="boardContent" rows="20" class="form-control" placeholder="내용을 입력하세요."></textarea>
						</td>
					</tr>
					<tr>
						<th class="w-25">작성자</th>
						<td>
							<input type="text" name="boardWriter" class="form-control">
						</td>
					</tr>
					<tr>
						<th class="w-25">글 비밀번호</th>
						<td>
							<input type="text" name="boardPw" class="form-control" placeholder="최초 작성 후 수정할 수 없습니다.">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<button type="submit" class="btn btn-outline-primary float-end">ADD</button>
							<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-outline-primary float-start">BACK</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>