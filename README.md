# dotfiles

macOS configuration, installed with Homebrew and GNU Stow.

## Setup

Install [Homebrew](https://brew.sh/) first, then run:

```bash
git clone git@github.com:ptran32/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

Open a new terminal window after installation. AeroSpace and Borders require macOS Accessibility permission.

## Git identity

Keep your identity machine-local and out of the repository:

```bash
cp git/.gitconfig.local.example ~/.gitconfig.local
${EDITOR:-vi} ~/.gitconfig.local
```
