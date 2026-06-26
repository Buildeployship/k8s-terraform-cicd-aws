# ---- build stage ----
FROM python:3.13.1-slim AS build
WORKDIR /app

# create a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# install deps into the venv
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- runtime stage ----
FROM python:3.13.1-slim
WORKDIR /app

# create a non-root user
RUN useradd --create-home --uid 1000 appuser

# copy the whole venv from the build stage
COPY --from=build /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY app/main.py .

USER appuser

EXPOSE 8080
CMD ["python3", "main.py"]
