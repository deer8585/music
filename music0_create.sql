create schema music0 collate utf8mb4_0900_ai_ci;
use music0;

-- 用户表
-- auto-generated definition
create table users
(
    id            int auto_increment
        primary key,
    username      varchar(64)                              not null,
    password_hash varchar(32)                             not null,
    role          varchar(64)  default 'user'              null,
    avatar        varchar(64) default 'images/avatar.png' null,
    created_at    timestamp    default CURRENT_TIMESTAMP   null,
    nickname      varchar(50)  default username            null,
    gender        varchar(10)                              null,
    signature     varchar(32)                             null,
    constraint username
        unique (username)
);

-- 插入默认管理员用户（如果不存在）
INSERT IGNORE INTO users (username, password_hash, role, avatar)
VALUES ('admin', 'admin123', 'admin', 'images/admin-avatar.png');
-- 插入默认普通用户（如果不存在）
INSERT IGNORE INTO users (username, password_hash, role, avatar)
VALUES ('user', 'user123', 'user', 'images/user-avatar.png');

-- 歌曲表
-- auto-generated definition
create table music
(
    id             int auto_increment
        primary key,
    title          varchar(32)                        not null,
    artist         varchar(16)                        not null,
    album          varchar(32)                        null,
    duration       int                                 not null,
    path           varchar(64)                        not null,
    release_time   datetime  default CURRENT_TIMESTAMP null,
    play_count     int       default 0                 null,
    favorite_count int       default 0                 null,
    like_count     int       default 0                 null,
    comment_count  int       default 0                 null,
    created_at     timestamp default CURRENT_TIMESTAMP null,
    cover_path     varchar(64)                        null comment '封面图片路径'
);



-- 我的收藏表
-- auto-generated definition
create table favorites
(
    user_id    int                                 not null,
    song_id    int                                 not null,
    created_at timestamp default CURRENT_TIMESTAMP null,
    primary key (user_id, song_id),
    constraint favorites_ibfk_1
        foreign key (user_id) references users (id)
            on delete cascade,
    constraint favorites_ibfk_2
        foreign key (song_id) references music (id)
            on delete cascade
);

create index song_id
    on favorites (song_id);

# -- 为测试用户添加一些收藏（假设用户ID为2）
# -- 注意：请根据实际的用户ID和歌曲ID调整
# INSERT IGNORE INTO favorites (user_id, song_id) VALUES
# (2, 1),
# (2, 2),
# (2, 3);

-- 我的歌单表
-- auto-generated definition
create table playlists
(
    id          int auto_increment
        primary key,
    user_id     int                                      not null,
    name        varchar(32)                             not null,
    description text                                     null,
    cover_path  varchar(64) default 'images/avatar.png' null,
    song_count  int          default 0                   null,
    created_at  timestamp    default CURRENT_TIMESTAMP   null,
    updated_at  timestamp    default CURRENT_TIMESTAMP   null on update CURRENT_TIMESTAMP,
    constraint playlists_ibfk_1
        foreign key (user_id) references users (id)
            on delete cascade
);

create index user_id
    on playlists (user_id);

-- 歌单歌曲关联表
-- auto-generated definition
create table playlist_songs
(
    playlist_id int                                 not null,
    song_id     int                                 not null,
    added_at    timestamp default CURRENT_TIMESTAMP null,
    primary key (playlist_id, song_id),
    constraint playlist_songs_ibfk_1
        foreign key (playlist_id) references playlists (id)
            on delete cascade,
    constraint playlist_songs_ibfk_2
        foreign key (song_id) references music (id)
            on delete cascade
);

create index song_id
    on playlist_songs (song_id);


-- 评论表
-- auto-generated definition
create table comments
(
    id          int auto_increment
        primary key,
    user_id     int                                 not null,
    song_id     int                                 not null,
    content     text                                not null,
    created_at  timestamp default CURRENT_TIMESTAMP null,
    is_featured tinyint   default 0                 null,
    constraint comments_ibfk_1
        foreign key (user_id) references users (id)
            on delete cascade,
    constraint comments_ibfk_2
        foreign key (song_id) references music (id)
            on delete cascade
);

create index song_id
    on comments (song_id);

create index user_id
    on comments (user_id);


