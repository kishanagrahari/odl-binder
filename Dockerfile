# Lightweight Dockerfile for Binder (Python 2.7 + ODL + Jupyter)
# Shrunk down to avoid timeout on Binder

FROM python:2.7

# Set working directory
WORKDIR /home/odl

# Install core dependencies only
RUN apt-get update && \
    apt-get install -y git gfortran libatlas-base-dev libhdf5-dev libfreetype6-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Pin pip version to compatible with Python 2.7
RUN pip install --upgrade pip==20.3.4

# Only necessary scientific libraries
RUN pip install numpy scipy pandas matplotlib h5py==2.10.0

# Install Keras 1.2.1 + Theano backend (no TF yet)
RUN pip install Theano==0.8.2 keras==1.2.1

# Add minimal TensorFlow (for Keras to load properly)
RUN pip install tensorflow==1.15.0

# Install core Jupyter dependencies
RUN pip install notebook==5.7.8 jupyter-client==5.3.5 ipykernel==4.10.1 ipython==5.10.0 traitlets==4.3.3 \
    tornado==5.1.1 jinja2==2.11.3 nbconvert==5.6.1 nbformat==4.4.0 pygments==2.5.2 prompt-toolkit==1.0.18

# Clone and patch Keras with ODL training.py
RUN git clone https://github.com/LIBOL/ODL.git && \
    python -c "import keras, os; p=os.path.dirname(keras.__file__); open('/tmp/keras_path.txt','w').write(p)" && \
    cp /home/odl/ODL/training.py $(cat /tmp/keras_path.txt)/engine/training.py

# Copy your notebook
COPY ODL_Demo_v2.ipynb /home/odl/

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
