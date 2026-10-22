# AgentRelay

AgentRelay 用 GitHub Issue、分支和 Pull Request 协调不同设备上的编码 Agent。

主控 Agent 使用 `skills/orchestrator/SKILL.md`：通过 Superpowers 形成规格和计划，再创建带依赖的任务 Issue。执行 Agent 使用 `skills/worker/SKILL.md`：人工选择任务，在 `task/<task_id>` 分支中执行 Superpowers、测试并创建 PR。

复制 `AGENTS.md`、`.github/` 和 `skills/` 到目标仓库后即可采用协议。第一版没有常驻服务、数据库、云端执行器或自动并发领取。

Reviewer 在另一台设备的新会话中人工调用 `agentrelay-reviewer`。完成后，在主控设备人工调用 `agentrelay-orchestrator`；主控会自动检查 Reviewer 的当前 SHA、required CI 和 Issue 验收证据，并在全部通过时使用 Merge Bot 执行 squash merge。失败时会在 PR 记录原因，下次再次调用主控 Skill 会自动重试。

Token 配置见 [`docs/credentials.md`](docs/credentials.md)。每个 Skill 根据自身角色自动读取对应的持久化环境变量。
