# AgentRelay

AgentRelay 用 GitHub Issue、分支和 Pull Request 协调不同设备上的编码 Agent。

主控 Agent 使用 `skills/orchestrator/SKILL.md`：通过 Superpowers 形成规格和计划，再创建带依赖的任务 Issue。执行 Agent 使用 `skills/worker/SKILL.md`：人工选择任务，在 `task/<task_id>` 分支中执行 Superpowers、测试并创建 PR。

复制 `AGENTS.md`、`.github/` 和 `skills/` 到目标仓库后即可采用协议。第一版没有常驻服务、数据库、云端执行器或自动并发领取。
