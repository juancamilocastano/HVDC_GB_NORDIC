## Step 0: Activate environment
using Pkg
# Pkg.activate(@__DIR__)
# Pkg.instantiate()
# Pkg.update()
# Pkg.add("Ipopt")
# Pkg.add("PowerModels")
# Pkg.add("PowerModelsACDC")
# Pkg.add("JuMP")
using PowerModels,  Gurobi, JuMP, CSV, DataFrames, CairoMakie
# Pkg.add("Plots") # if Plots package not added yet, for plotting results


gurobi = optimizer_with_attributes(Gurobi.Optimizer)

##### Step 1: Import the grid data and initialize the JuMP model
# Select the MATPOWER case file
path = pwd()
case_file = joinpath(path,"test_system_NORDIC_GB_HVDC.m")

# For convenience, use the parser of Powermodels to convert the MATPOWER format file to a Julia dictionary
data = PowerModels.parse_file(case_file)

#Original dictionary with information from power models
old=copy(data["convdc"])
#New keys structure
new = Dict{String, Dict{String, Any}}(
    string(v["busdc_i"]) => Dict{String, Any}(v)
    for (_, v) in old
)
#Diccionary corresponding to converter dc associated with same numenclature bus dc
data["convdc"] = new



ts = CSV.read("Load_data_hvdc.csv", DataFrame)
tsw= CSV.read("Wind_data_hvdc.csv", DataFrame)

# Initialize the JuMP model (an empty JuMP model) with defined solver
m = Model(gurobi)
#set_optimizer_attribute(m, "MIPGap", 0.0003)

##### Step 2: create the JuMP model & pass data to model
include(joinpath(path,"init_model.jl")) # Define functions define_sets! and process_parameters!
define_sets!(m, data,ts,tsw) # Pass the sets to the JuMP model
process_parameters!(m, data,ts,tsw) # Pass the parameters to the JuMP model

##### Step 3: Build the model
include(joinpath(path,"printparameters_frequency_sev_var_res_provi.jl")) # Define build_ac_opf_acdc! function
include(joinpath(path,"build_ac_opf_acdc_frequency_sev_var_res_provi.jl")) # Define build_ac_opf_acdc! function
include(joinpath(path,"plotfunction_frequency_sev_var_res_provis.jl")) # Define build_ac_opf_acdc! function

#build_ac_opf_acdc_modify!(m) # Pass the model to the build_ac_opf_acdc! function
#build_ac_opf_acdc_frequency!(m) # Pass the model to the build_ac_opf_acdc! function
#build_ac_opf_acdc_frequency_silent_3!(m) # Pass the model to the build_ac_opf_acdc! function
#build_ac_opf_acdc_frequency_silent_4!(m) # Pass the model to the build_ac_opf_acdc! function
#build_ac_opf_acdc_frequency_several_res_var_without_loss_res!(m)
build_ac_opf_acdc_frequency_sev_var_res_provi!(m)

##### Step 4: Solve the model


# set_optimizer_attribute(m, "DualReductions", 0)
# set_optimizer_attribute(m, "InfUnbdInfo", 1)
set_optimizer_attribute(m, "MIPGap", 0.0002) 
optimize!(m)
# @show termination_status(m)

# compute_conflict!(m)

#plotfunction_modify!(m) # Plot the results
#printparameters_frequency_silent_several_res_var
#plotfunction_frequency!(m) # Plot the results

# plotfunction_frequency_several_res_var_without_loss_res!(m) # Plot the results
#printparameters_frequency_several_res_var_without_loss_res!(m) # Print the results

plotfunction_frequency_sev_var_res_provis!(m) # Plot the results


printparameters_frequency_sev_var_res_provi!(m) # Plot the results



filename = "1_objective.txt"

open(filename, "w") do file
    
    println(file, "Objective: ", objective_value(m))
end


solution_summary(m)
#println(objective_value(m)) # Print the objective value of the model


