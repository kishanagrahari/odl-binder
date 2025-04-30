FROM python:2.7

# Set working directory
WORKDIR /home/odl

# Install core dependencies
RUN apt-get update && \
    apt-get install -y git wget gfortran libblas-dev liblapack-dev \
    libatlas-base-dev libhdf5-dev libfreetype6-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Python package dependencies
RUN pip install numpy scipy pandas matplotlib h5py==2.10.0
RUN pip install Theano==0.8.2
RUN pip install keras==1.2.1
RUN pip install tensorflow==1.15.0  # Needed by Keras backend

# Jupyter and notebook tools
RUN pip install notebook==5.7.8 jupyter-client==5.3.5 ipykernel==4.10.1 \
    ipython==5.10.0 traitlets==4.3.3 tornado==5.1.1 jinja2==2.11.3 \
    nbconvert==5.6.1 nbformat==4.4.0 pygments==2.5.2 prompt-toolkit==1.0.18

# Clone official ODL repo to get custom training script
RUN git clone https://github.com/LIBOL/ODL.git

# Replace Keras training.py dynamically
RUN python -c "import keras, os; p=os.path.dirname(keras.__file__); open('/tmp/training_path.txt','w').write(p)" && \
    cp /home/odl/ODL/training.py $(cat /tmp/training_path.txt)/engine/training.py

# Copy any local notebooks (optional step, uncomment if needed)
# COPY ODL_Demo_v2.ipynb .

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
