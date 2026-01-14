<%--
  Created by IntelliJ IDEA.
  User: wangshuyu
  Date: 2025/5/31
  Time: 19:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>评论管理</title>
  <!-- 引入管理员主题样式 - music_bg.jpg 背景 -->
  <link rel="stylesheet" href="css/admin-theme.css">
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f5f0ff;
      color: #333;
      margin: 0;
      padding: 20px;
    }
    .container {
      width: 90%;
      max-width: 1200px;
      margin: 0 auto;
      background-color: #ffffff;
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(102, 51, 153, 0.1);
      border: 1px solid #e0d0ff;
    }
    .header {
      position: relative;
      text-align: center;
      margin-bottom: 30px;
    }
    .header h2 {
      color: #6a3093;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #e0d0ff;
    }
    .back-btn {
      position: absolute;
      left: 0;
      top: 50%;
      transform: translateY(-50%);
      background-color: #6a3093;
      color: white;
      padding: 8px 16px;
      border-radius: 4px;
      text-decoration: none;
      font-weight: bold;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .back-btn:hover {
      background-color: #8e44ad;
    }
    h2 {
      color: #6a3093;
      text-align: center;
      margin-bottom: 30px;
      padding-bottom: 15px;
      border-bottom: 1px solid #e0d0ff;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #e0d0ff;
    }
    th {
      background-color: #f9f5ff;
      color: #6a3093;
      font-weight: 600;
    }
    tr:nth-child(even) {
      background-color: #fcfaff;
    }
    tr:hover {
      background-color: #f5f0ff;
    }
    .action-btn {
      padding: 6px 12px;
      background-color: #6a3093;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      font-size: 14px;
      margin-right: 5px;
    }
    .action-btn:hover {
      background-color: #8e44ad;
      transform: translateY(-1px);
    }
    .delete-btn {
      background-color: #d9534f;
    }
    .delete-btn:hover {
      background-color: #c9302c;
    }
    .featured-btn {
      background-color: #5cb85c;
    }
    .featured-btn:hover {
      background-color: #449d44;
    }
    .search-box {
      margin-bottom: 20px;
      display: flex;
      gap: 10px;
    }
    .search-box input {
      padding: 8px 12px;
      border: 1px solid #d9c2ff;
      border-radius: 4px;
      flex-grow: 1;
    }
    .search-box button {
      padding: 8px 16px;
      background-color: #6a3093;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .pagination {
      display: flex;
      justify-content: center;
      margin-top: 20px;
    }
    .pagination a {
      padding: 8px 16px;
      margin: 0 5px;
      border: 1px solid #d9c2ff;
      border-radius: 4px;
      color: #6a3093;
      text-decoration: none;
    }
    .pagination a.active {
      background-color: #6a3093;
      color: white;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="header">
    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="back-btn">← 返回后台</a>
    <h2>评论管理</h2>
  </div>

  <form class="search-box" method="get" action="comments">
    <input type="text" name="keyword" placeholder="搜索评论内容、用户名或歌曲名..." 
           value="${keyword}" id="searchInput">
    <button type="submit">搜索</button>
    <c:if test="${not empty keyword}">
      <a href="comments" style="padding: 8px 16px; background-color: #999; color: white; 
         border-radius: 4px; text-decoration: none; margin-left: 5px;">清除</a>
    </c:if>
  </form>

  <c:if test="${not empty keyword}">
    <div style="margin-bottom: 15px; padding: 10px; background-color: #e8f5e9; 
         border-left: 4px solid #4caf50; border-radius: 4px;">
      搜索关键词："<strong>${keyword}</strong>"，找到 <strong>${comments.size()}</strong> 条结果
    </div>
  </c:if>

  <table>
    <thead>
    <tr>
      <th>ID</th>
      <th>歌曲ID</th>
      <th>歌曲名字</th>
      <th>用户名</th>
      <th>评论内容</th>
      <th>创建时间</th>
      <th>状态</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="comment" items="${comments}">
      <tr>
        <td>${comment.id}</td>
        <td>${comment.musicId}</td>
        <td style="color: #6a3093; font-weight: 500;">${comment.musicTitle}</td>
        <td>${comment.username}</td>
        <td>${comment.content}</td>
        <td><fmt:formatDate value="${comment.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        <td>
          <c:choose>
            <c:when test="${comment.isFeatured}">
              <span style="color: #5cb85c; font-weight: bold;">✓ 精华</span>
            </c:when>
            <c:otherwise>
              <span style="color: #999;">普通</span>
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <form method="post" action="toggleFeaturedComment" style="display: inline;">
            <input type="hidden" name="id" value="${comment.id}">
            <button type="submit" class="action-btn featured-btn">
              <c:choose>
                <c:when test="${comment.isFeatured}">取消精华</c:when>
                <c:otherwise>设为精华</c:otherwise>
              </c:choose>
            </button>
          </form>
          <a href="deleteComment?id=${comment.id}" class="action-btn delete-btn"
             onclick="return confirm('确定要删除这条评论吗？')">删除</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <!-- 分页组件 -->
  <jsp:include page="/WEB-INF/includes/pagination.jsp" />
</div>
</body>
</html>
