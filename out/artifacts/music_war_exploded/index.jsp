<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>音悦</title>
  <style>
    :root {
      --primary: hsl(122, 39%, 65%);  /* 主色调-浅绿 */
      --secondary: hsl(122, 39%, 75%);  /* 辅色-浅绿 */
      --accent: hsl(122, 39%, 55%);     /* 强调色-绿 */
      --light: hsl(122, 39%, 85%);      /* 超浅背景 */
      --text-dark: hsl(122, 20%, 30%);  /* 深色文本 */
      --text-light: hsl(122, 15%, 50%); /* 浅色文本 */
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "STZhongsong", "华文中宋", "SimSun", "宋体", sans-serif;
    }

    body {
      background: linear-gradient(135deg, var(--light), #ffffff);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      position: relative;
      overflow: hidden;
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
      color: var(--primary);
      opacity: 0.2;
      font-size: 3rem;
      animation: float 15s linear infinite;
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

    .auth-container {
      background: rgba(245, 255, 255, 0.95);
      padding: 4rem 3rem;
      border-radius: 24px;
      box-shadow: 0 15px 30px rgba(129, 199, 132, 0.3);
      text-align: center;
      transform: translateY(20px);
      opacity: 0;
      animation: fadeIn 0.8s ease-out forwards;
      position: relative;
      z-index: 10;
      max-width: 400px;
      width: 90%;
    }

    @keyframes fadeIn {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .logo-container {
      margin-bottom: 2.5rem;
      position: relative;
      display: inline-block;
    }

    .logo {
      width: 120px;
      height: 120px;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      box-shadow: 0 8px 25px rgba(129, 199, 132, 0.5);
      transition: transform 0.3s ease;
      position: relative;
    }

    .logo-art {
      position: relative;
      width: 80px;
      height: 80px;
    }

    .ear-curve {
      position: absolute;
      width: 45px;
      height: 60px;
      border: 4px solid white;
      border-radius: 40% 70% 60% 40%;
      border-right: none;
      border-bottom: none;
      transform: rotate(-15deg);
      top: 10px;
      left: 0;
    }

    .note-stem {
      position: absolute;
      width: 4px;
      height: 45px;
      background: white;
      border-radius: 2px;
      transform: rotate(15deg);
      top: 10px;
      right: 18px;
    }

    .note-head {
      position: absolute;
      width: 22px;
      height: 16px;
      background: white;
      border-radius: 10px 0 0 10px;
      transform: rotate(15deg);
      top: 35px;
      right: 25px;
    }

    .sound-wave {
      position: absolute;
      width: 30px;
      height: 20px;
      border: 2px solid white;
      border-radius: 50%;
      border-top: none;
      border-left: none;
      border-right: none;
      transform: rotate(10deg);
      bottom: 10px;
      left: 30px;
    }

    .logo-container:hover .logo {
      transform: scale(1.05) rotate(5deg);
    }

    h1 {
      color: var(--text-dark);
      font-size: 2.5rem;
      margin-bottom: 0.5rem;
      font-weight: 500;
      letter-spacing: 1px;
    }

    .subtitle {
      color: var(--text-light);
      font-size: 1.1rem;
      margin-bottom: 3rem;
      line-height: 1.5;
      font-weight: 400;
    }

    .button-group {
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
      margin-top: 1rem;
    }

    .auth-btn {
      padding: 1.2rem 2.5rem;
      border-radius: 30px;
      font-size: 1.2rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      border: none;
      position: relative;
      overflow: hidden;
      display: flex;
      align-items: center;
      justify-content: center;
      letter-spacing: 0.5px;
    }

    .login-btn {
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      color: white;
      box-shadow: 0 8px 20px rgba(129, 199, 132, 0.5);
    }

    .register-btn {
      background: transparent;
      border: 2px solid var(--primary);
      color: var(--text-dark);
    }

    .auth-btn:hover {
      transform: translateY(-3px);
    }

    .auth-btn::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.5s ease;
    }

    .auth-btn:hover::before {
      transform: scaleX(1);
    }

    @media (max-width: 480px) {
      .auth-container {
        padding: 3rem 2rem;
        margin: 1rem;
      }

      h1 {
        font-size: 2rem;
      }

      .subtitle {
        font-size: 1rem;
      }

      .auth-btn {
        padding: 1rem 2rem;
        font-size: 1.1rem;
      }
    }
  </style>
</head>
<body>
<!-- 音乐音符背景装饰 -->
<div class="background-pattern">
  <div class="music-note" style="left: 10%; top: -50px; animation-delay: 0s;">♫</div>
  <div class="music-note" style="left: 25%; top: -50px; animation-delay: 2s;">♪</div>
  <div class="music-note" style="left: 40%; top: -50px; animation-delay: 1s;">♩</div>
  <div class="music-note" style="left: 55%; top: -50px; animation-delay: 3s;">♬</div>
  <div class="music-note" style="left: 70%; top: -50px; animation-delay: 1.5s;">♫</div>
  <div class="music-note" style="left: 85%; top: -50px; animation-delay: 2.5s;">♪</div>
  <div class="music-note" style="left: 15%; top: -50px; animation-delay: 4s;">♩</div>
  <div class="music-note" style="left: 30%; top: -50px; animation-delay: 3.5s;">♬</div>
  <div class="music-note" style="left: 60%; top: -50px; animation-delay: 4.5s;">♫</div>
  <div class="music-note" style="left: 80%; top: -50px; animation-delay: 5s;">♪</div>
</div>

<div class="auth-container">
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
  <h1>音悦</h1>
  <p class="subtitle">让每一个音符，触动你的心灵</p>

  <div class="button-group">
    <button class="auth-btn login-btn" onclick="location.href='login.jsp'">
      立即登录
    </button>
    <button class="auth-btn register-btn" onclick="location.href='register.jsp'">
      注册账号
    </button>
  </div>
</div>

<!-- 引入Font Awesome图标库 -->
<link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
</body>
</html>
