<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>音悦</title>
    <style>
        :root {
            --light-1: hsl(247, 52%, 85%);
            --light-2: hsl(229, 86%, 85%);
            --light-3: hsl(225, 65%, 95%);
            /* 新增字体变量 */
            --c-font: "STZhongsong", "华文中宋", serif;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            overflow: hidden;
            background: var(--light-3);
            font-family: var(--c-font); /* 全局字体设置 */
        }

        #splash {
            position: relative;
            height: 100vh;
            font-family: var(--c-font); /* 覆盖字体 */
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #2F4F4F; /* 深石板灰 */
            font-family: 'Microsoft YaHei', sans-serif;
            box-shadow: inset 0 0 100px rgba(135, 206, 235, 0.3);
        }

        .splash-content {
            text-align: center;
            animation: float 3s ease-in-out infinite;
        }

        h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(143, 188, 214, 0.5);
            background: linear-gradient(45deg,
            var(--light-2),
            var(--light-1));
            -webkit-background-clip: text;
            color: transparent;
            /* 增强字体渲染 */
            font-weight: 500;
            letter-spacing: 1.5px;
        }

        .loading-text {
            font-size: 1.2rem;
            margin-bottom: 30px;
            color: var(--light-2);
            text-shadow: 0 0 10px rgba(176, 224, 230, 0.5);
            /* 调整字重 */
            font-weight: 400;
        }

        .skip-btn {
            font-family: var(--c-font);
            font-weight: 500;
            padding: 12px 30px;
            background: linear-gradient(135deg,
            var(--light-1) 0%,
            var(--light-2) 100%);
            border: 2px solid var(--light-3);
            border-radius: 30px;
            color: #FFFFFF;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .skip-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 25px rgba(176, 224, 230, 0.4);
            background: linear-gradient(135deg,
            var(--light-2) 0%,
            var(--light-1) 100%);
        }

        .skip-btn::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg,
            transparent,
            rgba(224, 255, 255, 0.3),
            transparent);
            transform: rotate(45deg);
            animation: btnGlow 3s infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes btnGlow {
            0% { left: -50%; }
            100% { left: 150%; }
        }
    </style>
    <style>
        .particles {
            position: fixed;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
            overflow: hidden;
            background: linear-gradient(to bottom,
            rgba(16, 16, 64, 0.2) 0%,
            transparent 100%);
        }

        .particle {
            position: absolute;
            background: white;
            border-radius: 50%;
            animation: starTwinkle 3s infinite;
            will-change: transform, opacity;
        }

        /* 不同大小的星星 */
        .particle.small {
            width: 1px;
            height: 1px;
            box-shadow: 0 0 10px 1px rgba(25,205,225,0.4);
        }
        .particle.medium {
            width: 2px;
            height: 2px;
            box-shadow: 0 0 15px 2px rgba(255,255,255,0.4);
        }
        .particle.large {
            width: 3px;
            height: 3px;
            box-shadow: 0 0 20px 3px rgba(255,255,255,0.5);
        }

        @keyframes starTwinkle {
            0%, 100% {
                opacity: 0.3;
                transform: scale(0.8);
            }
            50% {
                opacity: 1;
                transform: scale(1.2);
            }
        }

        @keyframes starDrift {
            0% { transform: translate(0, 0); }
            100% { transform: translate(100px, 50px); }
        }
    </style>
    <div class="particles">
        <%
            // 生成300个粒子
            for(int i=0; i<300; i++){
                String[] sizes = {"small", "medium", "medium", "large"}; // 大小分布概率
                String size = sizes[(int)(Math.random()*sizes.length)];
        %>
        <div class="particle <%= size %>"
             style="left: <%= Math.random()*100 %>%;
                     top: <%= Math.random()*100 %>%;
                     animation-delay: <%= Math.random()*5 %>s;
                     animation-duration: <%= 2 + Math.random()*3 %>s;
                     <%= (i%5==0) ? "animation-name: starTwinkle, starDrift;" : "" %>">
        </div>
        <% } %>
    </div>
    <div class="particles">
        <% for(int i=0; i<100; i++){ %>
        <div class="particle"
             style="left: <%= Math.random()*100 %>%;
                     top: <%= Math.random()*100 + 50 %>%;
                     animation-delay: <%= Math.random()*5 %>s;
                     animation-duration: <%= 3 + Math.random()*5 %>s;">
        </div>
        <% } %>
    </div>
</head>
<body>
<div id="splash">
    <div class="splash-content">
        <h1>音悦</h1>
        <p class="loading-text">音乐随心，自在聆听</p>
        <button class="skip-btn" onclick="skipSplash()">
            <span style="position: relative; z-index: 1">立即体验</span>
        </button>
    </div>
</div>

<script>
    let timer = setTimeout(redirectToMain, 5000);

    function redirectToMain() {
        window.location.href = "index.jsp";
    }

    function skipSplash() {
        clearTimeout(timer);
        redirectToMain();
    }
</script>
</body>
</html>

