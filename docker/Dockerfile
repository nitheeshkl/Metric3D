FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 as base

# Install base utilities
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Pacific
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y build-essential && \
    apt-get install --no-install-recommends -y \
# General os pkgs that aren't version specific
    apt-transport-https \
    wget \
    locales \
    curl \
    less \
    jq \
    git \
    git-lfs \
    vim \
    sudo \
    unzip \
    ca-certificates \
    gnupg2 \
    cmake \
    ccache \
    pkg-config \
    libhdf5-dev \
    libgl1 \
    libgl-dev \
    python3 \
    python3-pip \
&& apt-get clean

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

### set up ccache
RUN /usr/sbin/update-ccache-symlinks
ENV PATH=/usr/lib/ccache:${PATH}
ARG CCACHE_BASEDIR=/cache
ARG CCACHE_DIR=/cache/ccache
ARG CCACHE_COMPILERCHECK=content

###############################################################################
# Decontainer image for development
###############################################################################
FROM base AS dev

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ${CONDA_DIR} && \
    addgroup --gid 1099 conda && \
    chgrp -R conda ${CONDA_DIR} && \
    chmod 777 -R ${CONDA_DIR}

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

RUN conda create -y -n metric3d python=3.11

SHELL ["conda", "run", "--no-capture-output","-n", "metric3d", "/bin/bash", "-c"]

WORKDIR /workspace

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "metric3d", "/bin/bash", "-l", "-c"]

ENV CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH