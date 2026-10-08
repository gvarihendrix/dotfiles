# Warn in the prompt when pseudo-terminal usage approaches the kernel cap.
# Relies on the `pty` function (functions/pty.fish). Prints ONE line only when
# at/over the warn threshold; silent otherwise, so it never clutters a normal
# prompt or fights the theme's prompt renderer.
#
# Throttled to at most once every __pty_warn_interval seconds so a tight prompt
# loop (hitting enter repeatedly) does not run lsof on every keystroke.

set -q __pty_warn_interval; or set -g __pty_warn_interval 30
set -g __pty_warn_last 0

function __pty_warn --on-event fish_prompt
    functions -q pty; or return

    set -l now (date +%s)
    if test (math "$now - $__pty_warn_last") -lt $__pty_warn_interval
        return
    end
    set -g __pty_warn_last $now

    # `pty -q` prints "used/max" and exits 1 (near cap) or 2 (over cap).
    set -l reading (pty -q 2>/dev/null)
    set -l code $status
    test $code -eq 0; and return  # OK -- stay quiet

    if test $code -ge 2
        set_color red --bold
        echo "⚠ PTY OVER CAP: $reading -- new tabs/panes will fail (ENXIO). Run: pty"
    else
        set_color yellow
        echo "⚠ PTY near cap: $reading -- run `pty` to see holders"
    end
    set_color normal
end
