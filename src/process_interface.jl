using Sockets
using JSON3

const HOST = ip"0.0.0.0"
const PORT = 11111
const CONFIG_PATH = "/config/config.json"
const CONFIG_DEFAULT = "config/default_config.json"


# process -----------------------

abstract type Process end

function inputs(process::Process)::Dict
    Dict()
end

function outputs(process::Process)::Dict
    Dict()
end

function update(process::Process, state::JSON3.Object, interval::Float64)::Dict
    Dict()
end

# commands -------------------

function parse_command(command::String)
    JSON3.read(command)
end

function write_result(result::Dict)
    JSON3.write(result)
end

function read_config_path(path::String)
    config_data = "{}"
    open(path, "r") do config_file
        config_data = read(config_file, String)
    end
    parse_command(config_data)
end

function read_config(path::String = CONFIG_PATH)
    config = Dict()

    if isfile(path)
        config = read_config_path(
            path)
    else
        config = read_config_path(
            CONFIG_DEFAULT)
    end

    return config
end

function run_command(command::JSON3.Object, process::Process)
    result = Dict()

    if command.command == "inputs"
        result = inputs(process)
    elseif command.command == "outputs"
        result = outputs(process)
    elseif command.command == "update"
        arguments = command.arguments
        result = update(
            process,
            arguments.state,
            arguments.interval)
    end

    result
end

# server -----------------

function start_server(process::Process, host::IPAddr = HOST, port::Integer = PORT)
    server = listen(host, port)
    println("process is listening on port $PORT")

    while true
        conn = accept(server)
        println("connected to $conn\n")

        @async begin
            try
                while true
                    line = readline(conn)

                    command = parse_command(line)
                    println("received command: $command")

                    update = run_command(command, process)
                    println("computed update: $update")

                    result = write_result(update)

                    write(conn, "$result\n")
                end
            catch err
                println("connection ended with error: $err")
            end
        end
    end
end
