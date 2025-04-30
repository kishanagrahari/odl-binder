# Dockerfile for running ODL (Online Deep Learning) in Binder
# Python 2.7 + Theano 0.8.2 + Keras 1.2.1

FROM python:2.7

# Set working directory
WORKDIR /home/odl

# Install system dependencies
RUN apt-get update && \
    apt-get install -y git wget gfortran libblas-dev liblapack-dev libatlas-base-dev libhdf5-dev libfreetype6-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install numpy scipy pandas matplotlib h5py==2.10.0
RUN pip install Theano==0.8.2
RUN pip install keras==1.2.1

# Clone the ODL repo
RUN git clone https://github.com/LIBOL/ODL.git

# Download sample dataset
RUN mkdir -p /home/odl/ODL/data && \
    wget -O /home/odl/ODL/data/higgs.mat https://www.dropbox.com/s/fvqnhe34cf0mlz9/higgs_100k.mat?dl=1

# Start Jupyter when container loads
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''"]
