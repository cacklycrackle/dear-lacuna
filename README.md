# Dear Lacuna

Dear Lacuna is a small-scale platformer game built with Godot, featuring multiple levels, complex puzzles with fluid movement.

## Features
### Current Progress
* Basic movement
    * Player can move horizontally, jump vertically and double jump with gravity accounted for
* Basic vision radius
    * Vision is restricted to small circular region centred on player
* Basic collisions
    * Player collisions with walls and floors detected
* Basic save / load system for keybinds
    * User-modified keybinds are locally saved and loaded when game runs again
* Two basic levels
* One in-level puzzle
    * Sliding block puzzle, as inspired by [Move the block](https://play.google.com/store/apps/details?id=com.bitmango.go.unblockcasual&hl=en_SG) and similar games

### To Be Completed
* Multiple keybinds per action
* In-game characters for player interaction
* Storyline and integration with in-game characters
* Render tiles and sprites for each level based on tileset
* Save / Load system for user progression through levels
* At least five levels
* Variable vision radius
    * Allow player vision to increase with level
* Music and sound effects


## Installation
Download the latest release from [here](exports/windows).

Extract all the files for your operating system to your desired location.

Run `dear_lacuna.exe` to start the game.

## Controls

> [!NOTE]
> Keybinds for the following actions can be viewed and modified from the start menu

| **Action**   | **Keys (default)** |
| :------: | :------------: |
| Movement | Arrow keys |
| Interact | Z |
| Pause | Esc |

## Flow & Architecture
![Flow and architecture diagram of game](https://github.com/user-attachments/assets/9602cb4-f550-491c-81f2-0547ee71c203)

## Use cases
1. Actor : User \
Use Case : Rebind action keys.
    * User enters Controls Menu from Start Menu.
    * User clicks on button for action to rebind key for.
    * User rebinds action with desired keypress or mouse click.
    * Game writes changes to local config file.
    * User quits game.
    * Upon re-entry, game loads with user-modified keybinds.

2. Actor : User \
Use Case : Return to default keybinds for all actions.
    * User enters Control Menu from Start Menu.
    * User select "reset all to default" button.
    * Game rebinds each allowed action to the single default key defined in Project Settings.
    * Game writes each change to local config file.
    * User quits game.
    * Upon re-entry, game loads with default keybinds.


## Tech Stack
Godot with GDScript
* Game enginer and editor

Git & GitHub
* Version Control

Aseprite
* Used to create game assets (images and animations)

## Project Log
[Project Log](https://docs.google.com/spreadsheets/d/1YbEd0rHw6HKd-1JRQwQTvf6US5fMhkmUJgZpu2ZH8-c/edit?usp=sharing)
### Development Team
Team JVM - Orbital 25 Project Gemini