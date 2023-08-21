ARG PYTHON_BASE_IMAGE='python'
FROM ${PYTHON_BASE_IMAGE}:3.11-slim AS rye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH="/app/src:$PYTHONPATH"
ENV RYE_HOME="/opt/rye"
ENV PATH="$RYE_HOME/shims:$PATH"

WORKDIR /app
RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl \
  && curl -sSf https://rye-up.com/get | RYE_NO_AUTO_INSTALL=1 RYE_INSTALL_OPTION="--yes" bash

COPY pyproject.toml requirements.lock requirements-dev.lock .python-version README.md ./
RUN rye sync --no-dev --no-lock
RUN . .venv/bin/activate

FROM rye AS dev
RUN rye sync --no-lock

FROM rye AS run

ENV PORT=8000
ENV HOST=0.0.0.0

COPY server.py server.py

ENTRYPOINT ["sh", "-c", "/app/.venv/bin/uvicorn server:app --host $HOST --port $PORT"]
