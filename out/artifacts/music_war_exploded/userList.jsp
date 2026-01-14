<%--
  Created by IntelliJ IDEA.
  User: wangshuyu
  Date: 2025/6/1
  Time: 12:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <title>用户管理</title>
  <!-- 引入管理员主题样式 - music_bg.jpg 背景 -->
  <link rel="stylesheet" href="css/admin-theme.css">
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
      background: linear-gradient(135deg, var(--light), #ffffff);
      margin: 0;
      padding: 20px;
      min-height: 100vh;
      position: relative;
      overflow-x: hidden;
    }
    
    /* 音乐音符背景装饰 */
    .background-pattern {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: 0;
      overflow: hidden;
      pointer-events: none;
    }

    .music-note {
      position: absolute;
      color: var(--primary);
      opacity: 0.2;
      font-size: 3rem;
      animation: float 15s linear infinite;
    }

    @keyframes float {
      0% {
        transform: translateY(-100%) rotate(0deg);
        opacity: 0;
      }
      10% {
        opacity: 0.2;
      }
      90% {
        opacity: 0.2;
      }
      100% {
        transform: translateY(100vh) rotate(360deg);
        opacity: 0;
      }
    }
    .container {
      width: 90%;
      max-width: 1200px;
      margin: 0 auto;
      background-color: rgba(255, 255, 255, 0.95);
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(129, 199, 132, 0.3);
      border: 1px solid hsl(122, 39%, 80%);
      position: relative;
      z-index: 10;
    }
    .header {
      position: relative;
      text-align: center;
      margin-bottom: 30px;
    }
    .header h2 {
      color: var(--accent);
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid hsl(122, 39%, 80%);
    }
    .back-btn {
      position: absolute;
      left: 0;
      top: 50%;
      transform: translateY(-50%);
      background-color: var(--accent);
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
      background-color: var(--primary);
    }
    h2 {
      color: var(--accent);
      text-align: center;
      margin-bottom: 30px;
      padding-bottom: 15px;
      border-bottom: 1px solid hsl(122, 39%, 80%);
    }
    .search-box {
      margin-bottom: 20px;
      display: flex;
      gap: 10px;
    }
    .search-box input {
      padding: 8px 12px;
      border: 1px solid var(--secondary);
      border-radius: 4px;
      flex-grow: 1;
    }
    .search-box button {
      padding: 8px 16px;
      background-color: var(--accent);
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid hsl(122, 39%, 80%);
    }
    th {
      background-color: var(--accent);
      color: white;
      font-weight: 600;
    }
    tr:nth-child(even) {
      background-color: hsl(122, 39%, 95%);
    }
    tr:hover {
      background-color: hsl(122, 39%, 90%);
      transform: scale(1.01);
      transition: all 0.3s ease;
    }
    .action-btn {
      padding: 6px 12px;
      background-color: var(--accent);
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
      background-color: var(--primary);
      transform: translateY(-1px);
    }
    .delete-btn {
      background: linear-gradient(135deg, #ff4d4d, #cc0000);
      color: white;
      padding: 5px 10px;
      border-radius: 4px;
    }
    .created-at {
      white-space: nowrap;
    }
    .avatar-img {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
    }
    .role-badge {
      display: inline-block;
      padding: 3px 8px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: bold;
    }
    .role-admin {
      background-color: #6a3093;
      color: white;
    }
    .role-user {
      background-color: #e0d0ff;
      color: #6a3093;
    }
    .alert {
      padding: 12px 20px;
      margin-bottom: 20px;
      border-radius: 4px;
      font-size: 14px;
    }
    .alert-success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }
    .alert-error {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="header">
    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="back-btn">← 返回后台</a>
    <h2>👥 用户管理</h2>
  </div>

  <!-- 显示操作结果消息 -->
  <c:if test="${param.success == 'deleted'}">
    <div class="alert alert-success">用户注销成功！</div>
  </c:if>
  <c:if test="${param.error == 'delete_failed'}">
    <div class="alert alert-error">用户注销失败，请重试。</div>
  </c:if>
  <c:if test="${param.error == 'invalid_id'}">
    <div class="alert alert-error">无效的用户ID。</div>
  </c:if>
  <c:if test="${param.error == 'system_error'}">
    <div class="alert alert-error">系统错误，请稍后重试。</div>
  </c:if>

  <div class="search-box">
    <input type="text" placeholder="搜索用户名..." id="searchInput">
    <button onclick="searchUsers()">搜索</button>
  </div>

  <table>
    <thead>
    <tr>
      <th width="10%">头像</th>
      <th width="20%">用户名</th>
      <th width="20%">创建时间</th>
      <th width="15%">用户ID</th>
      <th width="35%">操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="user" items="${users}">
      <tr>
        <td>
          <c:choose>
            <c:when test="${not empty user.avatar}">
              <img src="${pageContext.request.contextPath}/${user.avatar}?v=<%= System.currentTimeMillis() %>" class="avatar-img" alt="用户头像">
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}/images/avatar.png?v=<%= System.currentTimeMillis() %>" class="avatar-img" alt="默认头像">
            </c:otherwise>
          </c:choose>
        </td>
        <td>${user.username}</td>
        <td class="created-at">
          <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
        </td>
        <td>${user.id}</td>
        <td>
          <a href="${pageContext.request.contextPath}/user/view?id=${user.id}" class="action-btn">查看</a>
          <a href="${pageContext.request.contextPath}/deleteUser?id=${user.id}" class="action-btn delete-btn"
             onclick="return confirm('确定要注销用户 ${user.username} 吗？')">注销</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

<script>
  function searchUsers() {
    const searchText = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('tbody tr');

    rows.forEach(row => {
      const username = row.cells[1].textContent.toLowerCase();
      if (username.includes(searchText)) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });
  }
</script>
<script>
  // 添加退出登录功能
  document.getElementById('logout').addEventListener('click', function(e) {
    e.preventDefault();
    if(confirm('确定要退出登录吗？')) {
      // 发送退出请求
      fetch('${pageContext.request.contextPath}/logout', {
        method: 'POST'
      }).then(response => {
        if(response.ok) {
          window.location.href = '${pageContext.request.contextPath}/login.jsp';
        }
      });
    }
  });
</script>

<!-- 分页组件 -->
<jsp:include page="/WEB-INF/includes/pagination.jsp" />

</body>
</html>