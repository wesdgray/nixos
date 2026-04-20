# Repo Overview
This repo manages nixos configurations using the dentritic pattern via flake parts.

# Use cases and commands
- When refactoring, we can check that our refactor does not result in a change to the system.
  - `nh os build . > changelog`
