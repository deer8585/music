package servlet;

import dao.MusicDAO;
import entity.Music;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import util.FileUploadUtil;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.text.ParseException;


@WebServlet(name = "MusicServlet", value = "/MusicServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 100   // 100MB
)
public class MusicServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    //处理GET请求 - 音乐管理相关操作
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        
        if ("manage".equals(action)) {
            // 音乐管理页面
            handleManagePage(req, resp);
        } else if ("delete".equals(action)) {
            // 删除音乐
            handleDeleteMusic(req, resp);
        } else if ("edit".equals(action)) {
            // 编辑音乐页面
            handleEditPage(req, resp);
        } else if ("search".equals(action)) {
            // 搜索音乐
            handleSearchMusic(req, resp);
        } else if ("getAll".equals(action)) {
            List<Music> musicList = musicDAO.getAllMusic();
            req.setAttribute("musicList", musicList);
            req.getRequestDispatcher("/addMusic.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/addMusic.jsp").forward(req, resp);
        }
    }

    //处理POST请求 - 添加和更新音乐
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        
        if ("update".equals(action)) {
            // 更新音乐信息
            handleUpdateMusic(req, resp);
        } else {
            // 默认为添加音乐
            handleAddMusic(req, resp);
        }
    }
    
    // 添加音乐处理方法
    private void handleAddMusic(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 获取表单参数
            String title = req.getParameter("title");
            String artist = req.getParameter("artist");
            String album = req.getParameter("album");
            
            // 获取Web应用根路径
            String webPath = getServletContext().getRealPath("/");
            
            // 处理文件上传
            Part musicFilePart = req.getPart("musicFile");
            Part coverFilePart = req.getPart("coverFile");
            
            // 上传音乐文件并自动解析时长
            FileUploadUtil.MusicUploadResult uploadResult = FileUploadUtil.uploadMusicFileWithDuration(musicFilePart, album, webPath);
            if (uploadResult == null) {
                throw new IllegalArgumentException("音乐文件是必须的，请选择MP3文件");
            }
            
            String musicPath = uploadResult.getPath();
            int duration = uploadResult.getDuration();
            
            // 如果用户手动输入了时长，使用用户输入的值（可选）
            String durationParam = req.getParameter("duration");
            if (durationParam != null && !durationParam.trim().isEmpty()) {
                try {
                    int manualDuration = Integer.parseInt(durationParam);
                    if (manualDuration > 0) {
                        duration = manualDuration;
                    }
                } catch (NumberFormatException e) {
                    // 忽略，使用自动解析的时长
                }
            }
            
            // 上传封面图片（可选）
            String coverPath = FileUploadUtil.uploadCoverImage(coverFilePart, album, webPath);

            // 设置默认值
            int playCount = 0; // 播放量默认为0

            // 创建Music对象
            Music music = new Music();
            music.setTitle(title);
            music.setArtist(artist);
            music.setAlbum(album);
            music.setDuration(duration);
            music.setPath(musicPath);
            music.setCoverPath(coverPath);
            music.setReleaseTime(new Date()); // 设置为当前时间
            music.setPlayCount(playCount);
            music.setFavoriteCount(0);
            music.setLikeCount(0);
            music.setCommentCount(0);

            // 添加到数据库
            musicDAO.addMusic(music);

            // 检查是否成功获取生成的ID
            Long generatedId = music.getId();
            if (generatedId != null && generatedId > 0) {
                req.setAttribute("message", "歌曲添加成功！ID：" + generatedId + "，时长：" + duration + "秒");
            } else {
                req.setAttribute("message", "歌曲添加成功，但无法获取自动生成的ID");
            }

            req.getRequestDispatcher("/success.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            req.setAttribute("error", "参数格式错误：" + e.getMessage());
            req.getRequestDispatcher("/addMusic.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "添加歌曲失败：" + e.getMessage());
            req.getRequestDispatcher("/addMusic.jsp").forward(req, resp);
        }
    }
    
    // 音乐管理页面处理
    private void handleManagePage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int page = 1;
            int pageSize = 10;
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            int totalCount = musicDAO.getMusicCount();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            List<Music> musicList = musicDAO.getMusicByPage(page, pageSize);
            
            req.setAttribute("musicList", musicList);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);
            req.getRequestDispatcher("/musicManage.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "获取音乐列表失败：" + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
    
    // 删除音乐处理
    private void handleDeleteMusic(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            long id = Long.parseLong(req.getParameter("id"));
            boolean success = musicDAO.deleteMusic(id);
            
            if (success) {
                req.setAttribute("message", "音乐删除成功！");
            } else {
                req.setAttribute("error", "音乐删除失败！");
            }
            
            // 重新加载音乐列表
            List<Music> musicList = musicDAO.getAllMusic();
            req.setAttribute("musicList", musicList);
            req.getRequestDispatcher("/musicManage.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "删除音乐失败：" + e.getMessage());
            List<Music> musicList = musicDAO.getAllMusic();
            req.setAttribute("musicList", musicList);
            req.getRequestDispatcher("/musicManage.jsp").forward(req, resp);
        }
    }
    
    // 编辑音乐页面处理
    private void handleEditPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            long id = Long.parseLong(req.getParameter("id"));
            Music music = musicDAO.getMusicById(id);
            
            if (music != null) {
                req.setAttribute("music", music);
                req.getRequestDispatcher("/editMusic.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "未找到指定的音乐！");
                handleManagePage(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "获取音乐信息失败：" + e.getMessage());
            handleManagePage(req, resp);
        }
    }
    
    // 搜索音乐处理
    private void handleSearchMusic(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String keyword = req.getParameter("keyword");
            List<Music> musicList;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                musicList = musicDAO.searchMusic(keyword.trim());
                req.setAttribute("keyword", keyword);
            } else {
                musicList = musicDAO.getAllMusic();
            }
            
            req.setAttribute("musicList", musicList);
            req.getRequestDispatcher("/musicManage.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "搜索音乐失败：" + e.getMessage());
            List<Music> musicList = musicDAO.getAllMusic();
            req.setAttribute("musicList", musicList);
            req.getRequestDispatcher("/musicManage.jsp").forward(req, resp);
        }
    }
    
    // 更新音乐处理
    private void handleUpdateMusic(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            long id = Long.parseLong(req.getParameter("id"));
            String title = req.getParameter("title");
            String artist = req.getParameter("artist");
            String album = req.getParameter("album");
            
            Music music = musicDAO.getMusicById(id);
            if (music != null) {
                music.setTitle(title);
                music.setArtist(artist);
                music.setAlbum(album);
                
                // 处理文件上传（如果有新文件）
                String webPath = getServletContext().getRealPath("/");
                Part musicFilePart = req.getPart("musicFile");
                Part coverFilePart = req.getPart("coverFile");
                
                // 如果上传了新的音乐文件，自动解析时长
                if (musicFilePart != null && musicFilePart.getSize() > 0) {
                    FileUploadUtil.MusicUploadResult uploadResult = FileUploadUtil.uploadMusicFileWithDuration(musicFilePart, album, webPath);
                    if (uploadResult != null) {
                        music.setPath(uploadResult.getPath());
                        music.setDuration(uploadResult.getDuration());
                    }
                } else {
                    // 如果没有上传新文件，检查是否手动修改了时长
                    String durationParam = req.getParameter("duration");
                    if (durationParam != null && !durationParam.trim().isEmpty()) {
                        try {
                            int duration = Integer.parseInt(durationParam);
                            music.setDuration(duration);
                        } catch (NumberFormatException e) {
                            // 保持原有时长
                        }
                    }
                }
                
                if (coverFilePart != null && coverFilePart.getSize() > 0) {
                    String coverPath = FileUploadUtil.uploadCoverImage(coverFilePart, album, webPath);
                    if (coverPath != null) {
                        music.setCoverPath(coverPath);
                    }
                }
                
                boolean success = musicDAO.updateMusic(music);
                
                if (success) {
                    req.setAttribute("message", "音乐更新成功！");
                } else {
                    req.setAttribute("error", "音乐更新失败！");
                }
            } else {
                req.setAttribute("error", "未找到指定的音乐！");
            }
            
            handleManagePage(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "更新音乐失败：" + e.getMessage());
            handleManagePage(req, resp);
        }
    }

}