---
name: agentrelay-worker
description: Manually select and execute one approved AgentRelay GitHub task.
---

# Worker

## 前置检查

读取 `AGENTS.md`、规格和计划，运行 `gh auth status`，确认工作树干净。认证、网络或上下文失败时停止并报告。

## 流程

1. 查询 `task:planned` Issue，解析必填字段并过滤 `depends_on` 中未完成的任务。
2. 若有多个候选，展示编号、目标、范围、依赖和验收标准，等待**人工选择**；不自动抢占。
3. 检查目标分支或 PR 是否已存在；存在时停止并提供继续/恢复选项，不覆盖已有工作。
4. 创建 `task/<task_id>` 分支，将 Issue 更新为 `task:in-progress`，记录 Agent/设备和开始阶段。
5. 按任务类型调用 Superpowers：实现用 `test-driven-development`，调试用 `systematic-debugging`，完成前用 `verification-before-completion`，需要审查时用 `requesting-code-review`。
6. 运行 Issue 要求的测试。规格缺失、冲突或越界时标记 `task:blocked` 并写明原因；无法在范围内修复的测试失败标记 `task:failed`。
7. 用 `gh pr create` 创建关联 PR，描述变更、测试结果和未解决风险；将 Issue 标记 `task:review` 并回写执行证据。
8. 合并 PR 由主控或指定审查者人工完成；合并并验收后，才将 Issue 标记 `task:done`。
