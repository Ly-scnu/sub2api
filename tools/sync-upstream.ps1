param(
    [string]$CustomBranch = "custom/local",
    [string]$MirrorBranch = "main"
)

$ErrorActionPreference = "Stop"

function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    git @Args
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Args -join ' ') failed with exit code $LASTEXITCODE"
    }
}

$status = git status --porcelain
if ($status) {
    Write-Error "Working tree is not clean. Commit or stash changes before syncing."
    exit 1
}

Invoke-Git fetch upstream $MirrorBranch
Invoke-Git switch $MirrorBranch
Invoke-Git reset --hard "upstream/$MirrorBranch"
Invoke-Git push origin $MirrorBranch

Invoke-Git switch $CustomBranch
Invoke-Git rebase $MirrorBranch
Invoke-Git push --force-with-lease origin $CustomBranch

Write-Host "Synced upstream/$MirrorBranch into $CustomBranch and pushed origin/$CustomBranch."
