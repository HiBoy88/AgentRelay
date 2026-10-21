$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$required = @('AGENTS.md','skills/orchestrator/SKILL.md','skills/worker/SKILL.md','.github/ISSUE_TEMPLATE/task.yml','.github/pull_request_template.md','.github/labels.md','README.md')
foreach ($file in $required) { if (-not (Test-Path (Join-Path $root $file))) { throw "Missing $file" } }
$issue = Get-Content (Join-Path $root '.github/ISSUE_TEMPLATE/task.yml') -Raw
foreach ($field in @('task_id','parent_plan','depends_on','目标','范围','验收标准','测试要求','建议执行 Agent','完成后产物')) { if ($issue -notmatch [regex]::Escape($field)) { throw "Missing issue field $field" } }
$pr = Get-Content (Join-Path $root '.github/pull_request_template.md') -Raw
foreach ($field in @('测试结果','未解决风险')) { if ($pr -notmatch $field) { throw "Missing PR field $field" } }
$rules = Get-Content (Join-Path $root 'AGENTS.md') -Raw
foreach ($label in @('task:planned','task:blocked','task:in-progress','task:review','task:done','task:failed')) { if ($rules -notmatch [regex]::Escape($label)) { throw "Missing label $label" } }
Write-Output 'PASS repository contract'
