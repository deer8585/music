<%@ page import="java.sql.*" %>
    <%@ page import="entity.User" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    // 处理登录请求
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String errorMsg = null;
        boolean loginSuccess = false;

        // 数据库连接信息
        String dbUrl = "jdbc:mysql://localhost:3306/music0";
        String dbUser = "root";
        String dbPass = "1234";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 建立连接
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            // 准备SQL查询 - 只查询用户名和角色
            String sql = "SELECT * FROM users WHERE username = ? AND role = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, role);

            // 执行查询
            rs = stmt.executeQuery();

            if (rs.next()) {
                // 获取数据库中的密码哈希
                String storedHash = rs.getString("password_hash");

                if (storedHash.equals(password)) {
                    // 登录成功
                    User user = new User();
                    user.setId(rs.getLong("id"));
                    user.setUsername(username);
                    user.setRole(role);
                    user.setAvatar(rs.getString("avatar"));
                    user.setNickname(rs.getString("nickname"));
                    user.setGender(rs.getString("gender"));
                    user.setSignature(rs.getString("signature"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));

                    // 将User对象存入session
                    session.setAttribute("user", user);
                    loginSuccess = true;

                    // 根据角色重定向
                    if ("admin".equals(role)) {
                        response.sendRedirect("dashboard.jsp");
                        return;
                    } else {
                        response.sendRedirect("user/music");
                        return;
                    }
                } else {
                    errorMsg = "用户名或密码错误";
                }
            } else {
                errorMsg = "用户名或角色不正确";
            }
        } catch (Exception e) {
            errorMsg = "系统错误: " + e.getMessage();
        } finally {
            // 关闭资源
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {}

            try {
                if (stmt != null) stmt.close();
            } catch (Exception e) {}

            try {
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }

        // 保存错误信息到request中
        request.setAttribute("errorMsg", errorMsg);
        request.setAttribute("loginRole", role);
    }
