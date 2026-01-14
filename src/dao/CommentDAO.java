package dao;

import bean.ConnectionPool;
import entity.Comment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 评论管理
 */
public class CommentDAO {
    /**
     * 获取所有评论列表
     */
    public List<Comment> getAllComments() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Comment> comments = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT c.id, c.user_id, c.song_id, c.content, c.created_at, c.is_featured, " +
                        "u.username, m.title as music_title " +
                        "FROM comments c " +
                        "JOIN users u ON c.user_id = u.id " +
                        "JOIN music m ON c.song_id = m.id " +
                        "ORDER BY c.created_at DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getLong("id"));
                comment.setMusicId(rs.getLong("song_id"));
                comment.setUserId(rs.getLong("user_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreateTime(rs.getTimestamp("created_at"));
                comment.setIsFeatured(rs.getBoolean("is_featured"));
                comment.setUsername(rs.getString("username"));
                comment.setMusicTitle(rs.getString("music_title"));
                comments.add(comment);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return comments;
    }

    /**
     * 根据ID删除评论
     */
    public boolean deleteComment(long id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "DELETE FROM comments WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);

            int rowsAffected = pstmt.executeUpdate();
            success = rowsAffected > 0;
            conn.commit();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            rollbackTransaction(conn);
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
        return success;
    }
    /**
     * 设置精华评论
     */
    public boolean setFeatured(long commentId, boolean isFeatured) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "UPDATE comments SET is_featured = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setBoolean(1, isFeatured);
            pstmt.setLong(2, commentId);

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
     * 根据歌曲ID获取评论列表（用户端）
     */
    public List<Comment> getCommentsByMusicId(long musicId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Comment> comments = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT c.id, c.user_id, c.song_id, c.content, c.created_at, c.is_featured, u.username " +
                        "FROM comments c JOIN users u ON c.user_id = u.id " +
                        "WHERE c.song_id = ? ORDER BY c.is_featured DESC, c.created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, musicId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getLong("id"));
                comment.setUserId(rs.getLong("user_id"));
                comment.setMusicId(rs.getLong("song_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreateTime(rs.getTimestamp("created_at"));
                comment.setIsFeatured(rs.getBoolean("is_featured"));
                comment.setUsername(rs.getString("username"));
                comments.add(comment);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return comments;
    }

    /**
     * 添加评论（用户端）
     */
    public boolean addComment(long userId, long musicId, String content) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);
            
            // 插入评论
            String sql = "INSERT INTO comments (user_id, song_id, content, created_at) VALUES (?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, musicId);
            pstmt.setString(3, content);

            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // 更新歌曲评论数
                pstmt.close();
                String updateSql = "UPDATE music SET comment_count = comment_count + 1 WHERE id = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setLong(1, musicId);
                pstmt.executeUpdate();
                
                conn.commit();
                success = true;
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            rollbackTransaction(conn);
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
        return success;
    }

    /**
     * 获取评论总数（按歌曲ID）
     */
    public int getCommentCountByMusicId(long musicId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT COUNT(*) FROM comments WHERE song_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, musicId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return count;
    }

    /**
     * 模糊搜索评论（管理端）
     */
    public List<Comment> searchComments(String keyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Comment> comments = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT c.id, c.user_id, c.song_id, c.content, c.created_at, c.is_featured, " +
                        "u.username, m.title as music_title " +
                        "FROM comments c " +
                        "JOIN users u ON c.user_id = u.id " +
                        "JOIN music m ON c.song_id = m.id " +
                        "WHERE c.content LIKE ? OR u.username LIKE ? OR m.title LIKE ? " +
                        "ORDER BY c.created_at DESC";
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getLong("id"));
                comment.setMusicId(rs.getLong("song_id"));
                comment.setUserId(rs.getLong("user_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreateTime(rs.getTimestamp("created_at"));
                comment.setIsFeatured(rs.getBoolean("is_featured"));
                comment.setUsername(rs.getString("username"));
                comment.setMusicTitle(rs.getString("music_title"));
                comments.add(comment);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return comments;
    }

    // 私有方法：回滚事务
    private void rollbackTransaction(Connection conn) {
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    /**
     * 分页查询评论列表
     */
    public List<Comment> getCommentsByPage(int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Comment> comments = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT c.id, c.user_id, c.song_id, c.content, c.created_at, c.is_featured, " +
                        "u.username, m.title as music_title " +
                        "FROM comments c " +
                        "JOIN users u ON c.user_id = u.id " +
                        "JOIN music m ON c.song_id = m.id " +
                        "ORDER BY c.created_at DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getLong("id"));
                comment.setMusicId(rs.getLong("song_id"));
                comment.setUserId(rs.getLong("user_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreateTime(rs.getTimestamp("created_at"));
                comment.setIsFeatured(rs.getBoolean("is_featured"));
                comment.setUsername(rs.getString("username"));
                comment.setMusicTitle(rs.getString("music_title"));
                comments.add(comment);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return comments;
    }

    /**
     * 获取评论总数
     */
    public int getCommentCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT COUNT(*) FROM comments";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return count;
    }

    /**
     * 切换评论精华状态
     */
    public boolean toggleFeatured(long commentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);
            
            // 先查询当前状态
            String querySql = "SELECT is_featured FROM comments WHERE id = ?";
            pstmt = conn.prepareStatement(querySql);
            pstmt.setLong(1, commentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                boolean currentStatus = rs.getBoolean("is_featured");
                rs.close();
                pstmt.close();
                
                // 切换状态
                String updateSql = "UPDATE comments SET is_featured = ? WHERE id = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setBoolean(1, !currentStatus);
                pstmt.setLong(2, commentId);
                int rowsAffected = pstmt.executeUpdate();
                
                conn.commit();
                return rowsAffected > 0;
            }
            
            conn.commit();
            return false;
        } catch (Exception e) {
            rollbackTransaction(conn);
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(rs, pstmt, conn);
        }
    }

    // 私有方法：关闭资源
    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            ConnectionPool.getInstance().releaseConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}