-- 为歌曲添加评论
INSERT INTO comments (user_id, song_id, content, created_at, is_featured) VALUES
(7, 2, '江南水乡的韵味尽在这首歌中，林俊杰的声音太有感染力了！', '2025-12-10 15:40:00', 1),
(8, 2, '风到这里就是粘，粘住过客的思念...永远的经典！听了十几年了！', '2025-12-11 14:25:00', 0),
(5, 3, '美人鱼的爱情故事，旋律优美动听，林俊杰的情歌总是这么动人。', '2025-12-12 13:10:00', 0),
(6, 4, '茉莉雨的意境很美，JJ的创作能力越来越强了！', '2025-12-13 10:05:00', 0),
(7, 5, '刚刚好的爱情，刚刚好的距离，薛之谦的情歌总是这么戳心。', '2025-12-10 17:30:00', 1),
(8, 6, '天外来物，我的单曲循环！老薛的歌词写得太好了！', '2025-12-11 19:45:00', 1),
(5, 7, '怪咖的旋律很特别，薛之谦的独特风格，喜欢！', '2025-12-12 20:15:00', 0),
(6, 8, '周杰伦的经典之作，前奏一响就让人回到青春时代！', '2025-12-13 14:30:00', 1),
(7, 9, '最美的不是下雨天，是曾与你躲过雨的屋檐。这句歌词太经典了！', '2025-12-12 16:45:00', 1),
(8, 10, '稻香是对故乡的怀念，每次听都觉得很温暖。', '2025-12-13 11:20:00', 0),
(5, 11, '花海的旋律太美了，周杰伦的才华真的无可挑剔！', '2025-12-14 09:30:00', 0),
(6, 12, '周深的声音就像天籁，大鱼这首歌被他演绎得太完美了！', '2025-12-11 21:30:00', 1),
(7, 13, '王菲的空灵嗓音，如愿这首歌让人感动。', '2025-12-12 22:10:00', 0);

-- 添加更多评论
INSERT INTO comments (user_id, song_id, content, created_at, is_featured) VALUES
(8, 1, '凤凰传奇的经典作品，广场舞神曲！太有节奏感了！', '2025-12-10 14:30:00', 1),
(5, 2, 'JJ的成名曲，华语乐坛的经典之作！', '2025-12-12 16:30:00', 0),
(6, 3, '喜欢这首歌的编曲，很有意境！', '2025-12-13 14:20:00', 0),
(7, 4, '中国风歌曲，很有味道！', '2025-12-14 11:15:00', 0),
(8, 5, '薛之谦的歌词写得真好，句句入心！', '2025-12-11 18:45:00', 0),
(5, 6, '薛之谦最近几年的作品质量都很高！', '2025-12-12 20:30:00', 0),
(6, 7, '这首比较小众但很好听！', '2025-12-13 21:10:00', 0),
(7, 8, '窗外的麻雀在电线杆上多嘴...青春的记忆！', '2025-12-14 15:20:00', 0),
(8, 8, '周董早期的作品真是百听不厌！', '2025-12-15 16:10:00', 1),
(5, 8, '七里香，永远的经典！', '2025-12-16 17:05:00', 0),
(6, 9, '周杰伦早期作品中的经典，百听不厌！', '2025-12-13 17:30:00', 0),
(7, 9, '前奏一响，回忆就涌上来了！', '2025-12-14 18:25:00', 0),
(8, 10, '这首歌很有正能量，鼓励大家勇敢向前！', '2025-12-14 12:15:00', 0),
(5, 11, '周董的中国风歌曲都很好听！', '2025-12-15 10:25:00', 0),
(6, 12, '国风音乐的经典之作，周深的嗓音太独特了！', '2025-12-12 22:15:00', 0),
(7, 12, '电影《大鱼海棠》的主题曲，画面感很强！', '2025-12-13 23:10:00', 1),
(8, 12, '周深的空灵嗓音，无人能及！', '2025-12-14 20:05:00', 0),
(5, 13, '电影《我和我的父辈》的主题曲，很有意义的一首歌。', '2025-12-13 19:40:00', 0),
(6, 13, '王菲的歌声还是那么有穿透力！', '2025-12-14 21:30:00', 0);

-- 自动统计并更新所有歌曲的评论数
UPDATE music m
SET comment_count = (
    SELECT COUNT(*)
    FROM comments c
    WHERE c.song_id = m.id
)
WHERE 1=1;



