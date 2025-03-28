#!/bin/bash

# Verifica se o nome do plugin foi fornecido
if [ -z "$1" ]; then
    echo "Uso: $0 <nome-do-plugin>"
    exit 1
fi

PLUGIN_NAME=$1
PLUGIN_PATH="src/plugins/$PLUGIN_NAME"

echo "📦 Criando plugin: $PLUGIN_NAME..."

# Criando estrutura de diretórios
mkdir -p "$PLUGIN_PATH"/{server,admin}

# Criando package.json
cat > "$PLUGIN_PATH/package.json" <<EOL
{
  "name": "$PLUGIN_NAME",
  "version": "0.1.0",
  "description": "Plugin $PLUGIN_NAME para Strapi",
  "strapi": {
    "kind": "plugin"
  },
  "main": "server/index.ts",
  "license": "MIT"
}
EOL

# Criando server/index.ts
cat > "$PLUGIN_PATH/server/index.ts" <<EOL
export default {
  register({ strapi }) {
    strapi.log.info("Plugin $PLUGIN_NAME registrado!");
  },
  bootstrap({ strapi }) {
    strapi.log.info("Plugin $PLUGIN_NAME iniciado!");
  },
};
EOL

# Criando config/plugins.ts (se não existir)
CONFIG_FILE="config/plugins.ts"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "export default {};" > "$CONFIG_FILE"
fi

# Adicionando plugin ao config/plugins.ts
if ! grep -q "$PLUGIN_NAME" "$CONFIG_FILE"; then
    sed -i "/export default {/a \ \ \"$PLUGIN_NAME\": { enabled: true, resolve: \"./$PLUGIN_PATH\" }," "$CONFIG_FILE"
    echo "✅ Plugin $PLUGIN_NAME adicionado ao config/plugins.ts"
else
    echo "⚠️ Plugin $PLUGIN_NAME já está no config/plugins.ts"
fi

echo "🎉 Plugin $PLUGIN_NAME criado com sucesso!"
