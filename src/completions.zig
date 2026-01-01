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
    \\  if [[ $CURRENT -eq 2 ]]; then
    \\    local subcommands=('attach' 'kill' 'list')
    \\    _describe 'subcommand' subcommands
    \\    return
    \\  fi
    \\
    \\  if [[ $CURRENT -eq 3 && ${words[2]} == (attach|kill) ]]; then
    \\    local list=$(zmx list --short)
    \\
    \\    local sessions=(${(f)list})
    \\    _describe 'session' sessions
    \\    return
    \\  fi
    \\}
    \\
    \\compdef _zmx zmx
    \\
    \\_ssh_zmx() {
    \\  if [[ $CURRENT -eq 3 ]]; then
    \\    local commands=('zmx')
    \\    _describe 'remote command' commands
    \\    return
    \\  fi
    \\
    \\  if [[ $CURRENT -eq 4 && ${words[3]} == 'zmx' ]]; then
    \\    local subcommands=('attach' 'kill' 'list')
    \\    _describe 'remote subcommand' subcommands
    \\    return
    \\  fi
    \\
    \\  if [[ $CURRENT -eq 5 && ${words[3]} == 'zmx' && ${words[4]} == (attach|kill) ]]; then
    \\    local list=$(ssh ${words[2]} zmx list --short)
    \\
    \\    local sessions=(${(f)list})
    \\    _describe 'remote session' sessions
    \\    return
    \\  fi
    \\
    \\  _ssh # Fallback to default ssh completions for hostnames
    \\}
    \\
    \\compdef _ssh_zmx ssh
;

const fish_completions =
    \\# TODO: fish completions
;
