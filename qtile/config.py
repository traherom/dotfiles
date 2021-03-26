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

import os
import subprocess
from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook, qtile
from libqtile import config
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
shift = "shift"
ctrl = "ctrl"

terminal = guess_terminal()
web_browser = "google-chrome"
file_browser = "pcmanfm"
    
keys = [
    # Switch between windows in current stack pane
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus up in stack pane"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus down in stack pane"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),

    # Move windows up or down in current stack
    Key([mod, shift], "h", lazy.layout.swap_left(), desc="Move window to left stack "),
    Key([mod, shift], "k", lazy.layout.shuffle_up(), desc="Move window down in current stack "),
    Key([mod, shift], "j", lazy.layout.shuffle_down(), desc="Move window up in current stack "),
    Key([mod, shift], "l", lazy.layout.swap_right(), desc="Move window to right stack "),
    
    # Sizing
    Key([mod], "n", lazy.layout.normalize()),

    # XMonadTall bindings
    Key([mod], "i", lazy.layout.grow()),
    Key([mod], "m", lazy.layout.shrink()),
    Key([mod], "o", lazy.layout.maximize()),
    Key([mod, shift], "space", lazy.layout.flip()),
    
    # Column bindings
    # Key([mod, shift], "j", lazy.layout.shuffle_down()),
    # Key([mod, shift], "k", lazy.layout.shuffle_up()),
    # Key([mod, shift], "h", lazy.layout.shuffle_left()),
    # Key([mod, shift], "l", lazy.layout.shuffle_right()),
    # Key([mod, ctrl], "j", lazy.layout.grow_down()),
    # Key([mod, ctrl], "k", lazy.layout.grow_up()),
    # Key([mod, ctrl], "h", lazy.layout.grow_left()),
    # Key([mod, ctrl], "l", lazy.layout.grow_right()),
    # Key([mod], "Return", lazy.layout.toggle_split()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "Tab", lazy.layout.next(), desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, shift], "Tab", lazy.layout.rotate(), desc="Swap panes of split stack"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, shift], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
        
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "y", lazy.spawn(web_browser), desc="Launch web browser"),
    Key([mod], "e", lazy.spawn(file_browser), desc="Launch file browser"),
    Key([mod], "p", lazy.spawn("rofi -modi combi,run,drun -show combi -combi-modi drun,run"), desc="Launcher"),

    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, shift], "q", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, shift], "c", lazy.restart(), desc="Restart qtile"),
    Key([mod, shift], "e", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),

    # Hardware
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') +8%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') -8%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute $(pacmd list-sinks |awk '/* index:/{print $3}') toggle")),
    Key([], "XF86AudioMicMute", lazy.spawn("amixer -D pulse sset Capture toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
]

groups = [
    Group("1"),
    Group("2"),
    Group("3"),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
    Group(
        "0",
        label="Chat",
        matches=[
            Match(wm_class="discord"),
            Match(wm_class="signal"),
        ],
        layouts=[
            layout.Columns(num_columns=2, name="2col"),
            layout.Max(),
        ],
    ),
]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        # Key([mod, shift], i.name, lazy.window.togroup(i.name, switch_group=True),
        #     desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        Key([mod, shift], i.name, lazy.window.togroup(i.name),
            desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.MonadTall(ratio=0.6, new_at_current=True),
    layout.Max(),
    # layout.Columns(num_columns=2, name="2col"),
    # layout.Columns(num_columns=3, name="3col"),
    # layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

def get_bar():
    return bar.Bar(
        [
            widget.CurrentScreen(),
            widget.Sep(),
            widget.GroupBox(disable_drag=True),
            widget.Sep(),
            widget.CurrentLayout(),
            widget.Sep(),
            widget.Chord(
                chords_colors={
                    'launch': ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
            widget.Prompt(),
            widget.TaskList(),
            widget.BatteryIcon(battery=1),
            #widget.Systray(),
            widget.Clock(format='%a %d %b %H:%M '),
        ],
        24,
    )

def configure_screens():
    []
    return [
        Screen(
            top=get_bar()
        ),
    ]

screens = configure_screens()

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = False
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/i3/autostart.sh')
    subprocess.call([home])

@hook.subscribe.screen_change
def restart_on_randr(ev):
    qtile.cmd_restart()
