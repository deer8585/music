<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑歌曲信息</title>
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
            width: 500px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(102, 51, 153, 0.1);
            border: 1px solid #e0d0ff;
        }

        h2 {
            color: #6a3093;
            text-align: center;
            margin-bottom: 20px;
        }

        .error {
            color: #d9534f;
            background-color: rgba(217, 83, 79, 0.1);
            padding: 8px;
            border-radius: 4px;
            margin-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 12px;
            border: 1px solid #e0d0ff;
        }

        tr:nth-child(even) {
            background-color: #f9f5ff;
        }

        input[type="text"],
        input[type="number"],
        input[type="file"] {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            background-color: #fff;
            border: 1px solid #c9b0ff;
            color: #333;
            border-radius: 4px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
            transition: all 0.3s ease;
        }

        .btn-submit {
            background-color: #6a3093;
            color: #fff;
            width: calc(50% - 10px);
        }

        .btn-submit:hover {
            background-color: #8e44ad;
        }

        .btn-cancel {
            background-color: #6c757d;
            color: #fff;
            width: calc(50% - 10px);
        }

        .btn-cancel:hover {
            background-color: #5a6268;
        }

        .button-group {
            text-align: center;
        }

        .current-file {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>编辑歌曲信息</h2>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <form action="MusicServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${music.id}">
            
            <table>
                <tr>
                    <td>歌曲名称：</td>
                    <td><input type="text" name="title" value="${music.title}" required></td>
                </tr>
                <tr>
                    <td>歌手：</td>
                    <td><input type="text" name="artist" value="${music.artist}" required></td>
                </tr>
                <tr>
                    <td>专辑：</td>
                    <td><input type="text" name="album" value="${music.album}"></td>
                </tr>
                <tr>
                    <td>时长（秒）：</td>
                    <td>
                        <input type="number" name="duration" value="${music.duration}">
                        <small style="color: #888;">上传新MP3文件时自动解析</small>
                    </td>
                </tr>
                <tr>
                    <td>音乐文件：</td>
                    <td>
                        <input type="file" name="musicFile" accept=".mp3">
                        <c:if test="${not empty music.path}">
                            <div class="current-file">当前文件: ${music.path}</div>
                        </c:if>
                        <small style="color: #888;">上传新文件将自动更新时长</small>
                    </td>
                </tr>
                <tr>
                    <td>封面图片：</td>
                    <td>
                        <input type="file" name="coverFile" accept=".png,.jpg,.jpeg">
                        <c:if test="${not empty music.coverPath}">
                            <div class="current-file">当前封面: ${music.coverPath}</div>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="button-group">
                        <button type="submit" class="btn btn-submit">更新</button>
                        <a href="MusicServlet?action=manage" class="btn btn-cancel">取消</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>