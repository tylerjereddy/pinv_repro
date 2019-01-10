FROM i386/ubuntu:bionic

RUN apt-get update && apt-get install -y \
  gcc-4.9 \
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
    pickle5 \
    wheel

RUN cd .. && \
    mkdir openblas && cd openblas && \
    wget https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com/openblas-v0.3.3-186-g701ea883-manylinux1_i686.tar.gz && \
    tar zxvf openblas-v0.3.3-186-g701ea883-manylinux1_i686.tar.gz && \
    cp -r ./usr/local/lib/* /usr/lib && \
    cp ./usr/local/include/* /usr/include && \
    cd .. && \
    git clone https://github.com/numpy/numpy.git

RUN cd numpy && \
    F77=gfortran-5 F90=gfortran-5 \
    CC=/usr/bin/gcc-5 CFLAGS='-UNDEBUG -std=c99' pip3 wheel -v -v -v --wheel-dir=./dist .

RUN cd numpy/dist && \
    F77=gfortran-5 F90=gfortran-5 CC=/usr/bin/gcc-5 CFLAGS='-UNDEBUG -std=c99' \
    pip3 install ./numpy*i686.whl

CMD cd numpy && \
    python3 runtests.py -n --mode=full -- -k "TestPinv" && \
    /usr/bin/gcc-5 --version
