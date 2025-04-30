git fetch -p && for /f "tokens=1" %%b in ('git branch -vv ^| find "gone"') do git branch -d %%b
