{ createCommand, ... }:

createCommand {
  name = "unhide-git-dir";
  buildInputs = [ ];

  command = ''
    find "$1" -type d \( ! -name . \) -exec bash -c "cd '{}' && pwd && git ls-files -z $(pwd) | xargs -0 git update-index --no-skip-worktree" \;
  '';
}
