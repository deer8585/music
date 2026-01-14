<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>个人中心 - 音悦</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global-player.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', sans-serif;
        }

        body {
            background-color: #f1f8f4;
            color: #333;
        }

        .sidebar {
            width: 220px;
            height: 100vh;
            background: linear-gradient(135deg, #66BB6A, #4CAF50);
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
            color: #c8e6c9;
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
            padding: 20px 30px 100px;
            min-height: 100vh;
        }

        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .profile-header {
            text-align: center;
            padding-bottom: 30px;
            border-bottom: 1px solid #c8e6c9;
            margin-bottom: 30px;
        }

        .profile-header h2 {
            color: #66BB6A;
            font-size: 24px;
            margin-bottom: 10px;
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
            background-color: #c8e6c9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: #66BB6A;
            font-weight: bold;
            overflow: hidden;
            border: 3px solid #66BB6A;
        }

        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .avatar-upload {
            display: inline-block;
            padding: 8px 20px;
            background-color: #66BB6A;
            color: white;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .avatar-upload:hover {
            background-color: #4CAF50;
        }

        .avatar-upload input[type="file"] {
            display: none;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #66BB6A;
            font-weight: bold;
        }

        .form-group input[type="text"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #c8e6c9;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-group input[type="text"]:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #66BB6A;
            box-shadow: 0 0 5px rgba(102, 187, 106, 0.2);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .form-group input[readonly] {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #c8e6c9;
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
            background-color: #66BB6A;
            color: white;
        }

        .btn-primary:hover {
            background-color: #4CAF50;
        }

        .btn-secondary {
            background-color: #c8e6c9;
            color: #66BB6A;
        }

        .btn-secondary:hover {
            background-color: #a5d6a7;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .alert {
            padding: 12px 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
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

<div class="main-content">
    <div class="profile-container">
        <div class="profile-header">
            <h2>个人中心</h2>
        </div>

        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success">
                个人信息更新成功！
            </div>
        </c:if>

        <c:if test="${param.error == 'true'}">
            <div class="alert alert-error">
                更新失败，请重试！
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/user/profile" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">

            <div class="avatar-section">
                <div class="avatar-preview" id="avatarPreview">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.avatar}">
                            <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}?v=<%= System.currentTimeMillis() %>" alt="头像">
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.user.username.charAt(0)}
                        </c:otherwise>
                    </c:choose>
                </div>
                <label class="avatar-upload">
                    <input type="file" name="avatar" id="avatarInput" accept="image/*">
                    上传头像
                </label>
            </div>

            <div class="form-group">
                <label>用户名</label>
                <input type="text" value="${sessionScope.user.username}" readonly>
            </div>

            <div class="form-group">
                <label>昵称</label>
                <input type="text" name="nickname" value="${sessionScope.user.nickname != null ? sessionScope.user.nickname : sessionScope.user.username}" required>
            </div>

            <div class="form-group">
                <label>性别</label>
                <select name="gender">
                    <option value="">保密</option>
                    <option value="男" ${sessionScope.user.gender == '男' ? 'selected' : ''}>男</option>
                    <option value="女" ${sessionScope.user.gender == '女' ? 'selected' : ''}>女</option>
                </select>
            </div>

            <div class="form-group">
                <label>个性签名</label>
                <textarea name="signature" placeholder="写点什么吧...">${sessionScope.user.signature}</textarea>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">保存修改</button>
                <a href="${pageContext.request.contextPath}/user/music" class="btn btn-secondary">返回首页</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">退出登录</a>
            </div>
        </form>
    </div>
</div>

<script>
    // 头像预览
    document.getElementById('avatarInput').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('avatarPreview');
                preview.innerHTML = '<img src="' + e.target.result + '" alt="头像">';
            };
            reader.readAsDataURL(file);
        }
    });
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
