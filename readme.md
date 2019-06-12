# Extendable Git Hooks

If you are using git 2.9+; use the following command to use these for all repos:

```git config --global core.hooksPath '<local_path_to_this_repo>'```

All git hooks are overridden and will run a personal hook of the same name after successfully completing the shared hook.


## Shared hooks

`pre-commit` - Fails commit if there php parse errors. 