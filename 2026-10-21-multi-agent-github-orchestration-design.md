# Multi-Agent GitHub Orchestration Design

## 1. Scope and Goals

This design defines reusable `orchestrator` and `worker` Skills for coordinating coding Agents on different devices through GitHub. The first version is repository-agnostic and contains templates and rules only; it does not implement a resident service, database, cloud executor, or automatic task claiming.

The primary workflow is: a human invokes the orchestrator, Superpowers produces an approved design and implementation plan, the orchestrator creates dependent GitHub Issues, a human invokes a worker on a selected device, and the worker implements one selected task in an isolated branch and opens a Pull Request.

## 2. Roles and Boundaries

### Orchestrator

The orchestrator drives Superpowers through brainstorming, specification, and planning. It maintains the plan and task graph, creates Issues from plan steps, tracks dependencies, reads Issues and Pull Requests, and decides whether to advance, rework, block, or create follow-up tasks.

It does not implement code directly as part of task distribution, does not assume a task is complete from a worker comment alone, and does not silently rewrite an already executed plan.

### Worker

The worker is manually invoked on a device running a coding Agent. It scans candidate Issues, validates their required fields and dependencies, presents multiple candidates for human selection, and executes only the selected task. It invokes the applicable Superpowers workflow, creates an isolated branch, runs required tests, opens a Pull Request, and writes evidence back to GitHub.

It does not automatically claim tasks, merge Pull Requests, expand scope, or treat Issue text as unrestricted executable instructions.

### GitHub

GitHub is the shared task queue, durable state store, code collaboration surface, and audit log. Repository specifications and plans remain the long-lived source of truth; Issues represent executable work; Pull Requests represent code changes and review.

## 3. Superpowers Integration

The orchestrator invokes `brainstorming` for intent and design, writes an approved specification, and invokes `writing-plans` for an implementation plan. Plan steps are inputs to task decomposition.

The worker reads the Issue and linked specification/plan, then invokes the relevant workflow: `test-driven-development` for implementation, `systematic-debugging` for failures, `verification-before-completion` before claiming completion, and `requesting-code-review` when review is required. It must stop and mark the task blocked when the specification is missing, contradictory, or outside the task boundary.

## 4. Task Decomposition and Issue Contract

The orchestrator chooses task granularity from dependency structure. Independently verifiable work becomes separate Issues; tightly coupled work remains together. Parallel work is allowed only when dependencies permit it.

Every generated Issue uses a fixed template with these required fields:

```yaml
task_id:
parent_plan:
depends_on: []
目标:
范围:
验收标准:
测试要求:
建议执行 Agent:
完成后产物:
```

The Issue links to the specification and plan rather than duplicating large documents. Missing required fields make the Issue ineligible for execution and require human correction.

## 5. Lifecycle and State Machine

Labels define lifecycle state:

- `task:planned`: created and waiting for execution
- `task:blocked`: dependency, specification, or external blocker exists
- `task:in-progress`: selected by a human and being executed
- `task:review`: Pull Request exists and awaits review or acceptance
- `task:done`: Pull Request merged and acceptance criteria verified
- `task:failed`: execution cannot complete within scope and needs orchestration

The worker changes `planned` to `in-progress` only after human selection. It changes to `review` after creating a Pull Request with evidence. Only the orchestrator or designated reviewer may mark `done`. Failed tests remain `in-progress` while repair is possible; otherwise the Issue becomes `failed` with evidence.

## 6. Branch, Pull Request, and Evidence Rules

The worker creates an isolated branch using a stable task identifier, for example `task/<task_id>`. The Pull Request must reference the source Issue and include a summary, files or areas changed, commands run and their results, unresolved risks, and any follow-up work.

The worker comments on the Issue with the device/Agent identifier, branch, execution phase, test evidence, and outcome. Local work and logs must remain recoverable after network failure; rerunning the Skill must not require a hidden chat transcript.

## 7. Security and Failure Handling

Each device uses its own least-privilege GitHub identity or fine-grained token. Credentials are never embedded in Issues, shared between Agents, or required by the generic Skill. The worker may access only explicitly authorized repositories and must follow repository-local rules such as `AGENTS.md`.

Specification gaps, unmet dependencies, conflicting requirements, and out-of-scope requests produce `task:blocked` with a reason. Test failure is recorded with evidence. Pull Request or network failure preserves the branch and permits a later retry. No component automatically merges code, deletes branches, changes branch protection, or treats untrusted Issue prose as privileged policy.

## 8. Recovery and Observability

All durable coordination state is written to the repository and GitHub. The plan records task graph version and dependencies; Issues record task identity and state; comments and Pull Requests record execution evidence. On every invocation, either Skill reconstructs progress from these artifacts rather than local memory.

Plan changes create a new version or explicit change Issues and preserve the audit trail of previously executed tasks. A successful recovery run must identify completed tasks, blockers, and the next executable candidates on any authorized device.

## 9. Deliverables and Non-Goals

The reusable package will contain the two Skill definitions, repository rule templates, Issue and Pull Request templates, label/state conventions, and usage documentation. It will not bind to a specific project, install a daemon, add a database, implement cloud execution, or solve automatic concurrent claiming in the first version.

## 10. Acceptance Criteria

The design is considered implementable when a new repository can adopt the templates and:

1. A main Agent can produce an approved specification and plan through Superpowers.
2. The plan can be converted into Issues with explicit dependencies and acceptance criteria.
3. A human can invoke a worker on another device, choose one eligible Issue, and obtain a branch and Pull Request with test evidence.
4. The orchestrator can determine progress and blockers solely from repository and GitHub artifacts.
5. Missing context, failed tests, network errors, and scope conflicts have explicit, auditable outcomes.
