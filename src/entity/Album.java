package entity;

public class Album {
    private String albumName;
    private String artist;
    private Integer songCount;
    private String coverPath;

    public Album() {}

    public Album(String albumName, String artist, Integer songCount, String coverPath) {
        this.albumName = albumName;
        this.artist = artist;
        this.songCount = songCount;
        this.coverPath = coverPath;
    }

    public String getAlbumName() {
        return albumName;
    }

    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public Integer getSongCount() {
        return songCount;
    }

    public void setSongCount(Integer songCount) {
        this.songCount = songCount;
    }

    public String getCoverPath() {
        return coverPath;
    }

    public void setCoverPath(String coverPath) {
        this.coverPath = coverPath;
    }
}
