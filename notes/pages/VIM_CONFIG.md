# VIM CONFIGURATION WORKFLOW 

## PROGRAMS

- `vim` main program
- `lazygit` for git interaction
- `fzf` for quick file opening
- `vim-ale` for lsp features and code analisys

## DEBIAN-INSTALLATION

for debian distros fzf main vim function need to be linked manually

```bash
mkdir -p /usr/share/vim/vimfiles/plugin/
ln -s /usr/share/doc/fzf/examples/plugin/fzf.vim /usr/share/vim/vimfiles/plugin/
```
