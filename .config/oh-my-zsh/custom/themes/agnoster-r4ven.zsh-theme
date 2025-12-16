# vim:ft=zsh ts=2 sw=2 sts=2
#
# Custom ZSH Theme
# Combines:
# 1. Agnoster theme
# 2. Dashes separator (from af-magic theme)
# 3. Cmdtime (from github.com/tom-auger/cmdtime)
#

# =============================================================================
# 1. INITIALIZATION & MODULES
# =============================================================================
setopt promptsubst

# Load required modules
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
zmodload zsh/datetime

# =============================================================================
# 2. CONFIGURATION & SYMBOLS
# =============================================================================

# Solarized Scheme Configuration
CURRENT_BG='NONE'
case ${SOLARIZED_THEME:-dark} in
  light) CURRENT_FG='white';;
  *)     CURRENT_FG='black';;
esac

# Powerline Symbols
# defined efficiently to avoid encoding issues
() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'
  PL_BRANCH_CHAR_DEFAULT=$'\ue0a0'
}

# Timer Configuration
TIMER_FORMAT="${TIMER_FORMAT:-%d}"
TIMER_THRESHOLD="${TIMER_THRESHOLD:-1}"

# Dashes Color Configuration
# Take name of color ('red', 'blue') or code ('004', '208').
# : ${DASHES_COLOR:="004"}
DASHES_COLOR="${DASHES_COLOR:-004}"

# =============================================================================
# 3. UTILITIES & HELPERS
# =============================================================================

# --- Segment Drawing Helpers ---

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# --- Dashes Logic ---

