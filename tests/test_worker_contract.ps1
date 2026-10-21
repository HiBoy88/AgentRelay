$ErrorActionPreference = 'Stop'; $p = Join-Path (Split-Path -Parent $PSScriptRoot) 'skills/worker/SKILL.md'; $s = Get-Content $p -Raw
foreach ($x in @('人工选择','task/<task_id>','test-driven-development','systematic-debugging','verification-before-completion','gh pr create','task:blocked','task:review')) { if ($s -notmatch [regex]::Escape($x)) { throw "Missing worker contract: $x" } }
if ($s -match '自动合并 PR') { throw 'Worker must not auto merge' }
Write-Output 'PASS worker contract'
