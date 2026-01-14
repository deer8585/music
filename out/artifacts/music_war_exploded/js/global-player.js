// 全局播放器管理器
const GlobalPlayer = (function() {
    let currentSongIndex = -1;
    let songs = [];
    let isPlaying = false;
    let audioPlayer = null;
    let isDragging = false;
    let isInitialized = false;

    // 初始化播放器
    function init() {
        if (isInitialized) return; // 防止重复初始化
        
        audioPlayer = document.getElementById('audio-player');
        if (!audioPlayer) return;

        // 从localStorage恢复播放状态
        restorePlayerState();

        // 设置音量
        const savedVolume = localStorage.getItem('playerVolume') || 70;
        audioPlayer.volume = savedVolume / 100;
        const volumeControl = document.querySelector('.volume-control');
        if (volumeControl) {
            volumeControl.value = savedVolume;
        }

        // 绑定事件
        bindEvents();
        
        isInitialized = true;
    }

    // 绑定所有事件
    function bindEvents() {
        // 播放/暂停按钮
        const playPauseBtn = document.querySelector('.play-pause-btn');
        if (playPauseBtn) {
            playPauseBtn.addEventListener('click', togglePlayPause);
        }

        // 上一首/下一首
        const prevBtn = document.querySelector('.prev-btn');
        const nextBtn = document.querySelector('.next-btn');
        if (prevBtn) prevBtn.addEventListener('click', playPrevious);
        if (nextBtn) nextBtn.addEventListener('click', playNext);

        // 进度条拖动
        const progressBar = document.querySelector('.progress-bar');
        if (progressBar) {
            progressBar.addEventListener('mousedown', startDrag);
            progressBar.addEventListener('click', seekTo);
        }
        document.addEventListener('mousemove', onDrag);
        document.addEventListener('mouseup', stopDrag);

        // 音量控制
        const volumeControl = document.querySelector('.volume-control');
        if (volumeControl) {
            volumeControl.addEventListener('input', function() {
                audioPlayer.volume = this.value / 100;
                localStorage.setItem('playerVolume', this.value);
                updateVolumeIcon(this.value);
            });
        }

        // 音频事件
        audioPlayer.addEventListener('timeupdate', updateProgressBar);
        audioPlayer.addEventListener('ended', playNext);
        audioPlayer.addEventListener('loadedmetadata', function() {
            const duration = document.querySelector('.duration');
            if (duration) {
                duration.textContent = formatTime(audioPlayer.duration);
            }
        });

        // 页面卸载前保存状态
        window.addEventListener('beforeunload', savePlayerState);

        // 初始化音量图标
        const volumeValue = volumeControl ? volumeControl.value : 70;
        updateVolumeIcon(volumeValue);
    }

    // 开始拖动进度条
    function startDrag(e) {
        if (currentSongIndex === -1) return;
        isDragging = true;
        e.preventDefault();
    }

    // 拖动中
    function onDrag(e) {
        if (!isDragging) return;
        const progressBar = document.querySelector('.progress-bar');
        if (!progressBar) return;
        
        const rect = progressBar.getBoundingClientRect();
        const percent = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
        const progress = document.querySelector('.progress');
        if (progress) {
            progress.style.width = `${percent * 100}%`;
        }
    }

    // 停止拖动
    function stopDrag(e) {
        if (!isDragging) return;
        isDragging = false;
        
        const progressBar = document.querySelector('.progress-bar');
        if (!progressBar) return;
        
        const rect = progressBar.getBoundingClientRect();
        const percent = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
        if (audioPlayer && audioPlayer.duration) {
            audioPlayer.currentTime = percent * audioPlayer.duration;
        }
    }

    // 点击进度条跳转
    function seekTo(e) {
        if (currentSongIndex === -1 || isDragging) return;
        
        const progressBar = document.querySelector('.progress-bar');
        if (!progressBar) return;
        
        const rect = progressBar.getBoundingClientRect();
        const percent = (e.clientX - rect.left) / rect.width;
        if (audioPlayer && audioPlayer.duration) {
            audioPlayer.currentTime = percent * audioPlayer.duration;
        }
    }

    // 更新音量图标
    function updateVolumeIcon(volume) {
        const volumeIcon = document.querySelector('.volume-icon');
        if (!volumeIcon) return;
        
        if (volume == 0) {
            volumeIcon.textContent = '🔇';
        } else if (volume < 30) {
            volumeIcon.textContent = '🔈';
        } else if (volume < 70) {
            volumeIcon.textContent = '🔉';
        } else {
            volumeIcon.textContent = '🔊';
        }
    }

    // 设置歌曲列表（不自动播放，不打断当前播放）
    function setSongs(songList) {
        // 只有当传入的歌曲列表不为空时才更新
        if (songList && songList.length > 0) {
            songs = songList;
            // 高亮当前播放的歌曲（如果在新列表中）
            highlightCurrentSong();
            // 更新所有播放按钮的图标
            updatePlayButtons();
        }
        // 如果传入空列表，保持当前歌曲列表不变
    }

    // 播放指定索引的歌曲
    function playSong(index) {
        if (index < 0 || index >= songs.length) return;

        currentSongIndex = index;
        const song = songs[index];

        // 更新播放器显示
        const titleEl = document.querySelector('.player-song-title');
        const artistEl = document.querySelector('.player-song-artist');
        const durationEl = document.querySelector('.duration');
        
        if (titleEl) titleEl.textContent = song.title;
        if (artistEl) artistEl.textContent = song.artist;
        if (durationEl) durationEl.textContent = formatTime(song.duration);

        // 设置音频源并播放
        audioPlayer.src = song.path;
        audioPlayer.play().then(() => {
            isPlaying = true;
            const playPauseBtn = document.querySelector('.play-pause-btn');
            if (playPauseBtn) playPauseBtn.textContent = '⏸';
            
            // 更新所有播放按钮的图标
            updatePlayButtons();
            
            // 增加播放量
            incrementPlayCount(song.id);
        }).catch(err => {
            console.error('播放失败:', err);
        });

        // 高亮当前播放的歌曲
        highlightCurrentSong();

        // 保存播放状态
        savePlayerState();
    }

    // 高亮当前播放的歌曲
    function highlightCurrentSong() {
        const allRows = document.querySelectorAll('.song-list tr');
        allRows.forEach(tr => {
            tr.classList.remove('playing');
        });

        if (currentSongIndex >= 0 && songs[currentSongIndex]) {
            const currentSong = songs[currentSongIndex];
            allRows.forEach(tr => {
                const songId = tr.getAttribute('data-song-id');
                if (songId == currentSong.id) {
                    tr.classList.add('playing');
                }
            });
        }
    }

    // 更新所有播放按钮的图标
    function updatePlayButtons() {
        const allPlayBtns = document.querySelectorAll('.play-btn');
        allPlayBtns.forEach(btn => {
            const songId = btn.getAttribute('data-song-id');
            if (currentSongIndex >= 0 && songs[currentSongIndex] && songId == songs[currentSongIndex].id && isPlaying) {
                // 当前正在播放的歌曲显示暂停图标
                btn.textContent = '⏸';
            } else {
                // 其他歌曲显示播放图标
                btn.textContent = '▶';
            }
        });
    }

    // 播放/暂停切换
    function togglePlayPause() {
        if (currentSongIndex === -1) {
            if (songs.length > 0) {
                playSong(0);
            }
            return;
        }

        if (isPlaying) {
            audioPlayer.pause();
            isPlaying = false;
            const playPauseBtn = document.querySelector('.play-pause-btn');
            if (playPauseBtn) playPauseBtn.textContent = '⏯';
            // 更新所有播放按钮的图标
            updatePlayButtons();
        } else {
            audioPlayer.play().then(() => {
                isPlaying = true;
                const playPauseBtn = document.querySelector('.play-pause-btn');
                if (playPauseBtn) playPauseBtn.textContent = '⏸';
                // 更新所有播放按钮的图标
                updatePlayButtons();
            }).catch(err => {
                console.error('播放失败:', err);
            });
        }
        
        savePlayerState();
    }

    // 播放上一首
    function playPrevious() {
        if (songs.length === 0) return;
        const newIndex = (currentSongIndex - 1 + songs.length) % songs.length;
        playSong(newIndex);
    }

    // 播放下一首
    function playNext() {
        if (songs.length === 0) return;
        const newIndex = (currentSongIndex + 1) % songs.length;
        playSong(newIndex);
    }

    // 更新进度条
    function updateProgressBar() {
        if (isDragging) return; // 拖动时不更新
        
        const progress = document.querySelector('.progress');
        const currentTime = document.querySelector('.current-time');

        if (audioPlayer && audioPlayer.duration) {
            const percent = (audioPlayer.currentTime / audioPlayer.duration) * 100;
            if (progress) progress.style.width = `${percent}%`;
            if (currentTime) currentTime.textContent = formatTime(audioPlayer.currentTime);
        }
    }

    // 格式化时间（秒 → MM:SS）
    function formatTime(seconds) {
        if (isNaN(seconds) || seconds === null || seconds === undefined) return '0:00';
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return `${mins}:${secs < 10 ? '0' + secs : secs}`;
    }

    // 保存播放器状态到localStorage
    function savePlayerState() {
        try {
            const state = {
                currentSongIndex: currentSongIndex,
                currentTime: audioPlayer ? audioPlayer.currentTime : 0,
                isPlaying: isPlaying,
                songs: songs
            };
            localStorage.setItem('playerState', JSON.stringify(state));
        } catch (e) {
            console.error('保存播放状态失败:', e);
        }
    }

    // 从localStorage恢复播放器状态（只恢复显示，不自动播放）
    function restorePlayerState() {
        const savedState = localStorage.getItem('playerState');
        if (!savedState) return;

        try {
            const state = JSON.parse(savedState);
            songs = state.songs || [];
            currentSongIndex = state.currentSongIndex || -1;

            if (currentSongIndex >= 0 && songs[currentSongIndex]) {
                const song = songs[currentSongIndex];
                
                // 只更新显示信息，不加载音频
                const titleEl = document.querySelector('.player-song-title');
                const artistEl = document.querySelector('.player-song-artist');
                const durationEl = document.querySelector('.duration');
                
                if (titleEl) titleEl.textContent = song.title;
                if (artistEl) artistEl.textContent = song.artist;
                if (durationEl) durationEl.textContent = formatTime(song.duration);
                
                // 如果之前在播放，则恢复播放
                if (state.isPlaying) {
                    audioPlayer.src = song.path;
                    audioPlayer.currentTime = state.currentTime || 0;
                    
                    // 尝试自动播放（可能会被浏览器阻止）
                    audioPlayer.play().then(() => {
                        isPlaying = true;
                        const playPauseBtn = document.querySelector('.play-pause-btn');
                        if (playPauseBtn) playPauseBtn.textContent = '⏸';
                        // 更新所有播放按钮的图标
                        updatePlayButtons();
                    }).catch(() => {
                        // 自动播放被阻止，显示暂停状态
                        isPlaying = false;
                        const playPauseBtn = document.querySelector('.play-pause-btn');
                        if (playPauseBtn) playPauseBtn.textContent = '⏯';
                        // 更新所有播放按钮的图标
                        updatePlayButtons();
                    });
                } else {
                    // 不在播放状态，只设置音频源但不播放
                    audioPlayer.src = song.path;
                    audioPlayer.currentTime = state.currentTime || 0;
                    isPlaying = false;
                    const playPauseBtn = document.querySelector('.play-pause-btn');
                    if (playPauseBtn) playPauseBtn.textContent = '⏯';
                    // 更新所有播放按钮的图标
                    updatePlayButtons();
                }

                // 高亮当前播放的歌曲
                highlightCurrentSong();
            }
        } catch (e) {
            console.error('恢复播放器状态失败:', e);
        }
    }

    // 根据歌曲ID播放
    function playSongById(songId) {
        const index = songs.findIndex(s => s.id == songId);
        if (index >= 0) {
            playSong(index);
        }
    }

    // 公开的API
    return {
        init: init,
        setSongs: setSongs,
        playSong: playSong,
        playSongById: playSongById,
        getCurrentSong: () => songs[currentSongIndex],
        getSongs: () => songs
    };
})();

// 增加播放量
function incrementPlayCount(songId) {
    fetch('incrementPlayCount', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'songId=' + songId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            console.log('播放量+1');
        } else {
            console.error('播放量增加失败:', data.message);
        }
    })
    .catch(error => {
        console.error('请求失败:', error);
    });
}

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    GlobalPlayer.init();
});
