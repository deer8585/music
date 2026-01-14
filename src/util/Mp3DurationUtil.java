package util;

import java.io.*;

/**
 * MP3时长解析工具类
 * 通过读取MP3文件头信息计算音频时长
 */
public class Mp3DurationUtil {
    
    // MPEG版本
    private static final int[][] BITRATES = {
        // MPEG 1
        {0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448},
        // MPEG 2
        {0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384},
        // MPEG 2.5
        {0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320}
    };
    
    private static final int[][] SAMPLE_RATES = {
        {44100, 48000, 32000}, // MPEG 1
        {22050, 24000, 16000}, // MPEG 2
        {11025, 12000, 8000}   // MPEG 2.5
    };
    
    /**
     * 从MP3文件中解析时长（秒）
     * @param file MP3文件
     * @return 时长（秒），解析失败返回0
     */
    public static int getDuration(File file) {
        try (RandomAccessFile raf = new RandomAccessFile(file, "r")) {
            long fileLength = raf.length();
            
            // 跳过ID3v2标签
            long audioStart = skipId3v2Tag(raf);
            raf.seek(audioStart);
            
            // 查找第一个有效的MP3帧
            byte[] header = new byte[4];
            long position = audioStart;
            int frameCount = 0;
            int sampleRate = 0;
            int mpegVersion = 0;
            int layer = 0;
            
            // 扫描所有帧来精确计算时长
            while (position < fileLength - 4) {
                raf.seek(position);
                if (raf.read(header) != 4) break;
                
                if (isValidMp3Header(header)) {
                    // 解析帧头信息
                    mpegVersion = getMpegVersion(header);
                    layer = getLayer(header);
                    int bitrate = getBitrate(header, mpegVersion, layer);
                    sampleRate = getSampleRate(header, mpegVersion);
                    int padding = (header[2] & 0x02) >> 1;
                    
                    if (bitrate > 0 && sampleRate > 0) {
                        // 计算当前帧长度
                        int frameLength;
                        if (layer == 1) {
                            frameLength = (12 * bitrate * 1000 / sampleRate + padding) * 4;
                        } else {
                            frameLength = 144 * bitrate * 1000 / sampleRate + padding;
                        }
                        
                        frameCount++;
                        position += frameLength;
                        
                        // 为了性能，扫描前100帧后使用估算
                        if (frameCount >= 100) {
                            // 基于前100帧估算总帧数
                            long scannedBytes = position - audioStart;
                            long totalAudioBytes = fileLength - audioStart;
                            frameCount = (int) ((double) frameCount * totalAudioBytes / scannedBytes);
                            break;
                        }
                    } else {
                        position++;
                    }
                } else {
                    position++;
                }
            }
            
            if (frameCount > 0 && sampleRate > 0) {
                // 每帧的样本数
                int samplesPerFrame;
                if (mpegVersion == 0) { // MPEG 1
                    samplesPerFrame = (layer == 1) ? 384 : 1152;
                } else { // MPEG 2/2.5
                    samplesPerFrame = (layer == 1) ? 384 : 576;
                }
                
                // 计算总时长：总样本数 / 采样率
                double duration = (double) (frameCount * samplesPerFrame) / sampleRate;
                return (int) Math.round(duration);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * 从InputStream解析MP3时长
     * @param inputStream 输入流
     * @param fileSize 文件大小
     * @return 时长（秒）
     */
    public static int getDuration(InputStream inputStream, long fileSize) {
        try {
            // 将InputStream转换为临时文件
            File tempFile = File.createTempFile("mp3_temp_", ".mp3");
            tempFile.deleteOnExit();
            
            try (FileOutputStream fos = new FileOutputStream(tempFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }
            
            return getDuration(tempFile);
            
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 跳过ID3v2标签
     */
    private static long skipId3v2Tag(RandomAccessFile raf) throws IOException {
        raf.seek(0);
        byte[] id3Header = new byte[10];
        
        if (raf.read(id3Header) == 10) {
            // 检查ID3v2标签
            if (id3Header[0] == 'I' && id3Header[1] == 'D' && id3Header[2] == '3') {
                // 计算标签大小
                int size = ((id3Header[6] & 0x7F) << 21) |
                          ((id3Header[7] & 0x7F) << 14) |
                          ((id3Header[8] & 0x7F) << 7) |
                          (id3Header[9] & 0x7F);
                return size + 10;
            }
        }
        
        return 0;
    }
    
    /**
     * 检查是否为有效的MP3帧头
     */
    private static boolean isValidMp3Header(byte[] header) {
        // 帧同步字：前11位必须全为1
        return (header[0] & 0xFF) == 0xFF && (header[1] & 0xE0) == 0xE0;
    }
    
    /**
     * 获取MPEG版本
     */
    private static int getMpegVersion(byte[] header) {
        int version = (header[1] & 0x18) >> 3;
        if (version == 3) return 0; // MPEG 1
        if (version == 2) return 1; // MPEG 2
        if (version == 0) return 2; // MPEG 2.5
        return 0;
    }
    
    /**
     * 获取层
     */
    private static int getLayer(byte[] header) {
        int layer = (header[1] & 0x06) >> 1;
        return 4 - layer; // Layer I=1, Layer II=2, Layer III=3
    }
    
    /**
     * 获取比特率
     */
    private static int getBitrate(byte[] header, int mpegVersion, int layer) {
        int bitrateIndex = (header[2] & 0xF0) >> 4;
        if (bitrateIndex == 0 || bitrateIndex == 15) return 0;
        
        // 根据MPEG版本和层选择正确的比特率表
        if (mpegVersion == 0) { // MPEG 1
            if (layer == 1) { // Layer I
                int[] rates = {0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448};
                return rates[bitrateIndex];
            } else if (layer == 2) { // Layer II
                int[] rates = {0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384};
                return rates[bitrateIndex];
            } else { // Layer III
                int[] rates = {0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320};
                return rates[bitrateIndex];
            }
        } else { // MPEG 2/2.5
            if (layer == 1) { // Layer I
                int[] rates = {0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256};
                return rates[bitrateIndex];
            } else { // Layer II & III
                int[] rates = {0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160};
                return rates[bitrateIndex];
            }
        }
    }
    
    /**
     * 获取采样率
     */
    private static int getSampleRate(byte[] header, int mpegVersion) {
        int sampleRateIndex = (header[2] & 0x0C) >> 2;
        if (sampleRateIndex == 3) return 0;
        return SAMPLE_RATES[mpegVersion][sampleRateIndex];
    }
}
