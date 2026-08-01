-- https://github.com/vim-airline/vim-airline
-- Classic Vim statusline (mode, branch + repo git status, file, location).
-- Theme name is set in themes.lua (tracks light/dark).
--
-- Section B (after mode, before filename) — whole-repo status, not the open buffer:
--    main ↑1 ↓2 +1 ~3 ?2
--          │  │  │  │  │
--          │  │  │  │  └─ untracked files
--          │  │  │  └─ unstaged (worktree) files
--          │  │  └─ staged (index) files
--          │  └─ commits behind upstream
--          └─ commits ahead of upstream
-- Empty when the working tree is clean and branch is in sync.

vim.g.airline_powerline_fonts = 1
vim.g.airline_skip_empty_sections = 1

vim.opt.laststatus = 3

vim.g["airline#extensions#tabline#enabled"] = 0
vim.g["airline#extensions#branch#enabled"] = 1
vim.g["airline#extensions#hunks#enabled"] = 0
vim.g["airline#extensions#whitespace#enabled"] = 0
vim.g["airline#extensions#wordcount#enabled"] = 0

vim.g.airline_section_y = ""
vim.g.airline_section_z = "%l/%L:%v"

-- Whole-repo git status (cached ~2s so statusline redraw stays cheap).
vim.cmd([[
  let s:airline_gs_text = ''
  let s:airline_gs_time = 0

  function! AirlineGitStatusInvalidate() abort
    let s:airline_gs_time = 0
  endfunction

  function! AirlineGitStatus() abort
    let now = reltimefloat(reltime())
    if now - s:airline_gs_time < 2.0
      return s:airline_gs_text
    endif
    let s:airline_gs_time = now

    if !exists('*FugitiveGitDir') || empty(FugitiveGitDir())
      let s:airline_gs_text = ''
      return ''
    endif

    let root = FugitiveWorkTree()
    let lines = systemlist(
      \ 'git -C ' . shellescape(root)
      \ . ' --no-optional-locks status --porcelain=v1 --branch --ignore-submodules=dirty'
      \ )
    if v:shell_error || empty(lines)
      let s:airline_gs_text = ''
      return ''
    endif

    let ahead = 0
    let behind = 0
    let staged = 0
    let unstaged = 0
    let untracked = 0

    for line in lines
      if line =~# '^##'
        let ahead = +matchstr(line, 'ahead \zs\d\+')
        let behind = +matchstr(line, 'behind \zs\d\+')
        continue
      endif
      if strlen(line) < 2
        continue
      endif
      let x = line[0]
      let y = line[1]
      if x ==# '?' && y ==# '?'
        let untracked += 1
      elseif x ==# '!' && y ==# '!'
        continue
      else
        if x !=# ' ' && x !=# '?'
          let staged += 1
        endif
        if y !=# ' ' && y !=# '?'
          let unstaged += 1
        endif
      endif
    endfor

    let parts = []
    if ahead > 0 | call add(parts, '↑' . ahead) | endif
    if behind > 0 | call add(parts, '↓' . behind) | endif
    if staged > 0 | call add(parts, '+' . staged) | endif
    if unstaged > 0 | call add(parts, '~' . unstaged) | endif
    if untracked > 0 | call add(parts, '?' . untracked) | endif

    let s:airline_gs_text = join(parts, ' ')
    return s:airline_gs_text
  endfunction
]])

vim.fn["airline#parts#define_function"]("git_status", "AirlineGitStatus")
vim.g.airline_section_b = vim.fn["airline#section#create"]({ "branch", "git_status" })
pcall(vim.cmd.AirlineRefresh)

vim.api.nvim_create_autocmd({ "FocusGained", "BufWritePost", "ShellCmdPost" }, {
  group = vim.api.nvim_create_augroup("airline-git-status", { clear = true }),
  callback = function()
    vim.fn.AirlineGitStatusInvalidate()
    pcall(vim.cmd.AirlineRefresh)
  end,
})
