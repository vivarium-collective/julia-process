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