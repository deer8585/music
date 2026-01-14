<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>🎵 歌曲管理</title>
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
        
        .header h1 {
            color: #6a3093;
            margin-bottom: 20px;
            font-size: 28px;
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
        
        .search-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f5ff;
            border-radius: 6px;
        }
        
        .search-form {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .search-input {
            padding: 8px 12px;
            border: 1px solid #c9b0ff;
            border-radius: 4px;
            width: 300px;
            font-size: 14px;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-search {
            background-color: #6a3093;
            color: white;
        }
        
        .btn-search:hover {
            background-color: #8e44ad;
        }
        
        .btn-add {
            background-color: #28a745;
            color: white;
        }
        
        .btn-add:hover {
            background-color: #218838;
        }
        
        .btn-delete {
            background-color: #dc3545;
            color: white;
            padding: 4px 8px;
            font-size: 12px;
        }
        
        .btn-delete:hover {
            background-color: #c82333;
        }
        
        .btn-edit {
            background-color: #ffc107;
            color: #212529;
            padding: 4px 8px;
            font-size: 12px;
        }
        
        .btn-edit:hover {
            background-color: #e0a800;
        }
        
        .music-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .music-table th,
        .music-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0d0ff;
        }
        
        .music-table th {
            background-color: #6a3093;
            color: white;
            font-weight: bold;
        }
        
        .music-table tr:nth-child(even) {
            background-color: #f9f5ff;
        }
        
        .music-table tr:hover {
            background-color: #f0e6ff;
        }
        
        .cover-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .no-cover {
            width: 50px;
            height: 50px;
            background-color: #e0d0ff;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6a3093;
            font-size: 20px;
        }
        
        .duration {
            font-family: monospace;
        }
        
        .actions {
            display: flex;
            gap: 5px;
        }
        
        .message {
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        
        .success {
            background-color: rgba(92, 184, 92, 0.1);
            color: #5cb85c;
            border: 1px solid #5cb85c;
        }
        
        .error {
            background-color: rgba(217, 83, 79, 0.1);
            color: #d9534f;
            border: 1px solid #d9534f;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="dashboard.jsp" class="back-btn">← 返回后台</a>
            <h1>🎵 歌曲管理</h1>
        </div>
        
        <!-- 消息显示 -->
        <c:if test="${not empty message}">
            <div class="message success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>
        
        <!-- 搜索和添加区域 -->
        <div class="search-section">
            <form class="search-form" action="MusicServlet" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="search-input" 
                       placeholder="搜索歌曲名称、歌手或专辑..." value="${keyword}">
                <button type="submit" class="btn btn-search">搜索</button>
            </form>
            <a href="addMusic.jsp" class="btn btn-add">添加音乐</a>
        </div>
        
        <!-- 音乐列表表格 -->
        <c:choose>
            <c:when test="${not empty musicList}">
                <table class="music-table">
                    <thead>
                        <tr>
                            <th>封面</th>
                            <th>歌曲名称</th>
                            <th>歌手</th>
                            <th>专辑</th>
                            <th>时长</th>
                            <th>播放量</th>
                            <th>添加时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="music" items="${musicList}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty music.coverPath}">
                                            <img src="${pageContext.request.contextPath}/${music.coverPath}" alt="封面" class="cover-img">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-cover">🎵</div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${music.title}</td>
                                <td>${music.artist}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty music.album}">${music.album}</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="duration">
                                    <c:set var="minutes" value="${music.duration - (music.duration % 60)}" />
                                    <c:set var="seconds" value="${music.duration % 60}" />
                                    <fmt:formatNumber value="${minutes / 60}" pattern="0" />:<fmt:formatNumber value="${seconds}" pattern="00" />
                                </td>
                                <td><fmt:formatNumber value="${music.playCount}" pattern="#,###" /></td>
                                <td>
                                    <fmt:formatDate value="${music.releaseTime}" pattern="yyyy-MM-dd HH:mm" />
                                </td>
                                <td>
                                    <div class="actions">
                                        <a href="MusicServlet?action=edit&id=${music.id}" class="btn btn-edit">修改</a>
                                        <a href="MusicServlet?action=delete&id=${music.id}" 
                                           class="btn btn-delete"
                                           onclick="return confirm('确定要删除这首歌曲吗？')">删除</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <c:choose>
                        <c:when test="${not empty keyword}">
                            没有找到包含 "${keyword}" 的歌曲
                        </c:when>
                        <c:otherwise>
                            暂无音乐数据，<a href="addMusic.jsp">点击添加</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- 分页组件 -->
        <jsp:include page="/WEB-INF/includes/pagination.jsp" />
    </div>
    
    <script>
        // 自动隐藏消息
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.opacity = '0';
                setTimeout(function() {
                    msg.style.display = 'none';
                }, 300);
            });
        }, 3000);
    </script>
</body>
</html>
