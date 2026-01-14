package util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

public class FileUploadUtil {
    
    /**
     * 上传音乐文件到指定专辑目录
     * @param part 文件部分
     * @param albumName 专辑名称
     * @param webPath Web应用根路径
     * @return 相对路径
     */
    public static String uploadMusicFile(Part part, String albumName, String webPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        // 获取原始文件名
        String originalFileName = getFileName(part);
        if (originalFileName == null || !originalFileName.toLowerCase().endsWith(".mp3")) {
            throw new IllegalArgumentException("只支持MP3格式的音乐文件，当前文件: " + originalFileName);
        }
        
        // 创建目录路径
        String musicDir = "music" + File.separator + albumName;
        Path dirPath = Paths.get(webPath, musicDir);
        Files.createDirectories(dirPath);
        
        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString() + "_" + originalFileName;
        
        // 保存文件
        Path filePath = dirPath.resolve(fileName);
        
        // 使用InputStream方式写入文件，更可靠
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // 验证文件是否存在
        if (!Files.exists(filePath)) {
            throw new IOException("文件上传失败");
        }
        
        // 返回相对路径
        return "music/" + albumName + "/" + fileName;
    }
    
    /**
     * 上传音乐文件并解析时长
     * @param part 文件部分
     * @param albumName 专辑名称
     * @param webPath Web应用根路径
     * @return MusicUploadResult对象，包含文件路径和时长
     */
    public static MusicUploadResult uploadMusicFileWithDuration(Part part, String albumName, String webPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        // 获取原始文件名
        String originalFileName = getFileName(part);
        if (originalFileName == null || !originalFileName.toLowerCase().endsWith(".mp3")) {
            throw new IllegalArgumentException("只支持MP3格式的音乐文件，当前文件: " + originalFileName);
        }
        
        // 创建目录路径
        String musicDir = "music" + File.separator + albumName;
        Path dirPath = Paths.get(webPath, musicDir);
        Files.createDirectories(dirPath);
        
        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString() + "_" + originalFileName;
        
        // 保存文件
        Path filePath = dirPath.resolve(fileName);
        
        // 使用InputStream方式写入文件，更可靠
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // 验证文件是否存在
        if (!Files.exists(filePath)) {
            throw new IOException("文件上传失败");
        }
        
        // 解析MP3时长
        int duration = Mp3DurationUtil.getDuration(filePath.toFile());
        
        // 返回相对路径和时长
        String relativePath = "music/" + albumName + "/" + fileName;
        return new MusicUploadResult(relativePath, duration);
    }
    
    /**
     * 音乐上传结果类
     */
    public static class MusicUploadResult {
        private String path;
        private int duration;
        
        public MusicUploadResult(String path, int duration) {
            this.path = path;
            this.duration = duration;
        }
        
        public String getPath() {
            return path;
        }
        
        public int getDuration() {
            return duration;
        }
    }
    
    /**
     * 上传封面图片到指定专辑目录
     * @param part 文件部分
     * @param albumName 专辑名称
     * @param webPath Web应用根路径
     * @return 相对路径
     */
    public static String uploadCoverImage(Part part, String albumName, String webPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        // 获取原始文件名
        String originalFileName = getFileName(part);
        if (originalFileName == null) {
            throw new IllegalArgumentException("无效的文件");
        }
        
        String lowerFileName = originalFileName.toLowerCase();
        if (!lowerFileName.endsWith(".png") && !lowerFileName.endsWith(".jpg") && !lowerFileName.endsWith(".jpeg")) {
            throw new IllegalArgumentException("只支持PNG、JPG格式的图片文件，当前文件: " + originalFileName);
        }
        
        // 创建目录路径
        String imageDir = "images" + File.separator + albumName;
        Path dirPath = Paths.get(webPath, imageDir);
        Files.createDirectories(dirPath);
        
        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString() + "_" + originalFileName;
        
        // 保存文件
        Path filePath = dirPath.resolve(fileName);
        
        // 使用InputStream方式写入文件，更可靠
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // 验证文件是否存在
        if (!Files.exists(filePath)) {
            throw new IOException("封面图片上传失败");
        }
        
        // 返回相对路径
        return "images/" + albumName + "/" + fileName;
    }
    
    /**
     * 通用文件上传方法
     * @param part 文件部分
     * @param uploadPath 上传目录的绝对路径
     * @return 文件名（不含路径）
     */
    public static String uploadFile(Part part, String uploadPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        // 获取原始文件名
        String originalFileName = getFileName(part);
        if (originalFileName == null) {
            throw new IllegalArgumentException("无效的文件");
        }
        
        // 创建目录
        Path dirPath = Paths.get(uploadPath);
        Files.createDirectories(dirPath);
        
        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString() + "_" + originalFileName;
        
        // 保存文件
        Path filePath = dirPath.resolve(fileName);
        
        // 使用InputStream方式写入文件
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // 验证文件是否存在
        if (!Files.exists(filePath)) {
            throw new IOException("文件上传失败");
        }
        
        // 返回文件名
        return fileName;
    }

    /**
     * 上传歌单封面图片
     * @param part 文件部分
     * @param playlistName 歌单名称
     * @param webPath Web应用根路径
     * @return 相对路径
     */
    public static String uploadPlaylistCover(Part part, String playlistName, String webPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        // 获取原始文件名
        String originalFileName = getFileName(part);
        if (originalFileName == null) {
            throw new IllegalArgumentException("无效的文件");
        }
        
        String lowerFileName = originalFileName.toLowerCase();
        if (!lowerFileName.endsWith(".png") && !lowerFileName.endsWith(".jpg") && !lowerFileName.endsWith(".jpeg")) {
            throw new IllegalArgumentException("只支持PNG、JPG格式的图片文件，当前文件: " + originalFileName);
        }
        
        // 创建目录路径 - 使用playlist子目录
        String imageDir = "images" + File.separator + "playlist" + File.separator + playlistName;
        Path dirPath = Paths.get(webPath, imageDir);
        Files.createDirectories(dirPath);
        
        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString() + "_" + originalFileName;
        
        // 保存文件
        Path filePath = dirPath.resolve(fileName);
        
        // 使用InputStream方式写入文件，更可靠
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // 验证文件是否存在
        if (!Files.exists(filePath)) {
            throw new IOException("歌单封面上传失败");
        }
        
        // 返回相对路径
        return "images/playlist/" + playlistName + "/" + fileName;
    }

    /**
     * 从Part中获取文件名
     */
    private static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    String fileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                    return fileName.isEmpty() ? null : fileName;
                }
            }
        }
        return null;
    }
}