package vo;

public class DeptEmp {
	// 테이블 컬럼과 일치하는 도메인 타입
	// 단점 : join 결과를 처리할 수 없음
	// public int emp;
	// public int deptNo;
	
	// 장점 : dept_emp 테이블의 행 + join 결과의 행도 처리할 수 있음
	// 단점 : 복잡하다
	public Employee emp;
	public Department dept;
	public String fromDate;
	public String toDate;
	
	
}
