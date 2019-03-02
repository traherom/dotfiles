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
from collections import namedtuple

config_dir = Path(__file__).resolve().parent

logging.basicConfig(filename=config_dir / "qtile-config.log", level=logging.DEBUG)
LOG = logging.getLogger(__name__)

Programs = namedtuple("Programs", "terminal,browser,files,editor")

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
        "black": ["#000000", "#000000"],
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
        Key([mod, control], "Down", lazy.layout.shuffle_down()),
        Key([mod, control], "Up", lazy.layout.shuffle_up()),
        Key([mod, control], "Left", lazy.layout.shuffle_left()),
        Key([mod, control], "Right", lazy.layout.shuffle_right()),
        # Resize layout
        Key([mod, alt], "Up", lazy.layout.grow_up()),
        Key([mod, alt], "Down", lazy.layout.grow_down()),
        Key([mod, alt], "Left", lazy.layout.grow_left()),
        Key([mod, alt], "Right", lazy.layout.grow_right()),
        # Switch window focus to other pane(s) of stack
        Key([mod], "space", lazy.layout.next()),
        Key([alt], "Tab", lazy.layout.next()),
        Key([mod, shift], "space", lazy.layout.rotate()),
        Key([mod, shift], "Return", lazy.layout.toggle_split()),
        Key([mod, shift], "Tab", lazy.window.toggle_floating()),
        # Toggle between different layouts as defined below
        Key([mod], "Tab", lazy.next_layout()),
        # Program control
        Key([mod], "z", lazy.window.kill()),
        Key([mod], "a", lazy.spawn("rofi -show drun")),
        Key([mod, shift], "a", lazy.spawn("rofi -show window")),
        Key([mod], "q", lazy.spawn(programs.terminal)),
        Key([mod], "e", lazy.spawn(programs.files)),
        Key([mod], "w", lazy.spawn(programs.browser)),
        # Hardware control
        Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
        Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
        Key([], "XF86AudioMute", lazy.spawn("amixer sset Master toggle")),
        Key([mod], "F1", lazy.spawn("lxrandr")),
        Key([mod], "F2", launch_script("monitor-laptop-only.sh")),
        Key([mod], "F3", launch_script("monitor-external-only.sh")),
        Key([mod], "F4", launch_script("monitor-projector.sh")),
        Key([mod], "F5", launch_script("monitor-mirror.sh")),
        # QTile
        Key([mod], "l", lazy.spawn("light-locker-command -l")),
        Key(
            [mod, control],
            "e",
            lazy.spawn(f"{programs.editor} '{Path(__file__).resolve()}'"),
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


def init_floating_layout():
    return layout.Floating(
        border_width=2, border_focus=colors["blue"][0], border_normal=colors["black"][0]
    )


def init_layouts():
    return [
        layout.Columns(name="2col", num_columns=2),
        layout.Columns(name="3col", num_columns=3),
        layout.Max(),
        # layout.Bsp(),
    ]


def init_groups():
    terminal_wm_class = "Mate-terminal"
    terminal_group_config = {
        # "layout": "2col",
        # "layouts": [
        #     layout.Columns(name="2col", num_columns=2),
        #     layout.Columns(name="3col", num_columns=3),
        #     layout.Max(),
        # ],
        # "exclusive": True,
    }

    return [
        Group(
            "1) WWW",
            # layout="columns",
            # layouts=[layout.Max(), layout.Columns(num_columns=2)],
        ),
        Group(
            "2) Dev",
            layout="columns",
            layouts=[layout.Columns(num_columns=2), layout.Max()],
        ),
        Group("3) T1", **terminal_group_config),
        Group("4) T2", **terminal_group_config),
        Group("5) T3", **terminal_group_config),
        Group("6) Floating", layout="floating", layouts=[layout.Floating()]),
    ]


def init_widgets_defaults():
    return dict(font="Arial", fontsize=16, padding=3)


def init_screens():
    return [
        # Screen(
        #     top=bar.Bar(
        #         [
        #             widget.GroupBox(
        #                 background=colors["white"], foreground=colors["black"]
        #             ),
        #             widget.WindowName(
        #                 background=colors["black"], foreground=colors["white"]
        #             ),
        #         ],
        #         30,
        #     )
        # ),
        Screen(
            top=bar.Bar(
                [
                    widget.Prompt(background=colors["grey"], ignore_dups_history=True),
                    widget.GroupBox(
                        background=colors["white"], foreground=colors["black"]
                    ),
                    widget.WindowName(
                        background=colors["black"], foreground=colors["white"]
                    ),
                    widget.TextBox("CPU"),
                    widget.CPUGraph(),
                    widget.TextBox("Mem"),
                    widget.MemoryGraph(),
                    widget.CurrentLayout(),
                    widget.Notify(),
                    widget.Systray(),
                    widget.TextBox("Vol", background=colors["red"]),
                    widget.Volume(background=colors["red"]),
                    widget.TextBox("Batt", background=colors["green"]),
                    widget.Battery(format="{percent:2.0%}", background=colors["green"]),
                    widget.Clock(
                        format="%I:%M %p",
                        background=colors["white"],
                        foreground=colors["black"],
                    ),
                    widget.Spacer(length=5),
                ],
                30,
            )
        ),
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


def init_programs():
    return Programs(
        terminal="mate-terminal",
        browser="sensible-browser",
        files="caja",
        editor="code",
    )


######################################
# Initialize
if __name__ in ["config", "__main__"]:
    LOG.debug("Initializing, name %s", __name__)

    # Key alias
    mod = "mod4"
    alt = "mod1"
    shift = "shift"
    control = "control"

    programs = init_programs()

    colors = init_colors()
    # fonts = init_fonts()

    keys = init_keys()
    mouse = init_mouse()
    floating_layout = init_floating_layout()
    # layout_theme = init_layout_theme()
    # border_args = init_border_args()

    layouts = init_layouts()
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
