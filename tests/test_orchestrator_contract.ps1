$ErrorActionPreference = 'Stop'; $p = Join-Path (Split-Path -Parent $PSScriptRoot) 'skills/orchestrator/SKILL.md'; $s = Get-Content $p -Raw
foreach ($x in @('brainstorming','writing-plans','task_id','parent_plan','depends_on','gh issue create','task:blocked','Pull Request')) { if ($s -notmatch [regex]::Escape($x)) { throw "Missing orchestrator contract: $x" } }
Write-Output 'PASS orchestrator contract'
