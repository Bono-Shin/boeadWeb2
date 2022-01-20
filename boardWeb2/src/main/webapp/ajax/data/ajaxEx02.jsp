<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function callJson(){
		var request = new XMLHttpRequest();
		
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					//json은 자바스크립트 객체로 변환해서 쓴다.
					var jobj = JSON.parse(request.responseText);
					console.log(jobj);
					
					for(var i=0; i<jobj.length; i++){
						var obj = jobj[i];
						
						document.getElementById("result").innerHTML 
						+= obj.name +","+ obj.publisher +","+ obj.author +","+ obj.price+"<br>";
					}
				
				}
			}
		}
		
		request.open("GET","json/data1.json",false);
		
		request.send();
	}
		
	function callJson2(){
		
		var request = new XMLHttpRequest();
		
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					//jobj가 가지고 있는 fiedl3 출력
					var jobj = JSON.parse(request.responseText); //json파일을 가져와서 자바스크립트 객체타입으로 변환
					for(var i=0; i<jobj.length; i++){
						
						var field3 = jobj[i].field3; //field3을 출력하기 위한 변수 선언 및 사용
						console.log(field3);
							//field3이 배열로 되어 있으므로 한번 더 for문
							for(var j=0; j<field3.length; j++){
								document.getElementById("result").innerHTML
								+= field3[j].subfield1 +","+ field3[j].subfield2+"<br>";
							}
						
					}
				}
			}
		}
		
		request.open("GET","json/data2.json",false);
		
		request.send();
	
	}
	
	function callXml(){
		var request = new XMLHttpRequest();
		
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var xml = request.responseXML;
					
					var books = xml.getElementsByTagName("book");
					
					console.log(books.length);
					
					for(var i=0; i<books.length; i++){
						var name = books[i].getElementsByTagName("name")[0].textContent;
						console.log(name);
						var publisher = books[i].getElementsByTagName("publisher")[0].textContent;
						var author = books[i].getElementsByTagName("author")[0].textContent;
						var price = books[i].getElementsByTagName("price")[0].textContent;
						
						document.getElementById("result").innerHTML
						+= name +","+ publisher +","+ author +","+ price + "<br>";
					}
				}
			}
		}
		
		request.open("GET","xml/data1.xml",false);
		
		request.send();
	}
	
	//xml2 버튼 클릭 시, data2.xml에 있는 모든 subItem의 name 태그 값을 result 태그에 출력
	function callXml2(){
		var request = new XMLHttpRequest();
		
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var xml = request.responseXML;
					var items = xml.getElementsByTagName("item");
					console.log(items);
					
					for(var i=0; i<items.length; i++){
						var subItem = items[i].getElementsByTagName("subItem");
						console.log(subItem.length);
						
						for(var j=0; j<subItem.length; j++){
							var subName = subItem[j].getElementsByTagName("name")[0].textContent;
							
							document.getElementById("result").innerHTML += subName + "<br>";
							
						}
					}
				}
			}
		}
		
		request.open("GET","xml/data2.xml",false);
		request.send();
	}
</script>
</head>
<body>
	<h2>XML, JSON ajax 통신 예제</h2>
	<button onclick="callJson()">json</button>
	<button onclick="callJson2()">json2</button>
	<button onclick="callXml()">xml</button>
	<button onclick="callXml2()">xml2</button>
	<div id="result"></div>
</body>
</html>