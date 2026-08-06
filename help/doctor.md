# cdsync doctor

Check that the installation, its dependencies and the spec library are intact.

```
cdsync doctor
```

Takes no options. It reads and reports; it writes nothing, anywhere.

## The six checks

| # | Check | What a failure means |
|---|---|---|
| 1 | `CDSYNC_HOME` is set and points at a real directory | The shim resolved home wrongly, or the install moved |
| 2 | `bin`, `lib` and `help` are present, and `bin/cdsync` is executable | A partial install. Fix an executable bit with `chmod +x` |
| 3 | `cdsync` is reachable on `$PATH` | Only a convenience -- everything still works by full path |
| 4 | `jq`, `unzip` and `python3` are available | Each is named with what it is for, so a missing one tells you which command will break |
| 5 | The spec library: how many specs, taxonomy slugs and bundles, and the library, structure and kit versions | A count of zero means the library did not resolve, not that it is empty |
| 6 | Target resolution: which target, where it came from, and whether it versions with the project | A target outside the repository does not version with the project |

## Why it reports the target's provenance

**A target outside the repository is correct for a shared or confidential drop, and wrong by accident.** The two cases look identical once resolved, so every command that resolves a target says which of the four sources it came from -- `--target`, `$CDSYNC_TARGET`, `cdsync.json`, or the `design/` default -- and whether the result sits inside the repository.

`doctor` is where you check that deliberately, rather than discovering it from a command that has already written something.

## Why check 5 reports counts

The library is the source of truth for what an asset is, and a drop carries a stamped copy of each spec it delivers. **The version difference between the two is what makes staleness detectable** -- so knowing which library version this installation holds is what lets you read a `check` rule-2 finding.

The taxonomy count is wider than the spec count on purpose: the taxonomy is the menu, and the library holds specs for the ones written so far. A slug can be legitimately named -- as a dependency, or in a bundle -- long before anyone specifies it.

## Exit codes

| Code | Meaning |
|---|---|
| 0 | All checks passed |
| 1 | At least one check failed |
