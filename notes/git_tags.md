# Git Tags

## Frequent Commands
- Listing git tags: ```git tag```
- Push to origin: ```git push --tags origin```
- Create new tag: ```git tag -a v1.1 -m "First stable release"```

## Rename an Existing Tag
1. Find the commit the old tag points to ```git rev-parse v1.0```
   - Example output: ```abc123def456...```
2. Delete the old tag ```git tag -d v1.0```
3. Create the new tag pointing to the same commit (with annotation) ```git tag -a v1.0.0 abc123def456^{} -m "Rename v1.0 to v1.0.0"```
4. Push changes to remote
   - delete old remote tag ```git push origin :refs/tags/v1.0```
   - push new tag ```git push origin v1.0.0```

## References
1. https://kodekloud.com/blog/how-to-push-git-tags-to-remote/