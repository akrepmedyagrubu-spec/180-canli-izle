FROM ubuntu:22.04

RUN apt update && apt install -y ffmpeg python3 git git-lfs

WORKDIR /app

COPY . .

# 👇 EN KRİTİK SATIR
RUN git lfs install && git lfs pull

RUN chmod +x run.sh

CMD ["./run.sh"]
