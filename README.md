# DataEditorX

A Windows-based card database editor for YGOPro, built with .NET 6.0. This tool allows you to create, edit, and manage card databases (.cdb files) with an intuitive user interface.

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

### Database Management
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

### Script Editor
- Advanced Lua script editor with:
  - Syntax highlighting
  - Auto-completion
  - Function tooltips
  - Code folding
  - Find and replace
  - Multiple file support
  - Template support 
- Koishi-Style script formatting
- Module script support
- Script templates
- Error checking and validation
- Script packaging for distribution

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

## Language Support

The application supports multiple languages through translation files:
- `data/language_xxx.txt`: UI translations
- `data/cardinfo_xxx.txt`: Card information

Currently supported languages:
- English
- Chinese

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

## Version

Current Version: 4.0.2.6

## License

This project uses various open-source components:
- DockPanelSuite (3.1.0)
- FCTB (2.16.24)
- NeoLua (1.3.14)
- Newtonsoft.Json (13.0.1)
- Serilog (4.1.0)