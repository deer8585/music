<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>数据库连接测试</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h2>数据库连接测试</h2>
    
    <%
        String dbUrl = "jdbc:mysql://localhost:3306/music0";
        String dbUser = "root";
        String dbPass = "1234";
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            // 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            out.println("<p class='info'>MySQL驱动加载成功</p>");
            
            // 建立连接
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            out.println("<p class='success'>数据库连接成功！</p>");
            out.println("<p class='info'>数据库URL: " + dbUrl + "</p>");
            
            // 测试查询
            stmt = conn.createStatement();
            
            // 检查数据库是否存在
            rs = stmt.executeQuery("SELECT DATABASE()");
            if (rs.next()) {
                out.println("<p class='info'>当前数据库: " + rs.getString(1) + "</p>");
            }
            
            // 检查表是否存在
            rs = stmt.executeQuery("SHOW TABLES");
            out.println("<h3>数据库中的表:</h3>");
            out.println("<ul>");
            while (rs.next()) {
                out.println("<li>" + rs.getString(1) + "</li>");
            }
            out.println("</ul>");
            
            // 检查users表结构
            try {
                rs = stmt.executeQuery("DESCRIBE users");
                out.println("<h3>users表结构:</h3>");
                out.println("<table border='1' style='border-collapse: collapse;'>");
                out.println("<tr><th>字段</th><th>类型</th><th>空值</th><th>键</th><th>默认值</th><th>额外</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("Field") + "</td>");
                    out.println("<td>" + rs.getString("Type") + "</td>");
                    out.println("<td>" + rs.getString("Null") + "</td>");
                    out.println("<td>" + rs.getString("Key") + "</td>");
                    out.println("<td>" + rs.getString("Default") + "</td>");
                    out.println("<td>" + rs.getString("Extra") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            } catch (SQLException e) {
                out.println("<p class='error'>users表不存在: " + e.getMessage() + "</p>");
                out.println("<p class='info'>请运行database_setup.sql创建表结构</p>");
            }
            
        } catch (ClassNotFoundException e) {
            out.println("<p class='error'>MySQL驱动未找到: " + e.getMessage() + "</p>");
        } catch (SQLException e) {
            out.println("<p class='error'>数据库连接失败: " + e.getMessage() + "</p>");
            out.println("<p class='info'>请检查:</p>");
            out.println("<ul>");
            out.println("<li>MySQL服务是否启动</li>");
            out.println("<li>数据库名称是否正确: music0</li>");
            out.println("<li>用户名密码是否正确: root/1234</li>");
            out.println("<li>端口是否正确: 3306</li>");
            out.println("</ul>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("<p class='error'>关闭连接时出错: " + e.getMessage() + "</p>");
            }
        }
    %>
    
    <hr>
    <p><a href="register.jsp">返回注册页面</a></p>
</body>
</html>