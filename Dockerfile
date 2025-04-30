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

# ✅ Install older, compatible Jupyter and dependencies for Python 2.7
RUN pip install notebook==5.7.8 jupyter-client==5.3.5 ipykernel==4.10.1 \
    ipython==5.10.0 traitlets==4.3.3 tornado==5.1.1 jinja2==2.11.3 \
    nbconvert==5.6.1 nbformat==4.4.0 pygments==2.5.2 \
    prompt-toolkit==1.0.18

# Clone the ODL repo
RUN git clone https://github.com/LIBOL/ODL.git

# Replace Keras training.py with the custom ODL version
RUN cp /home/odl/ODL/training.py /usr/local/lib/python2.7/dist-packages/keras/engine/training.py

# Download sample dataset
RUN mkdir -p /home/odl/ODL/data && \
    wget -O /home/odl/ODL/data/higgs.mat https://www.dropbox.com/s/fvqnhe34cf0mlz9/higgs_100k.mat?dl=1

# Set default command
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''"]
