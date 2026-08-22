FROM node:20-slim

RUN apt update && apt install -y ffmpeg curl wget jq python3

WORKDIR /app

COPY . .

RUN npm install

CMD ["bash", "startup.sh"]
