<%--
  Created by IntelliJ IDEA.
  User: wangshuyu
  Date: 2025/5/29
  Time: 12:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>操作结果</title>
  <style>
    :root {
      --primary: hsl(122, 39%, 65%);
      --secondary: hsl(122, 39%, 75%);
      --accent: hsl(122, 39%, 55%);
      --light: hsl(122, 39%, 85%);
      --text-dark: hsl(122, 20%, 30%);
    }
    
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: var(--light);
      color: #333;
      margin: 0;
      padding: 20px;
    }
    .container {
      width: 500px;
      margin: 0 auto;
      text-align: center;
      background-color: #ffffff;
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(129, 199, 132, 0.3);
      border: 1px solid hsl(122, 39%, 80%);
    }
    h2 {
      color: var(--accent);
      margin-bottom: 20px;
    }
    .success {
      color: var(--accent);
      font-size: 18px;
      padding: 10px;
      background-color: rgba(129, 199, 132, 0.15);
      border-radius: 4px;
    }
    .button-group {
      margin-top: 20px;
    }
    .btn-continue, .btn-return {
      color: var(--accent);
      text-decoration: none;
      font-weight: bold;
      padding: 10px 20px;
      border: 1px solid var(--accent);
      border-radius: 4px;
      display: inline-block;
      margin: 0 10px;
      transition: all 0.3s ease;
    }
    .btn-continue:hover, .btn-return:hover {
      background-color: var(--accent);
      color: white;
    }
    .btn-continue {
      background-color: #f8f9fa;
    }
    .btn-return {
      background-color: var(--accent);
      color: white;
    }
    .btn-return:hover {
      background-color: var(--primary);
    }
  </style>
</head>
<body>
<div class="container">
  <h2>操作结果</h2>
  <p class="success">${message}</p>
  <div class="button-group">
    <a href="addMusic.jsp" class="btn-continue">继续添加</a>
    <a href="MusicServlet?action=manage" class="btn-return">返回</a>
  </div>
</div>
</body>
</html>
