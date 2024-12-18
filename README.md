"# minecraft-servers" 
Script d'installation de serveur minecraft.

## Requirements
- screen (apt install screen)
- Divers dossiers pour contenir les serveurs (BASDIR = /srv)

## Modifcations
Plusieurs variables sont présentes au début du script.
Vous pouvez les modifiers comme vous le souhaitez.
- BASE_DIR     Répertoire racine des serveurs 
- NUM_SERVERS  Nombre de serveur à creer
- TOTAL_RAM    Nombre de RAM maximum pour tout les serveurs
- DEFAULT_PORT Port par défaut à ouvrir, incrémenté de 1 pour chaque serveur
- URL=         URL du fichier jar pour la version du serveur
