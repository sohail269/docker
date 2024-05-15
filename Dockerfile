# Use a specific lightweight Linux distribution version to avoid potential issues
FROM alpine:3.18

# Set the working directory to /tmp
WORKDIR /tmp

# Copy the OpenSSL and cURL tarballs to the container
COPY openssl-1.1.1w.tar.gz curl-7.81.0.tar.gz /tmp/

# Install dependencies required for building
RUN apk add --no-cache \
    build-base \
    zlib-dev \
    linux-headers \
    libressl-dev

# Extract and install OpenSSL
RUN tar -xzvf openssl-1.1.1w.tar.gz && \
    cd openssl-1.1.1w && \
    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib && \
    make && make install_sw

# Extract and install cURL
RUN tar -xzvf curl-7.81.0.tar.gz && \
    cd curl-7.81.0 && \
    ./configure --with-ssl=/usr/local/ssl --prefix=/usr/local && \
    make && make install

# Clean up
RUN rm -rf /tmp/*

# Set the entry point to cURL
ENTRYPOINT ["curl"]
