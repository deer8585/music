package entity;

import java.util.Date;

public class Music {
    private Long id;
    private String title;
    private String artist;
    private String album;
    private Integer duration;
    private String path;
    private Date releaseTime;
    private Integer playCount;
    private Integer favoriteCount;
    private Integer likeCount;
    private Integer commentCount;
    private String coverPath; // 封面图片路径

    // 无参构造方法
    public Music() {}

    // 全参构造方法
    public Music(Long id, String title, String artist, String album, Integer duration,
                 String path, Date releaseTime, Integer playCount,
                 Integer favoriteCount, Integer likeCount, Integer commentCount, String coverPath) {
        this.id = id;
        this.title = title;
        this.artist = artist;
        this.album = album;
        this.duration = duration;
        this.path = path;
        this.releaseTime = releaseTime;
        this.playCount = playCount;
        this.favoriteCount = favoriteCount;
        this.likeCount = likeCount;
        this.commentCount = commentCount;
        this.coverPath = coverPath;
    }

    // Getter 和 Setter 方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public String getAlbum() {
        return album;
    }

    public void setAlbum(String album) {
        this.album = album;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public Date getReleaseTime() {
        return releaseTime;
    }

    public void setReleaseTime(Date releaseTime) {
        this.releaseTime = releaseTime;
    }

    public Integer getPlayCount() {
        return playCount;
    }

    public void setPlayCount(Integer playCount) {
        this.playCount = playCount;
    }

    public Integer getFavoriteCount() {
        return favoriteCount;
    }

    public void setFavoriteCount(Integer favoriteCount) {
        this.favoriteCount = favoriteCount;
    }

    public Integer getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }

    public Integer getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(Integer commentCount) {
        this.commentCount = commentCount;
    }

    public String getCoverPath() {
        return coverPath;
    }

    public void setCoverPath(String coverPath) {
        this.coverPath = coverPath;
    }

    // 重写 toString 方法，方便打印对象信息
    @Override
    public String toString() {
        return "Music{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", artist='" + artist + '\'' +
                ", album='" + album + '\'' +
                ", duration=" + duration +
                ", path='" + path + '\'' +
                ", releaseTime=" + releaseTime +
                ", playCount=" + playCount +
                ", favoriteCount=" + favoriteCount +
                ", likeCount=" + likeCount +
                ", commentCount=" + commentCount +
                ", coverPath='" + coverPath + '\'' +
                '}';
    }
    private String formattedReleaseTime; // 新增字段
    private boolean favorited; // 是否已收藏

    // 添加getter/setter
    public String getFormattedReleaseTime() {
        return formattedReleaseTime;
    }

    public void setFormattedReleaseTime(String formattedReleaseTime) {
        this.formattedReleaseTime = formattedReleaseTime;
    }

    public boolean isFavorited() {
        return favorited;
    }

    public void setFavorited(boolean favorited) {
        this.favorited = favorited;
    }

}