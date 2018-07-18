# Requirements

## Installing Node.js

```
$ wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
$ source ~/.bashrc  # It might be different if you use zsh or other shell
$ nvm install --lts
$ nvm use node
```

## Installing rbenv

Execute the following commands, but use your ~/.bashrc file instead of ~/.bash_profile if you are working in Ubuntu, or the specific file for your shell.

```
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
$ cd ~/.rbenv && src/configure && make -C src
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
$ rbenv init  # This fails...
```

More information in [github page](https://github.com/rbenv/rbenv), under the header Basic GitHub Checkout.

### To install the latest ruby

```
$ mkdir -p "$(rbenv root)"/plugins
$ git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
$ rbenv install 2.5.0
```

The instructions are taken from [here](https://github.com/rbenv/ruby-build#readme).

Now, you have to tell rbenv to actually use the version just installed

`$ rbenv global 2.5.0`

Check everything is working with a script

`$ curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash`

## Installing dependencies

Go back to the project directory and run:

`$ gem install bundler`

To install the depdendencies listed in Gemfile use:

```
$ bundle
$ npm i
```
