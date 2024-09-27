# parent image for python using slim image
FROM python:3.12-slim-bookworm

ARG DOCKER_TEST_ENV

LABEL maintainer="{{ cookiecutter.project_domain }}"
LABEL vendor="{{ cookiecutter.project_domain }}"

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  # pip:
  PIP_NO_CACHE_DIR=1 \
  PIP_DISABLE_PIP_VERSION_CHECK=1 \
  PIP_DEFAULT_TIMEOUT=100 \
  # poetry:
  POETRY_VERSION=1.8.3 \
  POETRY_HOME="/opt/poetry" \
  POETRY_VIRTUALENVS_IN_PROJECT=true \
  POETRY_NO_INTERACTION=1

# set work directory
WORKDIR /app

# install system dependencies (gcc) needed for some python package
RUN apt-get update && apt-get install -y \
  gcc \
  curl \
  && rm -rf /var/lib/apt/lists/*

# install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# add poetry to PATH
ENV PATH="${POETRY_HOME}/bin:$PATH"

# copy poetry files
COPY pyproject.toml poetry.lock* ./

# install dependencies
RUN poetry install --no-dev --no-root

# copy the rest of the project files
COPY data/ .

# install dependencies
RUN poetry install --no-dev

# run the application
CMD ["poetry", "run", "python", "data/data_fetcher.py"]


