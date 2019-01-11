# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, Screen, Group, Drag, Click, Rule, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

from typing import List
from pathlib import Path
import subprocess
import re
import logging

config_dir = Path(__file__).resolve().parent

logging.basicConfig(filename=config_dir / "qtile-config.log", level=logging.DEBUG)
LOG = logging.getLogger(__name__)

################################
# Helpers
def launch_script(script, args: List = None):
    @lazy.function
    def __inner(qtile):
        cmd = ["sh", config_dir / script]
        if args is not None:
            cmd.extend(args)
        LOG.info("Running script %s", cmd)
        subprocess.run(cmd)

    return __inner


def window_to_group_with_focus():
    @lazy.function
    def __inner(qtile):
        i = qtile.groups.index(qtile.currentGroup)

        if qtile.currentWindow and i != 0:
            group = qtile.groups[i - 1].name
            qtile.currentWindow.togroup(group)
            qtile.currentScreen.cmd_toggle_group(group_name=group)

    return __inner


def window_to_prev_group():
    @lazy.function
    def __inner(qtile):
        i = qtile.groups.index(qtile.currentGroup)

        if qtile.currentWindow and i != 0:
            group = qtile.groups[i - 1].name
            qtile.currentWindow.togroup(group)
            qtile.currentScreen.cmd_toggle_group(group_name=group)

    return __inner


def window_to_next_group():
    @lazy.function
    def __inner(qtile):
        i = qtile.groups.index(qtile.currentGroup)

        if qtile.currentWindow and i != len(qtile.groups):
            group = qtile.groups[i + 1].name
            qtile.currentWindow.togroup(group)
            qtile.currentScreen.cmd_toggle_group(group_name=group)

    return __inner


##################################
# Configuration items
def init_colors():
    return {
        "black": ["#2B303B", "#2B303B"],
        "grey": ["#40444D", "#424A5B"],
        "white": ["#C0C5CE", "#C0C5CE"],
        "red": ["#BF616A", "#BF616A"],
        "magenta": ["#B48EAD", "#B48EAD"],
        "green": ["#A3BE8C", "#A3BE8C"],
        "darkgreen": ["#859900", "#859900"],
        "blue": ["#8FA1B3", "#8FA1B3"],
        "darkblue": ["#65737E", "#65737E"],
        "orange": ["#EBCB8B", "#EBCB8B"],
    }


def init_keys():
    keys = [
        # Window movement
        Key([mod], "Right", lazy.screen.next_group()),  # Move to right group
        Key([mod], "Left", lazy.screen.prev_group()),  # Move to left group
        Key([mod, shift], "Right", window_to_next_group()),  # Move to right group
        Key([mod, shift], "Left", window_to_prev_group()),  # Move to left group
        # Switch between windows in current stack pane
        Key([mod], "k", lazy.layout.down()),
        Key([mod], "j", lazy.layout.up()),
        # Move windows up or down in current stack
        Key([mod, control], "k", lazy.layout.shuffle_down()),
        Key([mod, control], "j", lazy.layout.shuffle_up()),
        # Switch window focus to other pane(s) of stack
        Key([mod], "space", lazy.layout.next()),
        # Swap panes of split stack
        Key([mod, shift], "space", lazy.layout.rotate()),
        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key([mod, shift], "Return", lazy.layout.toggle_split()),
        Key([mod], "Return", lazy.spawn("mate-terminal")),
        # Toggle between different layouts as defined below
        Key([mod], "Tab", lazy.next_layout()),
        # Program control
        Key([mod], "w", lazy.window.kill()),
        Key([mod], "p", lazy.spawn("rofi -show drun")),
        Key([mod, shift], "p", lazy.spawn("rofi -show window")),
        # Hardware control
        Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
        Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
        Key([], "XF86AudioMute", lazy.spawn("amixer sset Master toggle")),
        Key([mod], "F1", lazy.spawn("lxrandr")),
        Key([mod], "F2", launch_script("monitor-laptop-only.sh")),
        Key([mod], "F3", launch_script("monitor-home-dock.sh")),
        Key([mod], "F4", launch_script("monitor-projector.sh")),
        Key([mod], "F5", launch_script("monitor-mirror.sh")),
        # QTile
        Key([mod], "l", lazy.spawn("light-locker-command -l")),
        Key(
            [mod, control],
            "e",
            lazy.spawn("code '{}'".format(Path(__file__).resolve())),
        ),
        Key([mod, control], "r", lazy.restart()),
        Key([mod, control], "q", lazy.shutdown()),
    ]

    return keys


def init_group_keybindings(groups):
    for i, group in enumerate(groups, start=1):
        # mod1 + letter of group = switch to group
        keys.append(Key([mod], str(i), lazy.group[group.name].toscreen()))

        # mod1 + shift + letter of group = switch to & move focused window to group
        keys.append(Key([mod, shift], str(i), lazy.window.togroup(group.name)))


