# cwcr

*clipboard write, clipboard read*, a [fish shell](https://fishshell.com/) facade to interact with the clipboard.

## Installation

### Using [Fisher](https://github.com/jorgebucaran/fisher)

```fish
fisher add giorgiga/cwcr
```

### Manually

```fish
curl -Lo ~/.config/fish/conf.d/cwcr.fish  --create-dirs https://raw.githubusercontent.com/giorgiga/cwcr/main/conf.d/cwcr.fish
curl -Lo ~/.config/fish/functions/cw.fish --create-dirs https://raw.githubusercontent.com/giorgiga/cwcr/main/functions/cw.fish
curl -Lo ~/.config/fish/functions/cr.fish --create-dirs https://raw.githubusercontent.com/giorgiga/cwcr/main/functions/cr.fish
```

## Dependencies

In order for *cwcr* to work, you'll need:

* `wl-clipboard`, if you use Wayland
* `xcopy` and/or `xsel`, if you use X11
* optionally, `perl` (without it, you may run into issues when copying or pasting more than 100MiB of data)

## Usage

This package adds two functions:

* `cw` (clipboard write) reads from standard input and writes to the clipboard
* `cr` (clipboard read) reads from the clipboard and writes to standard output

When writing to the cliboard, the last newline (if any) is ignored and so after executing (eg) `echo hello world | cw` the clipboard will contain `hello world` and not `hello world\n`.

If run in a non-graphical session, cwcr will read/write from a temporary file instead of the clipboard.
