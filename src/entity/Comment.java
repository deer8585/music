package entity;

import java.sql.Timestamp;

public class Comment {
    private long id;
    private long musicId;
    private long userId;
    private String content;
    private Timestamp createTime;
    private Boolean isFeatured;
    private String username; // 用户名，用于显示
    private String musicTitle; // 歌曲标题，用于显示

    // 构造方法
    public Comment() {}

    public Comment(long userId, long musicId, String content) {
        this.userId = userId;
        this.musicId = musicId;
        this.content = content;
        this.isFeatured = false;
    }

    // getters and setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getMusicId() { return musicId; }
    public void setMusicId(long musicId) { this.musicId = musicId; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Timestamp getCreateTime() { return createTime; }
    public void setCreateTime(Timestamp createTime) { this.createTime = createTime; }

    public Boolean getIsFeatured() { return isFeatured; }
    public void setIsFeatured(Boolean featured) { this.isFeatured = featured; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getMusicTitle() { return musicTitle; }
    public void setMusicTitle(String musicTitle) { this.musicTitle = musicTitle; }

    @Override
    public String toString() {
        return "Comment{" +
                "id=" + id +
                ", musicId=" + musicId +
                ", userId=" + userId +
                ", content='" + content + '\'' +
                ", createTime=" + createTime +
                ", isFeatured=" + isFeatured +
                ", username='" + username + '\'' +
                ", musicTitle='" + musicTitle + '\'' +
                '}';
    }
}
