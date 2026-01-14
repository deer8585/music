<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>查看用户信息</title>
    <!-- 引入管理员主题样式 -->
    <link rel="stylesheet" href="css/admin-theme.css">
    <style>
        :root {
            --primary: hsl(122, 39%, 65%);
            --secondary: hsl(122, 39%, 75%);
            --accent: hsl(122, 39%, 55%);
            --light: hsl(122, 39%, 85%);
            --text-dark: hsl(122, 20%, 30%);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', sans-serif;
        }

        body {
            background-color: var(--light);
            color: #333;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(129, 199, 132, 0.3);
            border: 1px solid hsl(122, 39%, 80%);
        }

        .header {
            position: relative;
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid hsl(122, 39%, 80%);
        }

        .header h2 {
            color: var(--accent);
            font-size: 24px;
            margin-bottom: 5px;
        }

        .back-btn {
            position: absolute;
            left: 0;
            top: 0;
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

        .avatar-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .avatar-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 15px;
            background-color: var(--light);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: var(--accent);
            font-weight: bold;
            overflow: hidden;
            border: 3px solid var(--accent);
        }

        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .info-section {
            margin-bottom: 30px;
        }

        .info-group {
            margin-bottom: 20px;
            padding: 15px;
            background-color: hsl(122, 39%, 95%);
            border-radius: 8px;
            border-left: 4px solid var(--accent);
        }

        .info-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--accent);
            font-weight: bold;
            font-size: 14px;
        }

        .info-group .value {
            color: #333;
            font-size: 16px;
            padding: 8px 0;
        }

        .info-group .empty {
            color: #999;
            font-style: italic;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0d0ff;
        }

        .btn {
            padding: 10px 30px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background-color: #6a3093;
            color: white;
        }

        .btn-primary:hover {
            background-color: #8e44ad;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .role-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 14px;
            font-weight: bold;
        }

        .role-user {
            background-color: #e0d0ff;
            color: #6a3093;
        }

        .role-admin {
            background-color: #6a3093;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <a href="${pageContext.request.contextPath}/user/list" class="back-btn">← 返回列表</a>
        <h2>👤 用户信息</h2>
    </div>

    <div class="avatar-section">
        <div class="avatar-preview">
            <c:choose>
                <c:when test="${not empty viewUser.avatar}">
                    <img src="${pageContext.request.contextPath}/${viewUser.avatar}?v=<%= System.currentTimeMillis() %>" alt="用户头像">
                </c:when>
                <c:otherwise>
                    ${viewUser.username.charAt(0)}
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="info-section">
        <div class="info-group">
            <label>用户ID</label>
            <div class="value">${viewUser.id}</div>
        </div>

        <div class="info-group">
            <label>用户名</label>
            <div class="value">${viewUser.username}</div>
        </div>

        <div class="info-group">
            <label>昵称</label>
            <div class="value">
                <c:choose>
                    <c:when test="${not empty viewUser.nickname}">
                        ${viewUser.nickname}
                    </c:when>
                    <c:otherwise>
                        <span class="empty">未设置</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="info-group">
            <label>性别</label>
            <div class="value">
                <c:choose>
                    <c:when test="${not empty viewUser.gender}">
                        ${viewUser.gender}
                    </c:when>
                    <c:otherwise>
                        <span class="empty">保密</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="info-group">
            <label>个性签名</label>
            <div class="value">
                <c:choose>
                    <c:when test="${not empty viewUser.signature}">
                        ${viewUser.signature}
                    </c:when>
                    <c:otherwise>
                        <span class="empty">这个人很懒，什么都没写</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="info-group">
            <label>用户角色</label>
            <div class="value">
                <c:choose>
                    <c:when test="${viewUser.role == 'admin'}">
                        <span class="role-badge role-admin">管理员</span>
                    </c:when>
                    <c:otherwise>
                        <span class="role-badge role-user">普通用户</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="info-group">
            <label>注册时间</label>
            <div class="value">
                <fmt:formatDate value="${viewUser.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </div>
        </div>
    </div>

    <div class="button-group">
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-primary">返回列表</a>
        <a href="${pageContext.request.contextPath}/deleteUser?id=${viewUser.id}" 
           class="btn btn-danger"
           onclick="return confirm('确定要注销用户 ${viewUser.username} 吗？此操作不可恢复！')">注销用户</a>
    </div>
</div>
</body>
</html>
