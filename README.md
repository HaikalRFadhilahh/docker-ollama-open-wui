# Deploy Your Personal AI (Ollama + Docker + Open Web UI)

<p>This project is a simple script for those of you who want to create or have a Personal AI such as ChatGPT, DeepSeek, etc. Without requiring complicated configuration, you can easily set up your own AI system. Using Docker Compose, you just need to run a few commands, and with Reverse Proxy, you can make it accessible through your personal domain.
</p>

## Requirements

- Docker
- docker compose / docker-compose Command

## Features

- Simple Deployment using Docker Compose
- Interactive Bash Script for Unix Operating System Based
- Easy to Installing Available Models

## Manual Installation and Deployment

<p>1. Clone Project Repository</p>

```bash
git clone https://github.com/HaikalRFadhilahh/docker-ollama-open-wui.git docker-ollama-open-wui
```

<p>2. Go to Project Repository</p>

```bash
cd docker-ollama-open-wui
```

<p>3. Pull Docker Image Services</p>

```bash
docker compose pull
```

<p>4. Starting Docker Service via Docker Compose</p>

```bash
docker compose up -d
```

<p>3. Pull Docker Image Services</p>

```bash
docker compose pull
```

### Stopping Ollama and Open Web UI Services

<p>Stopping All Services (Without Remove Ollama Models)</p>

```bash
docker compose down
```

<p>Stopping All Service and Remove Volumes (Including Open Web UI Credentials and Ollama Models)</p>

```bash
docker compose down -v
```

### Installing Models via Ollama

<p>Installing Models Ollama using Docker Exec</p>

```bash
docker exec -it ollama-ai ollama pull ${model_name}
```

<p>Example:</p>

```bash
docker exec -it ollama-ai ollama pull deepseek-r1:1.5b
```

You can find the available Ollama Model List at the following link [list ollama models](https://ollama.com/search)

### Delete unused Ollama Models.

<p>Delete Models Ollama using Docker Exec</p>

```bash
docker exec -it ollama-ai ollama pull ${model_name}
```

<p><b>You can view the list of ollama models available on your local machine with this command.</b></p>

```bash
docker exec -it ollama-ai ollama list
```

## Automation Installation and Deployment Using Bash Script (Only for Unix Systems)

<p>Coming Soon 😔</p>

## Contributing

<p>You can contribute to this project through Pull Requests to this Repository, or you can report bugs or vulnerabilities through the issues feature on github. 🐳</p>

<p align="center"><b>Created by Haikal and Contributors with ❤️</b></p>
