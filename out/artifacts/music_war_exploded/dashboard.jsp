<%--
  Created by IntelliJ IDEA.
  User: wangshuyu
  Date: 2025/5/30
  Time: 20:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>管理后台</title>
  <!-- 引入Font Awesome图标库 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- 引入管理员主题样式 - music_bg.jpg 背景 -->
  <link rel="stylesheet" href="css/admin-theme.css">
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #E0E7FF;
      color: #333;
      margin: 0;
      padding: 20px;
    }
    .container {
      width: 800px;
      margin: 0 auto;
      background-color: #ffffff;
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(102, 51, 153, 0.1);
      border: 1px solid #e0d0ff;
    }
    h2 {
      color: #6a3093;
      text-align: center;
      margin-bottom: 30px;
      padding-bottom: 15px;
      border-bottom: 1px solid #e0d0ff;
    }
    .menu {
      list-style: none;
      padding: 0;
    }
    .menu li {
      margin: 15px 0;
    }
    .menu a {
      display: flex;
      align-items: center;
      padding: 12px 20px;
      background-color: #E0E7FF;
      text-decoration: none;
      color: #6a3093;
      border-radius: 6px;
      border: 1px solid #d9c2ff;
      transition: all 0.3s ease;
      font-weight: 500;
    }
    .menu a:hover {
      background-color: #6a3093;
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(106, 48, 147, 0.2);
    }
    .menu a:hover .icon {
      color: white;
    }
    .icon {
      width: 24px;
      margin-right: 12px;
      color: #6a3093;
      text-align: center;
      font-size: 18px;
      transition: all 0.3s ease;
    }
  </style>
</head>
<body>
<div class="container">
  <h2><i class="fas fa-cog"></i> 管理后台</h2>
  <ul class="menu">
    <li>
      <a href="MusicServlet?action=manage">
        <span class="icon"><i class="fas fa-music"></i></span>
        歌曲管理
      </a>
    </li>
    <li>
      <a href="comments">
        <span class="icon"><i class="fas fa-comments"></i></span>
        评论管理
      </a>
    </li>
    <li>
      <a href="hotlist">
        <span class="icon"><i class="fas fa-fire"></i></span>
        热榜管理
      </a>
    </li>
    <li>
      <a href="user/list">
        <span class="icon"><i class="fas fa-users"></i></span>
        用户管理
      </a>
    </li>
    <li>
      <a href="login.jsp">
        <span class="icon"><i class="fas fa-sign-out-alt"></i></span>
        退出登录
      </a>
    </li>
  </ul>
</div>
</body>
</html>
