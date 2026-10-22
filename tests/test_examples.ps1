$ErrorActionPreference = 'Stop'; $root = Split-Path -Parent $PSScriptRoot
foreach ($f in @('examples/sample-plan.md','examples/sample-task-issue.md')) { if (-not (Test-Path (Join-Path $root $f))) { throw "Missing $f" } }
$s = Get-Content (Join-Path $root 'examples/sample-task-issue.md') -Raw
foreach ($x in @('task_id','depends_on','验收标准','测试要求','完成后产物')) { if ($s -notmatch [regex]::Escape($x)) { throw "Missing example field $x" } }
foreach ($f in @('examples/review-comment.md','examples/merge-failure-comment.md')) { if (-not (Test-Path (Join-Path $root $f))) { throw "Missing $f" } }
$r = Get-Content (Join-Path $root 'examples/review-comment.md') -Raw
foreach ($x in @('agentrelay_review','PASS','commit_sha','evidence')) { if ($r -notmatch [regex]::Escape($x)) { throw "Missing review example field $x" } }
Write-Output 'PASS examples'
