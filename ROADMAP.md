Plans for development:
1. Implement host system (almost done, just need graph)
2. Implement files and filesystem
3. Implement FTP
4. Implemen NPC system
5. Implement privilege system
6. Implement map (how it will actually work in 3d space)
7. Implement weapons and damage system
8. Implement NPC hosts
9. Implement file minigames
10. Implement random events
11. Implement quest system

They do not strictly have to be done in order.

Anything else likely can be implemented alongside one of the tasks above as it's simpler (e.g. bitcoin system).

After all of the above has been done, likely taking a couple of months, we look at the other networks.

Anything relating to how something will look should be ideally done last.

## Host System
Pretty much the only thing left to do is to implement the graph and the methods for it.

# Details
The NPC AI will obviously be one of the most difficult things to implement due to the complexities surrounding it.

The second most difficult things to implement would probably be the GUI due to the quirks of Roblox GUI programming
as described in `ftp-gui.luau`, lines 116-172 where I wrote that rant during school at whatever the class I had before
science was. Point is, trying to make it look good is gonna be an absolute pain and would likely take a lot of tinkering
in Roblox Studio.

The host system and the position system needs to be completely overhauled in the future, but for now, it'll do because
of other priorities and that it SHOULD work.

The data handling of the game is mostly done, but the data in `shared-data-module.luau` CAN be compressed, but that will
also be a future problem.

Priority right now is the FTP interface, maps, privilege-obtainment files and finishing `brute-force-minigame.luau` so that
there is at least one hacking file as of right now. However, __the number one priority right now is handling the initialisation__
__for when the player first joins the game, where one of each file will be initialised in random hosts that are reachable.__

# Log
- September 20: tweaked with VSCode extensions and realised that data related scripts can actually be placed in a separate
folder for organisation. Did exactly that.
- September 21: replaced the deprecated BodyVelocity with LinearVelocity instead and also added the client side script for
shooting bullets because I forgot about it when porting this project to Rojo. Also begun working on the server-side FTP logic.
- September 22: continued working on server-side FTP logic but spent time testing to see how TextChatService works and I discovered
that you can technically implement markdown support for the Roblox chat. However, that is not top priority so it won't be implemented
and most likely never will be.