# AgentRelay 实现计划

> **面向 AI 代理的工作者：** 必需子技能：使用 subagent-driven-development（推荐）或 executing-plans 逐任务实现此计划。步骤使用复选框（`- [ ]`）语法来跟踪进度。

**目标：** 为 AgentRelay 创建可复用的 `orchestrator` 与 `worker` Skills，以及仓库级规则、GitHub Issue/PR 模板和状态协议。

**架构：** `orchestrator` 驱动 Superpowers 产出规格和计划，并把计划步骤转换为带依赖的 GitHub Issues；`worker` 由人工触发，读取并选择可执行 Issue，在独立分支中调用 Superpowers 完成任务并创建 PR。GitHub 是唯一的共享持久化状态，不部署常驻服务或数据库。

**技术栈：** Markdown Skill 文件、Markdown/YAML 仓库规则与模板、GitHub CLI (`gh`)；验证使用 Shell/PowerShell 静态检查和本地模板测试。

**规格：** `docs/superpowers/specs/2026-10-21-multi-agent-github-orchestration-design.md`

## 全局约束

- 第一版只提供通用模板，不绑定具体代码仓库。
- Worker 必须人工选择任务，不自动抢占或合并 PR。
- Issue 必须包含 `task_id`、`parent_plan`、`depends_on`、`目标`、`范围`、`验收标准`、`测试要求`、`建议执行 Agent`、`完成后产物`。
- 生命周期标签固定为 `task:planned`、`task:blocked`、`task:in-progress`、`task:review`、`task:done`、`task:failed`。
- 规格缺失、依赖未完成、冲突要求和越界请求必须进入 `task:blocked` 并记录原因。
- Worker 分支使用 `task/<task_id>`；PR 必须关联源 Issue 并包含测试证据和未解决风险。
- 不实现常驻服务、数据库、云端执行器或自动并发领取。

## 审查重点（Review Focus）

- Issue 缺少必填字段时，扫描结果必须明确指出缺失字段且不可执行。
- `depends_on` 中存在未完成任务时，任务必须被过滤或标记阻塞，不能误报为可执行。
- GitHub CLI 不可用、未认证或网络失败时，Skill 必须停止并给出可恢复的诊断，不得伪造状态更新。
- Issue 内容包含越权操作或超出范围的要求时，Worker 必须阻塞并要求主控澄清。
- 已存在同名任务分支或 PR 时，Worker 必须避免覆盖并提示恢复/继续选项。

### 任务 1：初始化仓库协议与目录结构

**文件：**
- 创建：`AGENTS.md`
- 创建：`skills/orchestrator/SKILL.md`
- 创建：`skills/worker/SKILL.md`
- 创建：`.github/ISSUE_TEMPLATE/task.yml`
- 创建：`.github/pull_request_template.md`
- 创建：`.github/labels.md`
- 创建：`README.md`
- 测试：`tests/test_repository_contract.ps1`

- [ ] **步骤 1：编写失败的协议测试**

  在 `tests/test_repository_contract.ps1` 中检查七个文件存在、Issue 模板包含全部必填字段、PR 模板包含测试证据/风险段落、`AGENTS.md` 包含禁止自动合并和状态标签集合。

- [ ] **步骤 2：运行测试验证失败**

  运行：`pwsh -NoProfile -File tests/test_repository_contract.ps1`

  预期：FAIL，报告缺少协议文件或字段。

- [ ] **步骤 3：创建协议文件**

  `AGENTS.md` 定义所有 Agent 的共享规则；模板定义 Issue/PR 的固定字段；`labels.md` 固定标签语义；README 说明安装、人工触发和状态恢复入口。Skill 文件先写清输入、输出、前置检查、Superpowers 调用顺序和停止条件，不实现隐式后台行为。

- [ ] **步骤 4：运行测试验证通过**

  运行同一命令；预期：PASS，所有文件和契约字段均被发现。

- [ ] **步骤 5：Commit**

  `git add AGENTS.md skills .github README.md tests/test_repository_contract.ps1 && git commit -m "docs: add AgentRelay repository contract"`

### 任务 2：实现 Orchestrator Skill 流程

**文件：**
- 修改：`skills/orchestrator/SKILL.md`
- 修改：`README.md`
- 测试：`tests/test_orchestrator_contract.ps1`

