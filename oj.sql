CREATE DATABASE IF NOT EXISTS oj CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE oj;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(64) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS problems (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(128) NOT NULL,
  description TEXT NOT NULL,
  time_limit_ms INT,
  memory_limit_mb INT,
  sample_input TEXT,
  sample_output TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS submissions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  problem_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  username VARCHAR(64),
  language VARCHAR(32) NOT NULL,
  code LONGTEXT NOT NULL,
  status VARCHAR(32) NOT NULL,
  problem_title VARCHAR(128),
  runtime_ms INT,
  memory_kb INT,
  run_output LONGTEXT,
  run_error LONGTEXT,
  compile_log LONGTEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sub_problem FOREIGN KEY (problem_id) REFERENCES problems(id)
) ENGINE=InnoDB;

CREATE INDEX IF NOT EXISTS idx_sub_problem ON submissions(problem_id);
CREATE INDEX IF NOT EXISTS idx_sub_user ON submissions(user_id);

CREATE TABLE IF NOT EXISTS test_cases (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  problem_id BIGINT NOT NULL,
  input_data TEXT NOT NULL,
  expected_output TEXT NOT NULL,
  CONSTRAINT fk_tc_problem FOREIGN KEY (problem_id) REFERENCES problems(id)
) ENGINE=InnoDB;

INSERT INTO users (username, password_hash) VALUES ('demo', '$2a$10$demo');
INSERT INTO problems (title, description, time_limit_ms, memory_limit_mb) VALUES (
  'A + B',
  '给定两个整数，输出它们的和。\n输入：两行，每行一个整数。\n输出：一行，和。',
  1000,
  128
);
