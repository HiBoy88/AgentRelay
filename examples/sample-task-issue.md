```yaml
task_id: task-003
parent_plan: docs/superpowers/plans/account-module-v1.md
depends_on: [task-001, task-002]
目标: 为账户 API 添加端到端测试
范围: tests/e2e/account/
验收标准:
  - 未认证请求返回 401
  - 合法请求返回账户数据
测试要求: 运行 npm test -- account:e2e
建议执行 Agent: worker-desktop-b
完成后产物: task/task-003 分支和关联 Pull Request
```
