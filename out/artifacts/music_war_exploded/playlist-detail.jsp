<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${playlist.name} - 我的歌单</title>
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

        .playlist-header {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
        }

        .playlist-cover-large {
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, #C8E6C9, #E8F5E9);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 80px;
            margin-right: 30px;
            overflow: hidden;
        }

        .playlist-cover-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .playlist-details h1 {
            color: #2E7D32;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .playlist-details p {
            color: #888;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .playlist-stats {
            color: #999;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .back-btn {
            display: inline-block;
            padding: 8px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 20px;
            transition: all 0.3s;
        }

        .back-btn:hover {
            background-color: #2E7D32;
        }

        .songs-container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .song-list {
            width: 100%;
            border-collapse: collapse;
        }

        .song-list th {
            text-align: left;
            padding: 12px 15px;
            color: #888;
            font-weight: normal;
            font-size: 14px;
            border-bottom: 1px solid #E8F5E9;
        }

        .song-list td {
            padding: 15px;
            border-bottom: 1px solid #E8F5E9;
            vertical-align: middle;
        }

        .song-list tr:last-child td {
            border-bottom: none;
        }

        .song-list tr:hover {
            background-color: #F1F8E9;
        }

        .song-number {
            color: #999;
            font-size: 16px;
            width: 40px;
        }

        .song-title {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 5px;
            color: #333;
        }

        .song-artist {
            color: #888;
            font-size: 13px;
        }

        .song-duration {
            color: #666;
            font-size: 14px;
        }

        .play-btn, .like-btn, .comment-btn, .remove-btn {
            background: none;
            border: none;
            color: #4CAF50;
            font-size: 18px;
            cursor: pointer;
            margin-left: 10px;
            transition: all 0.3s;
        }

        .play-btn:hover, .like-btn:hover, .comment-btn:hover, .remove-btn:hover {
            transform: scale(1.2);
        }

        .like-btn.liked {
            color: #ff4d4d;
        }

        .remove-btn {
            color: #d32f2f;
        }

        .comment-btn {
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .comment-count {
            font-size: 12px;
            margin-left: 4px;
        }

        .song-list tr.playing {
            background-color: #E8F5E9 !important;
        }

        .song-list tr.playing .song-title {
            color: #2E7D32;
            font-weight: bold;
        }

        #audio-player {
            display: none;
        }

        .empty-message {
            text-align: center;
            padding: 50px;
            color: #999;
            font-size: 16px;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            text-align: center;
            font-size: 16px;
            animation: fadeIn 0.5s;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
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

        .form-group input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #C8E6C9;
            border-radius: 5px;
        }

        .preview-image {
            max-width: 100%;
            max-height: 300px;
            margin-top: 10px;
            border-radius: 5px;
            display: none;
        }

        .form-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
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

    <!-- 成功消息提示 -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="success-message" id="successMessage">
            ✓ ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <div class="playlist-header">
        <div class="playlist-cover-large">
            <c:choose>
                <c:when test="${not empty playlist.coverPath && playlist.coverPath != 'images/avatar.png'}">
                    <img src="${pageContext.request.contextPath}/${playlist.coverPath}" alt="${playlist.name}">
                </c:when>
                <c:otherwise>
                    📋
                </c:otherwise>
            </c:choose>
        </div>
        <div class="playlist-details">
            <h1>${playlist.name}</h1>
            <p>${playlist.description}</p>
            <div class="playlist-stats">🎵 歌曲数: ${playlist.songCount}</div>
            <div style="margin-top: 15px;">
                <button class="back-btn" onclick="showUploadCoverModal()" style="margin-right: 10px; cursor: pointer; border: none;">📷 更换封面</button>
                <a href="${pageContext.request.contextPath}/playlists" class="back-btn">← 返回歌单列表</a>
            </div>
        </div>
    </div>

    <div class="songs-container">
        <c:choose>
            <c:when test="${empty songs}">
                <div class="empty-message">
                    <p>歌单中还没有歌曲</p>
                    <p style="font-size: 14px; margin-top: 10px;">去<a href="${pageContext.request.contextPath}/user/music" style="color: #6a3093;">首页</a>添加喜欢的歌曲吧！</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="song-list">
                    <thead>
                    <tr>
                        <th>序号</th>
                        <th>歌曲信息</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="song" items="${songs}" varStatus="status">
                        <tr data-song-id="${song.id}">
                            <td class="song-number">${status.index + 1}</td>
                            <td>
                                <div class="song-title">${song.title}</div>
                                <div class="song-artist">${song.artist}</div>
                            </td>
                            <td>
                                <button class="play-btn" data-song-id="${song.id}">▶</button>
                                <button class="like-btn" data-song-id="${song.id}">♥</button>
                                <a href="${pageContext.request.contextPath}/user/song-comments?musicId=${song.id}" 
                                   class="comment-btn" title="查看评论">
                                    💬<span class="comment-count">${song.commentCount}</span>
                                </a>
                                <button class="remove-btn" data-song-id="${song.id}" title="从歌单移除">🗑</button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 引入全局播放器 -->
