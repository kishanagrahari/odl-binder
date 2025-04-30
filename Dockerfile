FROM python:2.7

# Set working directory
WORKDIR /home/odl

# System dependencies
RUN apt-get update && \
    apt-get install -y git wget gfortran libblas-dev liblapack-dev libatlas-base-dev \
    libhdf5-dev libfreetype6-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Python dependencies
RUN pip install --upgrade pip==20.3.4
RUN pip install numpy scipy pandas matplotlib h5py==2.10.0
RUN pip install Theano==0.8.2
RUN pip install keras==1.2.1
RUN pip install tensorflow==1.15.0  # Required for Keras backend
RUN pip install notebook==5.7.8 jupyter-client==5.3.5 ipykernel==4.10.1 \
    ipython==5.10.0 traitlets==4.3.3 tornado==5.1.1 jinja2==2.11.3 \
    nbconvert==5.6.1 nbformat==4.4.0 pygments==2.5.2 \
    prompt-toolkit==1.0.18

# Clone ODL repo
RUN git clone https://github.com/LIBOL/ODL.git

# Dynamically patch keras training.py
RUN python -c "import keras, os; p=os.path.dirname(keras.__file__); \
    open('/tmp/keras_path.txt','w').write(p)" && \
    cp /home/odl/ODL/training.py $(cat /tmp/keras_path.txt)/engine/training.py

# Copy your notebook into the container
COPY ODL_Demo_v2.ipynb /home/odl/

# Launch Jupyter
CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
