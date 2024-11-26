![Tmux - installation and customization + Nord theme](https://r4ven.me/wp-content/uploads/2024/11/13-33-09_23-11-2024.resized2.png)

- [Tmux – installation and customization + Nord theme](#tmux--installation-and-customization--nord-theme)
    - [Greetings!](#greetings)
  - [Preface](#preface)
  - [Installing Tmux](#installing-tmux)
  - [Downloading the config and running](#downloading-the-config-and-running)
  - [Configuration Description](#configuration-description)
    - [What does this configuration add/change?](#what-does-this-configuration-addchange)
  - [Basic Tmux Hotkeys](#basic-tmux-hotkeys)
  - [Custom Tmux Hotkeys](#custom-tmux-hotkeys)
  - [Useful materials](#useful-materials)

# Tmux – installation and customization + Nord theme

### Greetings!

I will demonstrate the installation and customization of the most popular tool in terminal multiplexer category - **Tmux** 🪟.

The demonstration given in this article was performed in the [**Linux Mint 22**](https://r4ven.me/it-razdel/instrukcii/nativnoe-obnovlenie-s-linux-mint-21-3-do-linux-mint-22/) distribution environment with **Tmux** version **3.4** ✍️.

## Preface

I really love the [Nord](https://r4ven.me/tag/nord-theme/) theme ❄️ from Arcticicestudio⛄️ and prefer to design my system and applications in this palette😌. Tmux is no exception, so for a correct and harmonious display of the configuration, like mine, you will need:

1. Any monospaced **Powerline icon** **font** ⚡️.
    - _For example from the [Nerd fonts](https://www.nerdfonts.com/) project . I prefer the [Hack Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip) font . The font must be placed in the path `/usr/share/fonts/`or separately for the user in `~/.local/share/fonts/`and applied to the terminal._
2. Any **terminal emulator** 🧑‍💻, with TrueColor and Nord theme support.
    - _For example, [Gnome-terminal](https://r4ven.me/it-razdel/instrukcii/kastomizaciya-linux-mint-20-nord-theme/#%D0%A2%D0%B5%D1%80%D0%BC%D0%B8%D0%BD%D0%B0%D0%BB_Gnome) or [drop-down terminal – Guake](https://r4ven.me/it-razdel/poleznoe-po/guake-vypadayushhij-drop-down-terminal/) . In my experience, this theme is available for any popular terminal emulator;_
3. (Optional) **Console editor** 📝 with Nord theme.
    - _For example [Vim/Neo](https://r4ven.me/it-razdel/poleznoe-po/neovim-ustanovka-i-nastrojka-redaktora-koda-s-elementami-ide-vsego-v-neskolko-komand/) ._
4. (Optional) Interactive **command shell** 💻.
    - _For example [Zsh + Oh-My-Zsh](https://r4ven.me/it-razdel/instrukcii/zsh-interaktivnaya-komandnaya-obolochka-dlya-linux-oh-my-zsh/) with the **agnoster** theme ._

For those who are just getting to know Tmux, I will briefly list its entities🧐:

- **Session** – the basic unit of work, containing windows and panels;
- **Window** – a separate terminal in a session;
- **Panel** – division of the window into several terminals (panels);
- **Commands** – instructions for control  `tmux`;
- **Prefix key** – key for activating commands (default  `Ctrl-b`);
- **State** – active and inactive windows and panels;
- **Configuration (config)** – tmux settings, for example in a file  `~/.tmux.conf`or `~/.config/tmux/tmux.conf`.

We can begin the installation.

## Installing Tmux

![](https://r4ven.me/wp-content/uploads/2024/11/image-49.png)

Tmux is almost always available in the standard repositories, and many Linux [distributions even come pre-installed👌.](https://r4ven.me/it-razdel/slovarik/distributiv-linux/)

Open the terminal and execute:

```bash
sudo apt update && sudo apt install -y curl git xclip tmux
```

- `curl`– utility for interaction with the web (needed for downloading the config);
- `git`– version control system and utility of the same name for working with git [repositories](https://r4ven.me/it-razdel/slovarik/repozitorij-programmnogo-obespecheniya/) (needed for installing third-party plugins);
- `xclip`– a clipboard management utility in Xorg [desktop](https://r4ven.me/it-razdel/slovarik/okruzhenie-rabochego-stola/) systems, usually pre-installed (if you are installing tmux on a system without a gui, you don’t need to install it);
- `tmux`– the terminal multiplexer itself;

[![](https://r4ven.me/wp-content/uploads/2024/11/image-46.png)](https://r4ven.me/wp-content/uploads/2024/11/image-46.png)

## Downloading the config and running

Now let's use the utility `curl`to download the Tmux configuration file from my [GitHub](https://github.com/r4ven-me/dots/blob/main/.config/tmux/tmux.conf) 😇 repository:

```bash
curl --create-dirs -fLo \
    ~/.config/tmux/tmux.conf \
    https://raw.githubusercontent.com/r4ven-me/dots/main/.config/tmux/tmux.conf
```

[![](https://r4ven.me/wp-content/uploads/2024/11/image-45.png)](https://r4ven.me/wp-content/uploads/2024/11/image-45.png)

All that's left is to launch Tmux😳. The first launch will take some time⏳, because the plugin manager will be downloaded and then the plugins themselves will be downloaded using this manager.

> The configuration is built so that when adding new plugins, during the launch/restart of Tmux, they will be installed automatically😌. To install plugins manually, use `prefix+I`.

To create a new named session, use the command:

```bash
tmux new -s Work
```

Where:

- `new`– command to create a new session;
- `-s`– key for specifying the session name;
- `Work`– arbitrary session name.

[![](https://r4ven.me/wp-content/uploads/2024/11/image-47.png)](https://r4ven.me/wp-content/uploads/2024/11/image-47.png)

It should look something like this:

[![](https://r4ven.me/wp-content/uploads/2024/11/image-48.png)](https://r4ven.me/wp-content/uploads/2024/11/image-48.png)

That's it 😃 the setup is complete! Now you can actively use:

[![](https://r4ven.me/wp-content/uploads/2024/11/image-50-1500x845.png)](https://r4ven.me/wp-content/uploads/2024/11/image-50.png)

> ![](https://r4ven.me/wp-content/uploads/2024/11/image-38.png)
> 
> Liked my Neovim config? You can easily create a similar one according to the article: [Neovim – Installing and configuring a code editor with IDE elements in just a few commands](https://r4ven.me/it-razdel/poleznoe-po/neovim-ustanovka-i-nastrojka-redaktora-koda-s-elementami-ide-vsego-v-neskolko-komand/) .

And if you have a wide monitor, then it’s even better!

[![](https://r4ven.me/wp-content/uploads/2024/11/13-33-09_23-11-2024.resized.png)](https://r4ven.me/wp-content/uploads/2024/11/13-33-09_23-11-2024.resized.png)

You can even live in a terminal like this😎

To exit `tmux`without closing sessions, send a command `dettach`using a special hotkey: first press the so-called prefix key combination, by default it is `Ctrl+b`, and then immediately press the key `d`, abbreviated: `prefix+d`.

Yes, this is the style of hotkeys in Tmux🤷‍♂️. First, you press the key `prefix`, and then the action/command key. You need to get used to this method. The key `prefix`can be changed in the configuration. But it is not recommended to do this in order to maintain versatility🫠.

To return to a running session, use the command:

```bash
tmux attach -t Work || tmux new -s Work
```

Where:

- `attach`– command to connect to a running session;
- `-t`– key for specifying the tag/name of an existing session;
- `Work`– the name of the session we launched earlier;
- `||`– a logical “or” in a shell context, in other words, an [execution control](https://r4ven.me/it-razdel/zametki/komandnaya-stroka-linux-kontrol-vypolneniya-komand/) parameter that will run the next command if the previous one fails.

I recommend that you immediately create a convenient alias for your [shell](https://r4ven.me/it-razdel/slovarik/komandnyj-interpretator-ili-obolochka-shell/) :

```bash
echo 'alias T="tmux attach -t Work || tmux new -s Work"' >> ~/.profile

source ~/.profile
```

Replace `~/.profile`with a file containing your shell environment preparation parameters if necessary☝️.

Now you can connect to an existing session named **Work** using a single letter command `T`.

## Configuration Description

### What does this configuration add/change?

**General settings📖:**

- 256 colors support enabled: `screen-256color`;
- TrueColor support is enabled for more accurate color display;
- windows are numbered from 1, not 0 ( `base-index 1`);
- panels in windows are also numbered starting from 1 ( `pane-base-index 1`);
- history buffer limit increased to 10,000 lines for terminal scrolling;
- the mouse is enabled! you can click to select windows, scroll the output, change the size of panels, swap them, and you can also call the context menu via the right mouse button;
- Automatic updating of terminal window titles is enabled;
- uses vi-style keys to work in copy mode ( `mode-keys vi`) and interact with tmux commands ( `status-keys vi`invoked by `prefix+:`);
- Zsh is set as the default shell (replace with your own if you use another one);
- The locale is set `ru_RU.UTF-8`to display Russian characters correctly.

**Mouse control🐁:**

- General actions:
    - Double click on the status bar creates a new window ( `bind-key -n DoubleClick1Status new-window`);
- If you are using an X11 server when working with tmux:
    - The middle mouse button pastes text from the system clipboard (used `xclip`);
    - after selecting text with the mouse, copies the text to the clipboard without clearing the selection;
    - in copy mode(!) selection of a word/line by double/triple click is supported:
        - double-click LMB: selects a word, copies it to the clipboard;
        - triple click LMB: selects a line, copies it to the clipboard;
    - pressing LMB in copy mode cancels the current selection;
- In other environments (if not using X11):
    - the behavior is similar, but the text is saved only to the internal tmux buffer, not to the system one.

**Keyboard shortcuts🎹:**

Some keyboard shortcuts have been slightly expanded. For more details, see below: [Item 6. Custom Tmux hotkeys](https://r4ven.me/it-razdel/poleznoe-po/tmux-ustanovka-i-kastomizaciya-nord-theme/#%D0%9A%D0%B0%D1%81%D1%82%D0%BE%D0%BC%D0%BD%D1%8B%D0%B5_%D0%B3%D0%BE%D1%80%D1%8F%D1%87%D0%B8%D0%B5_%D0%BA%D0%BB%D0%B0%D0%B2%D0%B8%D1%88%D0%B8_Tmux) .

**List of plugins📋:**

1. `tmux-plugins/tpm`– plugin manager for tmux:
    - provides installation and management of other plugins;
2. `tmux-plugins/tmux-sensible`– sets optimal tmux default settings;
3. `arcticicestudio/nord-tmux`– installs the Nord theme for tmux;
4. `tmux-plugins/tmux-resurrect`– saves the state of sessions (windows, panels, running processes) and allows you to restore sessions after restarting tmux;
5. `tmux-plugins/tmux-continuum`– extension for `tmux-resurrect`:
    - automatically saves sessions at specified intervals (60 minutes);
    - automatically restores sessions when tmux starts;
    - activation using the systemd unit:
        - cm.`systemctl status --user tmux`

**Additionally📦:**

- automatic installation of tpm on first launch and checking/installation of new plugins on each launch/relaunch;
- cleaning old session files older than 3 days (in `~/.local/share/tmux/resurrect/`);
- The recovery system for Neovim is used through the session mechanism.

## Basic Tmux Hotkeys

Below are the most commonly used basic tmux commands/keyboard shortcuts. If you plan to work in the tmux environment regularly, I highly recommend you memorize them🤯.

**Prefix❗️:**

`Ctrl-b` – prefix;

**Window management (windows)** 🪟:

- `prefix+c`– create a new window (looks like a tab on the status panel);
- `prefix+w`– show the list of windows;
- `prefix+n`– switch to the next window;
- `prefix+p`– switch to the previous window;
- `prefix+<номер>`– go to the window with the specified number (for example, `ptefix+1`to the first window);
- `prefix+,`– rename the current window.

**Managing panels** 🎛:

- `prefix+%`– split the window into panels vertically;
- `prefix+"`– split the window into panels horizontally;
- `prefix+o`– switch to the next panel;
- `prefix+q`– show panel numbers (useful for selection);
- `prefix+x`– close the current panel;
- `prefix+z`– expand the current panel to full screen (and return it back);
- `prefix+{`– move the panel to the left;
- `prefix+}`– move the panel to the right;
- `prefix+!`– move the current panel to a separate window.

**Session management** 📚:

- `tmux new -s <имя>`– create a new session with a name;
- `tmux ls`– show the list of sessions;
- `tmux attach -t <имя>`– connect to the session;
- `prefix+d`– disconnect from the current session.

**Copy and paste** 📋:

- `prefix+[`– enter copy mode;
    - **Arrows or PgUp/PgDn** – navigation through history;
    - **Space** – start text selection;
    - **Enter** – copy the selected text;
    - **Esc** – cancel selection;
    - **q** – exit copy mode;
- `prefix+]`– paste the copied text.

**Additionally** 📦:

- `prefix+t`– show the clock;
- `prefix+?`– show help about all key combinations;
- `prefix+s`– show the list of sessions.

## Custom Tmux Hotkeys

Added/changed commands/keys from my config.

**Copy mode and working with the clipboard** 📝:

1. `prefix+v`– turns on the copy mode (analog `prefix+[`);
2. `v`(in copy mode) – starts selecting text;
3. `Enter`and `y`(in copy mode, X11):
    - copies the selected text to the system clipboard using `xclip`;
    - ends copy mode;
4. `y`(in copy mode, not X11):
    - copies the selection to the buffer `tmux`;
    - ends copy mode;
5. `p`(in copy mode, X11):
    - ends copy mode;
    - Pastes the contents of the system clipboard using `xclip`.
6. `p`(in copy mode, not X11):
    - ends copy mode;
    - inserts the contents of the buffer `tmux`;
7. `prefix+]`and `prefix+P`(in normal mode, X11):
    - pastes the contents of the system clipboard using `xclip`;
8. `prefix+]`and `prefix+P`(in normal mode, not X11):
    - inserts the contents of the buffer `tmux`.

**Navigate between panels (vi style)** 🎛:

- `prefix+h`– switch to the panel on the left;
- `prefix+j`– switch to the panel below;
- `prefix+k`– switch to the panel at the top;
- `prefix+l`– switch to the panel on the right.

**Resizing panels (vi style)🎛, command key can be pressed multiple times** :

- `prefix+H`– increase the panel to the left by 2 pixels;
- `prefix+J`– increase the panel down by 2 pixels;
- `prefix+K`– increase the panel up by 2 pixels;
- `prefix+L`– increase the panel to the right by 2 pixels.

**Saving and restoring the environment via tmux-resurrect** 💾:

1. `prefix+F5`:
    - saves the current state of tmux using `tmux-resurrect`;
    - moves the last saved session to a file `~/.local/share/tmux/resurrect/main.txt`for easy recovery;
    - shows a message about manual saving;
2. `prefix+F6`:
    - loads a saved state from a file `main.txt`.

## Useful materials

- [My Tmux Config | GitHub](https://github.com/r4ven-me/dots/blob/main/.config/tmux/tmux.conf)
- [Linuxoid Dictionary: Terminal Multiplexer | Raven's Blog](https://r4ven.me/it-razdel/slovarik/terminalnyj-multipleksor/)
- [Tmux | ArchWiki](https://wiki.archlinux.org/title/Tmux)
- ['Getting started' from official documentation | GitHub](https://github.com/tmux/tmux/wiki/Getting-Started)
- [tpm plugin | GitHub](https://github.com/tmux-plugins/tpm)
- [Tmux-sensitive plugin | GitHub](https://github.com/tmux-plugins/tmux-sensible)
- [Plugin nord-tmux | GitHub](https://github.com/nordtheme/tmux)
- [Plugin tmux-resurrect | GitHub](https://github.com/tmux-plugins/tmux-resurrect)
- [The tmux-continuum plugin | GitHub](https://github.com/tmux-plugins/tmux-continuum)