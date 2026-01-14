<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的歌单 - 音悦</title>
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

        .empty-message {
            text-align: center;
            padding: 80px 20px;
            color: #999;
            font-size: 16px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .empty-message p {
            margin-bottom: 10px;
        }

        .create-btn {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .create-btn:hover {
            background-color: #2E7D32;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
        }

        .playlists-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .playlist-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: all 0.3s;
        }

        .playlist-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .playlist-cover {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #C8E6C9, #E8F5E9);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            margin-bottom: 15px;
            overflow: hidden;
        }

        .playlist-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .playlist-name {
            color: #2E7D32;
            font-size: 18px;
            margin-bottom: 5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .playlist-count {
            color: #888;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .playlist-actions {
            display: flex;
            gap: 10px;
        }

        .action-btn {
            flex: 1;
            padding: 8px;
            background-color: #C8E6C9;
            color: #2E7D32;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s;
        }

        .action-btn:hover {
            background-color: #A5D6A7;
        }

        .action-btn.delete {
            background-color: #ffe0e0;
            color: #d32f2f;
        }

        .action-btn.delete:hover {
            background-color: #ffc0c0;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: #000;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2E7D32;
            font-weight: bold;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #C8E6C9;
            border-radius: 5px;
            font-size: 14px;
            font-family: 'Microsoft YaHei', sans-serif;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4CAF50;
        }

        .form-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .btn-cancel,
        .btn-submit {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-cancel {
            background-color: #e0e0e0;
            color: #666;
        }

        .btn-cancel:hover {
            background-color: #d0d0d0;
        }

        .btn-submit {
            background-color: #4CAF50;
            color: white;
        }

        .btn-submit:hover {
            background-color: #2E7D32;
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
        <li><a href="${pageContext.request.contextPath}/albums"><i>💿</i>专辑列表</a></li>
        <li><a href="${pageContext.request.contextPath}/playlists" class="active"><i>📋</i>我的歌单</a></li>
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

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h2 class="section-title">我的歌单</h2>
        <button class="create-btn" onclick="showCreateModal()">+ 创建歌单</button>
    </div>

    <c:choose>
        <c:when test="${empty playlists}">
            <div class="empty-message">
                <p>📋 还没有创建歌单</p>
                <p style="font-size: 14px; color: #bbb; margin-top: 10px;">点击"创建歌单"按钮开始吧！</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="playlists-grid">
                <c:forEach var="playlist" items="${playlists}">
                    <div class="playlist-card">
                        <div class="playlist-cover">
                            <c:choose>
                                <c:when test="${not empty playlist.coverPath && playlist.coverPath != 'images/avatar.png'}">
                                    <img src="${pageContext.request.contextPath}/${playlist.coverPath}" alt="${playlist.name}">
                                </c:when>
                                <c:otherwise>
                                    📋
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="playlist-info">
                            <h3 class="playlist-name">${playlist.name}</h3>
                            <p class="playlist-count">${playlist.songCount} 首歌曲</p>
                            <div class="playlist-actions">
                                <a href="${pageContext.request.contextPath}/playlist-detail?id=${playlist.id}" class="action-btn">查看</a>
                                <button class="action-btn" onclick="showEditModal(${playlist.id}, '${playlist.name}', '${playlist.description}')">编辑</button>
                                <button class="action-btn delete" onclick="deletePlaylist(${playlist.id})">删除</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 创建/编辑歌单弹窗 -->
<div id="playlistModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2 id="modalTitle">创建歌单</h2>
        <form id="playlistForm">
            <input type="hidden" id="playlistId" name="playlistId">
            <div class="form-group">
                <label>歌单名称</label>
                <input type="text" id="playlistName" name="name" required maxlength="50">
            </div>
            <div class="form-group">
                <label>歌单描述</label>
                <textarea id="playlistDesc" name="description" rows="3" maxlength="200"></textarea>
            </div>
            <div class="form-group" id="editCoverGroup" style="display: none;">
                <label>歌单封面</label>
                <p style="color: #888; font-size: 12px; margin-bottom: 10px;">
                    如需更换封面，请进入歌单详情页面上传
                </p>
            </div>
            <div class="form-buttons">
                <button type="button" class="btn-cancel" onclick="closeModal()">取消</button>
                <button type="submit" class="btn-submit">确定</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showCreateModal() {
        document.getElementById('modalTitle').textContent = '创建歌单';
        document.getElementById('playlistForm').reset();
        document.getElementById('playlistId').value = '';
        document.getElementById('playlistModal').style.display = 'block';
    }

    function showEditModal(id, name, description) {
        document.getElementById('modalTitle').textContent = '编辑歌单';
        document.getElementById('playlistId').value = id;
        document.getElementById('playlistName').value = name;
        document.getElementById('playlistDesc').value = description || '';
        document.getElementById('editCoverGroup').style.display = 'block';
        document.getElementById('playlistModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('playlistModal').style.display = 'none';
        document.getElementById('editCoverGroup').style.display = 'none';
    }

    document.getElementById('playlistForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const playlistId = document.getElementById('playlistId').value;
        const name = document.getElementById('playlistName').value.trim();
        const description = document.getElementById('playlistDesc').value.trim();
        
        if (!name) {
            alert('请输入歌单名称');
            return;
        }
        
        const action = playlistId ? 'update' : 'create';
        const formData = new FormData();
        formData.append('action', action);
        formData.append('name', name);
        formData.append('description', description);
        if (playlistId) {
            formData.append('playlistId', playlistId);
        }
        
        fetch('${pageContext.request.contextPath}/playlists', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                location.reload();
            } else {
                alert(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('操作失败，请重试');
        });
    });

    function deletePlaylist(playlistId) {
        if (!confirm('确定要删除这个歌单吗？')) {
            return;
        }
        
        fetch('${pageContext.request.contextPath}/playlists', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=delete&playlistId=' + playlistId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                location.reload();
            } else {
                alert(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('删除失败，请重试');
        });
    }

    // 点击模态框外部关闭
    window.onclick = function(event) {
        const modal = document.getElementById('playlistModal');
        if (event.target == modal) {
            closeModal();
        }
    }
</script>

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
