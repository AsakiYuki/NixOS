function git-commit() {
  git add .
  git commit -m "$1"
}

function git-push()  {
  git-commit "$1"
  git push origin HEAD
}

function git-pull() {
  git fetch origin HEAD
  git pull origin HEAD
}

function get-hash() {
  nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "$1")
}
