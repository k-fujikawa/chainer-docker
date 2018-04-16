FROM nvidia/cuda:9.0-cudnn7-devel

# Install default packages
RUN apt-get update -y && apt-get install -y \
    git \
    vim \
    gcc \
    build-essential \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libxrender-dev \
    curl \
    libcurl4-openssl-dev \
    wget \
    language-pack-ja \
    pkg-config \
    tzdata

# Set timezone
ENV TZ Asia/Tokyo
RUN echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

# Install pyenv & setup python
ENV PYENV_ROOT /opt/pyenv
ENV CONDA_VERSION miniconda3-4.1.11
RUN git clone git://github.com/yyuu/pyenv.git $PYENV_ROOT
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN pyenv install $CONDA_VERSION
RUN pyenv global $CONDA_VERSION
RUN pyenv rehash

# Create python enviromnents
ADD environment.yml /src/environment.yml
RUN conda env create -f /src/environment.yml
RUN pyenv global $CONDA_VERSION/envs/default
RUN pip install -U pip

# Install python dependencies
ADD requirements.txt /src/requirements.txt
RUN pip install -r /src/requirements.txt
ARG USE_GPU=1
RUN if [ $USE_GPU = 1 ] ; then \
    pip install cupy==2.4.0 ; fi

# Install src
ADD . /src
ENV CHAINER_SEED 0
ENV CHAINER_DATASET_ROOT /src/data
WORKDIR /src
