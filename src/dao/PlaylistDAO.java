package dao;

import bean.ConnectionPool;
import entity.Music;
import entity.Playlist;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlaylistDAO {

    /**
     * 创建歌单
     */
    public boolean createPlaylist(Playlist playlist) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);

            String sql = "INSERT INTO playlists (user_id, name, description, cover_path) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setLong(1, playlist.getUserId());
            pstmt.setString(2, playlist.getName());
            pstmt.setString(3, playlist.getDescription());
            pstmt.setString(4, playlist.getCoverPath());
            rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    playlist.setId(rs.getLong(1));
                }
            }

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
            closeResources(rs, pstmt, conn);
        }
        return rowsAffected > 0;
    }

    /**
     * 获取用户的所有歌单
     */
    public List<Playlist> getPlaylistsByUserId(long userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Playlist> playlists = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT * FROM playlists WHERE user_id = ? ORDER BY created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Playlist playlist = new Playlist();
                playlist.setId(rs.getLong("id"));
                playlist.setUserId(rs.getLong("user_id"));
                playlist.setName(rs.getString("name"));
                playlist.setDescription(rs.getString("description"));
                playlist.setCoverPath(rs.getString("cover_path"));
                playlist.setSongCount(rs.getInt("song_count"));
                playlist.setCreatedAt(rs.getTimestamp("created_at"));
                playlist.setUpdatedAt(rs.getTimestamp("updated_at"));
                playlists.add(playlist);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return playlists;
    }

    /**
     * 根据ID获取歌单
     */
    public Playlist getPlaylistById(long playlistId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Playlist playlist = null;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT * FROM playlists WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                playlist = new Playlist();
                playlist.setId(rs.getLong("id"));
                playlist.setUserId(rs.getLong("user_id"));
                playlist.setName(rs.getString("name"));
                playlist.setDescription(rs.getString("description"));
                playlist.setCoverPath(rs.getString("cover_path"));
                playlist.setSongCount(rs.getInt("song_count"));
                playlist.setCreatedAt(rs.getTimestamp("created_at"));
                playlist.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return playlist;
    }

    /**
     * 更新歌单信息
     */
    public boolean updatePlaylist(Playlist playlist) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);

            String sql = "UPDATE playlists SET name = ?, description = ?, cover_path = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, playlist.getName());
            pstmt.setString(2, playlist.getDescription());
            pstmt.setString(3, playlist.getCoverPath());
            pstmt.setLong(4, playlist.getId());
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
            closeResources(null, pstmt, conn);
        }
        return rowsAffected > 0;
    }

    /**
     * 删除歌单
     */
    public boolean deletePlaylist(long playlistId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);

            String sql = "DELETE FROM playlists WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
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
            closeResources(null, pstmt, conn);
        }
        return rowsAffected > 0;
    }

    /**
     * 添加歌曲到歌单
     */
    public boolean addSongToPlaylist(long playlistId, long songId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);

            // 检查歌曲是否已在歌单中
            if (isSongInPlaylist(playlistId, songId)) {
                return false;
            }

            String sql = "INSERT INTO playlist_songs (playlist_id, song_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
            pstmt.setLong(2, songId);
            rowsAffected = pstmt.executeUpdate();

            // 更新歌单歌曲数量
            if (rowsAffected > 0) {
                updateSongCount(playlistId, conn);
                // 如果歌单封面是默认的，更新为第一首歌的封面
                updatePlaylistCoverIfDefault(playlistId, conn);
            }

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
            closeResources(null, pstmt, conn);
        }
        return rowsAffected > 0;
    }

    /**
     * 从歌单中移除歌曲
     */
    public boolean removeSongFromPlaylist(long playlistId, long songId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rowsAffected = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            conn.setAutoCommit(false);

            String sql = "DELETE FROM playlist_songs WHERE playlist_id = ? AND song_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
            pstmt.setLong(2, songId);
            rowsAffected = pstmt.executeUpdate();

            // 更新歌单歌曲数量
            if (rowsAffected > 0) {
                updateSongCount(playlistId, conn);
            }

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
            closeResources(null, pstmt, conn);
        }
        return rowsAffected > 0;
    }

    /**
     * 获取歌单中的所有歌曲（按添加时间降序排序）
     */
    public List<Music> getSongsByPlaylistId(long playlistId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> songs = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT m.*, ps.added_at FROM music m " +
                    "INNER JOIN playlist_songs ps ON m.id = ps.song_id " +
                    "WHERE ps.playlist_id = ? " +
                    "ORDER BY ps.added_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
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
                songs.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return songs;
    }

    /**
     * 检查歌曲是否在歌单中
     */
    public boolean isSongInPlaylist(long playlistId, long songId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT 1 FROM playlist_songs WHERE playlist_id = ? AND song_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
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
     * 更新歌单歌曲数量
     */
    private void updateSongCount(long playlistId, Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE playlists SET song_count = (SELECT COUNT(*) FROM playlist_songs WHERE playlist_id = ?) WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
            pstmt.setLong(2, playlistId);
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
        }
    }

    /**
     * 如果歌单封面是默认的，更新为第一首歌的封面
     */
    private void updatePlaylistCoverIfDefault(long playlistId, Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // 检查歌单封面是否为默认
            String checkSql = "SELECT cover_path FROM playlists WHERE id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setLong(1, playlistId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String coverPath = rs.getString("cover_path");
                if (coverPath == null || coverPath.equals("images/avatar.png")) {
                    // 获取第一首歌的封面
                    rs.close();
                    pstmt.close();

                    String getSongCoverSql = "SELECT m.cover_path FROM music m " +
                            "INNER JOIN playlist_songs ps ON m.id = ps.song_id " +
                            "WHERE ps.playlist_id = ? LIMIT 1";
                    pstmt = conn.prepareStatement(getSongCoverSql);
                    pstmt.setLong(1, playlistId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String songCover = rs.getString("cover_path");
                        if (songCover != null && !songCover.isEmpty()) {
                            rs.close();
                            pstmt.close();

                            String updateSql = "UPDATE playlists SET cover_path = ? WHERE id = ?";
                            pstmt = conn.prepareStatement(updateSql);
                            pstmt.setString(1, songCover);
                            pstmt.setLong(2, playlistId);
                            pstmt.executeUpdate();
                        }
                    }
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
    }

    /**
     * 分页获取歌单中的歌曲
     */
    public List<Music> getSongsByPlaylistIdWithPage(long playlistId, int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Music> songs = new ArrayList<>();

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT m.*, ps.added_at FROM music m " +
                    "INNER JOIN playlist_songs ps ON m.id = ps.song_id " +
                    "WHERE ps.playlist_id = ? " +
                    "ORDER BY ps.added_at DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
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
                songs.add(music);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return songs;
    }

    /**
     * 获取歌单中的歌曲总数
     */
    public int getSongCountByPlaylistId(long playlistId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT COUNT(*) FROM playlist_songs WHERE playlist_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, playlistId);
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

    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                ConnectionPool.getInstance().releaseConnection(conn);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
