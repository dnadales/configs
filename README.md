# configs
Configurations I use


## oh-my-zsh

To install `oh-my-zsh` make sure to install
[zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) first. Then
install `oh-my-zsh` using one of the methods described
[here](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH), eg:

```
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

This will create a `~/.zshrc` file, and it will clone the
[oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) repository
in `~/.on-my-zsh`.

Now you can remove the `~/.zshrc` (or back it up), and create a soft link to the
[`.zshrc`](oh-my-zsh/.zshrc) file in this repository. It's probably a good idea
to check that these two files have not diverged too much.

``` sh
ln -s ~/development/dnadales/configs/oh-my-zsh/.zshrc .zshrc
```

Log in and log out for the changes to take effect.

This `zsh` configuration requires:
- [thefuck](https://github.com/nvbn/thefuck)
- [z](https://github.com/rupa/z)

