# Local Fork Workflow

This checkout is wired for long-term local customization while staying close to
the upstream Sub2API project.

## Remotes

- `upstream`: official repository, `https://github.com/Wei-Shaw/sub2api.git`
- `origin`: personal fork, `https://github.com/Ly-scnu/sub2api.git`

Do not push to `upstream`. Local customization should live on `custom/local`.

## Branches

- `main`: mirror of official `upstream/main`; keep this clean.
- `custom/local`: your local customization branch; commit changes here.

## Daily Development

```powershell
git switch custom/local
git status
git add <changed-files>
git commit -m "your change"
git push origin custom/local
```

## Sync Official Updates

Run this from the repository root:

```powershell
.\tools\sync-upstream.ps1
```

The script updates local `main` from `upstream/main`, pushes that clean mirror
to your fork, then rebases `custom/local` on top of the latest `main`.

If a conflict appears, fix the conflicted files, then run:

```powershell
git add <fixed-files>
git rebase --continue
git push --force-with-lease origin custom/local
```

Use `--force-with-lease` only for your customization branch after a rebase.
Do not force-push shared branches unless you deliberately coordinate it.
