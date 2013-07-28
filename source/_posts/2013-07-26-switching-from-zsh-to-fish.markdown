---
layout: post
title: "Switching from zsh to fish"
date: 2013-07-26 15:09
comments: true
categories: [ fish, zsh, shell, bash ]
---


Not long ago I heard of [fish (friendly interactive shell)](http://fishshell.com) and I decided it was worth a test drive. I have a decent configuration for zsh, with most credits to [Oh My Zsh!](https://github.com/robbyrussell/oh-my-zsh), but I was determined to get rid of most my dotfiles, as it is one of my greatest excuses to procrastinate, however tidy. Fish comes with lots of things out of the box, so I decided to replace zsh even if it meant to lose a thing or two.

<!--more-->

## Trying out fish

Being on Ubuntu, I found a ppa with very up to date fish:

```
sudo apt-add-repository -y ppa:zanchey/fishfish-snapshot
sudo apt-get update
sudo apt-get install -y fishfish
chsh -s /usr/bin/fish
```

I opened fish and started to type things to test. Syntax highlighting and history completion were great and beautiful. Completion is a little bit different, not as good as zsh's with lots of plugins and configurations, but close enough and again prettier. The syntax is very nice but it is not at all compatible with popular shells and not even POSIX. The name is hard to search and the documentation and community not big enough, but I managed to translate all my functions using the [tutorial](http://fishshell.com/tutorial.html) and the [documentation](http://fishshell.com/docs/current/index.html). Even harder than learning fish was to understand every feature of bash to translate the code to fish.

## Oh My Fish!

The fish configuration on the browser (fish_config command) is a neat concept, with a cool prompt visualizer (beats my [xterm opener](https://gist.github.com/mmacedo/4047615)), but disappointing as I didn't find anything worth configuring there. Already feeling like something was missing, I searched for [Oh My Fish!](https://github.com/bpinto/oh-my-fish), and I found exactly what I needed to have a complete shell:

```
curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | bash
```

Instead of a `~/.fishrc`, the fish configuration goes into `~/.config/fish/config.fish`:

```
set fish_path $HOME/.oh-my-fish
. $fish_path/oh-my-fish.fish
```

## Prompt / Theme

I still had to pick a good prompt to replace Oh My Zsh!'s [fino theme](http://www.maxmasnick.com/2012/09/02/zsh/). [Numist](https://github.com/bpinto/oh-my-fish/pull/27) is pretty much the same theme, but it doesn't show the ruby version. I added my custom version of oh-my-fish's numist theme with the ruby version from oh-my-zsh's fino theme:

```
set -l ruby_info
if which rvm-prompt >/dev/null ^&1
  set ruby_info (rvm-prompt i v g)
else
  if which rbenv >/dev/null ^&1
    set ruby_info (rbenv version-name)
  end
end

test $ruby_info; and set ruby_info "$normal""using $magenta‹$ruby_info›"
```

## Tools

Somehow the few plugins of Oh My Fish! were enough to cater for my needs. I don't know why, but [rbenv](https://github.com/sstephenson/rbenv) works fine, the [rake](https://github.com/bpinto/oh-my-fish/tree/master/plugins/rake) and [bundler](https://github.com/bpinto/oh-my-fish/tree/master/plugins/bundler) plugins are as good as their Oh My Zsh! counterparts. The [node](https://github.com/bpinto/oh-my-fish/tree/master/plugins/node) plugin works, but the completions that were supposed to be automatically generated from node's and npm's manpages, weren't. One plugin that I miss is completions for the [heroku CLI](https://github.com/heroku/heroku), since it doesn't have a manpage (shame on heroku for that).

Most tools, however, are not compatible with fish: how would them? It coincided that I wanted to try a new tool ([nvm](https://github.com/creationix/nvm)) for which there was no fish shim or fish plugin. Inspired by a [script](https://github.com/fish-shell/fish-shell/issues/522#issuecomment-12485379) that attempted to source POSIX/bash syntax files, I decided to write my own `source` function that could execute bash code and reproduce or simulate the changes to variables and functions on fish:

{% gist 6083809 source.fish %}

## Conclusion

My fish configuration now looks like this:

```
# Oh My Fish!
set fish_path $HOME/.oh-my-fish
set fish_theme my
set fish_plugins rbenv rake bundler node
. $fish_path/oh-my-fish.fish

# nvm
. $HOME/.config/fish/source.fish
source --bash $HOME/.nvm/nvm.sh

. $HOME/.config/fish/functions.fish
```
