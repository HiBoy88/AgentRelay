$ErrorActionPreference = 'Stop'; $root = Split-Path -Parent $PSScriptRoot; $s = Get-Content (Join-Path $root 'skills/orchestrator/SKILL.md') -Raw
foreach ($x in @('gh pr merge --squash','禁止合并','失败评论','task:done','重试')) { if ($s -notmatch [regex]::Escape($x)) { throw "Missing merge contract: $x" } }
Write-Output 'PASS merge contract'
