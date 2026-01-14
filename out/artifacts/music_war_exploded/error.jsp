<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>错误 - 音悦</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', sans-serif;
            background-color: #f8f5fe;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .error-container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .error-title {
            color: #6a3093;
            font-size: 24px;
            margin-bottom: 20px;
        }
        .error-message {
            color: #666;
            margin-bottom: 30px;
        }
        .back-btn {
            background: #6a3093;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-title">出错了</div>
        <div class="error-message">${error}</div>
        <a href="${pageContext.request.contextPath}/user/music" class="back-btn">返回首页</a>
    </div>
</body>
</html>