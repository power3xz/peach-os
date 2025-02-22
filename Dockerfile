FROM ubuntu:24.04 AS tool-installed

RUN apt update && apt install -y vim

FROM tool-installed
COPY "./docker-cmd.sh" /
RUN chmod +x ./docker-cmd.sh
RUN mkdir /mnt/d

CMD ["./docker-cmd.sh"]
