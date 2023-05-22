CREATE OR REPLACE DATABASE astronomy_app;

CREATE OR REPLACE USER 'astronomy_app_user'@'%' IDENTIFIED BY 'pgeti';
GRANT ALL PRIVILEGES ON astronomy_app.* TO 'astronomy_app_user'@'%';
FLUSH PRIVILEGES;

USE astronomy_app;

CREATE TABLE `SECTIONS` (
  `id` integer PRIMARY KEY,
  `title` varchar(512),
  `summary` text(512),
  `photo_id` integer,
  `time_investment` integer
);

CREATE TABLE `CHAPTERS` (
  `id` integer PRIMARY KEY,
  `title` varchar(512),
  `summary` text(65535),
  `time_investment` integer,
  `sections_id` integer
);

CREATE TABLE `TOPICS` (
  `id` integer PRIMARY KEY,
  `title` varchar(512),
  `visits` integer,
  `time_investment` integer,
  `edit_date` datetime,
  `difficulty` varchar(512),
  `chapters_id` integer
);

CREATE TABLE `PARAGRAPHS` (
  `id` integer PRIMARY KEY,
  `title` varchar(512),
  `text` text(65535),
  `topics_id` integer
);

CREATE TABLE `USERS` (
  `id` integer PRIMARY KEY,
  `role` varchar(512),
  `email` varchar(512),
  `username` varchar(512),
  `password` varchar(512),
  `level` integer,
  `xp` integer,
  `user_id` integer
);

CREATE TABLE `COMPLETED_TOPICS` (
  `id` integer NOT NULL  AUTO_INCREMENT,
  `users_id` integer,
  `topics_id` integer,
  PRIMARY KEY (`id`)
);

CREATE TABLE `FAVOURITED_TOPICS` (
  `id` integer NOT NULL  AUTO_INCREMENT,
  `users_id` integer,
  `topics_id` integer,
  PRIMARY KEY (`id`)
);

CREATE TABLE `AUTHORSHIP` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `users_id` integer,
  `topics_id` integer,
  PRIMARY KEY (`id`)
);

CREATE TABLE `PHOTOS` (
  `id` integer PRIMARY KEY,
  `url` varchar(512),
  `title` varchar(512),
  `alt` varchar(512)
);

CREATE TABLE `CHAPTERS_PHOTOS` (
  `id` integer NOT NULL  AUTO_INCREMENT,
  `chapters_id` integer,
  `photos_id` integer,
  PRIMARY KEY (`id`)
);

CREATE TABLE `TOPICS_PHOTOS` (
  `id` integer NOT NULL  AUTO_INCREMENT,
  `topics_id` integer,
  `photos_id` integer,
  PRIMARY KEY (`id`)
);

CREATE TABLE `PARAGRAPHS_PHOTOS` (
  `id` integer NOT NULL  AUTO_INCREMENT,
  `paragraphs_id` integer,
  `photos_id` integer,
  PRIMARY KEY (`id`)
);

CREATE TABLE `TESTS` (
  `id` integer PRIMARY KEY,
  `title` varchar(512),
  `number_of_questions` integer,
  `chapters_id` integer
);

CREATE TABLE `QUESTIONS` (
  `id` integer PRIMARY KEY,
  `question` varchar(512),
  `photo_id` integer,
  `tests_id` integer
);

CREATE TABLE `ANSWERS` (
  `id` integer PRIMARY KEY,
  `text` varchar(512),
  `is_correct` boolean,
  `photo_id` integer,
  `questions_id` integer
);

CREATE TABLE `SCORES` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `score` integer,
  `date` datetime,
  `users_id` integer,
  `tests_id` integer,
  PRIMARY KEY (`id`)
);

ALTER TABLE `SECTIONS` ADD FOREIGN KEY (`photo_id`) REFERENCES `PHOTOS` (`id`);

ALTER TABLE `CHAPTERS` ADD FOREIGN KEY (`sections_id`) REFERENCES `SECTIONS` (`id`);

ALTER TABLE `TOPICS` ADD FOREIGN KEY (`chapters_id`) REFERENCES `CHAPTERS` (`id`);

ALTER TABLE `PARAGRAPHS` ADD FOREIGN KEY (`topics_id`) REFERENCES `TOPICS` (`id`);

ALTER TABLE `COMPLETED_TOPICS` ADD FOREIGN KEY (`users_id`) REFERENCES `USERS` (`id`);

ALTER TABLE `COMPLETED_TOPICS` ADD FOREIGN KEY (`topics_id`) REFERENCES `TOPICS` (`id`);

ALTER TABLE `FAVOURITED_TOPICS` ADD FOREIGN KEY (`users_id`) REFERENCES `USERS` (`id`);

ALTER TABLE `FAVOURITED_TOPICS` ADD FOREIGN KEY (`topics_id`) REFERENCES `TOPICS` (`id`);

ALTER TABLE `AUTHORSHIP` ADD FOREIGN KEY (`users_id`) REFERENCES `USERS` (`id`);

ALTER TABLE `AUTHORSHIP` ADD FOREIGN KEY (`topics_id`) REFERENCES `TOPICS` (`id`);

ALTER TABLE `CHAPTERS_PHOTOS` ADD FOREIGN KEY (`chapters_id`) REFERENCES `CHAPTERS` (`id`);

ALTER TABLE `CHAPTERS_PHOTOS` ADD FOREIGN KEY (`photos_id`) REFERENCES `PHOTOS` (`id`);

ALTER TABLE `TOPICS_PHOTOS` ADD FOREIGN KEY (`topics_id`) REFERENCES `TOPICS` (`id`);

ALTER TABLE `TOPICS_PHOTOS` ADD FOREIGN KEY (`photos_id`) REFERENCES `PHOTOS` (`id`);

ALTER TABLE `PARAGRAPHS_PHOTOS` ADD FOREIGN KEY (`paragraphs_id`) REFERENCES `PARAGRAPHS` (`id`);

ALTER TABLE `PARAGRAPHS_PHOTOS` ADD FOREIGN KEY (`photos_id`) REFERENCES `PHOTOS` (`id`);

ALTER TABLE `TESTS` ADD FOREIGN KEY (`chapters_id`) REFERENCES `CHAPTERS` (`id`);

ALTER TABLE `QUESTIONS` ADD FOREIGN KEY (`photo_id`) REFERENCES `PHOTOS` (`id`);

ALTER TABLE `QUESTIONS` ADD FOREIGN KEY (`tests_id`) REFERENCES `TESTS` (`id`);

ALTER TABLE `ANSWERS` ADD FOREIGN KEY (`photo_id`) REFERENCES `PHOTOS` (`id`);

ALTER TABLE `ANSWERS` ADD FOREIGN KEY (`questions_id`) REFERENCES `QUESTIONS` (`id`);

ALTER TABLE `SCORES` ADD FOREIGN KEY (`users_id`) REFERENCES `USERS` (`id`);

ALTER TABLE `SCORES` ADD FOREIGN KEY (`tests_id`) REFERENCES `TESTS` (`id`);
