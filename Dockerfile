FROM ghcr.io/openclaw/openclaw:2026.3.13-1 AS build

USER root

RUN mkdir -p /build/usr/local/bin
RUN cd /build && \
    npm init -y && \
    npm i google-auth-library && \
    rm -rf package-lock.json package.json

RUN curl -fsSLo /build/usr/local/bin/jq https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux64 && \
    chmod +x /build/usr/local/bin/jq
RUN curl -fsSLo /build/usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.52.4/yq_linux_amd64 && \
    chmod +x /build/usr/local/bin/yq

FROM ghcr.io/openclaw/openclaw:2026.3.13-1

ENV HOMEBREW_PREFIX="/home/node/homebrew" \
    HOMEBREW_CELLAR="/home/node/homebrew/Cellar" \
    HOMEBREW_REPOSITORY="/home/node/homebrew" \
    PATH="/home/node/homebrew/bin:/home/node/homebrew/sbin:$PATH"

RUN --mount=type=secret,id=clawhub_apikey,env=CLAWHUB_API_KEY \
    cd /app && \
    npx --yes clawhub@latest login --token ${CLAWHUB_API_KEY:?} && \
    npx --yes clawhub@latest install agentic-coding && \
    npx --yes clawhub@latest install automation-workflows && \
    npx --yes clawhub@latest install markdown-converter && \
    npx --yes clawhub@latest install microsoft-excel && \
    npx --yes clawhub@latest install n8n-workflow-automation && \
    npx --yes clawhub@latest install playwright && \
    npx --yes clawhub@latest install playwright-mcp && \
    npx --yes clawhub@latest install salesforce-api && \
    npx --yes clawhub@latest install security-auditor && \
    npx --yes clawhub@latest install self-improving-agent && \
    npx --yes clawhub@latest install ui-ux-pro-max && \
    npx --yes clawhub@latest install word-docx && \
    git clone https://github.com/Homebrew/brew /home/node/homebrew && \
    brew install gogcli

COPY --from=build /build /