%>
                <!DOCTYPE html>
                <html lang="zh-CN">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>音悦</title>
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <style>
                        /* 添加华文中宋字体 */
                        @font-face {
                            font-family: 'STZhongsong';
                            src: local('STZhongsong'), local('华文中宋');
                        }

                        :root {
                            --primary: #66BB6A;
                            /* 主色调：浅绿色 */
                            --primary-light: #E8F5E9;
                            /* 浅绿色背景 */
                            --primary-dark: #4CAF50;
                            /* 深绿色 */
                            --secondary: #81C784;
                            /* 次要绿色 */
                            --secondary-light: #F1F8E9;
                            /* 次要浅绿色背景 */
                            --accent: #43A047;
                            /* 强调色 */
                            --success: #69A1A0;
                            /* 成功色 */
                            --text: #333333;
                            /* 主要文本 */
                            --text-light: #666666;
                            /* 次要文本 */
                            --background: #FAFAFA;
                            /* 背景色 */
                            --card-bg: #FFFFFF;
                            /* 卡片背景 */
                            --shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                            /* 阴影 */
                            --shadow-deep: 0 15px 35px rgba(0, 0, 0, 0.12);
                            /* 深阴影 */
                        }

                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                            font-family: 'STZhongsong', '华文中宋', 'SimSun', '宋体', sans-serif;
                        }

                        body {
                            background: url('images/userlogin.jpg') no-repeat center center fixed;
                            background-size: cover;
                            min-height: 100vh;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            padding: 20px;
                            color: var(--text);
                            overflow-x: hidden;
                            position: relative;
                        }
                        
                        /* 添加40%透明度的浅绿色渐变遮罩 */
                        body::before {
                            content: '';
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: linear-gradient(135deg, 
                                        rgba(200, 230, 201, 0.4), 
                                        rgba(255, 255, 255, 0.4));
                            z-index: 0;
                            pointer-events: none;
                        }

                        .login-container {
                            background: rgba(255, 255, 255, 0.92);
                            padding: 48px;
                            border-radius: 24px;
                            box-shadow: 0 8px 32px rgba(129, 199, 132, 0.4);
                            width: 500px;
                            max-width: 100%;
                            position: relative;
                            overflow: hidden;
                            transition: transform 0.3s ease, box-shadow 0.3s ease;
                            border: 1px solid rgba(129, 199, 132, 0.3);
                            z-index: 10;
                            backdrop-filter: blur(12px);
                            -webkit-backdrop-filter: blur(12px);
                        }

                        .login-container:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
                        }

                        .login-container::before {
                            content: '';
                            position: absolute;
                            top: -50%;
                            left: -50%;
                            width: 200%;
                            height: 200%;
                            background: radial-gradient(circle, rgba(102, 187, 106, 0.05) 0%, transparent 70%);
                            z-index: -1;
                            animation: rotate 60s linear infinite;
                        }

                        @keyframes rotate {
                            0% {
                                transform: rotate(0deg);
                            }

                            100% {
                                transform: rotate(360deg);
                            }
                        }

                        .login-header {
                            text-align: center;
                            margin-bottom: 32px;
                            position: relative;
                            z-index: 2;
                        }

                        .login-icon {
                            font-size: 3.5rem;
                            margin-bottom: 20px;
                            display: inline-block;
                            width: 120px;
                            height: 120px;
                            line-height: 100px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, var(--primary-light) 0%, var(--secondary-light) 100%);
                            box-shadow: 0 8px 25px rgba(102, 187, 106, 0.15);
                            transition: all 0.3s ease;
                            color: var(--primary);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto 16px;
                            /* 水平居中并添加底部边距 */
                        }

                        .login-icon:hover {
                            transform: scale(1.1) rotate(5deg);
                            box-shadow: 0 12px 30px rgba(102, 187, 106, 0.25);
                        }

                        .user-icon {
                            background: linear-gradient(135deg, var(--primary), var(--secondary));
                            color: white;
                        }

                        .admin-icon {
                            background: linear-gradient(135deg, var(--accent), var(--primary));
                            color: white;
                        }

                        h2 {
                            color: var(--primary);
                            font-size: 2rem;
                            margin-bottom: 8px;
                            font-weight: 600;
                            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.05);
                        }

                        .role-description {
                            color: var(--text-light);
                            font-size: 1rem;
                            margin-top: 4px;
                            font-weight: 400;
                        }

                        .form-group {
                            margin-bottom: 28px;
                            position: relative;
                        }

                        label {
                            display: block;
                            margin-bottom: 12px;
                            color: var(--primary);
                            font-weight: 500;
                            font-size: 0.95rem;
                            transition: color 0.3s ease;
                        }

                        input {
                            width: 100%;
                            padding: 18px 18px 18px 52px;
                            border: 2px solid #E0E0E0;
                            border-radius: 12px;
                            font-size: 1rem;
                            transition: all 0.3s ease;
                            background-color: rgba(255, 255, 255, 0.95);
                            box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.04);
                            font-weight: 400;
                        }

                        input:focus {
                            border-color: var(--primary);
                            box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.15), 0 4px 12px rgba(0, 0, 0, 0.08);
                            outline: none;
                            background-color: white;
                        }

                        .input-icon {
                            position: absolute;
                            left: 18px;
                            bottom: 18px;
                            color: var(--primary);
                            font-size: 20px;
                            transition: color 0.3s ease;
                        }

                        input:focus+.input-icon {
                            color: var(--primary-dark);
                        }

                        .login-btn {
                            background: var(--secondary);
                            /* 使用更浅的蓝紫色 */
                            color: white;
                            padding: 18px;
                            width: 100%;
                            border: none;
                            border-radius: 12px;
                            font-size: 1rem;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.3s ease;
                            box-shadow: 0 6px 18px rgba(102, 187, 106, 0.25);
                            position: relative;
                            overflow: hidden;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 12px;
                            z-index: 2;
                        }

                        .user-btn {
                            background: var(--secondary);
                            /* 用户按钮使用浅绿色 */
                            box-shadow: 0 6px 18px rgba(129, 199, 132, 0.3);
                        }

                        .login-btn:hover {
                            opacity: 0.95;
                            transform: translateY(-3px);
                            box-shadow: 0 8px 24px rgba(102, 187, 106, 0.35);
                        }

                        .login-btn:active {
                            transform: translateY(-1px);
                            box-shadow: 0 4px 12px rgba(102, 187, 106, 0.25);
                        }

                        .login-btn::after {
                            content: '';
                            position: absolute;
                            top: 50%;
                            left: 50%;
                            width: 5px;
                            height: 5px;
                            background: rgba(255, 255, 255, 0.5);
                            opacity: 0;
                            border-radius: 100%;
                            transform: scale(1, 1) translate(-50%);
                            transform-origin: 50% 50%;
                        }

                        .login-btn:focus::after {
                            animation: ripple 1s ease-out;
                        }

                        @keyframes ripple {
                            0% {
                                transform: scale(0, 0);
                                opacity: 0.5;
                            }

                            100% {
                                transform: scale(20, 20);
                                opacity: 0;
                            }
                        }

                        .error-message {
                            color: var(--accent);
                            text-align: center;
                            margin-top: 16px;
                            font-size: 0.9rem;
                            min-height: 36px;
                            padding: 12px 16px;
                            background: rgba(255, 64, 129, 0.1);
                            border-radius: 10px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 8px;
                            animation: shake 0.5s ease-in-out;
                            display: none;
                            /* 默认隐藏 */
                        }

                        .error-message.show {
                            display: flex;
                        }

                        @keyframes shake {

                            0%,
                            100% {
                                transform: translateX(0);
                            }

                            10%,
                            30%,
                            50%,
                            70%,
                            90% {
                                transform: translateX(-5px);
                            }

                            20%,
                            40%,
                            60%,
                            80% {
                                transform: translateX(5px);
                            }
                        }

                        .success-message {
                            color: var(--success);
                            text-align: center;
                            margin-top: 16px;
                            font-size: 0.9rem;
                            min-height: 36px;
                            padding: 12px 16px;
                            background: rgba(76, 175, 80, 0.1);
                            border-radius: 10px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 8px;
                            display: none;
                            /* 默认隐藏 */
                        }

                        .success-message.show {
                            display: flex;
                        }

                        .error-message i,
                        .success-message i {
                            font-size: 1rem;
                        }

                        .footer {
                            text-align: center;
                            margin-top: 32px;
                            color: var(--text-light);
                            font-size: 0.9rem;
                            width: 100%;
                        }

                        .footer a {
                            color: var(--primary);
                            text-decoration: none;
                            transition: all 0.3s ease;
                            font-weight: 500;
                        }

                        .footer a:hover {
                            color: var(--primary-dark);
                            text-decoration: underline;
                        }

                        /* 切换按钮样式 */
                        .role-toggle {
                            display: flex;
                            background: rgba(200, 230, 201, 0.3);
                            border-radius: 50px;
                            padding: 8px;
                            margin: 0 auto 30px;
                            max-width: 300px;
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                            position: relative;
                            z-index: 2;
                            backdrop-filter: blur(5px);
                        }

                        .role-btn {
                            flex: 1;
                            padding: 14px 20px;
                            border: none;
                            background: transparent;
                            border-radius: 40px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                            position: relative;
                            overflow: hidden;
                            color: var(--text-light);
                            font-size: 0.95rem;
                            z-index: 1;
                        }

                        .role-btn.active {
                            color: white;
                            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
                            box-shadow: 0 4px 15px rgba(102, 187, 106, 0.3);
                        }

                        .role-btn:not(.active):hover {
                            color: var(--primary);
                            background: rgba(102, 187, 106, 0.08);
                        }

                        /* 登录表单切换动画 */
                        .login-section {
                            opacity: 1;
                            transform: translateY(0);
                            transition: opacity 0.4s ease, transform 0.5s ease;
                        }

                        .login-section.hidden {
                            position: absolute;
                            top: 0;
                            left: 0;
                            right: 0;
                            opacity: 0;
                            transform: translateY(20px);
                            pointer-events: none;
                            display: none;
                            /* 确保隐藏的表单不占用空间 */
                        }

                        /* 加载状态动画 */
                        .loading {
                            display: inline-block;
                            width: 24px;
                            height: 24px;
                            border: 3px solid rgba(255, 255, 255, 0.3);
                            border-radius: 50%;
                            border-top-color: white;
                            animation: spin 1s ease-in-out infinite;
                            margin-right: 8px;
                        }

                        @keyframes spin {
                            to {
                                transform: rotate(360deg);
                            }
                        }

                        /* 耳朵音符图标样式 */
                        .logo-art {
                            position: relative;
                            width: 60px;
                            height: 60px;
                            transform: scale(1.1);
                        }

                        .ear-curve {
                            position: absolute;
                            width: 30px;
                            height: 40px;
                            border: 3px solid white;
                            border-radius: 40% 70% 60% 40%;
                            border-right: none;
                            border-bottom: none;
                            transform: rotate(-15deg);
                            top: 10px;
                            left: 5px;
                        }

                        .note-stem {
                            position: absolute;
                            width: 3px;
                            height: 30px;
                            background: white;
                            border-radius: 2px;
                            transform: rotate(15deg);
                            top: 10px;
                            right: 15px;
                        }

                        .note-head {
                            position: absolute;
                            width: 18px;
                            height: 13px;
                            background: white;
                            border-radius: 10px 0 0 10px;
                            transform: rotate(15deg);
                            top: 30px;
                            right: 20px;
                        }

                        @media (max-width: 768px) {
                            .login-container {
                                padding: 32px 24px;
                            }

                            .login-header {
                                margin-bottom: 24px;
                            }

                            .login-icon {
                                width: 80px;
                                height: 80px;
                                line-height: 80px;
                                font-size: 2.5rem;
                            }

                            h2 {
                                font-size: 1.6rem;
                            }

                            .role-toggle {
                                margin: 0 auto 20px;
                                padding: 6px;
                            }

                            .role-btn {
                                padding: 12px 16px;
                                font-size: 0.85rem;
                            }

                            /* 调整图标大小 */
                            .logo-art {
                                width: 50px;
                                height: 50px;
                            }

                            .ear-curve {
                                width: 25px;
                                height: 35px;
                                border-width: 2px;
                                top: 8px;
                                left: 3px;
                            }

                            .note-stem {
                                height: 25px;
                                top: 8px;
                                right: 12px;
                            }

                            .note-head {
                                width: 15px;
                                height: 10px;
                                top: 25px;
                                right: 16px;
                            }
                        }
                    </style>
                </head>

                <body>

                    <div class="login-container">
                        <!-- 登录标题和图标 -->
                        <div class="login-header">
                            <div class="login-icon user-icon" id="roleIcon">
                                <div class="logo-art">
                                    <div class="ear-curve"></div>
                                    <div class="note-stem"></div>
                                    <div class="note-head"></div>
                                </div>
                            </div>
                            <h2 id="roleTitle">用户登录</h2>
                            <p class="role-description" id="roleDescription">开启你的音乐世界</p>
                        </div>

                        <!-- 身份切换按钮 -->
                        <div class="role-toggle">
                            <button class="role-btn active" data-role="user">用户登录</button>
                            <button class="role-btn" data-role="admin">管理员登录</button>
                        </div>

                        <!-- 用户登录表单 -->
                        <div class="login-section" id="userForm">
                            <form method="post" id="userLoginForm">
                                <input type="hidden" name="role" value="user">
                                <div class="form-group">
                                    <label for="user-username">用户名：</label>
                                    <i class="fas fa-user input-icon"></i>
                                    <input type="text" id="user-username" name="username" required placeholder="请输入用户名">
                                </div>
                                <div class="form-group">
                                    <label for="user-password">密码：</label>
                                    <i class="fas fa-lock input-icon"></i>
                                    <input type="password" id="user-password" name="password" required
                                        placeholder="请输入密码">
                                </div>
                                <button type="submit" class="login-btn user-btn" id="userLoginBtn">
                                    <i class="fas fa-sign-in-alt"></i> 开启音乐之旅
                                </button>
                                <% if (request.getAttribute("errorMsg") !=null && "user"
                                    .equals(request.getAttribute("loginRole"))) { %>
                                    <div class="error-message show">
                                        <i class="fas fa-exclamation-circle"></i> ${errorMsg}
                                    </div>
                                    <% } %>
                            </form>
                        </div>

                        <!-- 管理员登录表单 -->
                        <div class="login-section hidden" id="adminForm">
                            <form method="post" id="adminLoginForm">
                                <input type="hidden" name="role" value="admin">
                                <div class="form-group">
                                    <label for="admin-username">管理员账号：</label>
                                    <i class="fas fa-user-cog input-icon"></i>
                                    <input type="text" id="admin-username" name="username" required
                                        placeholder="请输入管理员账号">
                                </div>
                                <div class="form-group">
                                    <label for="admin-password">管理密码：</label>
                                    <i class="fas fa-key input-icon"></i>
                                    <input type="password" id="admin-password" name="password" required
                                        placeholder="请输入密码">
                                </div>
                                <button type="submit" class="login-btn" id="adminLoginBtn">
                                    <i class="fas fa-sign-in-alt"></i> 进入音乐管理中心
                                </button>
                                <% if (request.getAttribute("errorMsg") !=null && "admin"
                                    .equals(request.getAttribute("loginRole"))) { %>
                                    <div class="error-message show">
                                        <i class="fas fa-exclamation-circle"></i> ${errorMsg}
                                    </div>
                                    <% } %>
                            </form>
                        </div>

                        <!-- 用户登录底部 -->
                        <div class="footer" id="userFooter">
                            <p>© 音悦 | <a href="register.jsp">立即注册</a></p>
                        </div>

                        <!-- 管理员登录底部 -->
