# Contributing to DevTooly

Thank you for considering contributing to DevTooly! We welcome contributions from everyone.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Adding New Tools](#adding-new-tools)
- [Testing](#testing)
- [Documentation](#documentation)
- [License](#license)

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Development Workflow

### Setting Up Your Development Environment

1. Clone the repository
```bash
git clone https://github.com/your-username/devtooly.git
cd devtooly
```

2. Install dependencies (none required for core functionality)

### Project Structure
```
devtooly/
├── src/
│   ├── core/
│   │   ├── utils/         # Helper functions and utilities
│   │   ├── ui/            # User interface components
│   │   └── installer/     # Installation functions
│   └── modules/           # Tool-specific installation scripts
│       ├── languages/     # Programming languages
│       ├── editors/       # Code editors
│       ├── databases/     # Database systems
│       ├── containers/    # Container tools
│       ├── devtools/      # Development tools
│       └── utilities/     # System utilities
└── .devtooly/            # Configuration files
```

## Adding New Tools

To add a new tool to DevTooly, follow these steps:

1. Create a new script in the appropriate module directory:
   - `src/modules/languages/` for programming languages
   - `src/modules/editors/` for code editors
   - `src/modules/databases/` for database systems
   - `src/modules/containers/` for container tools
   - `src/modules/devtools/` for development tools
   - `src/modules/utilities/` for system utilities

2. The script should:
   - Be named in lowercase (e.g., `python.sh`, `vscode.sh`)
   - Contain a function named `install_{tool_name}`
   - Use the `safe_exec` function for all commands
   - Follow the same error handling patterns as existing scripts

Example template:
```bash
#!/bin/bash

# Source helpers
source "${BASH_SOURCE%/*}/../../../utils/helpers.sh"

install_{tool_name}() {
    print_status "Installing {tool_name}..."
    
    # Add installation logic here
    # Use safe_exec for all commands
    # Handle errors appropriately
}
```

## Testing

### Manual Testing

1. Test your changes locally:
```bash
./devtooly.sh
```

2. Verify that:
   - The tool appears in the interactive menu
   - Installation completes successfully
   - All dependencies are properly installed

### Automated Testing

We plan to add automated testing in the future. For now, manual testing is required.

## Documentation

When adding new tools or making significant changes:

1. Update the README.md if needed
2. Add documentation for your tool in the appropriate module directory
3. Ensure all functions are properly documented with comments

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
