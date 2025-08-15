include("src/process_interface.jl")


struct GrowProcess <: Process
    name::String
    config::JSON3.Object

    function GrowProcess()
        config = read_config()
        new("grow", config)
    end
end

function inputs(process::GrowProcess)::Dict
    Dict("mass" => "float")
end

function outputs(process::GrowProcess)::Dict
    Dict("mass_delta" => "float")
end

function update(process::GrowProcess, state::JSON3.Object, interval::Float64)::Dict
    mass_delta = process.config.rate * state.mass * interval
    Dict("mass_delta" => mass_delta)
end


process = GrowProcess()
start_server(process)
