# DataEditorX

A powerful database management tool for Yu-Gi-Oh! card databases (.cdb files) used with [YGOPro](https://github.com/Fluorohydride/ygopro). DataEditorX allows you to create, edit, and manage card databases with an intuitive user interface.

## Original Source
https://github.com/Lyris12/DataEditorX

## Getting Started

### Installation
1. Download the latest release
2. Extract the files to your desired location
3. Run `DataEditorX.exe`

### Initial Setup
1. The default interface language is Chinese
2. To change to English:
   - Go to Help → Language
   - Select English
   - Restart the application

## Basic Usage

### Database Operations
- **Create New Database:**
  1. Click File → New
  2. Choose save location
  3. Name your .cdb file
  
- **Open Existing Database:**
  - File → Open
  - Or use File → Database History for recent files

### Card Management

#### Adding Cards
1. Fill in the required fields:
   - Card name
   - Card Code (ID)
   - Other properties

2. Click "Add" button

#### Required Fields Explanation

##### Rule Format
- **KoishiPRO:** Select "Anime" for customs
- **EdoPRO:** Select "Custom" (with updated cardinfo_english.txt)

##### Card Types
- Multiple selections allowed
- Some types enable/disable specific fields
  - Example: Link type enables Link Markers, disables DEF

##### Card Properties
- **Attribute:** For monster cards
- **Level/Rank/Link Rating:** Based on card type
- **Race:** Monster type (Warrior, Fairy, etc.)

##### Card Numbers
- **Card Code (ID):**
  - Must be positive integer
  - KoishiPRO: 1 to 268,435,455
  - EdoPRO: 1 to 4,294,967,295
  
  Reserved Ranges (EdoPRO):
  - 10ZXXXYYY: Pre-release TCG/OCG
  - 100XXXYYY: Video Game cards
  - 160XXXYYY: Rush cards
  - 300XXXYYY: Skill cards
  - 5ZZXXXYYY/200XXXYYY: Anime/manga cards

##### Archetype System
- Up to 4 archetypes per card
- Selection methods:
  1. Choose from predefined list
  2. Enter hex code (0 to FFFF)
  - 3-digit codes: Regular archetypes
  - 4-digit codes: Sub-archetypes

### Advanced Features

#### Multiple Database Management
- Open multiple databases simultaneously
- Arrange database windows:
  - Drag-and-drop interface
  - Split window support
  - Customizable layouts

#### Batch Operations
1. Select multiple cards:
   - Drag select
   - Ctrl + Click for individual selection
   - Shift + Click for range selection
2. Perform operations:
   - Copy/Paste between databases
   - Batch delete
   - Batch modify

#### Data Recovery
- Undo/Redo support
- Automatic backups
- Change history tracking

## Card Editor Details

### Description Fields
- Large text box for card effects/flavor text
- Support for both effect text and normal monster descriptions
- Multi-language text support

### Tips Text System
- 16 customizable text fields
- Accessible via script through `Auxiliary.Stringid`
- String IDs range from 0 to 15
- Used for effect descriptions and prompts

### Alias System
- Set alternative names for cards
- Rules for ID differences:
  - Alternative artwork: ID difference ≤ 9
  - Name treatment: ID difference > 9
- Affects card recognition and deck building restrictions

### Categories and Tags
- Optional card categorization
- Search filters in deck builder
- No gameplay impact
- Useful for organization

## Database Management

### Page Navigation
- Cards organized in pages
- Navigate using arrow buttons
- Direct page number input
- Search and filter capabilities

### Search Functions
1. Set search criteria in any field
2. Click Search button
3. Results displayed in left column
4. Reset to show all entries

### Entry Management
- **Modify:** Update existing entries
- **Delete:** Remove with confirmation
- **Reset:** Clear all fields
- **Undo:** Revert changes
- **Copy/Paste:** Transfer between databases

## Window Management

### Layout Options
- Split window into sections
- Nine-position layout system:
  - Four edge positions
  - Five central positions
- Customizable section sizes
- Drag-and-drop database tabs

### Multi-Window Support
- Create separate windows
- Move databases between windows
- Merge and split sections
- Persistent layout memory

## System Requirements

- Windows Operating System
- [.NET 6.0 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)

## Building from Source

### Prerequisites
- Visual Studio 2019 or later
- .NET 6.0 SDK
- Windows Forms development workload

### Build Steps
1. Clone the repository
2. Open `DataEditorX.sln` in Visual Studio
3. Restore NuGet packages:
   - Right-click on the solution in Solution Explorer
   - Select "Restore NuGet Packages"
   
   Alternatively, you can use the Package Manager Console:
   ```powershell
   Tools -> NuGet Package Manager -> Package Manager Console
   PM> Update-Package -reinstall
   ```
   
   Required packages will be automatically restored:
   - DockPanelSuite (3.1.0)
   - DockPanelSuite.ThemeVS2015 (3.1.0)
   - FCTB (2.16.24)
   - Microsoft.Data.Sqlite (7.0.0-preview.4)
   - NeoLua (1.3.14)
   - Newtonsoft.Json (13.0.1)
   - Serilog (4.1.0)
   - Serilog.Sinks.Console (6.0.0)
   - Serilog.Sinks.File (6.0.0)

4. Build the solution in Release mode
5. The compiled program will be in the `bin/Release/net6.0-windows` directory

## Features

### Database Management Features
- Create, edit, and manage YGOPro card databases (.cdb files)
- Compare databases and copy cards between them
- Batch operations for multiple cards
- Import cards from:
  - YGOPro deck files (.ydk)
  - Card picture folders
  - MSE (Magic Set Editor) sets
- Export to MSE format
- Automatic database backups
- Search and filter cards by various attributes

### Card Editor
- Full card property editing:
  - Card types (Monster/Spell/Trap)
  - Card attributes and stats
  - Card text and effects
  - Archetype management
- Real-time card preview
- Support for all card types:
  - Normal Monsters
  - Effect Monsters
  - Fusion/Synchro/Xyz/Link Monsters
  - Pendulum Monsters
  - Spell Cards
  - Trap Cards

### User Interface
- Modern docking interface (DockPanelSuite)
- Customizable layout
- Multi-monitor support
- Dark/Light theme support
- Font customization
- Word wrap options
- IME support for international text input

### Localization
- Multi-language support
  - English
  - Chinese
- Easy language switching
- Custom language file support
- Separate UI and card data translations

### Advanced Features
- Command history with undo/redo
- Automatic updates checking
- Archetype management system
- Card image handling
- Database optimization tools
- Error logging and diagnostics
- Configuration backup and restore

### Developer Tools
- Comprehensive logging system (Serilog)
- Debug mode for development
- Performance monitoring
- Error tracking
- Custom script module support

## Script Editor Features

### Code Editing
- Syntax highlighting for Lua
- Auto-completion support
- Function tooltips
- Code folding
- Find and replace functionality
- Multiple file support
- Template support
- Error checking and validation

### Koishi-Style Features
- Automatic script formatting
- Module script requirements
- Script packaging for distribution
- Support for all card types
- Special handling for:
  - Non-Pendulum Normal monsters
  - Card alias scripts

## Localization Support

### Language Files
- UI Translation: `data/language_xxx.txt`
- Card Data: `data/cardinfo_xxx.txt`
- Easy switching between languages
- Support for custom translations

### Adding New Languages
1. Create required files:
   - `language_xxx.txt` for interface
   - `cardinfo_xxx.txt` for card data
2. Use English files as templates
3. Translate content after Tab separators
4. Restart application to apply

## Technical Details

### File Structure
```
DataEditorX/
├── data/
│   ├── cardinfo_*.txt    # Card information
│   ├── language_*.txt    # UI translations
│   ├── strings.conf      # Configuration
│   └── *.lua            # Script templates
├── templates/           # Card templates
└── bin/                # Compiled files
```

### Dependencies
- DockPanelSuite (3.1.0)
- DockPanelSuite.ThemeVS2015 (3.1.0)
- FCTB (2.16.24)
- Microsoft.Data.Sqlite (7.0.0-preview.4)
- NeoLua (1.3.14)
- Newtonsoft.Json (13.0.1)
- Serilog (4.1.0)

## Project Structure

```
DataEditorX/
├── Common/         # Common utilities
├── Config/         # Configuration management
├── Controls/       # Custom UI controls
├── Core/           # Core functionality
├── Language/       # Localization
├── data/          # Resource files
│   ├── cardinfo_*.txt    # Card information
│   ├── language_*.txt    # UI translations
│   └── *.lua            # Lua templates
└── templates/     # Template files
```

## Command Line Arguments

The program supports the following command line arguments:
- No arguments: Normal startup
- File path: Opens the specified database file
- Language save tags: Saves language configurations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Coding Standards
- Follow existing code style
- Add comments for complex logic
- Update documentation
- Test thoroughly

## Support

### Common Issues
- **Program won't start:** Install .NET 6.0 Runtime
- **Script editing issues:** Check file permissions
- **Language problems:** Verify language files in data folder

### Getting Help
- Check existing issues on GitHub
- Create detailed bug reports
- Include error messages and steps to reproduce

## License

This project uses various open-source components under their respective licenses. See individual package documentation for details.

## Version

Current Version: 4.0.2.6