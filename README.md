# AltBotMenu

A lightweight World of Warcraft 1.12.1 addon that provides a simple menu interface for managing AI PlayerBots on cmangos servers.

## Features

- **Easy Bot Management**: Add or remove AI PlayerBots with a single click
- **Character Tracking**: Automatically records your alts when you log in
- **Faction-Aware**: Only shows alts from the same faction as your current character
- **Smart Filtering**: Excludes your currently logged-in character from the bot list
- **Persistent States**: Remembers which bots are currently active between sessions
- **Draggable Interface**: Move the menu anywhere on your screen
- **Vanilla-Style UI**: Blends seamlessly with classic WoW aesthetics

## Requirements

- World of Warcraft 1.12.1 (Vanilla)
- cmangos server with AI PlayerBots enabled
- Docker Desktop (for local testing environment)

## Installation

1. Download the latest release from [Releases Page] or clone this repository
2. Extract the `AltBotMenu` folder into your WoW AddOns directory:
3. The folder structure should look like:
World of Warcraft/Interface/AddOns/AltBotMenu/
├── AltBotMenu.toc
├── AltBotMenu.lua
└── README.md

## Usage

### Basic Commands
- Type `/altbot` in chat to open/close the menu
- Click any character button to toggle between adding/removing that bot

### How It Works

1. **First Time Setup**: 
- Log in to each of your characters at least once
- The addon automatically records their name, faction, class, and level

2. **Using the Menu**:
- Open the menu with `/altbot`
- Buttons show character names with "(Add)" or "(Remove)" status
- Click to toggle - green "(Add)" adds the bot, red "(Remove)" removes it
- The menu only shows same-faction alts (excluding your current character)

3. **Bot States**:
- The addon remembers which bots are active
- Button text updates immediately after clicking
- States persist between gaming sessions

## Saved Variables

The addon uses SavedVariables to store:
- `AltBotMenuDB.alts` - Your character database
- `AltBotMenuDB.botStates` - Current bot active/inactive states  
- `AltBotMenuDB.point` - Window position and layout

## Troubleshooting

### Common Issues

**Menu doesn't show any characters:**
- Make sure you've logged into each character at least once
- Verify characters are the same faction as your current character

**Bot commands don't work:**
- Ensure your server has AI PlayerBots enabled
- Check that the bot commands (`.bot add/remove`) are available on your server

**Addon errors:**
- Make sure you're using WoW 1.12.1
- Verify the addon is in the correct directory

### Debugging

If you encounter issues:
1. Check your WoW chat for error messages
2. Ensure all file permissions are correct
3. Try disabling other addons to check for conflicts

## Development

### File Structure
- `AltBotMenu.toc` - Addon metadata and file list
- `AltBotMenu.lua` - Main addon functionality

### Testing Environment
- WoW 1.12.1 client
- cmangos server with AI PlayerBots
- Docker Desktop on Windows 11 Home

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Designed for cmangos classic servers with AI PlayerBots
- Tested with Docker Desktop environment
- Vanilla WoW 1.12.1 compatible
