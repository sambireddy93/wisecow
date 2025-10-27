FROM debian:bookworm-slim

WORKDIR /app
COPY . /app

# Install all Wisecow dependencies properly
RUN apt-get update && \
    apt-get install -y bash curl netcat-openbsd && \
    apt-get install -y fortune-mod cowsay && \
    ln -s /usr/games/cowsay /usr/bin/cowsay && \
    ln -s /usr/games/fortune /usr/bin/fortune && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Make the script executable
RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]

