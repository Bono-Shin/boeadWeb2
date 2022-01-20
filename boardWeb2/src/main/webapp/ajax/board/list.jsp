<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script>
	//실시간을 위한 작업 2
	//전역변수 선언
	var clickBtn;
	//리스트 출력 여부 확인
	var printTable=false;

	function callList(){
		printTable=true;
		$.ajax({
			url : "ajaxList.jsp",
			type : "get",
			success : function(data){
				console.log(data);
				
				var json = JSON.parse(data.trim());
				console.log(json);
				
				var html = "";
				html += "<table border ='1'>";
				html += "<thead>";
				html += "<tr>";
				html += "<th>글번호</th><th>제목</th><th>작성자</th><th></th>";
				html += "</tr>";
				html += "</thead>";
				html += "<tbody>";
				for(var i=0; i<json.length; i++){
					html += "<tr>";
					html += "<td>"+json[i].bidx+"</td>";
					html += "<td>"+json[i].subject+"</td>";
					html += "<td>"+json[i].writer+"</td>";
														//for문이므로 i값을 이용해 bidx를 찾는다
					html += "<td><button onclick='modify("+json[i].bidx+",this)'>수정</button>"
																		//실시간을 위한 작업 3 (누른 버튼 찾기 위해)
							+"<button onclick='del("+json[i].bidx+",this)'>삭제</button></td>"
					html += "</tr>";
				}
				html += "</tbody>";
				html += "</table>";
				
				$("#list").html(html);
			}
		});
	}
	
				//bidx를 받아옴
	function modify(bidx,obj){
		//실시간작업 4 (수정을 클릭한 행을 변수에 담아 기억하기 위해서)
		clickBtn = obj;
		
		$.ajax({
			url : "ajaxView.jsp",
			type : "get", //조회 관련만 get방식 사용
			data : "bidx="+bidx, //{bidx : bixd} 형식의 객체로도 넘길 수 있다.{키 : 값, @#!$$, !@$@#$} 복수개 가능
			success : function(data){
				if(printTable){
				var json = JSON.parse(data.trim());
				
				$("input[name='subject']").val(json[0].subject);
				$("input[name='writer']").val(json[0].writer);
				$("textarea").val(json[0].content);
				//저장을 위한 bidx -> hidden type에 bidx의 value를 넣어줌
				$("input[name='bidx']").val(json[0].bidx);
				}
			}
		});
	}
	
	/*
	데이터 넘기는 법
	$.ajax({
		url : "경로",
		type : "메소드",
		data : "파라미터 형식으로 된 데이터" -> ex) "bidx=4" (요청경로에서 데이터는 request.getParameter("bidx")로 가져올 수 있다),
		success : function(data){
			
		}
	});
	*/
	
	
	//form이 빈값일 때 글 등록 되게 하기
	function save(){
		//저장버튼 클릭 시 ajax를 이용하여 해당 데이터 수정
		
		//실시간을 위한 작업
		//ajax는 비동기통신으로 기다리지않고 처리하기 때문에 해당 변수를 미리 선언한다.
		var subject = $("input[name='subject']").val();
		var writer = $("input[name='writer']").val();
		//글등록1 - bidx가 빈값인 경우는 수정버튼을 누르지 않은 상태
		var bidx = $("input[name='bidx']").val();
		
		var yn;
		
		if(bidx == ""){
			yn=confirm("등록하시겠습니까?");
			
			if(yn){
				$.ajax({
					url : "ajaxInsert.jsp",
					type : "post",
					data : $("form").serialize(),
					success : function(data){
						//화면 게시글 목록에 출력되고 있는 경우에만
						//응답 데이터 한건 테이블 맨 위 행으로 추가
						//jQuery prepend() 사용
						//prepend() -> 타겟 객체의 첫번째 요소로 붙인다.
						var json = JSON.parse(data.trim());
						var html = "<tr>";
						html += "<td>"+json[0].bidx+"</td>";
						html += "<td>"+json[0].subject+"</td>";
						html += "<td>"+json[0].writer+"</td>";
						html += "<td><button onclick='modify("+json[0].bidx+"this)'>수정</button>"
								+"<button onclick='del("+json[0].bidx+",this)'>삭제</button></td>"
						html += "</tr>";
						$("tbody").prepend(html);
					}
				});
			}
		}else{
			yn=confirm("수정하시겠습니까?");
			
			if(yn){
				//1.form 태그 안에 입력한 입력양식 데이터
				$.ajax({
					url : "ajaxUpdate.jsp",
					type : "post",
									//form태그 안에 입력값들을 파라미터 형식(변수=값)으로 만들어줌
					data : $("form").serialize(), //ex. bidx=?&subject=? 이런 형식으로
					success : function(data){
						if(data.trim() > 0){
							alert("수정완료");
							
						}else{
							alert("수정실패");
						}
						
						//실시간 작업 5 (기억한 변수를 사용해서 넣을 위치 찾기)
						$(clickBtn).parent().prev().text(writer);
						$(clickBtn).parent().prev().prev().text(subject);
						
					}
				});
				
			}
		}
		
		//2.modify.jsp로 ajax를 통하여 1번의 데이터를 전송
		//3.modify.jsp에서는 board 데이터를 수정 작업
		//4.success는 일단은 비움
	}
	
	function del(bidx,obj){
		$.ajax({
			url : "ajaxdel.jsp",
			type : "post",
			data : "bidx="+bidx,
			success : function(data){
				if(data > 0){
					//삭제된 tr을 알아야 함
					$(obj).parent().parent().remove();
					
				}
			}
		});
	}
	
	function resetFn(){
						//초기화 버튼
						//$("form").reset();
						document.frm.reset();
						//bidx 별도 초기화
						$("input[name='bidx']".val(""));
		
	}
</script>
</head>
<body>
	<button onclick="callList()">목록 출력</button>
	<h2>ajax를 이용한 게시판 구현</h2>
	<div id="list"></div>
	<div id="write">
		<form name="frm">
		<!-- 저장을 눌렀을 때, bidx 정보를 보내기 위해 -->
		<input type="hidden" name="bidx">
			<p>
				<label>
					제목 : <input type="text" name="subject" size="50">
				</label>
			</p>
			<p>
				<label>
					작성자 : <input type="text" name="writer">
				</label>
			</p>
			<p>
				<label>
					내용 : <textarea name="content"></textarea>
				</label>
			</p>
			<input type="button" value="저장" onclick="save()">
			<input type="button" value="초기화" onclick="resetFn()">
		</form>
	</div>
</body>
</html>