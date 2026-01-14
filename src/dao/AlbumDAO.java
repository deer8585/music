package dao;

import bean.ConnectionPool;
import entity.Album;
import entity.Music;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AlbumDAO {
    
    public List<Album> getAllAlbums() {
        List<Album> albums = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT album, artist, COUNT(*) as song_count, " +
                        "MAX(cover_path) as cover_path " +
                        "FROM music " +
                        "WHERE album IS NOT NULL AND album != '' " +
                        "GROUP BY album, artist " +
                        "ORDER BY album";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Album album = new Album();
                album.setAlbumName(rs.getString("album"));
                album.setArtist(rs.getString("artist"));
                album.setSongCount(rs.getInt("song_count"));
                album.setCoverPath(rs.getString("cover_path"));
                albums.add(album);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return albums;
    }
    
    public List<Music> getSongsByAlbum(String albumName, String artist) {
        List<Music> songs = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT * FROM music WHERE album = ? AND artist = ? ORDER BY id";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, albumName);
            pstmt.setString(2, artist);
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
     * 分页查询专辑中的歌曲
     */
    public List<Music> getSongsByAlbumWithPage(String albumName, String artist, int page, int pageSize) {
        List<Music> songs = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            int offset = (page - 1) * pageSize;
            String sql = "SELECT * FROM music WHERE album = ? AND artist = ? ORDER BY id LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, albumName);
            pstmt.setString(2, artist);
            pstmt.setInt(3, pageSize);
            pstmt.setInt(4, offset);
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
     * 获取专辑中的歌曲总数
     */
    public int getSongCountByAlbum(String albumName, String artist) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = ConnectionPool.getInstance().getConnection(5000);
            String sql = "SELECT COUNT(*) FROM music WHERE album = ? AND artist = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, albumName);
            pstmt.setString(2, artist);
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
            if (conn != null) ConnectionPool.getInstance().releaseConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