def init_layouts():
    return [
        layout.Max(),
        layout.Stack(num_stacks=2),
        layout.Matrix(),
        # layout.Tile(),
        layout.Columns(),
        # layout.Bsp(),
        layout.Zoomy(),
        layout.Floating(),
    ]


def init_floating_layout():
    return layout.Floating(
        border_width=2, border_focus=colors["blue"][0], border_normal=colors["black"][0]
    )


def init_groups():
    terminal_wm_class = "Mate-terminal"
    terminal_group_config = {
        "layout": "columns",
        "layouts": [layout.Columns(num_columns=3), layout.Matrix()],
        "matches": [Match(wm_class=[terminal_wm_class])],
        "exclusive": True,
    }

    return [
        Group(
            "WWW",
            layout="columns",
            layouts=[layout.Max(), layout.Columns(num_columns=3)],
            matches=[Match(wm_class=["Firefox", "Brave-browser", "Chrome-browser"])],
        ),
        Group(
            "Dev",
            layout="columns",
            layouts=[layout.Columns(num_columns=2)],
            matches=[Match(wm_class=["Code"])],
        ),
        Group("T1", **terminal_group_config),
        Group("T2", **terminal_group_config),
        Group("T3", **terminal_group_config),
        Group(
            "Misc",
            layout="columns",
            layouts=[layout.Max(), layout.Columns(num_columns=2)],
        ),
    ]


def init_widgets_defaults():
    return dict(font="Arial", fontsize=16, padding=3)


def init_screens():
    return [
        Screen(
            top=bar.Bar(
                [
                    widget.Prompt(),
                    widget.GroupBox(),
                    widget.WindowName(),
                    widget.MemoryGraph(),
                    widget.CurrentLayoutIcon(),
                    widget.Notify(),
                    widget.Systray(),
                    widget.TextBox("🔉"),
                    widget.Volume(),
                    widget.Battery(format="🔋 {percent:2.0%}"),
                    widget.Clock(format="%I:%M %p"),
                ],
                30,
            )
        )
    ]


def init_mouse():
    # Drag floating layouts.
    return [
        Drag(
            [mod],
            "Button1",
            lazy.window.set_position_floating(),
            start=lazy.window.get_position(),
        ),
        Drag(
            [mod],
            "Button3",
            lazy.window.set_size_floating(),
            start=lazy.window.get_size(),
        ),
        Click([mod], "Button2", lazy.window.bring_to_front()),
    ]


def init_rules():
    return [
        # Floating types
        Rule(
            Match(
                wm_type=[
                    "confirm",
                    "download",
                    "notification",
                    "toolbar",
                    "splash",
                    "dialog",
                    "error",
                    "file_progress",
                    "confirmreset",
                    "makebranch",
                    "maketag",
                    "branchdialog",
                    "pinentry",
                    "sshaskpass",
                ]
            ),
            float=True,
        ),
        # Floating classes
        Rule(
            Match(
                wm_class=[
                    "Xfce4-taskmanager",
                    "Gparted",
                    "Nitrogen",
                    "Lightdm-gtk-greeter-settings",
                    "Nm-connection-editor",
                    "Lxappearance",
                    "Pavucontrol",
                    "Arandr",
                    "qt5ct",
                    "Thunar",
                    "Engrampa",
                    "File-roller",
                    "Simple-scan",
                    re.compile("VirtualBox"),
                ]
            ),
            float=True,
            break_on_match=False,
        ),
    ]


######################################
# Initialize
if __name__ in ["config", "__main__"]:
    LOG.debug("Initializing, name %s", __name__)

    # Key alias
    mod = "mod4"
    alt = "mod1"
    shift = "shift"
    control = "control"

    colors = init_colors()
    # fonts = init_fonts()

    keys = init_keys()
    mouse = init_mouse()
    floating_layout = init_floating_layout()
    # layout_theme = init_layout_theme()
    # border_args = init_border_args()

    # layouts = init_layouts()
    groups = init_groups()
    init_group_keybindings(groups)
    dgroups_app_rules = init_rules()
    screens = init_screens()
    widget_defaults = init_widgets_defaults()

    dgroups_key_binder = None
    dgroups_app_rules = []
    main = None
    follow_mouse_focus = False
    bring_front_click = False
    cursor_warp = False
    auto_fullscreen = True
    focus_on_window_activation = "smart"
    extentions = []

    # XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
    # string besides java UI toolkits; you can see several discussions on the
    # mailing lists, github issues, and other WM documentation that suggest setting
    # this string if your java app doesn't work correctly. We may as well just lie
    # and say that we're a working one by default.
    #
    # We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
    # java that happens to be on java's whitelist.
    wmname = "LG3D"


##### STARTUP APPLICATIONS #####
@hook.subscribe.startup_once
def start_once():
    path = config_dir / "autostart.sh"
    LOG.info("Running autostart from %s", path)
    subprocess.run(["sh", path])