<%--                        <div class="footer hidden" id="adminFooter">--%>
<%--                            <p>© 音悦</p>--%>
<%--                        </div>--%>
                    </div>

                    <script>
                        // 切换登录身份
                        function switchRole(role) {
                            const userForm = document.getElementById('userForm');
                            const adminForm = document.getElementById('adminForm');
                            const userFooter = document.getElementById('userFooter');
                            const adminFooter = document.getElementById('adminFooter');
                            const roleTitle = document.getElementById('roleTitle');
                            const roleDescription = document.getElementById('roleDescription');
                            const roleIcon = document.getElementById('roleIcon');
                            const userBtn = document.querySelector('.role-btn[data-role="user"]');
                            const adminBtn = document.querySelector('.role-btn[data-role="admin"]');

                            // 更新按钮状态
                            userBtn.classList.toggle('active', role === 'user');
                            adminBtn.classList.toggle('active', role === 'admin');

                            // 更新表单显示
                            if (role === 'user') {
                                userForm.classList.remove('hidden');
                                adminForm.classList.add('hidden');
                                userFooter.classList.remove('hidden');
                                adminFooter.classList.add('hidden');
                                roleTitle.textContent = '用户登录';
                                roleDescription.textContent = '开启你的音乐世界';
                                roleIcon.className = 'login-icon user-icon';
                            } else {
                                userForm.classList.add('hidden');
                                adminForm.classList.remove('hidden');
                                userFooter.classList.add('hidden');
                                adminFooter.classList.remove('hidden');
                                roleTitle.textContent = '管理员登录';
                                roleDescription.textContent = '管理音乐世界';
                                roleIcon.className = 'login-icon admin-icon';
                            }

                            // 添加动画效果
                            roleIcon.style.animation = 'none';
                            setTimeout(() => {
                                roleIcon.style.animation = 'rotate 1s ease';
                            }, 10);
                        }

                        // 初始化
                        document.addEventListener('DOMContentLoaded', () => {
                            // 设置角色切换事件
                            document.querySelectorAll('.role-btn').forEach(btn => {
                                btn.addEventListener('click', () => {
                                    switchRole(btn.dataset.role);
                                });
                            });

                            // 表单提交时显示加载状态
                            document.querySelectorAll('form').forEach(form => {
                                form.addEventListener('submit', function () {
                                    const submitBtn = this.querySelector('button[type="submit"]');
                                    const originalHtml = submitBtn.innerHTML;

                                    submitBtn.disabled = true;
                                    submitBtn.innerHTML = '<span class="loading"></span> 正在登录...';
                                });
                            });
                        });
                    </script>
                </body>

                </html>