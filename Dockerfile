# ---------- BUILDER STAGE ----------
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH="/root/.foundry/bin:${PATH}"
RUN foundryup

# Setup project
WORKDIR /app
COPY . .

# Build contracts during image build
RUN forge build


# ---------- RUNTIME STAGE ----------
FROM ubuntu:22.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates

# Install Foundry again for runtime tests
RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH="/root/.foundry/bin:${PATH}"
RUN foundryup

WORKDIR /project

COPY --from=builder /app .

# Default CMD: Run full test suite
CMD ["forge", "test", "-vv"]
