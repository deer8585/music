package entity;

import java.sql.Timestamp;

public class User {
    private Long id;
    private String username;
    private String role;
    private String avatar;
    private String nickname;
    private String gender;
    private String signature;
    private Timestamp createdAt;

    public User() {}

    public User(Long id, String username, String role, String avatar, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.role = role;
        this.avatar = avatar;
        this.createdAt = createdAt;
    }

    public User(Long id, String username, String role, String avatar, String nickname, String gender, String signature, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.role = role;
        this.avatar = avatar;
        this.nickname = nickname;
        this.gender = gender;
        this.signature = signature;
        this.createdAt = createdAt;
    }

    // setter 方法
    public void setId(Long id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    // getter 方法
    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }

    public String getAvatar() {
        return avatar;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getNickname() {
        return nickname;
    }

    public String getGender() {
        return gender;
    }

    public String getSignature() {
        return signature;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                ", avatar='" + avatar + '\'' +
                ", nickname='" + nickname + '\'' +
                ", gender='" + gender + '\'' +
                ", signature='" + signature + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}