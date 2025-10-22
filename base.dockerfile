FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Asia/Shanghai \
    JOERN_HOME=/joern
ENV PATH="${JOERN_HOME}:${PATH}"

# 换源与基础依赖（Java 17、解压、网络工具、ctags 等）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl wget unzip git \
      universal-ctags \
      openjdk-17-jre-headless \
      bzip2 xz-utils gzip locales && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# 安装 Joern 并精简不需要的前端
ARG JOERN_VERSION=v4.0.353
RUN wget -q https://github.com/joernio/joern/releases/download/${JOERN_VERSION}/joern-cli.zip && \
    unzip -q joern-cli.zip && \
    mv joern-cli ${JOERN_HOME} && \
    rm -f joern-cli.zip && \
    rm -rf ${JOERN_HOME}/frontends/csharpsrc2cpg \
           ${JOERN_HOME}/frontends/ghidra2cpg \
           ${JOERN_HOME}/frontends/gosrc2cpg \
           ${JOERN_HOME}/frontends/swiftsrc2cpg \
           ${JOERN_HOME}/frontends/pysrc2cpg \
           ${JOERN_HOME}/frontends/rubysrc2cpg \
           ${JOERN_HOME}/frontends/php2cpg \
           ${JOERN_HOME}/frontends/jimple2cpg && \
    chmod +x ${JOERN_HOME}/joern && \
    joern --version

# 复制 Joern 脚本到镜像内
COPY parse.sc /workspace/parse.sc

WORKDIR /root

# 入口为 bash，容器内可直接运行 joern 命令
ENTRYPOINT ["bash"]
