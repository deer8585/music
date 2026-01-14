<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%
    // 处理注册请求
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        String role = "user"; // 固定为user角色
        String avatar = "images/avatar.png"; // 默认头像路径
        String created_at = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); // 当前系统时间

        // 数据库连接信息
        String dbUrl = "jdbc:mysql://localhost:3306/music0";
        String dbUser = "root";
        String dbPass = "1234";

        Connection conn = null;
        PreparedStatement stmt = null;
        String errorMsg = null;
        boolean success = false;

        // 检查密码是否匹配
        if (!password.equals(confirmPassword)) {
            errorMsg = "两次输入的密码不一致";
        } else {
            try {
                // 加载驱动
                Class.forName("com.mysql.cj.jdbc.Driver");

                // 建立连接
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

                // 检查用户名是否已存在 - 修改为查询users表
                String checkSql = "SELECT * FROM users WHERE username = ?";
                stmt = conn.prepareStatement(checkSql);
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    errorMsg = "用户名已被使用，请选择其他用户名";
                } else {
                    // 准备插入语句 - 修改为插入到users表，包含所有字段
                    String insertSql = "INSERT INTO users (username, password_hash, role, avatar, created_at) VALUES (?, ?, ?, ?, ?)";
                    stmt = conn.prepareStatement(insertSql);
                    stmt.setString(1, username);
                    stmt.setString(2, password); // 注意：实际应用中应该存储密码哈希而非明文
                    stmt.setString(3, role);
                    stmt.setString(4, avatar);
                    stmt.setString(5, created_at);

                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        success = true;
                    } else {
                        errorMsg = "注册失败，请稍后再试";
                    }
                }
            } catch (Exception e) {
                errorMsg = "系统错误: " + e.getMessage();
            } finally {
                // 关闭资源
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }

        if (success) {
            // 注册成功，设置属性以便显示成功消息
            request.setAttribute("successMsg", "注册成功！即将跳转到登录页面...");
            // 设置自动跳转
            response.setHeader("Refresh", "3;url=login.jsp");
        } else {
            // 保存错误信息到request中
            request.setAttribute("errorMsg", errorMsg);
        }
    }
