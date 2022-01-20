<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script>
	function callJson(){
		$.ajax({
			url : "json/data1.json",
			type : "get",
			//검증
			success : function(data){
				alert("통신 성공");
				console.log(data);
				
				for(var i=0; i<data.length; i++){
					console.log(data[i].name);
					//div(#result)에 아무것도 없으니 + 연산을 사용해서 data를 담고 그 담은 데이터를 출력하는 형식 
					$("#result").html($("#result").html()+data[i].name+"<br>");
				}
			},
			error : function(xhr,status,error){
				alert("통신 오류");
			}
		});
	}
	
	function callXml(){
		$.ajax({
			url : "xml/data1.xml",
			type : "get",
			success : function(data){
				console.log(data);
				//돔객체를 jquery로 변환
				var jxml = $(data);
				
				jxml.find("book").each(function(){
					var name = $(this).find("name").text();
					console.log(name);
				});
			},
			error : function(){
				alert("통신오류");
			}
		});
	}
</script>
</head>
<body>
	<h2>jQuery를 이용한 ajax</h2>
	<button onclick="callJson()">json</button>
	<button onclick="callXml()">xml</button>
	<div id="result">
	</div>
</body>
</html>