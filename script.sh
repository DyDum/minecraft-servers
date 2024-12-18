#!/bin/bash

BASE_DIR="/srv"
NUM_SERVERS=3
TOTAL_RAM=6
RAM_PER_SERVER=$((TOTAL_RAM / NUM_SERVERS))G
DEFAULT_PORT=25565
URL=https://api.papermc.io/v2/projects/paper/versions/1.18.1/builds/216/downloads/paper-1.18.1-216.jar

create_server() {
    SERVER_ID=$1
    SERVER_PORT=$2
    SERVER_USER="minecraft-$SERVER_ID"
    SERVER_DIR="${BASE_DIR}/minecraft-${SERVER_ID}"

    if ! id "$SERVER_USER" &>/dev/null; then
        useradd -m -d "$SERVER_DIR" -s /bin/bash "$SERVER_USER"
    fi

    if [ ! -d "$SERVER_DIR" ]; then
        echo "Erreur: Le Répertoire $SERVER_DIR n'existe pas. Merci de vérifier les partitions montées."
        return 1
    fi

    chown -R "$SERVER_USER:$SERVER_USER" "$SERVER_DIR"
    sudo -u "$SERVER_USER" wget -O "$SERVER_DIR/server.jar" $URL
    sudo -u "$SERVER_USER" bash -c "echo 'eula=true' > $SERVER_DIR/eula.txt"
    sudo -u "$SERVER_USER" bash -c "cat <<EOF > $SERVER_DIR/server.properties
server-port=$SERVER_PORT
enable-query=true
query.port=$SERVER_PORT
motd=Minecraft Server $SERVER_ID
EOF"
    sudo -u "$SERVER_USER" bash -c "cat <<EOF > $SERVER_DIR/start.sh
#!/bin/bash
java -Xms1G -Xmx${RAM_PER_SERVER} -jar server.jar nogui
EOF"
    chmod +x "$SERVER_DIR/start.sh"

    screen -dmS "minecraft-$SERVER_ID" bash -c "cd $SERVER_DIR && ./start.sh"
    echo "Serveur $SERVER_ID a commencé sur le screen minecraft-$SERVER_ID sur le port $SERVER_PORT."
}

for i in $(seq 1 $NUM_SERVERS); do
    create_server "$i" $((DEFAULT_PORT + i - 1))
done

echo "Tout les serveurs sont démarés dans des screens différents !"