# Dashes: separator line filling the screen width
prompt_dashes() {
  # Проверяем окружение python (старая логика для корректировки длины)
  local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
  local python_env="${python_env_dir##*/}"
  
  # Вычисляем длину
  local dash_len=$COLUMNS

  # Если есть virtualenv и он отображается в промпте, уменьшаем длину линии
  # (оставляем вашу логику как есть)
  if [[ -n "$python_env" && "$PROMPT" = *\(${python_env}\)* ]]; then
    dash_len=$(( COLUMNS - ${#python_env} - 3 ))
  fi

  # Защита от отрицательной длины (если окно терминала очень узкое)
  if (( dash_len < 0 )); then
    dash_len=0
  fi

  # Рисуем линию
  # %F{...} - установка цвета текста (ZSH native)
  # ${(l.Length..Char.)} - паддинг (заполнение символом)
  # %f - сброс цвета
  echo "%F{$DASHES_COLOR}${(l.${dash_len}..-.)}%f"
}

# =============================================================================
# 4. PROMPT COMPONENTS (SEGMENTS)
# =============================================================================

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  
  local PL_BRANCH_CHAR=$PL_BRANCH_CHAR_DEFAULT
  local ref dirty mode repo_path

  if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(command git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref="◈ $(command git describe --exact-match --tags HEAD 2> /dev/null)" || \
    ref="➦ $(command git rev-parse --short HEAD 2> /dev/null)"
    
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green $CURRENT_FG
    fi

    local ahead behind
    ahead=$(command git log --oneline @{upstream}.. 2>/dev/null)
    behind=$(command git log --oneline ..@{upstream} 2>/dev/null)
    if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21c5'
    elif [[ -n "$ahead" ]]; then
      PL_BRANCH_CHAR=$'\u21b1'
    elif [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21b0'
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

# Bazaar (bzr)
prompt_bzr() {
  (( $+commands[bzr] )) || return

  local dir="$PWD"
  while [[ ! -d "$dir/.bzr" ]]; do
    [[ "$dir" = "/" ]] && return
    dir="${dir:h}"
  done

  local bzr_status status_mod status_all revision
  if bzr_status=$(command bzr status 2>&1); then
    status_mod=$(echo -n "$bzr_status" | head -n1 | grep "modified" | wc -m)
    status_all=$(echo -n "$bzr_status" | head -n1 | wc -m)
    revision=${$(command bzr log -r-1 --log-format line | cut -d: -f1):gs/%/%%}
    if [[ $status_mod -gt 0 ]] ; then
      prompt_segment yellow black "bzr@$revision ✚"
    else
      if [[ $status_all -gt 0 ]] ; then
        prompt_segment yellow black "bzr@$revision"
      else
        prompt_segment green black "bzr@$revision"
      fi
    fi
  fi
}

# Mercurial (hg)
prompt_hg() {
  (( $+commands[hg] )) || return
  local rev st branch
  if $(command hg id >/dev/null 2>&1); then
    if $(command hg prompt >/dev/null 2>&1); then
      if [[ $(command hg prompt "{status|unknown}") = "?" ]]; then
        prompt_segment red white
        st='±'
      elif [[ -n $(command hg prompt "{status|modified}") ]]; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green $CURRENT_FG
      fi
      echo -n ${$(command hg prompt "☿ {rev}@{branch}"):gs/%/%%} $st
    else
      st=""
      rev=$(command hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(command hg id -b 2>/dev/null)
      if command hg st | command grep -q "^\?"; then
        prompt_segment red black
        st='±'
      elif command hg st | command grep -q "^[MA]"; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green $CURRENT_FG
      fi
      echo -n "☿ ${rev:gs/%/%%}@${branch:gs/%/%%}" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue $CURRENT_FG '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    prompt_segment blue black "(${VIRTUAL_ENV:t:gs/%/%%})"
  fi
}

# Status: error, root, job
prompt_status() {
  local -a symbols

  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

# AWS Profile
prompt_aws() {
  [[ -z "$AWS_PROFILE" || "$SHOW_AWS_PROMPT" = false ]] && return
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment red yellow  "AWS: ${AWS_PROFILE:gs/%/%%}" ;;
    *) prompt_segment green black "AWS: ${AWS_PROFILE:gs/%/%%}" ;;
  esac
}

# =============================================================================
# 5. EXECUTION TIME LOGIC (Cmdtime)
# =============================================================================

__cmdtime_current_time() {
  echo $EPOCHREALTIME
}

__cmdtime_format_duration() {
  local hours=$(printf '%u' $(($1 / 3600)))
  local mins=$(printf '%u' $((($1 - hours * 3600) / 60)))
  local secs=$(printf "%.3f" $(($1 - 60 * mins - 3600 * hours)))
  if [[ ! "${mins}" == "0" ]] || [[ ! "${hours}" == "0" ]]; then
      secs=${secs%\.*}
  elif [[ "${secs}" =~ "^0\..*" ]]; then
      secs="${${${secs#0.}#0}#0}m"
  else
      secs=${secs%?}
  fi
  local duration_str=$(echo "${hours}h:${mins}m:${secs}s")
  echo "${TIMER_FORMAT//\%d/${${duration_str#0h:}#0m:}}"
}

__cmdtime_save_time_preexec() {
  __cmdtime_cmd_start_time=$(__cmdtime_current_time)
  # Clear RPROMPT before executing command to remove old timing
  RPROMPT=""
}

__cmdtime_display_cmdtime_precmd() {
  if [ -n "${__cmdtime_cmd_start_time}" ]; then
    local cmd_end_time=$(__cmdtime_current_time)
    local tdiff=$((cmd_end_time - __cmdtime_cmd_start_time))
    unset __cmdtime_cmd_start_time

    if (( tdiff >= TIMER_THRESHOLD )); then
        local tdiffstr=$(__cmdtime_format_duration ${tdiff})

        # Styling to match Agnoster theme (Right prompt)
        # Background: 008 (Dark Grey), Foreground: 015 (White)
        local BG_COLOR="008"
        local FG_COLOR="015"
        local PL_ARROW_LEFT=""

        RPROMPT="%f%k%F{$BG_COLOR}${PL_ARROW_LEFT}%K{$BG_COLOR}%F{$FG_COLOR} ${tdiffstr} %f%k"
    else
        RPROMPT=""
    fi
  else
    # Clear RPROMPT if no command was executed (empty Enter)
    RPROMPT=""
  fi
}

# =============================================================================
# 6. MAIN PROMPT CONSTRUCTION & HOOKS
# =============================================================================

build_prompt() {
  RETVAL=$?
  prompt_dashes
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_context
  prompt_dir
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_end
}

# Set the prompt
PROMPT='%{%f%b%k%}$(build_prompt) '

# Register hooks
add-zsh-hook preexec __cmdtime_save_time_preexec
add-zsh-hook precmd __cmdtime_display_cmdtime_precmd
