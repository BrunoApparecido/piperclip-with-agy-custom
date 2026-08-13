FROM ghcr.io/paperclipai/paperclip:latest

USER root

# 1. Dependências base do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar a CLI Antigravity (agy) globalmente
RUN npm install -g @google/antigravity-cli || npm install -g agy

# 3. Instalar o adapter customizado do Antigravity para o Paperclip
# Pode ser via npm se publicado ou clonado do repositório
RUN npm install -g @weslleycapelari/adapter-antigravity-local || \
    (mkdir -p /paperclip/adapters/antigravity-local && \
     git clone https://github.com/weslleycapelari/adapter-antigravity-local.git /paperclip/adapters/antigravity-local && \
     cd /paperclip/adapters/antigravity-local && npm install --production)

# Retorna ao usuário padrão da aplicação
USER node

EXPOSE 3100
