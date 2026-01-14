<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 全局播放器 -->
<div class="player-bar">
    <div class="player-song">
        <div class="player-cover">🎵</div>
        <div class="player-song-info">
            <div class="player-song-title">未播放</div>
            <div class="player-song-artist">--</div>
        </div>
    </div>

    <audio id="audio-player" preload="auto"></audio>

    <div class="player-controls">
        <div class="player-buttons">
            <button class="player-btn prev-btn">⏮</button>
            <button class="player-btn play-pause-btn">⏯</button>
            <button class="player-btn next-btn">⏭</button>
        </div>
        <div class="progress-container">
            <span class="progress-time current-time">0:00</span>
            <div class="progress-bar">
                <div class="progress"></div>
            </div>
            <span class="progress-time duration">0:00</span>
        </div>
    </div>

    <div class="player-extra">
        <span class="volume-icon">🔊</span>
        <input type="range" class="volume-control" min="0" max="100" value="70">
    </div>
</div>
