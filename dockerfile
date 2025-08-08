FROM julia:latest

# do we need to update?
# RUN apt-get update && apt-get install -y openssh-server

WORKDIR /process

COPY Project.toml Manifest.toml /process/

RUN julia --project=/process -e 'using Pkg; Pkg.instantiate()'

COPY . /process

EXPOSE 11111

LABEL config_schema='{"rate":"float"}'

CMD ["julia", "--project=/process", "process.jl"]