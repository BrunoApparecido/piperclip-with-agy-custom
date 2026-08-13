FROM ghcr.io/paperclipai/paperclip:latest

USER root

# 1. Dependências base do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar a CLI Antigravity (agy)
RUN npm install -g @google/antigravity-cli || npm install -g agy

# 3. Instalar o adapter customizado
RUN npm install -g @weslleycapelari/adapter-antigravity-local || \
    (mkdir -p /paperclip/adapters/antigravity-local && \
     git clone https://github.com/weslleycapelari/adapter-antigravity-local.git /paperclip/adapters/antigravity-local && \
     cd /paperclip/adapters/antigravity-local && npm install --production)

# 4. CRÍTICO: Criar a pasta do antigravity-cli e ajustar permissões para o usuário 'node'
RUN mkdir -p /paperclip/.gemini/antigravity-cli \
    && chown -R node:node /paperclip

# Retorna ao usuário 'node'
# USER node

EXPOSE 3100
