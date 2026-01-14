<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>专辑列表 - 音悦</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global-player.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', sans-serif;
        }

        body {
            background-color: #f8f5fe;
            color: #333;
        }

        .sidebar {
            width: 220px;
            height: 100vh;
            background: linear-gradient(135deg, #4CAF50, #2E7D32);
            position: fixed;
            padding: 20px 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .logo {
            text-align: center;
            padding: 15px 0 30px;
            color: white;
            font-size: 22px;
            font-weight: bold;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-menu li a {
            display: block;
            color: #d9c2ff;
            padding: 12px 25px;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 15px;
        }

        .nav-menu li a:hover,
        .nav-menu li a.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
            border-left: 4px solid #81C784;
        }

        .nav-menu li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .main-content {
            margin-left: 220px;
            padding: 20px 30px 100px;
            min-height: 100vh;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #C8E6C9;
        }

        .search-box {
            position: relative;
            width: 350px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 50px 10px 15px;
            border: none;
            border-radius: 20px;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .search-box button {
            position: absolute;
            right: 5px;
            top: 5px;
            background-color: #5cb85c;
            border: none;
            border-radius: 15px;
            padding: 5px 15px;
            color: white;
            cursor: pointer;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #C8E6C9;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2E7D32;
            font-weight: bold;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid #4CAF50;
        }

        .user-avatar:hover {
            transform: scale(1.1);
            box-shadow: 0 2px 8px rgba(76, 175, 80, 0.3);
        }

        .section-title {
            color: #2E7D32;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .albums-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            padding: 20px 0;
        }

        .album-card {
            background-color: white;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: #333;
            display: block;
        }

        .album-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(76, 175, 80, 0.2);
        }

        .album-cover {
            width: 100%;
            height: 170px;
            background: linear-gradient(135deg, #C8E6C9, #E8F5E9);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
            margin-bottom: 12px;
            overflow: hidden;
        }

        .album-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .album-name {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .album-artist {
            color: #888;
            font-size: 14px;
            margin-bottom: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .album-info {
            color: #999;
            font-size: 12px;
        }

        .empty-message {
            text-align: center;
            padding: 50px;
            color: #999;
            font-size: 16px;
        }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="logo">🎵 音悦</div>
    <ul class="nav-menu">
        <li><a href="${pageContext.request.contextPath}/user/music"><i>🏠</i>首页</a></li>
        <li><a href="${pageContext.request.contextPath}/hot-songs"><i>🔥</i>热歌榜单</a></li>
        <li><a href="${pageContext.request.contextPath}/favorites"><i>❤️</i>我的收藏</a></li>
        <li><a href="${pageContext.request.contextPath}/albums" class="active"><i>💿</i>专辑列表</a></li>
        <li><a href="${pageContext.request.contextPath}/playlists"><i>📋</i>我的歌单</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="top-bar">
        <form class="search-box" method="get" action="${pageContext.request.contextPath}/user/music">
            <input type="text" name="keyword" placeholder="搜索音乐">
            <button type="submit">🔍</button>
        </form>
        <div class="user-info">
            <a href="${pageContext.request.contextPath}/user/profile" style="text-decoration: none; display: flex; align-items: center;">
                <div class="user-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.avatar}">
                            <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}" alt="头像" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.user.username.charAt(0)}
                        </c:otherwise>
                    </c:choose>
                </div>
                <span style="color: #333; margin-left: 10px;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.nickname}">
                            ${sessionScope.user.nickname}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.user.username}
                        </c:otherwise>
                    </c:choose>
                </span>
            </a>
        </div>
    </div>

    <h2 class="section-title">专辑列表</h2>

    <c:choose>
        <c:when test="${empty albums}">
            <div class="empty-message">
                <p>暂无专辑数据</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="albums-grid">
                <c:forEach var="album" items="${albums}">
                    <a href="${pageContext.request.contextPath}/album-songs?album=${album.albumName}&artist=${album.artist}" class="album-card">
                        <div class="album-cover">
                            <c:choose>
                                <c:when test="${not empty album.coverPath}">
                                    <img src="${pageContext.request.contextPath}/${album.coverPath}" alt="${album.albumName}">
                                </c:when>
                                <c:otherwise>
                                    💿
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="album-name" title="${album.albumName}">${album.albumName}</div>
                        <div class="album-artist" title="${album.artist}">${album.artist}</div>
                        <div class="album-info">🎵 歌曲数: ${album.songCount}</div>
                    </a>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 引入全局播放器 -->
<jsp:include page="/WEB-INF/includes/player.jsp" />

<script src="${pageContext.request.contextPath}/js/global-player.js"></script>
<script>
    // 这个页面没有歌曲列表，播放器将继续播放之前的歌曲
    document.addEventListener('DOMContentLoaded', function() {
        // 不调用setSongs，保持之前的播放状态
    });
</script>

</body>
</html>
