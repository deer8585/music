package dao;

import bean.ConnectionPool;
import entity.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public List<User> getAllUsers() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            // 修改SQL查询，只获取role为user的用户
            String sql = "SELECT id, username, role, avatar, nickname, gender, signature, created_at FROM users WHERE role = 'user' ORDER BY created_at DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setAvatar(rs.getString("avatar"));
                user.setNickname(rs.getString("nickname"));
                user.setGender(rs.getString("gender"));
                user.setSignature(rs.getString("signature"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return users;
    }

    public boolean deleteUser(Long userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            // 删除用户（会级联删除相关的评论和收藏）
            String sql = "DELETE FROM users WHERE id = ? AND role = 'user'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    public User getUserById(Long userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT id, username, role, avatar, nickname, gender, signature, created_at FROM users WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setAvatar(rs.getString("avatar"));
                user.setNickname(rs.getString("nickname"));
                user.setGender(rs.getString("gender"));
                user.setSignature(rs.getString("signature"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return user;
    }

    public boolean updateUserProfile(Long userId, String nickname, String gender, String signature, String avatar) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "UPDATE users SET nickname = ?, gender = ?, signature = ?, avatar = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname);
            pstmt.setString(2, gender);
            pstmt.setString(3, signature);
            pstmt.setString(4, avatar);
            pstmt.setLong(5, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    /**
     * 分页查询用户列表
     */
    public List<User> getUsersByPage(int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT id, username, role, avatar, nickname, gender, signature, created_at " +
                        "FROM users WHERE role = 'user' ORDER BY created_at DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setAvatar(rs.getString("avatar"));
                user.setNickname(rs.getString("nickname"));
                user.setGender(rs.getString("gender"));
                user.setSignature(rs.getString("signature"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return users;
    }

    /**
     * 获取用户总数
     */
    public int getUserCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT COUNT(*) FROM users WHERE role = 'user'";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return count;
    }

    private static void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) ConnectionPool.getInstance().releaseConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}