<jsp:include page="/WEB-INF/includes/player.jsp" />

<!-- 上传封面弹窗 -->
<div id="uploadCoverModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeUploadCoverModal()">&times;</span>
        <h2 style="color: #2E7D32; margin-bottom: 20px;">更换歌单封面</h2>
        <form id="uploadCoverForm" action="${pageContext.request.contextPath}/update-playlist-cover" method="post" enctype="multipart/form-data">
            <input type="hidden" name="playlistId" value="${playlist.id}">
            <div class="form-group">
                <label>选择封面图片</label>
                <input type="file" name="cover" id="coverInput" accept="image/png,image/jpeg,image/jpg" required onchange="previewCover(this)">
                <p style="color: #888; font-size: 12px; margin-top: 5px;">支持PNG、JPG格式，建议尺寸：500x500像素</p>
                <img id="coverPreview" class="preview-image" alt="封面预览">
            </div>
            <div class="form-buttons">
                <button type="button" class="btn-cancel" onclick="closeUploadCoverModal()">取消</button>
                <button type="submit" class="btn-submit">上传</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showUploadCoverModal() {
        document.getElementById('uploadCoverModal').style.display = 'block';
    }

    function closeUploadCoverModal() {
        document.getElementById('uploadCoverModal').style.display = 'none';
        document.getElementById('uploadCoverForm').reset();
        document.getElementById('coverPreview').style.display = 'none';
    }

    function previewCover(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('coverPreview');
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 点击模态框外部关闭
    window.onclick = function(event) {
        const modal = document.getElementById('uploadCoverModal');
        if (event.target == modal) {
            closeUploadCoverModal();
        }
    }

    // 自动隐藏成功消息
    window.addEventListener('DOMContentLoaded', function() {
        const successMessage = document.getElementById('successMessage');
        if (successMessage) {
            setTimeout(function() {
                successMessage.style.transition = 'opacity 0.5s';
                successMessage.style.opacity = '0';
                setTimeout(function() {
                    successMessage.remove();
                }, 500);
            }, 3000); // 3秒后开始淡出
        }
    });
</script>

<script src="${pageContext.request.contextPath}/js/global-player.js"></script>
<script>
    const playlistId = ${playlist.id};

    document.addEventListener('DOMContentLoaded', function() {
        // 页面级歌曲列表
        const pageSongs = [
            <c:forEach var="song" items="${songs}" varStatus="status">
            {
                id: ${song.id},
                title: '${song.title}',
                artist: '${song.artist}',
                album: '${song.album}',
                duration: ${song.duration},
                path: '${pageContext.request.contextPath}/${song.path}'
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // 播放按钮点击事件 - 点击时才设置歌曲列表并播放
        document.querySelectorAll('.play-btn').forEach((btn) => {
            btn.addEventListener('click', function() {
                const songId = this.getAttribute('data-song-id');
                const currentSong = GlobalPlayer.getCurrentSong();
                
                if (currentSong && currentSong.id == songId) {
                    const playPauseBtn = document.querySelector('.play-pause-btn');
                    if (playPauseBtn) playPauseBtn.click();
                } else {
                    GlobalPlayer.setSongs(pageSongs);
                    GlobalPlayer.playSongById(songId);
                }
            });
        });

        // 收藏按钮
        document.querySelectorAll('.like-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const songId = this.getAttribute('data-song-id');
                toggleFavorite(songId, this);
            });
        });

        // 移除按钮
        document.querySelectorAll('.remove-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const songId = this.getAttribute('data-song-id');
                removeSongFromPlaylist(songId, this);
            });
        });

        // 检查收藏状态
        checkFavoriteStatus();
    });

    function toggleFavorite(songId, btn) {
        const isLiked = btn.classList.contains('liked');
        const action = isLiked ? 'remove' : 'add';

        fetch('${pageContext.request.contextPath}/favorites', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=' + action + '&songId=' + songId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                btn.classList.toggle('liked');
            } else {
                alert(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('操作失败，请重试');
        });
    }

    function removeSongFromPlaylist(songId, btn) {
        if (!confirm('确定要从歌单中移除这首歌吗？')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/playlists', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=removeSong&playlistId=' + playlistId + '&songId=' + songId
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
    }

    function checkFavoriteStatus() {
        document.querySelectorAll('.like-btn').forEach(btn => {
            const songId = btn.getAttribute('data-song-id');
            fetch('${pageContext.request.contextPath}/check-favorite?songId=' + songId)
                .then(response => response.json())
                .then(data => {
                    if (data.isFavorite) {
                        btn.classList.add('liked');
                    }
                })
                .catch(error => console.error('Error:', error));
        });
    }
</script>

<!-- 分页组件 -->
<jsp:include page="/WEB-INF/includes/pagination.jsp" />

</body>
</html>
