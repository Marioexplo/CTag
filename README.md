# CTag
A small CLI interface for Bash to see the tag of all the files in a directory, in particular the artist tag in mp3 files.

This is a project I made for me in my very spared time. I think I'll try to add other features as I get better at writing Shell but it probably will never get much bigger than it already is.

## Install
Fist of all, clone the repo
```
git clone https://github.com/marioexplo/ctag.git
```
Then (in the repo) make *ctag.sh*
```
chmod +x ctag.sh
```
Now you can choose to copy ctag.sh in folder for commands like `/usr/local/bin`, which will make CTag available for all user of your machine,
```
sudo cp ctag.sh /usr/local/bin
```
or `~/.local/bin`, just for you.
```
cp ctag.sh ~/.local/bin
```
You can also choose to just make an alias for *ctag.sh*: in your shell's config file (like .bashrc for bash or .zshrc for zsh), add `alias ctag=/path/to/this/repo/ctag.sh`.