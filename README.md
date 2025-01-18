# DESCRIPTION

  Dashi is discord bot client.

# SET UP

## install perl lib
require anyenv, gcc, libssl-dev or libcrypt-ssleay-perl.

```
$ git clone git@github.com:Likk/Dashi.git
$ cd ./Dashi
$ anyenv install plenv
$ cat .perl-version | xargs plenv install
$ ./env.sh plenv install-cpanm
$ ./env.sh cpanm App::cpm
$ ./env.sh cpm install
```

## edit your bot configure
copy env.sh.template to env.sh and edit it.
You can get your bot token from [here](https://discord.com/developers/applications).
And write it to DISCORD_TOKEN at env.sh.
```
cp env.sh.template env.sh
vim env.sh
```

# LUNCH YOUR BOT
./env.sh perl bot.pl

# Bot Slash Command List
- ayt
- choice
- dice
- dict
- group

## /ayt - are you there.
this command is ping. like AYT command on telnet. its means 'are you there?'.

## /choice - random choice from list.
this command is random choice.
example: /choice alice,bob,carol,dave

## /dice - roll dice
default 1d6. The dice string uses the following format: [0-9]+d[F0-9]+
examples: 1d20, 2d10, 1dF
see also: https://en.wikipedia.org/wiki/Dice_notation

## /dict - dictionary
this command is dictionary.
### /dict add key value
add key and value to dictionary.
example: /dict add foo bar
### /dict overwrite key value
overwrite key and value to dictionary.
example: /dict overwrite foo baz
### /dict get key
get value from dictionary.
example: /dict get foo
### /dict delete key
delete key from dictionary.
example: /dict delete foo
### /dict rename before after
rename key from dictionary.
example: /dict rename foo bar
### /dict file
download dictionary as tsv file.
example: /dict file

## /group - random grouping.
this command is random grouping.
example: /group 2 alice,bob,carol,dave
