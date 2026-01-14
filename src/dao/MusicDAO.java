package dao;

import bean.ConnectionPool;
import entity.Music;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;
public class MusicDAO {
    /**
     * 添加音乐到数据库
     */
    public void addMusic(Music music) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet generatedKeys = null;

        try {
            // 获取连接（超时时间5秒）
            conn = ConnectionPool.getInstance().getConnection(5000);
            
            // 设置手动提交事务
            conn.setAutoCommit(false);

            // 插入音乐数据
            String sql = "INSERT INTO music (title, artist, album, duration, path, cover_path, release_time, play_count, favorite_count, like_count, comment_count) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            pstmt.setString(1, music.getTitle());
            pstmt.setString(2, music.getArtist());
            pstmt.setString(3, music.getAlbum());
            pstmt.setInt(4, music.getDuration());
            pstmt.setString(5, music.getPath());
            pstmt.setString(6, music.getCoverPath());
            pstmt.setTimestamp(7, new java.sql.Timestamp(music.getReleaseTime().getTime()));
            pstmt.setInt(8, music.getPlayCount());
            pstmt.setInt(9, music.getFavoriteCount());
            pstmt.setInt(10, music.getLikeCount());
            pstmt.setInt(11, music.getCommentCount());

            int rowsAffected = pstmt.executeUpdate();

            // 获取并设置生成的主键ID
            if (rowsAffected > 0) {
                generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong(1);
                    music.setId(id);
                    System.out.println("插入成功，生成的ID: " + id);
                }
            }

