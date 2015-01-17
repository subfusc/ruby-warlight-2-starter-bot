# Ruby Warlight 2 Starterbot

## License

The bot is provided with a 3-clause BSD license. See the LICENSE file
if you want more information about the boring legal stuff.

## Running

### Linux

Clone the repo to get started using the bot:

    $ git clone https://github.com/subfusc/ruby-warlight-2-starter-bot.git

Running the bot is done by doing:

    $ ruby bot.rb

Testing it is done by piping testing input to the bot:

    $ ruby bot.rb < testmatch.txt

### OSX & Windows

I have no clue, but here is a hint: bot.rb is the main file.
If someone use this bot on either os and want to provide this section,
please feel free to contact me.

## Developing

### Initial state

The bot does random moves and can play games right out of the box.

### Further development

The file game-logic should be the starting point of your improvements. This
contains the class that does the playing etc. At the starting point you can
see it responding with random moves.

The world-map class contains the game map, land is just a generic which
region and super-region inherits from (as they are both types of land...).

bot.rb contains the I/O. The game uses Standard in/out to communicate with the bot,
so its simple puts and $stdin that is used for communicating with the server.
it is important to note that the I/O should be done synchronusly, so the option
STDOUT.sync = true is imporant to have.

### Upload to Warlight Server

zip the necessesary ruby files and upload the resulting file on your profile page.
The starter files are: bot.rb, world-map.rb, game-logic.rb, land.rb, region.rb,
server-settings.rb, super-region.rb

#### Linux:

This can be done on linux by running in the project folder:

    $ tar -zcf bot.tgz *.rb