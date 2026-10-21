# 示例计划：账户模块

`plan_id`: account-module-v1

- `task-001`: 建立领域模型，`depends_on: []`，可独立执行。
- `task-002`: 添加 API 层，`depends_on: []`，可与 task-001 并行。
- `task-003`: 添加端到端测试，`depends_on: [task-001, task-002]`，两者完成后执行。

主控将每项生成一个 Issue。Worker 每次只人工选择一个可执行 Issue；PR 合并并验收后，主控解除后续依赖。
