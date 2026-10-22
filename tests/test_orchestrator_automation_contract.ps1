$ErrorActionPreference = 'Stop'; $root = Split-Path -Parent $PSScriptRoot; $s = Get-Content (Join-Path $root 'skills/orchestrator/SKILL.md') -Raw
foreach ($x in @('agentrelay_review','commit_sha','required CI','验收标准','Merge Bot','gh pr merge --squash','人工调用')) { if ($s -notmatch [regex]::Escape($x)) { throw "Missing automation contract: $x" } }
Write-Output 'PASS orchestrator automation contract'
