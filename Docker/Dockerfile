FROM ubuntu:22.04

RUN useradd -ms /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd && \
    usermod -aG sudo ubuntu
#RUN useradd -r -p ubuntu -g root ubuntu
#not work why?

#注意，换行用TAB
RUN apt-get update \
    && apt-get install -y sudo \
    && apt-get install -y vim \
    && apt-get install -y tree \
    && sudo apt-get install build-essential \
    && apt-get install -y git

USER ubuntu
WORKDIR /opt/docker
#ENTRYPOINT [ "/bin/bash" ] # 执行shell脚本
#docker build -t NAME:TAG .
#如：docker build -t test:v1 . 是test镜像，v1的tag
#注意！
#1. 先执行docker login
#2. 执行build命令时,要在一个空文件夹下（如果不是空文件夹要添加.dockerignore文件）
#3. 要在有Dockerfile文件下的目录执行build命令

