<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>搜索结果 - 音悦</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global-player.css">
    <style>
        /* 复用UserMusic.jsp的样式 */
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
            background: linear-gradient(135deg, #6a3093, #4a2080);
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

        .nav-menu li a:hover {
            background-color: rgba(255,255,255,0.1);
            color: white;
            border-left: 4px solid #b399ff;
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
            border-bottom: 1px solid #e0d0ff;
        }

        .search-box {
            position: relative;
            width: 350px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: none;
            border-radius: 20px;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 12px;
            color: #999;
        }

        .search-results {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .results-header {
            margin-bottom: 20px;
            color: #6a3093;
            font-size: 18px;
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
            border-bottom: 1px solid #f0e5ff;
        }

        .song-list td {
            padding: 15px;
            border-bottom: 1px solid #f0e5ff;
            vertical-align: middle;
        }

        .song-list tr:hover {
            background-color: #faf5ff;
        }

        .play-btn, .like-btn {
            background: none;
            border: none;
            color: #6a3093;
            font-size: 18px;
            cursor: pointer;
            margin-left: 10px;
            transition: all 0.3s;
        }

        .play-btn:hover, .like-btn:hover {
            transform: scale(1.2);
        }

        .like-btn.liked {
            color: #ff4d4d;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: #888;
        }

        .back-link {
            color: #6a3093;
            text-decoration: none;
            margin-bottom: 20px;
            display: inline-block;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<div class="sidebar">
    <div class="logo">🎵 音悦</div>
    <ul class="nav-menu">
        <li><a href="${pageContext.request.contextPath}/user/music"><i>🏠</i>首页</a></li>
        <li><a href="${pageContext.request.contextPath}/hot-songs"><i>🔥</i>热歌榜单</a></li>
        <li><a href="${pageContext.request.contextPath}/favorites"><i>❤️</i>我的收藏</a></li>
        <li><a href="${pageContext.request.contextPath}/albums"><i>💿</i>专辑列表</a></li>
        <li><a href="${pageContext.request.contextPath}/playlists"><i>📋</i>我的歌单</a></li>
    </ul>
</div>

<!-- 主内容区 -->
<div class="main-content">
    <!-- 顶部搜索栏 -->
    <div class="top-bar">
        <div class="search-box">
            <i>🔍</i>
            <form action="${pageContext.request.contextPath}/search" method="get" style="display: inline;">
                <input type="text" name="keyword" placeholder="搜索歌曲、歌手或专辑" value="${keyword}">
            </form>
        </div>
    </div>

    <div class="search-results">
        <a href="${pageContext.request.contextPath}/user/music" class="back-link">← 返回首页</a>
        
        <div class="results-header">
            搜索 "${keyword}" 的结果 (${searchResults.size()} 首歌曲)
        </div>

        <c:choose>
            <c:when test="${empty searchResults}">
                <div class="no-results">
                    <p>没有找到相关歌曲</p>
                    <p>试试其他关键词吧</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="song-list">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>歌曲名</th>
                        <th>歌手</th>
                        <th>专辑</th>
                        <th>播放次数</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="song" items="${searchResults}" varStatus="status">
                        <tr data-song-id="${song.id}">
                            <td>${status.index + 1}</td>
                            <td>${song.title}</td>
                            <td>${song.artist}</td>
                            <td>${song.album}</td>
                            <td>${song.playCount}</td>
                            <td>
                                <button class="play-btn" data-song-id="${song.id}" 
                                        data-title="${song.title}" data-artist="${song.artist}">▶</button>
                                <button class="like-btn ${song.favorited ? 'liked' : ''}" 
                                        data-song-id="${song.id}">♥</button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // 播放按钮点击事件
    document.querySelectorAll('.play-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const songId = this.dataset.songId;
            const title = this.dataset.title;
            const artist = this.dataset.artist;
            
            console.log('播放歌曲:', title, '-', artist);
            alert('开始播放: ' + title + ' - ' + artist);
        });
    });

    // 收藏按钮点击事件
    document.querySelectorAll('.like-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const songId = this.dataset.songId;
            const isLiked = this.classList.contains('liked');
            const action = isLiked ? 'remove' : 'add';
            
            fetch('${pageContext.request.contextPath}/favorite', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'songId=' + songId + '&action=' + action
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.classList.toggle('liked');
                    alert(data.message);
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请重试');
            });
        });
    });

    // 搜索表单提交
    document.querySelector('.search-box input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            const form = this.closest('form');
            if (this.value.trim()) {
                form.submit();
            }
        }
    });
</script>

<!-- 引入全局播放器 -->
<jsp:include page="/WEB-INF/includes/player.jsp" />

<script src="${pageContext.request.contextPath}/js/global-player.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 页面级歌曲列表
        const pageSongs = [
            <c:forEach var="song" items="${searchResults}" varStatus="status">
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
        document.querySelectorAll('.play-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const songId = this.dataset.songId;
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
    });
</script>

</body>
</html>