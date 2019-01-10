FROM i386/ubuntu:bionic

RUN apt-get update && apt-get install -y \
  gfortran-5 \
  git \
  locales \
  python3.6-dev \
  python3-pip \
  wget

RUN locale-gen fr_FR && update-locale
RUN pip3 install \
    setuptools \
    nose \
    cython==0.29.0 \
    pytest \
    pytz \
    pickle5

RUN cd .. && \
    mkdir openblas && cd openblas && \
    wget https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com/openblas-v0.3.3-186-g701ea883-manylinux1_i686.tar.gz && \
    tar zxvf openblas-v0.3.3-186-g701ea883-manylinux1_i686.tar.gz && \
    cp -r ./usr/local/lib/* /usr/lib && \
    cp ./usr/local/include/* /usr/include && \
    cd .. && \
    git clone https://github.com/numpy/numpy.git && \
    cd numpy && \
    NUMPY_EXPERIMENTAL_ARRAY_FUNCTION=1 \
    F77=gfortran-5 F90=gfortran-5 \
    python3 setup.py install

CMD cd numpy && \
    python3 runtests.py --mode=full --show-build-log -t "numpy/linalg/tests/test_linalg.py::TestPinv"
