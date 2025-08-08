using Sockets
using JSON3


const HOST = ip"0.0.0.0"
const PORT = 11111
const CONFIG_PATH = "/config/config.json"
const CONFIG_DEFAULT = "config/default_config.json"


function parse_command(command::String)
    JSON3.read(command)
end

function write_result(result::Dict)
    JSON3.write(result)
end

function read_config(path::String)
    config_data = "{}"
    open(path, "r") do config_file
        config_data = read(config_file, String)
    end
    parse_command(config_data)
end


config = Dict()
if isfile(CONFIG_PATH)
    config = read_config(
        CONFIG_PATH)
else
    config = read_config(
        CONFIG_DEFAULT)
end
    

println("read config: $config\n")

inputs = Dict(
    "mass" => "float")

outputs = Dict(
    "mass_delta" => "float")


function run_command(command::JSON3.Object)
    result = Dict()
    if command.command == "inputs"
        result = inputs
    elseif command.command == "outputs"
        result = outputs
    elseif command.command == "update"
        mass_delta = config.rate * command.arguments.state.mass * command.arguments.interval
        result = Dict(
            "mass_delta" => mass_delta)
    end

    result
end


server = listen(HOST, PORT)
println("process is listening on port $PORT")

while true
    conn = accept(server)
    println("connected to $conn\n")

    @async begin
        total = 0

        try
            while true
                line = readline(conn)
                command = parse_command(line)
                update = run_command(command)
                result = write_result(update)

                println("received command: $command")
                println("computed update: $update")

                # result = try
                #     Meta.parse(line) |> eval
                # catch e
                #     "Error: $e"
                # end
                # total += result
                # write(conn, "$total\n")

                write(conn, "$result\n")
            end
        catch err
            # Handle connection errors
            println("Connection ended with error: $err")
        end
    end
end
