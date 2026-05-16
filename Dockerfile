# Use Debian-based PostGIS image instead of Alpine
ARG BASE_IMAGE=postgis/postgis:15-3.4

FROM ${BASE_IMAGE} as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    cmake \
    make \
    gcc \
    g++ \
    postgresql-server-dev-15 \
    && pip3 install pgxnclient

# Install H3 extension
RUN pgxn install 'h3=4.1.3'

# Cleanup
RUN apt-get remove -y python3-pip cmake make gcc g++ postgresql-server-dev-15 && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

FROM ${BASE_IMAGE}

COPY --from=builder /usr/lib/postgresql/15/lib/* /usr/lib/postgresql/15/lib/
COPY --from=builder /usr/share/postgresql/15/extension/* /usr/share/postgresql/15/extension/

ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

EXPOSE 5432
CMD ["postgres"]