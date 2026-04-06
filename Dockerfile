FROM ghcr.io/openclaw/openclaw:2026.4.5

USER root

RUN curl -fsSLo /usr/local/bin/jq https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -fsSLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.52.4/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    apt update && \
    curl -fsSLo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install /tmp/chrome.deb -y && \
    apt install --no-install-recommends -y fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf && \
    rm -rf /tmp/*

USER node

ENV HOMEBREW_PREFIX="/app/homebrew" \
    HOMEBREW_CELLAR="/app/homebrew/Cellar" \
    HOMEBREW_REPOSITORY="/app/homebrew" \
    NPM_CONFIG_PREFIX="/home/node/.npm-packages" \
    PATH="/app/homebrew/bin:/app/homebrew/sbin:/home/node/.npm-packages/bin:$PATH"

RUN --mount=type=secret,id=clawhub_apikey,env=CLAWHUB_API_KEY \
    cd /app && \
    npx --yes clawhub@latest login --token ${CLAWHUB_API_KEY:?} && \
    npx --yes clawhub@latest install agentic-coding && \
    npx --yes clawhub@latest install automation-workflows && \
    npx --yes clawhub@latest install imap-smtp-email && \
    npx --yes clawhub@latest install markdown-converter && \
    npx --yes clawhub@latest install microsoft-excel && \
    npx --yes clawhub@latest install n8n-workflow-automation && \
    npx --yes clawhub@latest install playwright && \
    npx --yes clawhub@latest install playwright-mcp && \
    npx --yes clawhub@latest install salesforce-api && \
    npx --yes clawhub@latest install security-auditor && \
    npx --yes clawhub@latest install ui-ux-pro-max && \
    npx --yes clawhub@latest install word-docx && \
    npx --yes clawhub@latest install xiucheng-self-improving-agent && \
# post skill installation
    cd /app/skills/imap-smtp-email && npm i && \
    chmod +x /app/skills/imap-smtp-email/scripts/*.js && \
# remove bundled skills
    cd /app/skills && \
    rm -rf himalaya && \
# install homebrew
    git clone https://github.com/Homebrew/brew /app/homebrew && \
    brew install --cask claude-code && \
    brew install gogcli
