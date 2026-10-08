function pty --description 'Report pseudo-terminal usage vs the kernel cap and flag the top holders'
    # --- usage ---------------------------------------------------------------
    # pty            show summary + per-command breakdown
    # pty -q         quiet: print only "<used>/<max>" and set a nonzero exit if near/over cap
    # pty -n N       show top N holders (default 15)
    # pty -w PCT     warn threshold as a percent of the cap (default 80)
    # -------------------------------------------------------------------------

    argparse 'q/quiet' 'n/top=' 'w/warn=' 'h/help' -- $argv
    or return 2

    if set -q _flag_help
        echo 'pty - pseudo-terminal usage watchdog'
        echo
        echo 'Usage: pty [-q] [-n TOP] [-w WARN_PCT]'
        echo '  -q, --quiet      print only "used/max"; exit 1 if >= warn, 2 if >= cap'
        echo '  -n, --top N      show top N holding commands (default 15)'
        echo '  -w, --warn PCT   warn threshold as percent of cap (default 80)'
        return 0
    end

    set -l top (set -q _flag_top; and echo $_flag_top; or echo 15)
    set -l warn_pct (set -q _flag_warn; and echo $_flag_warn; or echo 80)

    # Kernel cap (macOS). Fall back gracefully on other platforms.
    set -l max (sysctl -n kern.tty.ptmx_max 2>/dev/null)
    if test -z "$max"
        set max 0
    end

    # Count currently-allocated pty slave devices. Prefer a direct device-node
    # glob; if that yields nothing (sandbox / restricted stat), fall back to the
    # distinct device count lsof reports so we never silently show 0.
    set -l used (count (path filter -c /dev/ttys* 2>/dev/null))
    if test $used -eq 0
        set used (lsof /dev/ttys* 2>/dev/null | awk 'NR>1 {print $NF}' | sort -u | count)
    end

    # Threshold in absolute slots.
    set -l warn_at 0
    if test $max -gt 0
        set warn_at (math "floor($max * $warn_pct / 100)")
    end

    # Status + exit code.
    set -l status_word 'OK'
    set -l code 0
    if test $max -gt 0
        if test $used -ge $max
            set status_word 'OVER CAP'
            set code 2
        else if test $used -ge $warn_at
            set status_word 'NEAR CAP'
            set code 1
        end
    end

    if set -q _flag_quiet
        echo "$used/$max"
        return $code
    end

    # --- human-readable report ----------------------------------------------
    set_color --bold
    printf 'PTY usage: %d / %d  (%s)\n' $used $max $status_word
    set_color normal

    if test $max -gt 0
        set -l pct (math "round($used * 100 / $max)")
        set -l barw 30
        set -l fill (math "min($barw, round($used * $barw / $max))")
        set -l empty (math "$barw - $fill")
        set -l color green
        test $code -ge 1; and set color yellow
        test $code -ge 2; and set color red
        set_color $color
        printf '['
        for i in (seq $fill); printf '#'; end
        for i in (seq $empty); printf '-'; end
        printf '] %d%%  (warn at %d)\n' $pct $warn_at
        set_color normal
    end

    # Top holders by command. lsof needs no sudo for your own fds, but may need
    # it to see every process -- note that if the breakdown looks thin.
    echo
    set_color --dim
    echo 'Top holders (command  pty-count  pids):'
    set_color normal

    set -l breakdown (lsof /dev/ttys* 2>/dev/null \
        | awk 'NR>1 {print $1"\t"$2}' \
        | sort -u \
        | awk -F'\t' '{cnt[$1]++; pids[$1]=pids[$1]" "$2} END {for (c in cnt) printf "%d\t%s\t%s\n", cnt[c], c, pids[c]}' \
        | sort -rn)

    if test -z "$breakdown"
        set_color yellow
        echo '  (lsof returned nothing -- try: sudo lsof /dev/ttys*)'
        set_color normal
    else
        printf '%s\n' $breakdown | head -n $top | while read -l cnt cmd pidlist
            printf '  %-18s %4d  %s\n' $cmd $cnt (string trim -- $pidlist)
        end
    end

    # Multiplexer hint -- detached sessions are the classic silent leak.
    set -l muxhint
    if command -q tmux; and tmux ls 2>/dev/null >/dev/null
        set -a muxhint "tmux ls   ("(tmux ls 2>/dev/null | count)" session(s))"
    end
    if command -q zellij
        set -l zcount (zellij list-sessions 2>/dev/null | count)
        test $zcount -gt 0; and set -a muxhint "zellij list-sessions   ($zcount)"
    end
    if test (count $muxhint) -gt 0
        echo
        set_color --dim
        echo 'Multiplexer sessions holding ptys:'
        for h in $muxhint; echo "  $h"; end
        set_color normal
    end

    return $code
end