            // 提交事务
            conn.commit();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("获取数据库连接被中断", e);
        } catch (SQLException e) {
            // 回滚事务
            try {
                if (conn != null && !conn.getAutoCommit()) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw new RuntimeException("添加音乐失败", e);
        } finally {
            // 恢复自动提交并关闭资源
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
                if (generatedKeys != null) generatedKeys.close();
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 查询所有音乐
     */
    public List<Music> getAllMusic() {
        List<Music> musicList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT * FROM music";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (InterruptedException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return musicList;
    }
    /**
     * 根据ID查询音乐
     */
    public Music getMusicById(long id) {
        Music music = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT * FROM music WHERE id =?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
            }
        } catch (InterruptedException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return music;
    }
    /**
     * 更新音乐信息
     */
    public boolean updateMusic(Music music) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);
            
            String sql = "UPDATE music SET title =?, artist =?, album =?, duration =?, path =?, cover_path =?, release_time =?, play_count =?, favorite_count =?, like_count =?, comment_count =? WHERE id =?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, music.getTitle());
            pstmt.setString(2, music.getArtist());
            pstmt.setString(3, music.getAlbum());
            pstmt.setInt(4, music.getDuration());
            pstmt.setString(5, music.getPath());
            pstmt.setString(6, music.getCoverPath());
            pstmt.setTimestamp(7, new java.sql.Timestamp(music.getReleaseTime().getTime()));
            pstmt.setInt(8, music.getPlayCount());
            pstmt.setInt(9, music.getFavoriteCount());
            pstmt.setInt(10, music.getLikeCount());
            pstmt.setInt(11, music.getCommentCount());
            pstmt.setLong(12, music.getId());
            rowsAffected = pstmt.executeUpdate();
            conn.commit();
        } catch (InterruptedException | SQLException e) {
            try {
                if (conn != null && !conn.getAutoCommit()) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return rowsAffected > 0;
    }

    /**
     * 删除音乐
     */
    public boolean deleteMusic(long id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);
            
            String sql = "DELETE FROM music WHERE id =?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            rowsAffected = pstmt.executeUpdate();
            conn.commit();
        } catch (InterruptedException | SQLException e) {
            try {
                if (conn != null && !conn.getAutoCommit()) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return rowsAffected > 0;
    }
    /**
     * 查看热榜前十
     */
    public List<Music> getTop10ByPlayCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT * FROM music ORDER BY play_count DESC LIMIT 10";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                music.setReleaseTime(rs.getDate("release_time"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn); // 现在这个方法已经存在了
        }
        return musicList;
    }
    // 添加在 MusicDAO 类的最后
    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                ConnectionPool.getInstance().releaseConnection(conn);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List<Music> getNewSongs(int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            // 修正SQL语句 - 移除了多余的SELECT子句
            String sql = "SELECT id, title, artist, album, duration, path, cover_path, " +
                    "release_time, play_count, favorite_count, like_count, comment_count " +
                    "FROM music ORDER BY release_time DESC LIMIT ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time")); // 保持datetime类型
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return musicList;
    }

    /**
     * 获取用户收藏的音乐列表
     */
    public List<Music> getFavoritesByUserId(long userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT m.* FROM music m " +
                    "INNER JOIN favorites f ON m.id = f.song_id " +
                    "WHERE f.user_id = ? " +
                    "ORDER BY f.created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return musicList;
    }

    /**
     * 添加收藏
     */
    public boolean addFavorite(long userId, long songId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);

            String sql = "INSERT INTO favorites (user_id, song_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, songId);
            rowsAffected = pstmt.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            try {
                if (conn != null && !conn.getAutoCommit()) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return rowsAffected > 0;
    }

    /**
     * 取消收藏
     */
    public boolean removeFavorite(long userId, long songId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);

            String sql = "DELETE FROM favorites WHERE user_id = ? AND song_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, songId);
            rowsAffected = pstmt.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            try {
                if (conn != null && !conn.getAutoCommit()) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return rowsAffected > 0;
    }

    /**
     * 检查是否已收藏
     */
    public boolean isFavorite(long userId, long songId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT 1 FROM favorites WHERE user_id = ? AND song_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, songId);
            rs = pstmt.executeQuery();
            exists = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return exists;
    }

    /**
     * 模糊搜索音乐（支持标题、歌手、专辑）
     */
    public List<Music> searchMusic(String keyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT * FROM music WHERE title LIKE ? OR artist LIKE ? OR album LIKE ? ORDER BY play_count DESC";
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return musicList;
    }
    
    /**
     * 获取音乐总数（用于分页）
     */
    public int getMusicCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT COUNT(*) FROM music";
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

    /**
     * 分页查询音乐列表
     */
    public List<Music> getMusicByPage(int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT * FROM music ORDER BY id DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return musicList;
    }

    /**
     * 分页查询热门歌曲（按播放量排序）
     */
    public List<Music> getHotMusicByPage(int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT * FROM music ORDER BY play_count DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return musicList;
    }

    /**
     * 分页查询用户收藏的音乐
     */
    public List<Music> getFavoritesByUserIdWithPage(long userId, int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT m.* FROM music m " +
                    "INNER JOIN favorites f ON m.id = f.song_id " +
                    "WHERE f.user_id = ? " +
                    "ORDER BY f.created_at DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setInt(2, pageSize);
            pstmt.setInt(3, offset);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return musicList;
    }

    /**
     * 获取用户收藏总数
     */
    public int getFavoritesCountByUserId(long userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT COUNT(*) FROM favorites WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
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

    /**
     * 增加歌曲播放量
     */
    public boolean incrementPlayCount(long songId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "UPDATE music SET play_count = play_count + 1 WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, songId);
            rowsAffected = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                ConnectionPool.getInstance().releaseConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return rowsAffected > 0;
    }

    /**
     * 分页查询随机排序的音乐列表
     */
    public List<Music> getRandomMusicByPage(int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> musicList = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT * FROM music ORDER BY RAND() LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Music music = new Music();
                music.setId(rs.getLong("id"));
                music.setTitle(rs.getString("title"));
                music.setArtist(rs.getString("artist"));
                music.setAlbum(rs.getString("album"));
                music.setDuration(rs.getInt("duration"));
                music.setPath(rs.getString("path"));
                music.setCoverPath(rs.getString("cover_path"));
                music.setReleaseTime(rs.getTimestamp("release_time"));
                music.setPlayCount(rs.getInt("play_count"));
                music.setFavoriteCount(rs.getInt("favorite_count"));
                music.setLikeCount(rs.getInt("like_count"));
                music.setCommentCount(rs.getInt("comment_count"));
                musicList.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return musicList;
    }

}
