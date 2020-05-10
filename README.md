# Simple RLCraft server docker image

## Features

* Server starts on boot and restarts if the process goes down
* Saves world state in volume mounted from host
* Backs up hourly to (another) volume mounted from host
* Tidies up world backups


## Building

### Provide RLCraft, Forge installer, mod packs

Our `Dockerfile` expects to find some resources in the `./provided` directory.

These aren't checked in to this repository, to keep the size down, and to allow
you to build an image with the newest or most stable versions of RLCraft and Forge.

#### Provide an RLCraft server pack

Download the RLCraft **server pack** zip from here:
  
https://www.curseforge.com/minecraft/modpacks/rlcraft/files

We tested with version `RLCraft Server Pack 1.12.2 - Beta v2.8.2.zip`

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

Copy the jar file into the `./provided` directory of this repository

No need to rename the file- the scripts will pick up `./provided/forge*.jar`

#### Add mods

Any mods you place in `./provided/mods/` will be loaded on to the server.

We like to add:

https://www.curseforge.com/minecraft/mc-mods/gravestone-mod/files

> NB: Make sure you download the mod for the right minecraft version.

> NB: Make sure you download the Forge mod (not bukkit, fabric, or whatever)

### Create a whitelist file for players allowed onto your server

Ask your players for their minecraft usernames.

For each player, get their account id by entering their username here: https://mcuuid.net

Create a `./provided/whitelist.json` file with an entry for each player, like this:

```
[
  {
    "uuid": "4b6a5391-f902-4a58-b007-1a3b315e4d30",
    "name": "playerone"
  },
  {
    "uuid": "6680fedf-0ff5-40c2-a53e-a39db1d95885",
    "name": "playertwo"
  }
]
```

You might want to check your file is valid by pasting it here: https://jsonlint.com/


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