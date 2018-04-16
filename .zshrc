# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Export npm global path
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.npm-global/bin
export PATH=$PATH:/opt/android-sdk/platform-tools
export PATH=$PATH:~/.gem/ruby/2.5.0/bin

# Theme Configuration

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(host root_indicator dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time background_jobs status time ssh)
POWERLEVEL9K_MODE="nerdfont-complete"

# Easily switch primary foreground/background colors
DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235
DEFAULT_COLOR=$DEFAULT_FOREGROUND

POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭"
#POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="❱ "
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰ \uF460\uF460\uF460 "

# Theme VCS config
POWERLEVEL9K_SHOW_CHANGESET=true

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
aliases() {
  alias edit="$EDITOR"
  alias zshconfig="$EDITOR ~/.zshrc"
  alias zshsource="source ~/.zshrc"
  alias docker-env="eval \$(docker-machine env)"
  alias aws-docker-login="eval \$(aws ecr get-login)"
  # alias ohmyzsh="mate ~/.oh-my-zsh"
}
# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#
# We are using our own theme, installed elsewhere
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colorize command-not-found compleat tmux tugboat bower 
github gitignore node yarn archlinux sudo autojump aws common-aliases 
dirhistory gpg-agent systemd docker docker-machine docker-compose dotenv
systemadmin aws autojump command-not-found colored-man-pages fancy-ctrl-z npx)

# Internals. Do not touch


export TERM=xterm-256color
# A ZSH cache dir for each user
ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
# Create it if it doesn't exist
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

os_distribution() {
  if [ -f "/etc/arch-release" ] || [ -f "/etc/anarchy-release" ]; then
    echo "arch"
  else
    echo "unknown"
    return 1
  fi
}

package_installed() {
  distribution=$(os_distribution)
  case $distribution in
    arch)
      pacman -Qi $1 &> /dev/null
      ;;
    *)
      return 0
      ;;
  esac
}

warn_package_installed() {
  if ! package_installed $1; then
    echo "Please install package" $1
  fi
}

_source() {
  source $1 &> /dev/null
}

# Arch Linux specific package path
if [ -f "/etc/arch-release" ] || [ -f "/etc/anarchy-release" ]; then
  if ! package_installed nerd-fonts-complete; then
    echo "Install nerd-fonts-complete and select a font to fix icon issues"
  fi

  if package_installed zsh-theme-powerlevel9k; then
    ZSH_THEME=/usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme
  else
    ZSH_THEME_PKG=zsh-theme-powerlevel9k
  fi

  if package_installed zsh-syntax-highlighting; then
    ZSH_SYNTAX_HIGHLIGHTING=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  else
    ZSH_SYNTAX_HIGHLIGHTING_PKG=zsh-syntax-highlighting
  fi
  
  if package_installed pkgfile; then
    ZSH_COMMAND_NOT_FOUND=/usr/share/doc/pkgfile/command-not-found.zsh
    if ! pkgfile -b -v -- zsh &> /dev/null; then
      echo "Please run \`pkgfile --update\` to enable Command Not Found"
    fi
  else
    ZSH_COMMAND_NOT_FOUND_PKG=pkgfile
  fi
  
  if package_installed zsh-autosuggestions; then
    ZSH_AUTOSUGGESTIONS=/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  else
    ZSH_AUTOSUGGESTIONS_PKG=zsh-autosuggestions
  fi
fi

if ! _source $ZSH_THEME; then
  echo "Theme disabled. Please install $ZSH_THEME_PKG"
fi

if ! _source $ZSH_SYNTAX_HIGHLIGHTING; then
  echo "Syntax Highlighting Plugin not found. Please install $ZSH_SYNTAX_HIGHLIGHTING_PKG"
fi

if ! _source $ZSH_COMMAND_NOT_FOUND; then
  echo "Command Not Found Plugin not found. Please install $ZSH_COMMAND_NOT_FOUND_PKG"
fi

if ! _source $ZSH_AUTOSUGGESTIONS; then
  echo "Autosuggestions Plugin not found. Please install $ZSH_AUTOSUGGESTIONS_PKG"
fi

aliases

