<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>我的收藏 - 音悦</title>
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
                        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
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
                        background-color: rgba(255, 255, 255, 0.1);
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
                        padding: 20px 30px 120px;
                        min-height: 100vh;
                    }

                    /* 顶部横幅图片 */
                    .banner-image {
                        width: 100%;
                        height: 200px;
                        object-fit: cover;
                        border-radius: 10px;
                        margin-bottom: 20px;
                        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
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

                    .logout-btn {
                        margin-left: 15px;
                        padding: 8px 15px;
                        background-color: #C8E6C9;
                        border: none;
                        border-radius: 15px;
                        cursor: pointer;
                        color: #2E7D32;
                        text-decoration: none;
                    }

                    .section-title {
                        color: #2E7D32;
                        font-size: 22px;
                        font-weight: bold;
                        margin-bottom: 20px;
                    }

                    .hot-songs {
                        background-color: white;
                        border-radius: 10px;
                        padding: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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

                    .song-actions {
                        /* 移除 text-align: right; 使图标左对齐 */
                    }

                    .play-btn,
                    .like-btn,
                    .comment-btn,
                    .playlist-btn {
                        background: none;
                        border: none;
                        color: #4CAF50;
                        font-size: 18px;
                        cursor: pointer;
                        margin-left: 10px;
                        transition: all 0.3s;
                    }

                    .play-btn:hover,
                    .like-btn:hover,
                    .comment-btn:hover,
                    .playlist-btn:hover {
                        transform: scale(1.2);
                    }

                    .like-btn.liked {
                        color: #ff4d4d;
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

                    .empty-message {
                        text-align: center;
                        padding: 50px;
                        color: #999;
                        font-size: 16px;
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
                        max-width: 400px;
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

                    .playlist-list {
                        max-height: 300px;
                        overflow-y: auto;
                        margin: 20px 0;
                    }

                    .playlist-item {
                        padding: 12px;
                        border: 1px solid #C8E6C9;
                        border-radius: 5px;
                        margin-bottom: 10px;
                        cursor: pointer;
                        transition: all 0.3s;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .playlist-item:hover {
                        background-color: #E8F5E9;
                        border-color: #4CAF50;
                    }

                    .playlist-item-name {
                        font-weight: bold;
                        color: #2E7D32;
                    }

                    .playlist-item-count {
                        color: #888;
                        font-size: 12px;
                    }

                    .create-new-playlist {
                        padding: 12px;
                        background-color: #4CAF50;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        width: 100%;
                        cursor: pointer;
                        font-size: 14px;
                        transition: all 0.3s;
                    }

                    .create-new-playlist:hover {
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
                        <li><a href="${pageContext.request.contextPath}/favorites" class="active"><i>❤️</i>我的收藏</a></li>
                        <li><a href="${pageContext.request.contextPath}/albums"><i>💿</i>专辑列表</a></li>
                        <li><a href="${pageContext.request.contextPath}/playlists"><i>📋</i>我的歌单</a></li>
                    </ul>
                </div>

                <div class="main-content">
                    <div class="top-bar">
                        <form class="search-box" method="get" action="${pageContext.request.contextPath}/favorites">
                            <input type="text" name="keyword" placeholder="搜索音乐" value="${keyword}">
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

                    <!-- 顶部横幅图片 -->
                    <img src="${pageContext.request.contextPath}/images/favorites.png" alt="收藏横幅" class="banner-image">

                    <h2 class="section-title">我的收藏</h2>

                    <div class="hot-songs">
                        <c:choose>
                            <c:when test="${empty favoritesList}">
                                <div class="empty-message">
                                    <p>暂无收藏的音乐</p>
                                    <p style="margin-top: 10px; font-size: 14px;">快去<a
                                            href="${pageContext.request.contextPath}/hot-songs"
                                            style="color: #4CAF50;">热歌榜单</a>收藏喜欢的歌曲吧！</p>
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
                                        <c:forEach var="song" items="${favoritesList}" varStatus="status">
                                            <tr data-song-id="${song.id}">
                                                <td class="song-number">${status.index + 1}</td>
                                                <td>
                                                    <div class="song-title">${song.title}</div>
                                                    <div class="song-artist">${song.artist}</div>
                                                </td>
                                                <td class="song-actions">
                                                    <button class="play-btn" data-song-id="${song.id}">▶</button>
                                                    <button class="like-btn liked" data-song-id="${song.id}">♥</button>
                                                    <a href="${pageContext.request.contextPath}/user/song-comments?musicId=${song.id}"
                                                        class="comment-btn" title="查看评论">
                                                        💬<span class="comment-count">${song.commentCount}</span>
                                                    </a>
                                                    <button class="playlist-btn" data-song-id="${song.id}" title="添加到歌单">📋</button>
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

                <!-- 添加到歌单弹窗 -->
                <div id="playlistModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closePlaylistModal()">&times;</span>
                        <h2 style="color: #2E7D32; margin-bottom: 20px;">添加到歌单</h2>
                        <div class="playlist-list" id="playlistList">
                            <p style="text-align: center; color: #999;">加载中...</p>
                        </div>
                        <button class="create-new-playlist" onclick="createAndAddToPlaylist()">+ 创建新歌单并添加</button>
                    </div>
                </div>

                <script>
                    let currentSongIdForPlaylist = null;

                    function showPlaylistModal(songId) {
                        currentSongIdForPlaylist = songId;
                        document.getElementById('playlistModal').style.display = 'block';
                        loadUserPlaylists();
                    }

                    function closePlaylistModal() {
                        document.getElementById('playlistModal').style.display = 'none';
                        currentSongIdForPlaylist = null;
                    }

                    function loadUserPlaylists() {
                        fetch('${pageContext.request.contextPath}/playlists', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'action=getUserPlaylists'
                        })
                        .then(response => response.json())
                        .then(data => {
                            const playlistList = document.getElementById('playlistList');
                            if (data.success && data.playlists.length > 0) {
                                playlistList.innerHTML = '';
                                data.playlists.forEach(playlist => {
                                    const item = document.createElement('div');
                                    item.className = 'playlist-item';
                                    item.onclick = () => addToPlaylist(playlist.id);
                                    item.innerHTML = '<div>' +
                                        '<div class="playlist-item-name">' + playlist.name + '</div>' +
                                        '<div class="playlist-item-count">' + playlist.songCount + ' 首歌曲</div>' +
                                        '</div>' +
                                        '<span>→</span>';
                                    playlistList.appendChild(item);
                                });
                            } else {
                                playlistList.innerHTML = '<p style="text-align: center; color: #999;">还没有歌单，创建一个吧！</p>';
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            document.getElementById('playlistList').innerHTML = '<p style="text-align: center; color: #f00;">加载失败</p>';
                        });
                    }

                    function addToPlaylist(playlistId) {
                        if (!currentSongIdForPlaylist) return;

                        fetch('${pageContext.request.contextPath}/playlists', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'action=addSong&playlistId=' + playlistId + '&songId=' + currentSongIdForPlaylist
                        })
                        .then(response => response.json())
                        .then(data => {
                            alert(data.message);
                            if (data.success) {
                                closePlaylistModal();
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('添加失败，请重试');
                        });
                    }

                    function createAndAddToPlaylist() {
                        const playlistName = prompt('请输入新歌单名称：');
                        if (!playlistName || !playlistName.trim()) {
                            return;
                        }

                        fetch('${pageContext.request.contextPath}/playlists', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'action=create&name=' + encodeURIComponent(playlistName.trim()) + '&description='
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                addToPlaylist(data.playlistId);
                            } else {
                                alert(data.message);
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('创建失败，请重试');
                        });
                    }
                </script>

                <script src="${pageContext.request.contextPath}/js/global-player.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // 页面级歌曲列表
                        const pageSongs = [
                            <c:forEach var="song" items="${favoritesList}" varStatus="status">
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
                            btn.addEventListener('click', function () {
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

                        // 添加到歌单按钮
                        document.querySelectorAll('.playlist-btn').forEach(btn => {
                            btn.addEventListener('click', function() {
                                const songId = this.getAttribute('data-song-id');
                                showPlaylistModal(songId);
                            });
                        });

                        // 收藏按钮事件
                        document.querySelectorAll('.like-btn').forEach(btn => {
                            btn.addEventListener('click', function () {
                                const songId = this.getAttribute('data-song-id');
                                toggleFavorite(songId, this);
                            });
                        });
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
                                    if (action === 'remove') {
                                        // 从列表中移除该行
                                        const row = btn.closest('tr');
                                        row.remove();

                                        // 如果列表为空，显示空消息
                                        if (document.querySelectorAll('.song-list tbody tr').length === 0) {
                                            location.reload();
                                        }
                                    } else {
                                        btn.classList.add('liked');
                                    }
                                } else {
                                    alert('操作失败：' + data.message);
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('操作失败，请重试');
                            });
                    }
                </script>
                
                <!-- 分页组件 -->
                <jsp:include page="/WEB-INF/includes/pagination.jsp" />
                
            </body>
            </html>