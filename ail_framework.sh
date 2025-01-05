#!/bin/bash

# Fonction pour afficher l'aide
show_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  --help               Affiche ce message d'aide."
    echo "  --setup              Configure et lance AIL-Framework via Docker."
    echo "  --start              Démarre le conteneur Docker AIL-Framework."
    echo "  --reset-password     Réinitialise le mot de passe administrateur."
    echo "  --stop               Arrête le conteneur Docker AIL-Framework."
    echo
    echo "Informations utiles :"
    echo "  Interface utilisateur AIL-Framework : https://127.0.0.1:7000"
    echo "  URL de Lacus pour la configuration des crawlers : http://127.0.0.1:7100"
    echo "  Proxy Tor : socks5://127.0.0.1:9050"
    exit 0
}

# Vérification des dépendances
check_dependency() {
    if ! command -v $1 &>/dev/null; then
        echo "Erreur : $1 n'est pas installé. Veuillez l'installer avant de continuer."
        exit 1
    fi
}

# Variables
AIL_DOCKER_REPO="https://github.com/supdevinci/ail-framework-docker.git"
AIL_FRAMEWORK_REPO="https://github.com/ail-project/ail-framework.git"
DOCKER_CONTAINER_NAME="ail-framework"

# Gestion des options
case "$1" in
    --help)
        show_help
        ;;
    --setup)
        echo "Vérification des dépendances requises..."
        check_dependency git
        check_dependency docker
        check_dependency docker-compose

        echo "Clonage des dépôts..."
        #[ ! -d "ail-framework-docker" ] && git clone $AIL_DOCKER_REPO
        #cd ail-framework-docker
        [ ! -d "ail-framework" ] && git clone $AIL_FRAMEWORK_REPO

        echo "Construction du conteneur Docker..."
        sudo docker compose build

        echo "Démarrage du conteneur Docker..."
        sudo docker compose up -d
        ;;
    --start)
        echo "Démarrage du conteneur Docker AIL-Framework..."
        sudo docker compose up -d
        ;;
    --reset-password)
        echo "Réinitialisation du mot de passe administrateur pour AIL-Framework..."
        container_status=$(sudo docker inspect -f '{{.State.Running}}' $DOCKER_CONTAINER_NAME 2>/dev/null)
        if [ "$container_status" == "true" ]; then
            sudo docker exec $DOCKER_CONTAINER_NAME bin/LAUNCH.sh -rp 2>/dev/null | grep -E "new user created|Réinitialisation|Resetting UI admin password|password|token" | while read -r line; do echo -e "\e[32m$line\e[0m"; done
            echo "Mot de passe administrateur réinitialisé avec succès."
        else
            echo "Erreur : le conteneur $DOCKER_CONTAINER_NAME n'est pas en cours d'exécution."
        fi
        ;;
    --stop)
        echo "Arrêt du conteneur Docker AIL-Framework..."
        sudo docker compose down
        ;;
    *)
        show_help       
        exit 1
        ;;
esac
