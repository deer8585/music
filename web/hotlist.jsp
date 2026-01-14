<%--
  Created by IntelliJ IDEA.
  User: wangshuyu
  Date: 2025/6/1
  Time: 12:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>音乐热榜</title>
    <!-- 引入管理员主题样式 -->
    <link rel="stylesheet" href="css/admin-theme.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f0ff;
            margin: 0;
            padding: 20px;
        }
        .container {
            width: 90%;
            max-width: 1000px;
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
        .header h2 {
            color: #6a3093;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0d0ff;
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
        h2 {
            color: #6a3093;
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0d0ff;
            font-size: 28px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        th {
            background: linear-gradient(135deg, #6a3093, #a044ff);
            color: white;
            font-weight: 600;
            text-shadow: 0 1px 1px rgba(0,0,0,0.2);
            position: sticky;
            top: 0;
        }
        th, td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #e0d0ff;
        }
        tr:nth-child(1) {
            background-color: #fff9e6;
        }
        tr:nth-child(1) td {
            font-weight: bold;
            color: #d4af37;
        }
        tr:nth-child(2) td {
            color: #c0c0c0;
        }
        tr:nth-child(3) td {
            color: #cd7f32;
        }
        tr:nth-child(even):not(:nth-child(1)) {
            background-color: #f9f5ff;
        }
        tr:hover {
            background-color: #f0e5ff;
            transform: translateY(-1px);
            transition: all 0.2s ease;
        }
        /* TOP3数字样式 */
        .rank {
            font-size: 1.2em;
            text-align: center;
            width: 60px;
        }
        .play-count {
            color: #d9534f;
            font-weight: bold;
            animation: countUp 0.8s ease-out forwards;
            opacity: 0;
        }
        @keyframes countUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        tr:nth-child(1) .play-count { animation-delay: 0.2s; }
        tr:nth-child(2) .play-count { animation-delay: 0.4s; }
        tr:nth-child(3) .play-count { animation-delay: 0.6s; }
        tr:nth-child(n+4) .play-count { animation-delay: 0.8s; }
        .music-icon {
            color: #6a3093;
            margin-left: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <a href="${pageContext.request.contextPath}/dashboard.jsp" class="back-btn">← 返回后台</a>
        <h2>🎵 音乐热榜 TOP 10</h2>
    </div>

    <table>
        <thead>
        <tr>
            <th width="10%">排名</th>
            <th width="25%">歌曲名称</th>
            <th width="20%">歌手</th>
            <th width="20%">专辑</th>
            <th width="15%">播放量</th>
            <th width="10%">时长</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="music" items="${hotList}" varStatus="status">
            <tr>
                <td class="rank">
                    <c:choose>
                        <c:when test="${status.index + 1 == 1}">①</c:when>
                        <c:when test="${status.index + 1 == 2}">②</c:when>
                        <c:when test="${status.index + 1 == 3}">③</c:when>
                        <c:otherwise>${status.index + 1}</c:otherwise>
                    </c:choose>
                </td>
                <td>${music.title} <span class="music-icon">♪</span></td>
                <td>${music.artist}</td>
                <td>${music.album}</td>
                <td class="play-count">
                    <fmt:formatNumber value="${music.playCount}" pattern="#,###"/>
                </td>
                <td>${music.duration}秒</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    // 数字增长动画
    document.addEventListener('DOMContentLoaded', function() {
        const playCounts = document.querySelectorAll('.play-count');

        playCounts.forEach(el => {
            const originalText = el.textContent;
            const target = parseInt(originalText.replace(/,/g, ''));
            const duration = 1500;
            const start = Math.floor(target * 0.2); // 从20%开始增长更自然
            const increment = (target - start) / (duration / 16);
            let current = start;

            el.textContent = start.toLocaleString();

            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    clearInterval(timer);
                    current = target;
                    el.textContent = originalText; // 最终显示原始格式化文本
                } else {
                    el.textContent = Math.floor(current).toLocaleString();
                }
            }, 16);
        });
    });
</script>
</body>
</html>