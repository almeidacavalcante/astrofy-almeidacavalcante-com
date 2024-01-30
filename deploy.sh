#!/bin/bash

PROJECT_DIR="./"
SERVER_USER="rootish"
SERVER_IP="almeidacavalcante.com"
SERVER_PATH="/var/sites/www/almeidacavalcante.com"
SERVER_PORT=2222

cd "$PROJECT_DIR"

echo "Construindo o site..."
pnpm run build

# Passo 1: Deletar o conteúdo da pasta 'almeidacavalcante.com' no servidor
echo "Deletando conteúdo da pasta remota 'almeidacavalcante.com'..."
ssh -p $SERVER_PORT "$SERVER_USER@$SERVER_IP" "rm -rf $SERVER_PATH/*"

# Passo 2: Criar um arquivo zip do conteúdo da pasta 'dist' (sem a pasta 'dist')
echo "Criando um arquivo zip do conteúdo da pasta 'dist'..."
(cd ./dist && zip -r ../dist.zip *)

# Passo 3: Enviar o arquivo zip para a pasta 'almeidacavalcante.com' no servidor e descompactar na raiz
echo "Enviando arquivo zip para a pasta remota e descompactando na raiz 'almeidacavalcante.com'..."
scp -P $SERVER_PORT ./dist.zip "$SERVER_USER@$SERVER_IP:$SERVER_PATH/"
ssh -p $SERVER_PORT "$SERVER_USER@$SERVER_IP" "unzip -o $SERVER_PATH/dist.zip -d $SERVER_PATH/ && rm $SERVER_PATH/dist.zip"

echo "Deploy concluído com sucesso!"
