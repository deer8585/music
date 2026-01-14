package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", value = "/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 获取当前 Session
        HttpSession session = req.getSession(false); // false 表示如果不存在，不创建新 Session

        // 2. 如果 Session 存在，则销毁它
        if (session != null) {
            session.invalidate(); // 清除所有 Session 数据
        }

        // 3. 重定向到登录页面
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}