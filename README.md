# julia-process

A container template for making a julia program into a Vivarium process

## build

> docker build -t julia-process .

## run

> docker run -p 11111:11111 -v ./test:/config julia-process

If you want to use a different config than the included test config you can map
a different host volume into the container - it will read anything inside with
the name `config.json`

## commands

Connecting to the socket on port 11111 will allow you to send commands to the
running process. Available commands are:

* inputs(): get the inputs schema for this process
* outputs(): get the outputs schema for this process
* update(state, interval): receives state in the form of the inputs schema, and produces a result in the form of the outputs schema. Runs for `interval` amount of time.

## process design

Right now the general process interface is abstracted into the file `src/process_interface.jl` and covers the basic Process type, reading and writing messages to the socket as "commands", and running the server that creates a socket and listens to it. This should be the same for any process you would want to write.

An example process is provided in `process.jl` - it only reads a single variable, "mass", and creates a delta based on a rate from the config. It is instantiated with

    process = GrowProcess()

and passed into the server:

    start_server(process)

You could supply your own process instance here. The specific methods for the process interface:

* inputs(process)
* outputs(process)
* update(process, state, interval)

are selected using Julia multidispatch.

The `config_schema` for the process is specified in the `dockerfile`, as it is universal for any instance of the process. 