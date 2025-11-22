# 带 AI 功能的在线评测系统（OJ）

一个包含评测、竞赛、公告、后台管理与多项 AI 辅助能力的完整 OJ 平台。

- 前端：`Vue 3 + Vite + Element Plus`
- 后端：`Spring Boot 3 + JPA + Validation`
- 判题：内置 Python/C 运行与用例比对，支持按分值统计
- AI 能力：解题思路、答疑分析、举一反三生成相似题、参考解答生成

## 功能特性

- 题目浏览与详情、提交与判题结果展示
- 题目统计（解决数、提交数、正确率）
- 竞赛列表与详情、排名与战绩
- 后台管理：题目/竞赛/公告/用户/系统配置
- 角色与权限：`ADMIN` 管理员、`TEACHER` 教师（受限入口）、普通用户
- 教师视角优化：只显示本人题目与竞赛，隐藏不相关入口
- 测试数据管理：样例输入输出与测试用例 CRUD（按分值计分）
- AI 集成：
  - 解题思路（SSE 流式或一次性）
  - 判题答疑（结合编译日志/程序输出/判题状态）
  - 举一反三生成相似题与测试用例 JSON
  - 参考解答生成（含详细解析，Markdown 输出）

## 界面预览

- 主页：![主页](image/OJ主页.png)
- 题目列表：![题目](image/OJ题目.png)
- 题目详情：![题目详情](image/OJ题目详情.png)
- 提交记录与判题详情：![提交记录](image/OJ提交记录.png) ![判题详情](image/OJ判题详情.png)
- 判题结果展示：![判题结果显示](image/OJ判题结果显示.png)
- AI 能力：![AI 解题思路](image/OJAI解题思路功能.png) ![AI 解题思路示例](image/OJAI解题思路输出示例.png) ![AI 答疑](image/OJAI答疑功能.png) ![AI 举一反三(前)](image/OJAI举一反三(生成答案前).png) ![AI 举一反三(后)](image/OJAI举一反三(生成答案后).png)
- 后台仪表盘与管理：![后台仪表盘](image/OJ后台仪表盘.png) ![题目列表](image/OJ后台题目列表.png) ![题目列表(教师)](image/OJ后台题目列表(教师).png) ![题目添加](image/OJ后台题目添加(Editor.md富文本编辑器).png) ![公告列表](image/OJ后台公告列表.png) ![用户管理](image/OJ后台用户管理.png) ![竞赛管理](image/OJ竞赛管理.png) ![系统配置](image/OJ系统配置.png) ![AI 测试](image/OJ后台AI测试.png)

## 技术栈与目录

- 前端：`frontend/`
  - `src/` 业务页面、路由、状态、API 封装
  - 开发服务器：`vite`（端口 5173，自动占用空闲端口）
  - 代理：`/api -> http://localhost:8081`（见 `frontend/vite.config.ts:11-15`）
- 后端：`backend/`
  - Spring Boot 3（端口 `8081`，见 `backend/src/main/resources/application.yml:1-2`）
  - JPA + Validation、MySQL/H2 依赖（MySQL 默认，见 `pom.xml`、`application.yml`）
  - 评测服务：`JudgeService`（Python/C，见 `backend/src/main/java/com/oj/service/JudgeService.java`）
  - AI 控制器：`AiController`（SSE/非流式，见 `backend/src/main/java/com/oj/controller/AiController.java`）
  - 测试数据根目录：`backend/data/problems`（见 `application.yml:23-25`）

## 快速开始

### 环境要求

- Node.js 18+，npm
- Java 17，Maven（项目已提供 `mvnw/mvnw.cmd`）
- MySQL 8（默认配置），或按需切换到 H2
- Python（用于 Python 语言判题）
- GCC（用于 C 语言编译，Windows 可安装 MinGW 或在 WSL 中运行）

### 初始化数据库（MySQL）

- 确认 `application.yml` 中的数据库配置：`spring.datasource.url/username/password`
- 执行 `db/oj.sql` 初始化基本表与示例数据（可选，JPA 已启用 `ddl-auto: update`）

### 启动后端

- Windows：在 `backend/` 目录运行：
  - `./mvnw.cmd spring-boot:run`
- macOS/Linux：在 `backend/` 目录运行：
  - `./mvnw spring-boot:run`
- 默认监听 `http://localhost:8081`

### 启动前端

- 在 `frontend/` 目录运行：
  - `npm install`
  - `npm run dev`
- 访问：`http://localhost:5173/`（端口占用时自动切换，如 `5174`）
- 所有前端请求通过 `/api` 代理到后端

### 生产构建

- 前端：`npm run build` 生成 `frontend/dist`
- 后端：`./mvnw[-.cmd] package` 生成可运行 JAR

## 角色与权限

- 管理员（ADMIN）：拥有全部后台入口与操作权限
- 教师（TEACHER）：后台仅开放仪表盘、题目与竞赛管理；并且列表只显示本人数据
- 普通用户：无后台权限，仅可浏览题目、提交与查看判题结果
- 前端路由守卫示例：`frontend/src/router/index.ts:61-76`

## 判题流程概述

- 用户提交代码后进入编译与运行阶段（见 `JudgeService#judgeAsync`）
- 根据 `backend/data/problems/{problemId}` 下的 `.in/.out` 文件依序运行与比对输出
- 每个用例按分值统计，结果聚合后给出总状态（`ACCEPTED/WRONG_ANSWER/COMPILE_ERROR/...`）
- 若未找到测试数据目录，将返回提示信息以便管理员/教师补充

## AI 配置

- 支持 OpenAI / DeepSeek 等兼容的 Chat Completions API
- 配置来源优先级：系统配置表 → 环境变量
- 环境变量示例：
  - `OPENAI_API_KEY` / `OPENAI_BASE_URL` / `OPENAI_MODEL`
  - `DEEPSEEK_API_KEY` / `DEEPSEEK_BASE_URL` / `DEEPSEEK_MODEL`
- 系统配置界面：后台“系统配置”页支持设置提供商、Base URL、模型与 Key

## 常见问题

- 前端无法访问后台：确认后端端口与代理 `/api` 是否可达
- 教师无法进入“测试数据”：路由已允许访问 `'/admin/problems/:id'`
- 判题失败且日志提示“未找到测试数据”：将 `.in/.out` 文件放置于 `backend/data/problems/{problemId}/`
- C 语言编译失败：检查是否已安装 `gcc` 并在系统 `PATH` 中

## 目录结构（节选）

```
backend/
  src/main/java/com/oj/
    controller/ AiController, ProblemController, SubmissionController ...
    service/ JudgeService.java
  src/main/resources/application.yml
  data/problems/1/*.in|*.out
frontend/
  src/pages/ 题目、提交、后台管理等页面
  src/router/index.ts  路由与权限
  src/stores/auth.ts   登录与角色同步
  vite.config.ts       开发代理到后端
image/                项目截图
```

---

如需进一步扩展（语言、判题沙箱、更多权限粒度等），可在后端服务与前端路由/页面中按现有模式迭代。