%>
            <!DOCTYPE html>
            <html lang="zh-CN">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>用户注册 - 音悦</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    :root {
                        --primary: hsl(122, 39%, 65%);
                        /* 主色调-浅绿 */
                        --secondary: hsl(122, 39%, 75%);
                        /* 辅色-浅绿 */
                        --accent: hsl(122, 39%, 55%);
                        /* 强调色-绿 */
                        --light: hsl(122, 39%, 85%);
                        /* 超浅背景 */
                        --text-dark: hsl(122, 20%, 30%);
                        /* 深色文本 */
                        --text-light: hsl(122, 15%, 50%);
                        /* 浅色文本 */
                        --success: hsl(122, 65%, 70%);
                        /* 成功色 */
                        --error: hsl(0, 65%, 70%);
                        /* 错误色 */
                    }

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                        font-family: "STZhongsong", "华文中宋", "SimSun", "宋体", sans-serif;
                    }

                    body {
                        background: linear-gradient(135deg, #d4f1d4 0%, #e8f5e9 100%);
                        min-height: 100vh;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        position: relative;
                        overflow: hidden;
                        padding: 20px;
                    }

                    /* 音乐音符背景装饰 */
                    .background-pattern {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        z-index: 0;
                        overflow: hidden;
                    }

                    .music-note {
                        position: absolute;
                        color: rgba(102, 187, 106, 0.15);
                        opacity: 0.2;
                        font-size: 2rem;
                        animation: float 15s linear infinite;
                        text-shadow: 0 0 8px rgba(255, 255, 255, 0.5);
                    }

                    @keyframes float {
                        0% {
                            transform: translateY(-100%) rotate(0deg);
                            opacity: 0;
                        }

                        10% {
                            opacity: 0.2;
                        }

                        90% {
                            opacity: 0.2;
                        }

                        100% {
                            transform: translateY(100vh) rotate(360deg);
                            opacity: 0;
                        }
                    }

                    .register-container {
                        background: rgba(255, 255, 255, 0.95);
                        padding: 1.8rem 1.5rem;
                        border-radius: 20px;
                        box-shadow: 0 10px 25px rgba(102, 187, 106, 0.2);
                        text-align: center;
                        position: relative;
                        z-index: 10;
                        max-width: 380px;
                        width: 100%;
                        backdrop-filter: blur(8px);
                        border: 1px solid rgba(255, 255, 255, 0.5);
                        animation: fadeIn 0.6s ease-out forwards;
                        transform: translateY(15px);
                        opacity: 0;
                    }

                    @keyframes fadeIn {
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .logo-container {
                        margin-bottom: 1rem;
                        position: relative;
                        display: inline-block;
                    }

                    .logo {
                        width: 75px;
                        height: 75px;
                        background: linear-gradient(135deg, var(--primary), var(--secondary));
                        border-radius: 50%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        box-shadow: 0 5px 15px rgba(129, 199, 132, 0.4);
                        transition: transform 0.4s ease;
                        position: relative;
                        overflow: hidden;
                    }

                    .logo::before {
                        content: '';
                        position: absolute;
                        width: 150%;
                        height: 150%;
                        background: radial-gradient(circle, rgba(255, 255, 255, 0.4) 0%, transparent 70%);
                        opacity: 0;
                        transition: opacity 0.4s ease;
                    }

                    .logo:hover::before {
                        opacity: 1;
                    }

                    .logo-art {
                        position: relative;
                        width: 45px;
                        height: 45px;
                    }

                    .ear-curve {
                        position: absolute;
                        width: 25px;
                        height: 35px;
                        border: 2.5px solid white;
                        border-radius: 40% 70% 60% 40%;
                        border-right: none;
                        border-bottom: none;
                        transform: rotate(-15deg);
                        top: 4px;
                        left: 0;
                    }

                    .note-stem {
                        position: absolute;
                        width: 2.5px;
                        height: 24px;
                        background: white;
                        border-radius: 2px;
                        transform: rotate(15deg);
                        top: 4px;
                        right: 8px;
                    }

                    .note-head {
                        position: absolute;
                        width: 12px;
                        height: 9px;
                        background: white;
                        border-radius: 6px 0 0 6px;
                        transform: rotate(15deg);
                        top: 18px;
                        right: 12px;
                    }

                    .sound-wave {
                        position: absolute;
                        width: 18px;
                        height: 10px;
                        border: 1.5px solid white;
                        border-radius: 50%;
                        border-top: none;
                        border-left: none;
                        border-right: none;
                        transform: rotate(10deg);
                        bottom: 4px;
                        left: 16px;
                    }

                    .logo-container:hover .logo {
                        transform: scale(1.08) rotate(5deg);
                    }

                    h1 {
                        color: var(--text-dark);
                        font-size: 1.8rem;
                        margin-bottom: 0.3rem;
                        font-weight: 500;
                        letter-spacing: 0.8px;
                        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.05);
                    }

                    .subtitle {
                        color: var(--text-light);
                        font-size: 0.9rem;
                        margin-bottom: 1.2rem;
                        line-height: 1.5;
                        font-weight: 400;
                        max-width: 280px;
                        margin-left: auto;
                        margin-right: auto;
                    }

                    .form-group {
                        margin-bottom: 0.9rem;
                        position: relative;
                        text-align: left;
                    }

                    label {
                        display: block;
                        margin-bottom: 0.4rem;
                        color: var(--text-dark);
                        font-size: 0.9rem;
                        padding-left: 8px;
                        letter-spacing: 0.5px;
                    }

                    input {
                        width: 100%;
                        padding: 0.75rem 0.75rem 0.75rem 2.8rem;
                        border: 2px solid #d5e0f0;
                        border-radius: 14px;
                        font-size: 0.9rem;
                        transition: all 0.3s ease;
                        background-color: rgba(255, 255, 255, 0.85);
                        box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.05);
                        color: var(--text-dark);
                        letter-spacing: 0.5px;
                        outline: none;
                    }

                    input:focus {
                        border-color: var(--accent);
                        box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.2);
                        background-color: white;
                    }

                    .input-icon {
                        position: absolute;
                        left: 1rem;
                        bottom: 0.75rem;
                        color: var(--accent);
                        font-size: 1.1rem;
                        transition: transform 0.3s ease;
                    }

                    input:focus+.input-icon {
                        color: hsl(265, 60%, 60%);
                        transform: scale(1.1);
                    }

                    .register-btn {
                        background: linear-gradient(135deg, var(--primary), var(--secondary));
                        color: white;
                        padding: 0.8rem;
                        width: 100%;
                        border: none;
                        border-radius: 20px;
                        font-size: 1rem;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        box-shadow: 0 5px 12px rgba(102, 187, 106, 0.3);
                        position: relative;
                        overflow: hidden;
                        margin-top: 0.4rem;
                        letter-spacing: 1px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 8px;
                    }

                    .register-btn:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 8px 18px rgba(102, 187, 106, 0.4);
                    }

                    .register-btn:active {
                        transform: translateY(-1px);
                    }

                    .register-btn::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: -100%;
                        width: 100%;
                        height: 100%;
                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
                        transition: 0.5s;
                    }

                    .register-btn:hover::before {
                        left: 100%;
                    }

                    .message-container {
                        min-height: 45px;
                        margin: 0.7rem 0;
                    }

                    .error-message {
                        color: var(--error);
                        text-align: center;
                        font-size: 0.85rem;
                        padding: 0.6rem 1rem;
                        background: rgba(255, 71, 87, 0.1);
                        border-radius: 8px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        letter-spacing: 0.4px;
                        max-width: 90%;
                        animation: fadeIn 0.4s ease-out;
                    }

                    .error-message i {
                        margin-right: 0.5rem;
                        font-size: 0.9rem;
                    }

                    .success-message {
                        color: var(--success);
                        text-align: center;
                        font-size: 0.85rem;
                        padding: 0.6rem 1rem;
                        background: rgba(46, 213, 115, 0.1);
                        border-radius: 8px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        letter-spacing: 0.4px;
                        max-width: 90%;
                        animation: fadeIn 0.4s ease-out;
                    }

                    .success-message i {
                        margin-right: 0.5rem;
                        font-size: 0.9rem;
                    }

                    .footer {
                        text-align: center;
                        margin-top: 1rem;
                        color: var(--text-light);
                        font-size: 0.85rem;
                        letter-spacing: 0.4px;
                        line-height: 1.5;
                    }

                    .footer a {
                        color: var(--accent);
                        text-decoration: none;
                        transition: all 0.3s ease;
                        font-weight: 500;
                        position: relative;
                    }

                    .footer a::after {
                        content: '';
                        position: absolute;
                        bottom: -1px;
                        left: 0;
                        width: 0;
                        height: 1px;
                        background: var(--accent);
                        transition: width 0.3s ease;
                    }

                    .footer a:hover::after {
                        width: 100%;
                    }

                    .terms {
                        display: flex;
                        align-items: center;
                        margin: 0.7rem 0 0.5rem;
                        padding: 0 0.2rem;
                        justify-content: center;
                    }

                    .terms input {
                        width: auto;
                        margin-right: 0.4rem;
                        transform: scale(1.1);
                        cursor: pointer;
                        padding: 0;
                        height: 15px;
                        width: 15px;
                    }

                    .terms label {
                        color: var(--text-light);
                        margin-bottom: 0;
                        font-size: 0.8rem;
                        letter-spacing: 0.3px;
                        cursor: pointer;
                        font-weight: 400;
                        transition: color 0.3s ease;
                    }

                    .terms input:checked+label {
                        color: var(--text-dark);
                    }

                    .database-info {
                        position: absolute;
                        bottom: 0.5rem;
                        right: 0.5rem;
                        background: rgba(123, 104, 238, 0.1);
                        color: #5a4acd;
                        padding: 0.25rem 0.6rem;
                        border-radius: 12px;
                        font-size: 0.7rem;
                        font-family: monospace;
                        letter-spacing: 0.3px;
                        opacity: 0.7;
                    }

                    .form-container {
                        animation: formSlide 0.6s ease-out forwards;
                        opacity: 0;
                        transform: translateY(10px);
                    }

                    @keyframes formSlide {
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    /* 响应式调整 */
                    @media (max-width: 480px) {
                        .register-container {
                            padding: 1.5rem 1.3rem;
                            border-radius: 18px;
                        }

                        h1 {
                            font-size: 1.7rem;
                        }

                        .subtitle {
                            font-size: 0.85rem;
                            margin-bottom: 1rem;
                        }

                        .logo {
                            width: 65px;
                            height: 65px;
                        }

                        .logo-art {
                            width: 38px;
                            height: 38px;
                        }

                        input {
                            padding: 0.7rem 0.7rem 0.7rem 2.5rem;
                            font-size: 0.85rem;
                            border-radius: 12px;
                        }

                        .input-icon {
                            font-size: 1rem;
                            left: 0.9rem;
                            bottom: 0.7rem;
                        }

                        .register-btn {
                            padding: 0.75rem;
                            font-size: 0.95rem;
                        }

                        .terms label {
                            font-size: 0.75rem;
                        }
                    }
                </style>
            </head>

            <body>

                <div class="register-container">
                    <div class="logo-container">
                        <div class="logo">
                            <div class="logo-art">
                                <div class="ear-curve"></div>
                                <div class="note-stem"></div>
                                <div class="note-head"></div>
                                <div class="sound-wave"></div>
                            </div>
                        </div>
                    </div>

                    <h1>用户注册</h1>
                    <p class="subtitle">加入音乐之旅，让心灵在旋律中自由翱翔</p>

                    <div class="form-container">
                        <form method="post">
                            <div class="form-group">
                                <label for="username">用户名：</label>
                                <input type="text" id="username" name="username" required placeholder="请输入您的用户名">
                                <i class="fas fa-user input-icon"></i>
                            </div>

                            <div class="form-group">
                                <label for="password">密码：</label>
                                <input type="password" id="password" name="password" required placeholder="请设置您的密码">
                                <i class="fas fa-lock input-icon"></i>
                            </div>

                            <div class="form-group">
                                <label for="confirm-password">确认密码：</label>
                                <input type="password" id="confirm-password" name="confirm-password" required
                                    placeholder="请再次输入密码">
                                <i class="fas fa-lock input-icon"></i>
                            </div>

                            <div class="terms">
                                <input type="checkbox" id="terms" name="terms" required>
                                <label for="terms">我已阅读并同意<a href="#">服务条款</a>和<a href="#">隐私政策</a></label>
                            </div>

                            <button type="submit" class="register-btn">
                                <i class="fas fa-user-plus"></i> 注册账户
                            </button>

                            <div class="message-container">
                                <% if (request.getAttribute("errorMsg") !=null) { %>
                                    <div class="error-message">
                                        <i class="fas fa-exclamation-circle"></i>
                                        <%= request.getAttribute("errorMsg") %>
                                    </div>
                                    <% } %>

                                        <% if (request.getAttribute("successMsg") !=null) { %>
                                            <div class="success-message">
                                                <i class="fas fa-check-circle"></i>
                                                <%= request.getAttribute("successMsg") %>
                                            </div>
                                            <% } %>
                            </div>
                        </form>
                    </div>

                    <div class="footer">
                        <p>已有账户？<a href="login.jsp">立即登录</a></p>
                        <p>© 音悦 | <a href="#">隐私政策</a> | <a href="#">用户协议</a></p>
                    </div>
                </div>

                <script>
                    // 初始化 - 表单容器动画
                    document.addEventListener('DOMContentLoaded', function () {
                        // 延迟显示表单，增加层次感
                        setTimeout(() => {
                            document.querySelector('.form-container').style.animation = 'formSlide 0.6s ease-out forwards';
                        }, 300);
                    });
                </script>
            </body>

            </html>