const std = @import("std");

pub const Shell = enum {
    bash,
    zsh,
    fish,

    pub fn fromString(s: []const u8) ?Shell {
        if (std.mem.eql(u8, s, "bash")) return .bash;
        if (std.mem.eql(u8, s, "zsh")) return .zsh;
        if (std.mem.eql(u8, s, "fish")) return .fish;

        return null;
    }

    pub fn getCompletionScript(self: Shell) []const u8 {
        return switch (self) {
            .bash => bash_completions,
            .zsh => zsh_completions,
            .fish => fish_completions,
        };
    }
};

const bash_completions =
    \\# TODO: bash completions
;

const zsh_completions =
    \\_zmx() {
    \\  local context state state_descr line
    \\  typeset -A opt_args
    \\
    \\  _arguments -C \
    \\    '1: :->commands' \
    \\    '2: :->args' \
    \\    '*: :->trailing' \
    \\    && return 0
    \\
    \\  case $state in
    \\    commands)
    \\      local -a commands
    \\      commands=(
    \\        'attach:Attach to session, creating if needed'
    \\        'run:Send command without attaching'
    \\        'detach:Detach all clients from current session'
    \\        'list:List active sessions'
    \\        'completions:Shell completion scripts'
    \\        'sync:Syncronise binary to remote host'
    \\        'kill:Kill a session'
    \\        'history:Output session scrollback'
    \\        'version:Show version'
    \\        'help:Show help message'
    \\      )
    \\      _describe 'command' commands
    \\      ;;
    \\    args)
    \\      case $words[2] in
    \\        attach|a|kill|k|run|r|history|hi)
    \\          _zmx_sessions
    \\          ;;
    \\        completions|c)
    \\          _values 'shell' 'bash' 'zsh' 'fish'
    \\          ;;
    \\        sync|s)
    \\          _zmx_hosts
    \\          ;;
    \\        list|l)
    \\          _values 'options' '--short'
    \\          ;;
    \\      esac
    \\      ;;
    \\    trailing)
    \\      # Additional args for commands like 'attach' or 'run'
    \\      ;;
    \\  esac
    \\}
    \\
    \\_zmx_hosts() {
    \\  local -a hosts
    \\  if [[ -f ~/.ssh/config ]]; then
    \\    hosts=($(awk '/^Host / && !/\*/ {print $2}' ~/.ssh/config))
    \\  fi
    \\  _describe 'hostname' hosts
    \\}
    \\
    \\_zmx_sessions() {
    \\  local -a sessions hosts
    \\
    \\  # Check if user is typing hostname:session pattern
    \\  if [[ $PREFIX == *:* ]]; then
    \\    local hostname=${PREFIX%%:*}
    \\
    \\    local remote_sessions=$(zmx list --short $hostname 2>/dev/null)
    \\    if [[ -n "$remote_sessions" ]]; then
    \\      sessions+=(${(f)remote_sessions})
    \\    fi
    \\
    \\    compadd -p "$hostname:" - ${sessions[@]}
    \\  else
    \\    local local_sessions=$(zmx list --short 2>/dev/null)
    \\    if [[ -n "$local_sessions" ]]; then
    \\      sessions+=(${(f)local_sessions})
    \\    fi
    \\
    \\    if [[ -f ~/.ssh/config ]]; then
    \\      hosts=($(awk '/^Host / && !/\*/ {print $2}' ~/.ssh/config))
    \\    fi
    \\
    \\    _describe 'local session' sessions
    \\    compadd -S ':' - ${hosts[@]}
    \\  fi
    \\}
    \\
    \\compdef _zmx zmx
;

const fish_completions =
    \\# TODO: fish completions
;
