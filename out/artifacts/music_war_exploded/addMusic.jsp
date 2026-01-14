<%-- Created by IntelliJ IDEA. User: wangshuyu Date: 2025/5/29 Time: 12:35 To change this template use File | Settings |
  File Templates. --%>
  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="UTF-8">
      <title>添加歌曲信息</title>
      <!-- 引入管理员主题样式 - music_bg.jpg 背景 -->
      <link rel="stylesheet" href="css/admin-theme.css">
      <style>
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background-color: #f5f0ff;
          /* 修改：淡紫色背景 */
          color: #333;
          /* 修改：深色文字 */
          margin: 0;
          padding: 20px;
        }

        .container {
          width: 500px;
          margin: 0 auto;
          background-color: #ffffff;
          /* 修改：白色容器背景 */
          padding: 25px;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(102, 51, 153, 0.1);
          /* 修改：紫色阴影 */
          border: 1px solid #e0d0ff;
          /* 修改：淡紫色边框 */
        }

        h2 {
          color: #6a3093;
          /* 修改：深紫色标题 */
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
          /* 修改：淡紫色边框 */
        }

        tr:nth-child(even) {
          background-color: #f9f5ff;
          /* 修改：非常淡的紫色背景 */
        }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        input[type="file"] {
          width: 100%;
          padding: 8px;
          box-sizing: border-box;
          background-color: #fff;
          border: 1px solid #c9b0ff;
          /* 修改：紫色边框 */
          color: #333;
          border-radius: 4px;
        }

        input[type="submit"] {
          padding: 10px 20px;
          background-color: #6a3093;
          /* 修改：深紫色按钮 */
          color: #fff;
          border: none;
          cursor: pointer;
          font-weight: bold;
          border-radius: 4px;
          width: 100%;
          transition: all 0.3s ease;
        }

        input[type="submit"]:hover {
          background-color: #8e44ad;
          /* 修改：悬停时更亮的紫色 */
          transform: translateY(-1px);
        }
      </style>
    </head>

    <body>

      <div class="container">
        <h2>添加歌曲信息</h2>

        <p class="error">${error}</p>

        <form action="MusicServlet" method="post" enctype="multipart/form-data">
        <table>
          <tr>
            <td>歌曲名称：</td>
            <td><input type="text" name="title" required></td>
          </tr>
          <tr>
            <td>歌手：</td>
            <td><input type="text" name="artist" required></td>
          </tr>
          <tr>
            <td>专辑：</td>
            <td><input type="text" name="album"></td>
          </tr>
          <tr>
            <td>时长（秒）：</td>
            <td>
              <input type="number" name="duration" placeholder="自动从MP3文件解析">
              <small style="color: #888;">留空则自动解析</small>
            </td>
          </tr>
          <tr>
            <td>音乐文件：</td>
            <td><input type="file" name="musicFile" accept=".mp3" required></td>
          </tr>
          <tr>
            <td>封面图片：</td>
            <td><input type="file" name="coverFile" accept=".png,.jpg,.jpeg"></td>
          </tr>
          <tr>
            <td>播放量：</td>
            <td><input type="number" name="playCount" value="0" min="0" readonly></td>
          </tr>
          <tr>
            <td colspan="2">
              <input type="submit" value="提交">
            </td>
          </tr>
        </table>
        </form>
      </div>
    </body>

    </html>