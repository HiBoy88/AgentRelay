$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $root 'skills/reviewer/SKILL.md'))) { throw 'Missing reviewer skill' }
$s = Get-Content (Join-Path $root 'skills/reviewer/SKILL.md') -Raw
foreach ($x in @('agentrelay_review','PASS','CHANGES_REQUESTED','commit_sha','session_id','evidence','新会话')) { if ($s -notmatch [regex]::Escape($x)) { throw "Missing reviewer contract: $x" } }
Write-Output 'PASS reviewer contract'
