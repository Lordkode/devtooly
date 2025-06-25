# DevTooly

[![CI](https://github.com/Lordkode/devtooly/workflows/CI/badge.svg)](https://github.com/Lordkode/devtooly/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

DevTooly est un script d'installation interactif pour les développeurs. Il permet d'installer facilement et en toute sécurité les outils de développement nécessaires sur votre système.

## Fonctionnalités

- Interface utilisateur interactive
- Installation sélective des outils
- Support multi-OS (Linux, macOS)
- Gestion des dépendances
- Logs détaillés
- Mode dry-run pour tester avant l'installation

## Installation

1. Clonez le dépôt :
```bash
git clone https://github.com/Lordkode/devtooly.git
cd devtooly
```

2. Rendez le script exécutable :
```bash
chmod +x devtooly.sh
```

## Utilisation

Lancez simplement le script :
```bash
./devtooly.sh
```

Le script vous guidera à travers une interface interactive pour sélectionner les outils à installer.

## Structure du Projet

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

## Contribuer

Veuillez lire le [guide de contribution](CONTRIBUTING.md) pour savoir comment contribuer à ce projet.

## Code de Conduite

Ce projet adhère au [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). En participant, vous acceptez de respecter ce code.

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Support

Pour obtenir de l'aide ou signaler des bugs, ouvrez une issue sur le [dépôt GitHub](https://github.com/Lordkode/devtooly/issues).
