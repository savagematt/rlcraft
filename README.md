# Simple RLCraft server docker image

## Features

* Server starts on boot
* Server is restarted on errors
* Saves world state in volume mounted from host
* Use any version of RLCraft (tested on `1.12.2-Beta-2.8.2`)
* Add additional mod packs
* Backs up hourly to (another) volume mounted from host
* Tidies up world backups
* Player whitelist updated from Google sheet

## Building

### Provide RLCraft, Forge installer, mod packs

Our `Dockerfile` expects to find some resources in the `./provided` directory.

These aren't checked in to this repository, to keep the size down, and to allow
you to build an image with the newest or most stable versions of RLCraft and Forge.

#### Provide an RLCraft server pack

Download the RLCraft **server pack** zip from here:
  
https://www.curseforge.com/minecraft/modpacks/rlcraft/files

We tested with version `RLCraft+Server+Pack+1.12.2+-+Beta+v2.8.2.zip`

Copy the zip file into the `./provided` directory of this repository
(DO NOT UNZIP THE FILE)

No need to rename the file- the scripts will pick up `./provided/RLCraft*.zip`

#### Provide a Forge installer for Linux

You need to provide an installer jar for Forge from https://files.minecraftforge.net

> NB The Forge installer will need to be compatible with your RLCraft server pack.
>
> That means it needs to be for the same minecraft version, in our example `1.12.2`.

We've tested with `forge-1.12.2-14.23.5.2854-installer.jar`, which can be found here:

https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.12.2.html

![screenshot](forge-screenshot.png)

Copy the jar file into the `./Provided` directory of this repository

No need to rename the file- the scripts will pick up `./provided/forge*.jar`

#### Add extra mods

Any mods you place in `./provided/mods/` will be loaded on to the server.

We like to add:

https://www.curseforge.com/minecraft/mc-mods/gravestone-mod/files

> NB: Make sure you download the mod for the right minecraft version.

> NB: Make sure you download the Forge mod (not bukkit, fabric, or whatever)

### Create a whitelist Google Sheet of players allowed onto your server

Create a blank Google sheet.

Rename `Sheet 1` worksheet to `players`

Add a list of players' usernames in column `A` and user ids in column `B`.

You can get the id for a user name from https://mcuuid.net/

Your sheet should look like this:

![screenshot](player-sheet.png)

Now click the "share" button. 

Click inside the `Get link` section.

Select `Anyone with the link` and `Viewer` to make sure the link is read only.

> NB: if you do not select `Viewer`, anyone with the link can edit your whitelist

![screenshot](share-sheet.png)

Now copy the link and paste it into `./config/whitelist.txt`.

Then deleted everything in `whitelist.txt` except for the link ID:

```
https://docs.google.com/spreadsheets/d/1a_6f6UrcM7zWxYR94n5tKrDOFhFcYaku0jAXjFzRyog/edit?usp=sharing
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

So `whitelist.txt` now looks something like:

```
1a_6f6UrcM7zWxYR94n5tKrDOFhFcYaku0jAXjFzRyog
```

The server will read from the sheet and update your player whitelist every 5 minutes.

### Build the Docker image

```
./build.sh
```

### Test the image

This command will **delete any existing `rlcraft` containers** and start a new one based on the 
image we just built.

```
./run-new.sh
```