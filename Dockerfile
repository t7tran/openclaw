FROM ghcr.io/openclaw/openclaw:2026.3.13-1

RUN cd /app && \
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
    echo