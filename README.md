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
- dict
- place
- dice

## ayt
ping. like AYT command on telnet. its means 'are you there?'.

## fishing ${item_name}
retruns teamcraft url.

## dict
### dict add ${key} ${word}
### dict overwrite ${key} ${word}
### dict get ${key}
### dict move ${old_key} ${new_key}
### dict delete ${key}

# choice [list]
returns random choice from list

# dice
roll dice. default 1d6.
The dice string uses the following format: [0-9]+d[F0-9]+
examples: 1d20, 2d10, 1dF
see also: [Games::Dice](https://metacpan.org/dist/Games-Dice)
