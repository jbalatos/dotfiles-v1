# Copyright (c) 2010 Aldo Cortesi{{{
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
# SOFTWARE.}}}

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.hook import subscribe

mod = "mod4"
terminal = "xterm"
browser = "firefox"
prompt = "dmenu_run -h 25"
file_manager = "pcmanfm"
shutdown_cmd = "~/.config/qtile/gentle_shutdown"

colors = ['#282828', '#a89984', '#ebdbb2', '#fb4934', '#282828']

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(["control"], "space", lazy.layout.next(), desc="Change window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),

    # General resize keybinds
    KeyChord([mod, "control"], "u", [
        Key([], "i", lazy.layout.grow()),
        Key([], "u", lazy.layout.shrink()),
        Key([], "n", lazy.layout.normalize()),
    ], mode="resize"),

    # Monadtall keybinds
    KeyChord([mod, "control"], "m", [
        Key([], "i", lazy.layout.grow_main()),
        Key([], "u", lazy.layout.shrink_main()),
        Key([], "n", lazy.layout.reset()),
        Key([], "f", lazy.layout.flip())
    ], mode="monad"),

    # Columns keybinds
    KeyChord([mod, "control"], "c", [
        Key([], "h", lazy.layout.swap_column_left()),
        Key([], "l", lazy.layout.swap_column_right()),
        Key([], "Return", lazy.layout.toggle_split(),
            desc="Toggle between split and unsplit sides of stack"),
    ], mode="columns"),

    # Fullscreen
    Key([mod], "m", lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on active window"),

    # Set opacity
    # KeyChord([mod, "control"], "o", [
        # Key([], "i", lazy.window.up_opacity()),
        # Key([], "u", lazy.window.down_opacity()),
    # ], mode="opacity"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Toggle between layouts"),

    # Launching apps (Firefox, dmenu, terminal, ranger)
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "r", lazy.spawn(prompt),
        desc="Spawn a command using a prompt widget"),
    Key([mod], "b", lazy.spawn(browser), desc="Open Browser"),
    Key([mod], "f", lazy.spawn(file_manager), desc="Open File Manager"),

    # Kill window,  restart and close qtile
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Change keyboard layout
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Change keyboard layout"),

    # Sound
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 sset Master 1- unmute")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 sset Master 1+ unmute")),
]

groups = [
    Group('DEV'),
    Group('WWW'),
    Group('PDF'),
    Group('MUS'),
    Group('MISC'),
]

group_keys = 'yuiop'; # positioned by ascending preference

def change_window_names(c):
    if c.name.startswith("jbalatos@ArchVm"):
        c.name = "XTerm"
    elif c.name.endswith("Mozilla Firefox"):
        c.name = "Mozilla Firefox"

def enable_floating(c) :
    if c.name == "Shutdown Prompt":
        c.cmd_enable_floating()

def switch_workspaces(c):
    if c.name.endswith("Mozilla Firefox"):
        c.togroup('WWW', switch_group=True)

subscribe.client_new(change_window_names)
subscribe.client_new(enable_floating)
subscribe.client_new(switch_workspaces)
subscribe.client_name_updated(change_window_names)

for i in range(len(groups)):
    group_len = len(groups)
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], group_keys[-group_len+i], lazy.group[groups[i].name].toscreen(),
            desc="Switch to group {}".format(groups[i].name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], group_keys[-group_len+i], lazy.window.togroup(groups[i].name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(groups[i].name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layout_settings = {'border_focus': colors[3], 'border_width': 1, 'margin': 8}

layouts = [
    layout.MonadTall(**layout_settings),
    layout.Columns(num_columns=2, insert_position=1, **layout_settings),
    layout.Floating(**layout_settings),
    layout.Max(**layout_settings),
]

widget_defaults = {
    'font': 'Ubuntu Bold Nerd Font',
    'fontsize': 14,
    'foreground': colors[2],
}

def handle_power_click() :
    qtile.cmd_spawn([
        terminal, '-bg', colors[3],
        '-T', 'Shutdown Prompt', '-e', shutdown_cmd
    ])

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Chord(**widget_defaults, background=colors[0],),
                widget.GroupBox(
                    padding=2,
                    background=colors[3],
                    hightlight_method='block',
                    inactive=colors[0],
                    active=colors[2],
                    this_current_screen_border = colors[0],
                    borderwidth=2,
                    **widget_defaults,
                ),
                widget.Image(filename='~/.config/qtile/icons/red_right_black.png'),
                widget.WindowName(max_chars=20, **widget_defaults, background=colors[0]),

                widget.Image(filename='~/.config/qtile/icons/red_left_black.png'),
                widget.TextBox(
                    text='☵', padding=0, fontsize=16,
                    foreground=colors[2], background=colors[3]
                ),
                widget.CurrentLayout(
                    **widget_defaults, padding=2, background=colors[3]
                ),
                widget.Image(filename='~/.config/qtile/icons/black_left_red.png', padding=0, margin=0),
                widget.Clock(
                    format='%d/%m/%Y | %a %H:%M',
                    **widget_defaults, background=colors[4]
                ),
                widget.Image(filename='~/.config/qtile/icons/red_left_black.png'),
                widget.KeyboardLayout(
                    configured_keyboards=['us', 'gr'],
                    **widget_defaults, background=colors[3]
                ),
                widget.Image(filename='~/.config/qtile/icons/black_left_red.png'),
                widget.TextBox(
                    text='↻', padding=2, fontsize=16,
                    foreground=colors[2], background=colors[4]
                ),
                widget.CheckUpdates(
                    **widget_defaults, background=colors[4],
                    colour_have_updates=colors[2], colour_no_updates=colors[1],
                    custom_command='checkupdates', display_format='{updates} P',
                    execute=terminal + ' -e sudo pacman -Syu',
                    no_update_string='0 P |', padding=1
                ),
                widget.CheckUpdates(
                    **widget_defaults, background=colors[4], padding=1,
                    colour_have_updates=colors[2], colour_no_updates=colors[1],
                    custom_command='checkupdates-aur', display_format='{updates} A',
                    execute=terminal + ' -e yay -Syu',
                    no_update_string='0 A'
                ),
                widget.TextBox(text=' ', padding=0, background=colors[4]),
                widget.Image(filename='~/.config/qtile/icons/red_left_black.png', padding=0, margin=0),
                widget.TextBox(
                    text='♫', padding=0, fontsize=14,
                    foreground=colors[2], background=colors[3]
                ),
                widget.Volume(**widget_defaults, background=colors[3]),
                widget.Image(filename='~/.config/qtile/icons/black_left_red.png'),
                widget.Battery(
                    format='{char} {percent:0.0%}', charge_char='↑',
                    discharge_char='↓', **widget_defaults, background=colors[4]
                ),
                widget.Image(
                    filename='~/.config/qtile/icons/red_left_black.png',
                    padding=0, margin=0,
                ),
                # widget.TextBox(text='  ', **widget_defaults, background=colors[3]),
# Power symbol
                widget.TextBox(
                    mouse_callbacks={'Button1': handle_power_click},
                    text=u"\u23FB" + " ", fontsize=20,
                    background=colors[3], 
                ),
            ],
            25,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
    Click([mod], "Button1", lazy.window.toggle_floating())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