- [ ] **步骤 1：编写失败的流程契约测试**

  测试断言 Skill 文档按顺序声明 `brainstorming`、规格审阅、`writing-plans`、任务拆分、依赖校验、Issue 创建和结果汇总；并包含 `task_id`、`parent_plan`、`depends_on` 生成规则。

- [ ] **步骤 2：运行测试验证失败**

  运行：`pwsh -NoProfile -File tests/test_orchestrator_contract.ps1`

  预期：FAIL，流程阶段或字段缺失。

- [ ] **步骤 3：完善 Orchestrator Skill**

  定义人工确认闸门、规格/计划路径、可并行与必须串行的拆分规则、GitHub CLI 调用前认证检查、Issue 幂等识别、阻塞任务处理和从 Issue/PR 恢复整体进度的步骤。Issue 正文引用规格和计划，不复制大段内容。

- [ ] **步骤 4：运行测试验证通过**

  运行同一命令；预期：PASS。

- [ ] **步骤 5：Commit**

  `git add skills/orchestrator/SKILL.md README.md tests/test_orchestrator_contract.ps1 && git commit -m "feat: define orchestrator workflow"`

### 任务 3：实现 Worker Skill 流程

**文件：**
- 修改：`skills/worker/SKILL.md`
- 修改：`README.md`
- 测试：`tests/test_worker_contract.ps1`

- [ ] **步骤 1：编写失败的流程契约测试**

  测试断言 Worker 文档包含认证检查、候选 Issue 扫描、人工选择、依赖过滤、分支 `task/<task_id>`、Superpowers 执行、测试证据、PR 创建、Issue 回写和失败状态处理；并断言没有自动合并指令。

- [ ] **步骤 2：运行测试验证失败**

  运行：`pwsh -NoProfile -File tests/test_worker_contract.ps1`

  预期：FAIL，至少一个必需阶段缺失。

- [ ] **步骤 3：完善 Worker Skill**

  定义候选筛选、多个任务时展示摘要并等待人工选择、依赖完成判断、规格冲突时标记 `task:blocked`、已存在分支/PR 时停止覆盖、按任务类型调用 `test-driven-development`/`systematic-debugging`/`verification-before-completion`/`requesting-code-review`、创建 PR 后回写执行证据，以及网络失败时保留可恢复本地状态。

- [ ] **步骤 4：运行测试验证通过**

  运行同一命令；预期：PASS。

- [ ] **步骤 5：Commit**

  `git add skills/worker/SKILL.md README.md tests/test_worker_contract.ps1 && git commit -m "feat: define worker workflow"`

### 任务 4：端到端示例与静态验证

**文件：**
- 创建：`examples/sample-plan.md`
- 创建：`examples/sample-task-issue.md`
- 修改：`README.md`
- 测试：`tests/test_examples.ps1`

- [ ] **步骤 1：编写失败的示例验证**

  测试示例计划和 Issue 包含可追踪的 `task_id`、依赖、验收标准、测试要求和 PR 产物，并能与模板字段一致。

- [ ] **步骤 2：运行测试验证失败**

  运行：`pwsh -NoProfile -File tests/test_examples.ps1`

  预期：FAIL，因为示例文件尚不存在。

- [ ] **步骤 3：创建最小可运行示例**

  示例展示一个父计划、两个可并行任务和一个依赖任务，说明主控如何创建 Issue、Worker 如何执行单个 Issue、主控如何根据 PR 推进状态。示例不调用真实 GitHub API。

- [ ] **步骤 4：运行全部验证**

  运行：`pwsh -NoProfile -File tests/test_repository_contract.ps1; pwsh -NoProfile -File tests/test_orchestrator_contract.ps1; pwsh -NoProfile -File tests/test_worker_contract.ps1; pwsh -NoProfile -File tests/test_examples.ps1`

  预期：四个脚本均 PASS。

- [ ] **步骤 5：Commit**

  `git add examples README.md tests && git commit -m "test: add AgentRelay workflow examples"`

## 规格覆盖检查

- 角色边界和 Superpowers 衔接：任务 2、任务 3。
- Issue 字段、依赖和状态机：任务 1、任务 2、任务 3。
- 分支、PR 和证据规则：任务 1、任务 3。
- 安全、失败处理和恢复：任务 2、任务 3、任务 4。
- 通用模板和非目标：任务 1、任务 4。
