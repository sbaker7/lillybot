#LillyBot

Welcome to Lillybot! I am a Twitch.TV bot written in Ruby. I respond to a number of commands, will participate in conversations based on various keywords and will even play games. A list of commands/interactions are available [below](#commands).

---

##Installation

1. Ensure you have [Ruby](https://www.ruby-lang.org/en/documentation/installation/) installed. You can check by typing `whereis ruby` into your terminal/console/command prompt window
2. [Fork](https://github.com/sbaker7/lillybot/fork) the repo
3. Make a branch: `git checkout -b [new-feature-or-whatever]`
4. Install [Bundler](http://bundler.io): `gem install bundler`
4. Install dependencies using bundler: `bundle install`
5. Run using `ruby lillybot.rb`

---

##Making Changes

You're welcome to make any changes you wish. If you wish to contribute to the project, please make sure you make a pull request. If you've made your own fork as specified above, it should be as easy as:

1. Commit your changes `git commit -am 'TAG: added some feature'`
2. Push changes `git push origin branchname`
3. Make a [pull request](https://github.com/sbaker7/lillybot/compare?expand=1).

These are the tags we use for our commit messages:

- *NEW*​: New features ​
- *ENHANCE*​: Improvement to existing feature (Not purely visual, see ​_looks_​.) ​
- *FIX*​: Fixed a bug ​
- *LOOKS*​: UI Refinement (Not for functionality change, see ​_enhance_​.) ​
- *SPEED*​: Performance-related ​
- *QUALITY*​: Refactoring 
- ​*DOC*​: Documentation ​
- *CONFIG*​: Config setting changed ​
- *TEST*​: Testing related addition or enhancement

---

##Dependencies

###Software Tools
1. Ruby
2. Bundler

###Gems
3. A modified version of [Twitch-chat](https://github.com/sbaker7/twitch-chat) (stored locally in libs folder, originally by [EnotPoloskun](https://github.com/enotpoloskun/twitch-chat))
4. Activesupport
5. Eventmachine

---

##<a name="commands"></a>Commands Quicklist

Here's a quick list of example commands to get you started. You can play around with Lillybot on my [twitch channel](http://twitch.tv/dragnflier) in the chat at any time.

###Commands

| Command | Function |
| ------- | -------- |
| !time | Returns the current time in Melbourne, Australia |
|!feels | Gives a short description of where Lilly's from |
|!banme | Bans the user for 1 second |
|!quote | Generates a random quote from Kawata Shoujo |
|!mycreator | Tells you who created the Lillybot |


###Keywords

These keywords all use regex, which mean most will run even if the message isn't presented exactly as shown.

| Command | Function |
| ------- | -------- |
| Hello/Hey/Hi Lilly | Lilly greets you |
| How are you, Lilly? | Lilly tells you how she is |
|Lily | You spelt Lilly wrong and she notices |
| Right Lilly | You ask Lilly's opinion |
|FrankerZ/LilyZ | Lilly loves dogs |

###Games

| Command | Function |
| ------- | -------- |
|!slots | Play slots with Lilly! |
|!chance | Play a game of chance. Don't get 3! |
|!guessinggame | Guess the number! |

###Complete List (With Todos)

A complete list of the commands available for Lillybot and upcoming commands can be found [here](https://github.com/sbaker7/lillybot/blob/development/Ruby/todolist.md)






































