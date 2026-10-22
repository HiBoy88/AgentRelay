$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$checks = @{
  'skills/worker/SKILL.md' = @('AGENTRELAY_TOKEN_WORKER_1','GH_TOKEN')
  'skills/reviewer/SKILL.md' = @('AGENTRELAY_TOKEN_REVIEWER','GH_TOKEN')
  'skills/orchestrator/SKILL.md' = @('AGENTRELAY_TOKEN_MERGE_BOT','GH_TOKEN')
}
foreach ($entry in $checks.GetEnumerator()) {
  $text = Get-Content (Join-Path $root $entry.Key) -Raw
  foreach ($term in $entry.Value) { if ($text -notmatch [regex]::Escape($term)) { throw "Missing credential contract $term in $($entry.Key)" } }
}
Write-Output 'PASS credentials contract'