-- 插入歌曲数据
INSERT INTO music (title, artist, album, duration, path, release_time, play_count, favorite_count, like_count, comment_count, created_at, cover_path) VALUES
('奢香夫人', '凤凰传奇', '', 17, 'music//2d98ed53-305c-4363-bc32-e55001f0e786_奢香夫人.mp3', '2025-12-17 16:14:07', 0, 0, 0, 0, '2025-12-17 16:14:07', 'images//d035920c-7db2-404c-9fc0-0342eef084c8_奢香夫人.png'),
('江南', '林俊杰', '第二天堂', 268, 'music/第二天堂/8e8d5551-5b85-4c62-bac6-7c65dbf35ff8_江南.mp3', '2025-12-17 16:24:47', 0, 0, 0, 0, '2025-12-17 16:24:47', 'images/第二天堂/ad558688-37fd-4945-8a1e-fbf26026a77b_第二天堂.png'),
('美人鱼', '林俊杰', '第二天堂', 254, 'music/第二天堂/ff9e389f-7961-4dd1-b3bc-56af23fcd746_美人鱼.mp3', '2025-12-17 16:24:47', 0, 0, 0, 0, '2025-12-17 16:24:47', 'images/第二天堂/92783deb-a04f-4fc6-a978-c5b0e8c7fd29_第二天堂.png'),
('茉莉雨', '林俊杰', '新地球', 257, 'music/新地球/7441cd3d-da5a-47a4-8afa-b650307bee93_茉莉雨.mp3', '2025-12-17 16:24:47', 0, 0, 0, 0, '2025-12-17 16:24:47', 'images/新地球/21054f42-c083-41ee-91e1-cd3425ebf0c7_新地球.png'),
('刚刚好', '薛之谦', '初学者', 251, 'music/初学者/1f68e382-d18f-475b-a19c-82d7db3b4300_刚刚好.mp3', '2025-12-17 16:24:47', 0, 0, 0, 0, '2025-12-17 16:24:47', 'images/初学者/ef8481fc-ded0-42d8-9e4b-da02428ec8fd_初学者.png'),
('天外来物', '薛之谦', '天外来物', 257, 'music/天外来物/0a2b46c2-5792-4d72-a32f-df1529d6c341_天外来物.mp3', '2025-12-17 16:24:47', 0, 0, 0, 0, '2025-12-17 16:24:47', 'images/天外来物/7c9821eb-6c10-4f67-bb7a-816d722923fc_天外来物.png'),
('怪咖', '薛之谦', '怪咖', 251, 'music/怪咖/d966aede-d188-4f89-b509-065bc6225eec_怪咖.mp3', '2025-12-17 16:24:47', 0, 0, 0, 0, '2025-12-17 16:24:47', 'images/怪咖/5d93e20b-61cf-45f4-8fdb-b4f8fc5880ec_怪咖.png'),
('七里香', '周杰伦', '七里香', 299, 'music/七里香/0444ae42-9fc4-49de-9bca-781a7c2b9d06_七里香.mp3', '2025-12-17 16:37:13', 0, 0, 0, 0, '2025-12-17 16:37:13', 'images/七里香/119405d1-6079-44ae-a9bf-8fa82fd2c17c_七里香.png'),
('晴天', '周杰伦', '叶惠美', 270, 'music/叶惠美/cf07a03f-7442-4d78-8f7e-334035a6afcb_晴天.mp3', '2025-12-17 16:37:13', 0, 0, 0, 0, '2025-12-17 16:37:13', 'images/叶惠美/a8faff1d-ac81-4d64-a59c-0a0cba825a68_叶惠美.png'),
('稻香', '周杰伦', '魔杰座', 224, 'music/魔杰座/122b28c7-065d-4375-8039-b9894739325d_稻香.mp3', '2025-12-17 16:37:13', 0, 0, 0, 0, '2025-12-17 16:37:13', 'images/魔杰座/8791e733-2d06-45d3-a234-8b616f179e48_魔杰座.png'),
('花海', '周杰伦', '魔杰座', 265, 'music/魔杰座/bf117f23-4b9e-46ba-b052-7ce8b0ec4e09_花海.mp3', '2025-12-17 16:37:13', 0, 0, 0, 0, '2025-12-17 16:37:13', 'images/魔杰座/95457c94-49fb-433d-bae5-71941a658bb6_魔杰座.png'),
('大鱼', '周深', '大鱼', 23, 'music/大鱼/6764126d-d5f0-4ebe-a2bc-8cfa2a41525d_大鱼.mp3', '2025-12-17 16:37:13', 0, 0, 0, 0, '2025-12-17 16:37:13', 'images/大鱼/cf160f83-5307-43cf-b986-720d23560a58_大鱼.png'),
('如愿', '王菲', '', 20, 'music//6853669c-684c-458b-978c-deaee7b6a9b5_如愿.mp3', '2025-12-17 19:25:26', 0, 0, 0, 0, '2025-12-17 19:25:26', 'images//2e942bbd-61c9-41f1-b8b8-fd028016d0c7_如愿.png');

-- 更新所有歌单的歌曲数量
UPDATE playlists p
SET song_count = (
    SELECT COUNT(*)
    FROM playlist_songs ps
    WHERE ps.playlist_id = p.id
)
WHERE 1=1;

-- 查看更新结果
SELECT
    p.id,
    p.name,
    p.song_count AS '显示的歌曲数',
    (SELECT COUNT(*) FROM playlist_songs ps WHERE ps.playlist_id = p.id) AS '实际歌曲数'
FROM playlists p
ORDER BY p.id;
