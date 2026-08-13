FROM ghcr.io/paperclipai/paperclip:latest

USER root

# Criar pasta global de credenciais e dar permissão total
RUN mkdir -p /paperclip/.gemini && \
    chmod -R 777 /paperclip/.gemini

# Forçar todos os caminhos possíveis de HOME/config a apontarem para o mesmo lugar
RUN mkdir -p /root /home/node && \
    ln -s /paperclip/.gemini /root/.gemini 2>/dev/null || true && \
    ln -s /paperclip/.gemini /home/node/.gemini 2>/dev/null || true

# Configurar as variáveis globais de ambiente
ENV HOME=/paperclip
ENV ANTIGRAVITY_CONFIG_DIR=/paperclip/.gemini

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

    # 1. Criar o link simbolico global para o agy
RUN ln -s /paperclip/.local/bin/agy /usr/local/bin/agy || true

# 2. Garantir que a pasta /paperclip/.local/bin esteja no PATH do container
ENV PATH="${PATH}:/paperclip/.local/bin"

# Retorna ao usuário 'node'
# USER node

EXPOSE 3100
