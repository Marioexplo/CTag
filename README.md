# CTag
A small CLI interface for Bash to see the tag of all the files in a directory, in particular the artist tag in mp3 files.

This is a project I made for me in my very spared time. I think I'll try to add other features as I get better at writing Shell but it probably will never get much bigger than it already is.

## Install
**Requirements:** [eyeD3](https://github.com/nicfit/eyeD3)

First of all, clone the repo
```
git clone https://github.com/marioexplo/ctag.git
```
Then (in the repo) make *ctag.sh* executable
```
chmod +x ctag.sh
```
Now you can choose to copy ctag.sh in a folder for commands like `/usr/local/bin`, which will make CTag available for all user of your machine,
```
sudo cp ctag.sh /usr/local/bin
```
or `~/.local/bin`, just for you.
```
cp ctag.sh ~/.local/bin
```
You can also choose to just make an alias for *ctag.sh*: in your shell's config file (like .bashrc for bash or .zshrc for zsh), add `alias ctag=/path/to/this/repo/ctag.sh`.

## How to use
There are more than one option you can choose
### Plain command
`ctag DIRECTORY`
The simplest command takes all the files in a directory and prints their artist tag.
Files of unknown artists and the ones with excluded formats will be ignored.
### Option flags
`ctag [OPTIONS] DIRECTORY`
When you explore directories, you can add these flags to filter your search:
- **`-a` <ins>A</ins>ll files:** files of unknown artists won't be ignored.
- **`-e FORMAT,FORMAT...` <ins>E</ins>xclude formats:** adds the given formats to the default ones for this search.
- **`-E FORMAT,FORMAT...` Override <ins>e</ins>xcluded formats:** only the formats given now will be ignored.
### Configuration flags
`ctag OPTION`
Use these flags to explore and change the configuration:
- **`-h` <ins>H</ins>elp page:** prints the help page.
- **`-d MODE FORMAT,FORMAT...` Change <ins>d</ins>efault formats:** configure formats that will be ignored by default. You can use these MODEs:
    * **SET:** changes to the given formats.
    * **ADD:** adds the given formats.
    * **SUB:** changes to the difference between the old and the given formats.