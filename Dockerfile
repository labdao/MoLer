FROM nvidia/cuda:11.6.0-cudnn8-devel-ubuntu20.04
FROM --platform=linux/amd64 python:3.7


RUN chsh -s /bin/bash

SHELL ["/bin/bash", "-c"]

WORKDIR /root/

RUN apt-get update
RUN apt-get install -y wget bzip2 apt-utils git
RUN apt-get clean

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH /opt/conda/bin:$PATH

# setup conda virtual environment
COPY ./environment.yml ./environment.yml

COPY ./datasets ./datasets

RUN conda env create -f environment.yml --name moler

RUN conda init bash

RUN echo "conda activate moler" >> ~/.bashrc

ENV PATH /opt/conda/envs/moler/bin:$PATH
ENV CONDA_DEFAULT_ENV $moler

RUN pip install molecule-generation

ENTRYPOINT [ "molecule_generation", "preprocess" ]
