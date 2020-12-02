# Contributing guidelines to openDBM

Please visit [openDBM](https://aicure.com/opendbm/) page if you have not seen it. If you are enthusiastic to contribute to this toolkit in terms of bug fixes, tutorials, new feature development, enhancing existing features etc. everything should be managed by submitting pull request on Github.

## What you should know

- Read [code of conduct](https://github.com/AiCure/open_dbm/blob/master/CODE_OF_CONDUCT.md).
- Read [License](https://github.com/AiCure/open_dbm/blob/master/license.txt).
- Agree to contribute code under openDBM(GPL v3.0).
- Before adding new feature/algorithmn make sure it's not patented.
- Before fixing any bug make sure it's still exists and reproducable in master branch.
- If you see any issue in existing features make sure to report the issue on openDBM issues page.
- After adding new code make sure everything is working as expected.

## How to contribute 

1. Install Git.
2. Register and signin into GitHub.
3. Fork openDBM repository https://github.com/AiCure/open_dbm.git (https://help.github.com/articles/fork-a-repo for details)
4. Assign a task for yourself. It could be a bugfix or adding new functionality.
5. Clone your fork into your local system.
6. Navigate to local repository.
7. Check that your fork is the 'origin' remote.
	- Use 'git remote -v' to show current remote
	- If you do not see any remote, add it using git remote add origin <url of fork branch>
8. Add openDBM master repository as 'upstream' remote.
	- Use 'git remote add upstream https://github.com/AiCure/open_dbm.git' command
	- Check remote using 'git remote -v'
9. Before making any changes better to synchronize local repository with openDBM master
	- git pull upstream master
10. Create new branch where you are going to add bugfix or new features
	- git checkout -b branch_name
11. Make and commit your changes into local repository
12. Validate all your commits and make sure everything is working as expected.
13. Push your chanhes to new branch(which is a branch of fork repository)
	-  git push origin branch_name
14. Create a pull request and add brief information about all your commits.(see https://help.github.com/articles/using-pull-requests for details)

## Request Approval

Once reviewer is happy with the code changes, will approve the pull request and merge it with the master branch.
