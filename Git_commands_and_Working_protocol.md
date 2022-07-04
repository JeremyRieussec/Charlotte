# Working protocol

There will always be at least two branches:
- main
- dev



### Branch **main**
Contains the history of finalized versions: v.1.0, v.1.1, v.2.0, ...

### Branch dev
Contains the evolutions between versions. 

### Working branches 
When wanting to add some features, do a bugfix, ...
- create your branch from dev 
- work on your branch 
- commit and push your changes to remote 
- update your branch according to dev
  - with rebase 
  - keep one commit with interactive rebase (better for fast-forwarding when merging)
- start a pull  request
  - at least one reviewer is necessary

# GIT commands

### Create branch
To **create** a new branch called “branch_name” from dev
```
git checkout dev
git pull
git checkout -b branch_name
```

### Delete branch
To **delete** a branch you do not need anymore,
```
git branch -d nom_branche
```
To force deletion,
```
git branch -D nom_branche
```
### Pull Requests

When wanting to merge modifications from your branch to dev, start a pull request. Two options:
- from GitHub
- from command line

**Before** doing a pull request on the dev branch:

- Make sure you rebase your branch branch_name on the updated dev branch
```
git checkout dev
git pull
git checkout branch_name
git rebase -i dev
```
- Keep first commit with “pick” and replace all other “pick” with “f” or “fixup” (this is to squash all commits into one). Save file and exit
- Resolve conflicts (if any)
```
git status
```
shows all the pending conflicts to be solved, make the modifications and save them. 

- Stage the modified files,
```
git add <modified files>
```
- Then, resume to rebase,
```
git rebase --continue
```
After that, git log should give you only one commit after dev
```
git log --oneline --graph --all
```
Push your modifications
```
git push origin branch_name
```
an error could occur because of divergent branches. 

If you are sure of your modifications, the push can be forced with the option -f  
```
git push -f origin branch_name
```
To update a pull request that is behind the dev branch
```
git checkout dev
git pull
git checkout branch_name
git rebase dev
git push -f origin branch_name
```

