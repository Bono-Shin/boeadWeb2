<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function callString(){
		//XMLHttpRequest 객체 생성
		var request = new XMLHttpRequest();
		
		//검증 - open 이전에 해야함
		request.onreadystatechange = function(){
			//4번이 내가 요청한 응답을 받은 상태임
			if(request.readyState == 4){
				//status 2xx 일 때, ok 상태임 -> 정상적으로 응답을 받아 처리했을 때만 결과를 출력해달라는 뜻
				if(request.status == 200){
					document.getElementById("result").innerHTML = request.responseText; //응답을 받을 경로 및 출력
					//해당 html에 있는 화면에 나타나는 데이터 자체가 응답데이터가 된다.
				}
			}
		}
		
		//open 메소드
		request.open("GET","html/data1.html",false); //준비과정
		//get방식, 요청보낼 경로, 요청이 올 때 까지 기다리겠다(false)
		//true : 응답을 기다리지 않고 다른일을 하다 응답이 오면 처리
		//false : 응답을 기다리다가 응답이 오면 처리
		
		request.send(); //요청을 보냄
		
	}
	
	function callHtlm(){
		var request = new XMLHttpRequest();
		
		request.onreadystatechange = function(){
			
			if(request.readyState == 4){
				if(request.status == 200){
					document.getElementById("result").innerHTML = request.responseText;
				}
			}
		}
		request.open("GET","html/data2.html",false);
		
		request.send();
		
	}
</script>
</head>
<body>
	<h2>ajax 예제</h2>
	<button onclick="callString()">String call</button>
	<button onclick="callHtlm()">html call</button>
	<div id="result">
	
	</div>
</body>
</html>