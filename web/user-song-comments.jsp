<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${music.title} - 歌曲评论</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global-player.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', sans-serif;
        }

        body {
            background-color: #f1f8e9;
            color: #333;
        }

        /* 导航栏 */
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

        /* 主内容区 */
        .main-content {
            margin-left: 220px;
            padding: 20px 30px 100px;
            min-height: 100vh;
        }

        /* 顶部栏 */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #C8E6C9;
        }

        .back-btn {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }

        .back-btn:hover {
            background-color: #2E7D32;
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

        /* 歌曲信息卡片 */
        .song-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .song-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .song-cover {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #4CAF50, #66BB6A);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 32px;
            margin-right: 20px;
        }

        .song-info h2 {
            color: #2E7D32;
            margin-bottom: 8px;
        }

        .song-meta {
            color: #888;
            font-size: 14px;
        }

        .song-meta span {
            margin-right: 15px;
        }

        /* 评论输入区 */
        .comment-input-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .comment-input-section h3 {
            color: #2E7D32;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .comment-input-section h3::before {
            content: '💬';
            margin-right: 8px;
        }

        .comment-form textarea {
            width: 100%;
            min-height: 100px;
            padding: 12px;
            border: 1px solid #C8E6C9;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
            font-family: 'Microsoft YaHei', sans-serif;
        }

        .comment-form textarea:focus {
            outline: none;
            border-color: #4CAF50;
        }

        .comment-form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
        }

        .char-count {
            color: #888;
            font-size: 14px;
        }

        .submit-btn {
            padding: 10px 30px;
            background-color: #5cb85c;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.3s;
        }

        .submit-btn:hover {
            background-color: #449d44;
            transform: translateY(-1px);
        }

        .submit-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        /* 评论列表 */
        .comments-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .comments-header {
            color: #2E7D32;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #E8F5E9;
            font-size: 18px;
        }

        .comment-item {
            padding: 20px 0;
            border-bottom: 1px solid #E8F5E9;
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-header {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
        }

        .comment-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4CAF50, #66BB6A);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 12px;
        }

        .comment-user-info {
            flex: 1;
        }

        .comment-username {
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }

        .comment-time {
            color: #999;
            font-size: 13px;
        }

        .featured-badge {
            background: linear-gradient(135deg, #5cb85c, #449d44);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }

        .comment-content {
            color: #333;
            line-height: 1.6;
            padding-left: 52px;
        }

        .no-comments {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .no-comments-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        /* 为底部播放器留出空间 */
        .main-content {
            padding-bottom: 120px;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<div class="sidebar">
    <div class="logo">🎵 音悦</div>
    <ul class="nav-menu">
        <li><a href="${pageContext.request.contextPath}/user/music"><i>🏠</i> 首页</a></li>
        <li><a href="${pageContext.request.contextPath}/hot-songs"><i>🔥</i> 热歌榜单</a></li>
        <li><a href="${pageContext.request.contextPath}/favorites"><i>❤️</i> 我的收藏</a></li>
        <li><a href="${pageContext.request.contextPath}/albums"><i>💿</i> 专辑列表</a></li>
        <li><a href="${pageContext.request.contextPath}/playlists"><i>📋</i> 我的歌单</a></li>
    </ul>
</div>

<!-- 主内容区 -->
<div class="main-content">
    <!-- 顶部栏 -->
    <div class="top-bar">
        <a href="javascript:history.back()" class="back-btn">← 返回</a>
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

    <!-- 歌曲信息 -->
    <div class="song-card">
        <div class="song-header">
            <div class="song-cover">♪</div>
            <div class="song-info">
                <h2>${music.title}</h2>
                <div class="song-meta">
                    <span>🎤 歌手: ${music.artist}</span>
                    <span>💿 专辑: ${music.album}</span>
                    <span>⏱ 播放量: <fmt:formatNumber value="${music.playCount}" pattern="#,###"/></span>
                </div>
            </div>
        </div>
    </div>

    <!-- 评论输入区 -->
    <div class="comment-input-section">
        <h3>发表评论</h3>
        <form class="comment-form" id="commentForm">
            <textarea 
                id="commentContent" 
                name="content" 
                placeholder="说说你对这首歌的感受吧..." 
                maxlength="500"
                required></textarea>
            <div class="comment-form-footer">
                <span class="char-count">还可以输入 <span id="charCount">500</span> 字</span>
                <button type="submit" class="submit-btn">发表</button>
            </div>
        </form>
    </div>

    <!-- 评论列表 -->
    <div class="comments-section">
        <div class="comments-header">
            全部评论 (${commentCount})
        </div>
        
        <div id="commentsList">
            <c:choose>
                <c:when test="${empty comments}">
                    <div class="no-comments">
                        <div class="no-comments-icon">💭</div>
                        <p>还没有评论，快来抢沙发吧！</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="comment" items="${comments}">
                        <div class="comment-item">
                            <div class="comment-header">
                                <div class="comment-avatar">${comment.username.charAt(0)}</div>
                                <div class="comment-user-info">
                                    <div class="comment-username">${comment.username}</div>
                                    <div class="comment-time">
                                        <fmt:formatDate value="${comment.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                                <c:if test="${comment.isFeatured}">
                                    <span class="featured-badge">✨ 精华评论</span>
                                </c:if>
                            </div>
                            <div class="comment-content">${comment.content}</div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- 引入全局播放器 -->
<jsp:include page="/WEB-INF/includes/player.jsp" />

<script src="${pageContext.request.contextPath}/js/global-player.js"></script>
<script>
    // 字符计数
    const textarea = document.getElementById('commentContent');
    const charCount = document.getElementById('charCount');
    
    textarea.addEventListener('input', function() {
        const remaining = 500 - this.value.length;
        charCount.textContent = remaining;
    });

    // 提交评论
    document.getElementById('commentForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const content = textarea.value.trim();
        if (!content) {
            alert('评论内容不能为空');
            return;
        }
        
        const submitBtn = this.querySelector('.submit-btn');
        submitBtn.disabled = true;
        submitBtn.textContent = '发表中...';
        
        // 发送AJAX请求
        fetch('${pageContext.request.contextPath}/user/add-comment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'musicId=${music.id}&content=' + encodeURIComponent(content)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('评论发表成功！');
                location.reload(); // 刷新页面显示新评论
            } else {
                alert(data.message || '评论发表失败');
                submitBtn.disabled = false;
                submitBtn.textContent = '发表';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('网络错误，请稍后重试');
            submitBtn.disabled = false;
            submitBtn.textContent = '发表';
        });
    });
</script>
</body>
</html>
