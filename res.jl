function res!(m::Model)

# ============================================================
# SETS
# ============================================================

T    = m.ext[:sets][:t]

G1   = m.ext[:sets][:G1]
G2   = m.ext[:sets][:G2]
WWS1 = m.ext[:sets][:WWS1]
WWS2 = m.ext[:sets][:WWS2]

E1   = m.ext[:sets][:E1]
E2   = m.ext[:sets][:E2]

S1   = m.ext[:sets][:S1]
S2   = m.ext[:sets][:S2]

G_solar_1 = m.ext[:sets][:G_solar_1]
G_solar_2 = m.ext[:sets][:G_solar_2]
G_wind_1  = m.ext[:sets][:G_wind_1]
G_wind_2  = m.ext[:sets][:G_wind_2]


# ============================================================
# PARAMETERS
# ============================================================

baseMVA = m.ext[:parameters][:baseMVA]

pmax = m.ext[:parameters][:pmax]
ic   = m.ext[:parameters][:ic]

f1 = m.ext[:parameters][:f1]
f2 = m.ext[:parameters][:f2]

Edeployment = m.ext[:parameters][:Edeployment]
G_dt        = m.ext[:parameters][:G_dt]

conv_p_ac_max = m.ext[:parameters][:convdc][:p_ac_max]


# ============================================================
# GENERATION
# ============================================================

pg = JuMP.value.(m.ext[:variables][:pg]) .* baseMVA


# ============================================================
# LOSS OF POWER PER AREA (N-1 generator outage)
# ============================================================

plg1 = JuMP.value.(m.ext[:variables][:plg1]) .* baseMVA
plg2 = JuMP.value.(m.ext[:variables][:plg2]) .* baseMVA

plg1vec = Array(plg1)
plg2vec = Array(plg2)


# ============================================================
# HVDC FLOWS
# ============================================================

flows_hvdc = JuMP.value.(m.ext[:variables][:brdc_p]) .* baseMVA

flows_hvdc12 = Array(flows_hvdc[("1", "1", "2"), :])


# ============================================================
# BINARY AND STATE VARIABLES
# ============================================================

zgvec = JuMP.value.(m.ext[:variables][:zg])   # unit commitment status
δgvec = JuMP.value.(m.ext[:variables][:δg])   # generator failure (N-1) indicator


# ============================================================
# SYSTEM INERTIA AFTER THE N-1 CONTINGENCY
# ============================================================

Inertia_nadir_frequency_1 = Dict()
Inertia_nadir_frequency_2 = Dict()

for t in T
    Inertia_nadir_frequency_1[t] = sum((zgvec[g,t] - δgvec[g,t])*ic[g]*pmax[g]*baseMVA for g in G1)
    Inertia_nadir_frequency_2[t] = sum((zgvec[g,t] - δgvec[g,t])*ic[g]*pmax[g]*baseMVA for g in G2)
end


# ============================================================
# N-k CONTINGENCY ANALYSIS
# ============================================================

#Available reserve from HVDC link

HVDC_reserve_row_1 = Dict()
HVDC_reserve_row_2 = Dict()

for (i, t) in enumerate(T)
    HVDC_reserve_row_1[t] = conv_p_ac_max["1"]*baseMVA + flows_hvdc12[i]
    HVDC_reserve_row_2[t] = conv_p_ac_max["2"]*baseMVA - flows_hvdc12[i]
end

r_proc_g_1 = JuMP.value.(m.ext[:variables][:r_proc_g_1]) .* baseMVA
r_proc_s_1 = JuMP.value.(m.ext[:variables][:r_proc_s_1]) .* baseMVA
r_proc_e_1 = JuMP.value.(m.ext[:variables][:r_proc_e_1]) .* baseMVA
r_proc_g_2 = JuMP.value.(m.ext[:variables][:r_proc_g_2]) .* baseMVA
r_proc_s_2 = JuMP.value.(m.ext[:variables][:r_proc_s_2]) .* baseMVA
r_proc_e_2 = JuMP.value.(m.ext[:variables][:r_proc_e_2]) .* baseMVA




fast_reserve_procured_1_per_hour = Dict()
slow_reserve_procured_1_per_hour = Dict()
slow_reserve_procured_1_nadir_per_hour=Dict()
fast_reserve_procured_2_per_hour = Dict()
slow_reserve_procured_2_per_hour = Dict()
slow_reserve_procured_2_nadir_per_hour=Dict()

storage_reserve_1_per_hour = Dict()
electrolyzer_reserve_1_per_hour = Dict()
storage_reserve_2_per_hour = Dict()
electrolyzer_reserve_2_per_hour = Dict()

for t in T
    fast_reserve_procured_1_per_hour[t] = sum(r_proc_s_1[s,t] for s in S1) + sum(r_proc_e_1[e,t] for e in E1)
    slow_reserve_procured_1_per_hour[t] = sum(r_proc_g_1[g,t] for g in G1)
    slow_reserve_procured_1_nadir_per_hour[t]= sum(r_proc_g_1[g,t] for g in G1)-sum(r_proc_g_1[g,t]*δgvec[g,t] for g in G1)
    fast_reserve_procured_2_per_hour[t] = sum(r_proc_s_2[s,t] for s in S2) + sum(r_proc_e_2[e,t] for e in E2)
    slow_reserve_procured_2_per_hour[t] = sum(r_proc_g_2[g,t] for g in G2)
    slow_reserve_procured_2_nadir_per_hour[t]= sum(r_proc_g_2[g,t] for g in G2)-sum(r_proc_g_2[g,t]*δgvec[g,t] for g in G2)
    storage_reserve_1_per_hour[t] = sum(r_proc_s_1[s,t] for s in S1)
    electrolyzer_reserve_1_per_hour[t] = sum(r_proc_e_1[e,t] for e in E1)
    storage_reserve_2_per_hour[t] = sum(r_proc_s_2[s,t] for s in S2)
    electrolyzer_reserve_2_per_hour[t] = sum(r_proc_e_2[e,t] for e in E2)
end

available_HVDC_reserve_1=Dict()
available_HVDC_reserve_2=Dict()


for t in T
    if plg1[t]-HVDC_reserve_row_1[t] <= 0
            available_HVDC_reserve_1[t]=  plg1[t]
        else    
            
            available_HVDC_reserve_1[t]= HVDC_reserve_row_1[t]
    end

    if plg2[t]-HVDC_reserve_row_2[t] <= 0
            available_HVDC_reserve_2[t]=  plg2[t]
        else    
            
            available_HVDC_reserve_2[t]= HVDC_reserve_row_2[t]
    end
end 




function rank_by_hour(pg, gens)
    ranking = Dict{String, Vector{Tuple{String, Float64}}}()
    for t in axes(pg, 2)
        vals = [(g, pg[g, t]) for g in gens]
        sort!(vals, by = x -> x[2], rev = true)   # highest to lowest
        ranking[t] = vals
    end
    return ranking
end

ranking_G1 = rank_by_hour(pg, G1)
ranking_G2 = rank_by_hour(pg, G2)
ranking_WWS1 = rank_by_hour(pg, WWS1)
ranking_WWS2 = rank_by_hour(pg, WWS2)
ranking_renewables_1 = rank_by_hour(pg, union(G_wind_1, G_solar_1))
ranking_renewables_2 = rank_by_hour(pg, union(G_wind_2, G_solar_2))
initial_plg_1 =plg1
initial_plg_2 =plg2

gens  = axes(pg, 1)   
horas = axes(pg, 2) 

gen_fail_1 = Dict(t => first(g for g in G1 if δgvec[g, t] > 0.5) for t in T)
gen_fail_2 = Dict(t => first(g for g in G2 if δgvec[g, t] > 0.5) for t in T)

#Sorts the set of generators by their generation in each hour, from highest to lowest excluding the generator that fails in each hour from the optimization process.
orden_G1 = Dict(t => sort(G1, by = g -> pg[g, t]) for t in horas)
orden_G2 = Dict(t => sort(G2, by = g -> pg[g, t]) for t in horas)
orden_WWS1 = Dict(t => sort(WWS1, by = g -> pg[g, t]) for t in horas)
orden_WWS2 = Dict(t => sort(WWS2, by = g -> pg[g, t]) for t in horas)
orden_renewables_1=Dict(t => sort(union(G_wind_1, G_solar_1), by = g -> pg[g, t]) for t in horas)
orden_renewables_2=Dict(t => sort(union(G_wind_2, G_solar_2), by = g -> pg[g, t]) for t in horas)

# Removes generator that fails
set_gen_fail_G1 = Dict(t => filter(!=(gen_fail_1[t]), orden_G1[t]) for t in T)
set_gen_fail_G2 = Dict(t => filter(!=(gen_fail_2[t]), orden_G2[t]) for t in T)
set_gen_fail_WWS1 = Dict(t => filter(!=(gen_fail_1[t]), orden_WWS1[t]) for t in T)
set_gen_fail_WWS2 = Dict(t => filter(!=(gen_fail_2[t]), orden_WWS2[t]) for t in T)
set_gen_fail_renewables_1 = Dict(t => filter(!=(gen_fail_1[t]), orden_renewables_1[t]) for t in T)
set_gen_fail_renewables_2 = Dict(t => filter(!=(gen_fail_2[t]), orden_renewables_2[t]) for t in T)



#Removes generators that are not producing significant power (less than 1 MW) in the hour of interest
set_gen_fail_G1 = Dict(t => filter(g -> pg[g, t] > 1e-3, set_gen_fail_G1[t]) for t in T)
set_gen_fail_G2 = Dict(t => filter(g -> pg[g, t] > 1e-3, set_gen_fail_G2[t]) for t in T)
set_gen_fail_WWS1 = Dict(t => filter(g -> pg[g, t] > 1e-3, set_gen_fail_WWS1[t]) for t in T)
set_gen_fail_WWS2 = Dict(t => filter(g -> pg[g, t] > 1e-3, set_gen_fail_WWS2[t]) for t in T)
set_gen_fail_renewables_1 = Dict(t => filter(g -> pg[g, t] > 1e-3, set_gen_fail_renewables_1[t]) for t in T)
set_gen_fail_renewables_2 = Dict(t => filter(g -> pg[g, t] > 1e-3, set_gen_fail_renewables_2[t]) for t in T)






total_per_hour = Dict{String, Float64}()





# re=5000*0.5->available_HVDC_reserve_1->available_HVDC_reserve_2
ic_hvdc=2.5
#Initial_inertia = copy(Inertia_nadir_energy)->Inertia_nadir_frequency_1->Inertia_nadir_frequency_2
#rg_ini=copy(sum_reserve_g)->slow_reserve_procured_1_per_hour
#rg_ini= Dict(i => v for (i, v) in enumerate(sum_reserve_g))
#Delta_f_electrolyzer=Dict()
Initial_inertia_1=copy(Inertia_nadir_frequency_1)
Initial_inertia_2=copy(Inertia_nadir_frequency_2)
Delta_f_HVDC_1=Dict()
Delta_f_HVDC_2=Dict()
# rocof_electrolyzer=Dict()
rocof_HVDC_1=Dict()
rocof_HVDC_2=Dict()

# Initial_pl = copy(plvec)
Initial_plg1=copy(plg1vec)
Initial_plg2=copy(plg2vec)
# power_balance_condition=Dict()
power_balance_condition_HVDC_1=Dict()
power_balance_condition_HVDC_2=Dict()
#extra_pl=Dict()
extra_plg1=Dict()
extra_plg2=Dict()
# cumulative_g = Dict()
cumulative_g1=Dict()
cumulative_g2=Dict()

#running_sum_g = 0   # running total
running_sum_g1 = 0   # running total
running_sum_g2 = 0   # running total
# reserve_loss=0 
reserve_loss1=0
reserve_loss2=0

Inertia_vector_1=Dict(k => ic[k] * pmax[k]*baseMVA for k in G1)
Inertia_vector_2=Dict(k => ic[k] * pmax[k]*baseMVA for k in G2)

rg_ini_1 = copy(slow_reserve_procured_1_nadir_per_hour)
rg_ini_2 = copy(slow_reserve_procured_2_nadir_per_hour)



extra_loss_of_power_1_per_hour = Dict()
extra_loss_of_reserve_1_per_hour = Dict()
extra_loss_of_inertia_1_per_hour = Dict()
safe_contingency_1_per_hour = Dict()
last_gen_1_per_hour = Dict()
safe_loss_of_power_1_per_hour = Dict()
safe_loss_of_reserve_1_per_hour = Dict()
safe_loss_of_inertia_1_per_hour = Dict()
safe_Deltaf_1_per_hour = Dict()
safe_rocof_1_per_hour = Dict()
safe_power_balance_1_per_hour = Dict()

extra_loss_of_power_2_per_hour = Dict()
extra_loss_of_reserve_2_per_hour = Dict()
extra_loss_of_inertia_2_per_hour = Dict()
safe_contingency_2_per_hour = Dict()
last_gen_2_per_hour = Dict()
safe_loss_of_power_2_per_hour = Dict()
safe_loss_of_reserve_2_per_hour = Dict()
safe_loss_of_inertia_2_per_hour = Dict()
safe_Deltaf_2_per_hour = Dict()
safe_rocof_2_per_hour = Dict()
safe_power_balance_2_per_hour = Dict()

for j in eachindex(T)

    N_1_loss_of_Inertia_1=sum((δgvec[g,string(j)])*ic[g]*pmax[g]*baseMVA for g in G1)
    N_1_loss_of_reserve_1=sum(r_proc_g_1[g,string(j)]*δgvec[g,string(j)] for g in G1)
    N_1_loss_of_Inertia_2=sum((δgvec[g,string(j)])*ic[g]*pmax[g]*baseMVA for g in G2)
    N_1_loss_of_reserve_2=sum(r_proc_g_2[g,string(j)]*δgvec[g,string(j)] for g in G2)

    # Inertia_loss=N_1_loss_of_Inertia
    Inertia_loss1=N_1_loss_of_Inertia_1
    Inertia_loss2=N_1_loss_of_Inertia_2

    # println("*************")
    # println("Results providing  just FFR ")
    # println("*************")

    # rocof_post_opt_resilience= Dict()
    rocof_post_opt_resilience_1= Dict()
    rocof_post_opt_resilience_2= Dict()

    # println("=============================================")
    # println("AREA 1 (Nordic) - hour ", j)
    # println("=============================================")

    # println("Available HVDC reserve 1: ", available_HVDC_reserve_1[string(j)], " MW")
    # println("Procured Inertia 1 ", Inertia_nadir_frequency_converter_1[string(j)]/1000, " Gws")
    # println("Inertia 1 N-1 contingency: ", Inertia_nadir_frequency_1[string(j)]/1000, " Gws")
    # println("RoCoF 1 N-1 contingency : ", plg1vec[j]*f1/(2*Inertia_nadir_frequency_1[string(j)]), " Hz/s")




    if Initial_plg1[j]<=available_HVDC_reserve_1[string(j)]+fast_reserve_procured_1_per_hour[string(j)]+rg_ini_1[string(j)]*Edeployment["1"]/G_dt["1"]
        Deltaf_HVDC_1 = f1*Initial_plg1[j]^2 / (4*Inertia_nadir_frequency_1[string(j)]*(rg_ini_1[string(j)]/G_dt["1"] + available_HVDC_reserve_1[string(j)]/Edeployment["1"] + fast_reserve_procured_1_per_hour[string(j)]/Edeployment["1"]))
        # println("Delta f N-1 contingency: ", Deltaf_HVDC_1, " Hz")
        # println("condition 1 holds")
        else 
        Deltaf_HVDC_1 = f1/(4*Inertia_nadir_frequency_1[string(j)]) * (
        (Initial_plg1[j] - available_HVDC_reserve_1[string(j)] - fast_reserve_procured_1_per_hour[string(j)])^2 * G_dt["1"] / rg_ini_1[string(j)]+ available_HVDC_reserve_1[string(j)] * Edeployment["1"]+ fast_reserve_procured_1_per_hour[string(j)] * Edeployment["1"] )      
        # println("Delta f N-1 contingency: ", Deltaf_HVDC_1, " Hz")
        # println("condition 2 holds")
    end

    if plg1vec[j] <= fast_reserve_procured_1_per_hour[string(j)] + rg_ini_1[string(j)]*Edeployment["1"]/G_dt["1"]
        Deltaf_no_HVDC_1 = f1*plg1vec[j]^2 / (4*Inertia_nadir_frequency_1[string(j)]*(rg_ini_1[string(j)]/G_dt["1"] + fast_reserve_procured_1_per_hour[string(j)]/Edeployment["1"]))
        # println("Delta f N-1 contingency without HVDC: ", Deltaf_no_HVDC_1, " Hz (condition 1)")
    else
        Deltaf_no_HVDC_1 = f1/(4*Inertia_nadir_frequency_1[string(j)]) * ((plg1vec[j] - fast_reserve_procured_1_per_hour[string(j)])^2 * G_dt["1"] / rg_ini_1[string(j)] + fast_reserve_procured_1_per_hour[string(j)]*Edeployment["1"])
        # println("Delta f N-1 contingency without HVDC: ", Deltaf_no_HVDC_1, " Hz (condition 2)")
    end
    # println("Loss of power N-1: ", plg1vec[j], " MW")
    # println("Loss of Inertia N-1: ", N_1_loss_of_Inertia_1, " Mws")
    # println("---------------")


    #Iteratively disconnect generators until the system exceeds the thresholds of Δf, ROCOF or power balance. The loop will stop when one of these thresholds is exceeded.

    extra_loss_of_power_1=0
    extra_loss_of_reserve_1=0
    extra_loss_of_inertia_1=0
    total_loss_of_reserve_1=0
    total_loss_of_inertia_1= N_1_loss_of_Inertia_1
    total_loss_of_reserve_1= N_1_loss_of_reserve_1
    contador_iter_1=1
    #Last state in which no threshold was exceeded
    safe_loss_of_power_1=0
    safe_loss_of_reserve_1=0
    safe_loss_of_inertia_1=0
    safe_contingency_1=1
    safe_Deltaf_1=Deltaf_HVDC_1
    safe_rocof_1=plg1[string(j)]*f1/(2*Initial_inertia_1[string(j)])
    safe_power_balance_1= - plg1[string(j)] + available_HVDC_reserve_1[string(j)]+fast_reserve_procured_1_per_hour[string(j)]+rg_ini_1[string(j)]
    last_gen_1=nothing
    for i in set_gen_fail_WWS1[string(j)]



            contador_iter_1+=1
            #println("N-", contador_iter_1, " contingency")

            Initial_inertia_1[string(j)]= Initial_inertia_1[string(j)]-zgvec[string(i),string(j)]*ic[string(i)]*pmax[string(i)]*baseMVA
            plg1[string(j)]      = plg1[string(j)] + pg[i,string(j)]
            rg_ini_1[string(j)]          = rg_ini_1[string(j)] - r_proc_g_1[string(i),string(j)]*zgvec[string(i),string(j)]
            extra_loss_of_power_1+= pg[i,string(j)]
            extra_loss_of_reserve_1+= r_proc_g_1[string(i),string(j)]*zgvec[string(i),string(j)]
            extra_loss_of_inertia_1+= zgvec[string(i),string(j)]*ic[string(i)]*pmax[string(i)]*baseMVA
            total_loss_of_inertia_1+= zgvec[string(i),string(j)]*ic[string(i)]*pmax[string(i)]*baseMVA
            total_loss_of_reserve_1+= r_proc_g_1[string(i),string(j)]*zgvec[string(i),string(j)]
            rocof_HVDC_1[string(j)] = plg1[string(j)] * f1 / (2 * Initial_inertia_1[string(j)])  # Hz/s
            power_balance_condition_1 = - plg1[string(j)] + available_HVDC_reserve_1[string(j)]+fast_reserve_procured_1_per_hour[string(j)]+rg_ini_1[string(j)]
            
            # println("Initial PL: ",plg1[string(j)])
            # println("Initial Inertia: ",Initial_inertia_1[string(j)])
            # println("rg ini: ", rg_ini_1[string(j)])
            # println("inertia constant: ",ic[string(i)])
            # println("pmax: ",pmax[string(i)])
            # println("RoCoF 1 N-1 contingency : ", plg1[string(j)]*f1/(2*Initial_inertia_1[string(j)]), " Hz/s")
            
            if  plg1[string(j)] <=available_HVDC_reserve_1[string(j)]+fast_reserve_procured_1_per_hour[string(j)]+rg_ini_1[string(j)]*Edeployment["1"]/G_dt["1"]
        Deltaf_HVDC_1 = f1*plg1[string(j)]^2 / (4*Initial_inertia_1[string(j)]*(rg_ini_1[string(j)]/G_dt["1"] + available_HVDC_reserve_1[string(j)]/Edeployment["1"] + fast_reserve_procured_1_per_hour[string(j)]/Edeployment["1"]))   
            # println("Delta f N-1 contingency: ", Deltaf_HVDC_1, " Hz")
            # println("condition 1 holds")
             else 
            Deltaf_HVDC_1 = f1/(4*Initial_inertia_1[string(j)]) * ((plg1[string(j)] - available_HVDC_reserve_1[string(j)] - fast_reserve_procured_1_per_hour[string(j)])^2 * G_dt["1"] / rg_ini_1[string(j)] + available_HVDC_reserve_1[string(j)]*Edeployment["1"] + fast_reserve_procured_1_per_hour[string(j)]*Edeployment["1"])
            # println("Delta f N-1 contingency: ", Deltaf_HVDC_1, " Hz")
            # println("condition 2 holds")
            # println("*************")
            end

            
            if Deltaf_HVDC_1 > 1|| rocof_HVDC_1[string(j)] > 1 || power_balance_condition_1 < 0
                println("Area 1 - Stopping loop: Δf = ", Deltaf_HVDC_1,
                        ", ROCOF = ", rocof_HVDC_1[string(j)],
                        ", Power Balance = ", power_balance_condition_1,
                        " → Threshold exceeded.")
                break
            end

            safe_loss_of_power_1=extra_loss_of_power_1
            safe_loss_of_reserve_1=extra_loss_of_reserve_1
            safe_loss_of_inertia_1=extra_loss_of_inertia_1
            safe_contingency_1=contador_iter_1
            safe_Deltaf_1=Deltaf_HVDC_1
            safe_rocof_1=rocof_HVDC_1[string(j)]
            safe_power_balance_1=power_balance_condition_1
            last_gen_1=i
    end

    # println("Extra loss of power: ", extra_loss_of_power_1)
    # println("Extra loss of reserve: ", extra_loss_of_reserve_1)
    # println("Extra loss of inertia: ", extra_loss_of_inertia_1)

    # println("Max contingency tolerated: N-", safe_contingency_1, " (last generator disconnected: ", last_gen_1, ")")
    # println("Extra loss of power tolerated: ", safe_loss_of_power_1)
    # println("Extra loss of reserve tolerated: ", safe_loss_of_reserve_1)
    # println("Extra loss of inertia tolerated: ", safe_loss_of_inertia_1)
    # println("Delta f at last tolerated contingency: ", safe_Deltaf_1, " Hz")
    # println("RoCoF at last tolerated contingency: ", safe_rocof_1, " Hz/s")
    # println("Power balance at last tolerated contingency: ", safe_power_balance_1, " MW")

    extra_loss_of_power_1_per_hour[string(j)]    = extra_loss_of_power_1
    extra_loss_of_reserve_1_per_hour[string(j)]  = extra_loss_of_reserve_1
    extra_loss_of_inertia_1_per_hour[string(j)]  = extra_loss_of_inertia_1
    safe_contingency_1_per_hour[string(j)]       = safe_contingency_1
    last_gen_1_per_hour[string(j)]               = last_gen_1
    safe_loss_of_power_1_per_hour[string(j)]     = safe_loss_of_power_1
    safe_loss_of_reserve_1_per_hour[string(j)]   = safe_loss_of_reserve_1
    safe_loss_of_inertia_1_per_hour[string(j)]   = safe_loss_of_inertia_1
    safe_Deltaf_1_per_hour[string(j)]            = safe_Deltaf_1
    safe_rocof_1_per_hour[string(j)]             = safe_rocof_1
    safe_power_balance_1_per_hour[string(j)]     = safe_power_balance_1


    # ============================================================
    # AREA 2 (GB)
    # ============================================================

    # println("=============================================")
    # println("AREA 2 (GB) - hour ", j)
    # println("=============================================")

    # println("Available HVDC reserve 2: ", available_HVDC_reserve_2[string(j)], " MW")
    # println("Inertia 2 N-1 contingency: ", Inertia_nadir_frequency_2[string(j)]/1000, " Gws")
    # println("Procured Inertia 2 ", Inertia_nadir_frequency_converter_2[string(j)]/1000, " Gws")
    # println("RoCoF 2 N-1 contingency : ", plg2vec[j]*f2/(2*Inertia_nadir_frequency_2[string(j)]), " Hz/s")



    if Initial_plg2[j]<=available_HVDC_reserve_2[string(j)]+fast_reserve_procured_2_per_hour[string(j)]+rg_ini_2[string(j)]*Edeployment["1"]/G_dt["1"]
        Deltaf_HVDC_2 = f2*Initial_plg2[j]^2 / (4*Inertia_nadir_frequency_2[string(j)]*(rg_ini_2[string(j)]/G_dt["1"] + available_HVDC_reserve_2[string(j)]/Edeployment["1"] + fast_reserve_procured_2_per_hour[string(j)]/Edeployment["1"]))
        # println("Area 2 - Delta f N-1 contingency: ", Deltaf_HVDC_2, " Hz")
        # println("Area 2 - condition 1 holds")
        else
        Deltaf_HVDC_2 = f2/(4*Inertia_nadir_frequency_2[string(j)]) * (
        (Initial_plg2[j] - available_HVDC_reserve_2[string(j)] - fast_reserve_procured_2_per_hour[string(j)])^2 * G_dt["1"] / rg_ini_2[string(j)]+ available_HVDC_reserve_2[string(j)] * Edeployment["1"]+ fast_reserve_procured_2_per_hour[string(j)] * Edeployment["1"] )
        # println("Area 2 - Delta f N-1 contingency: ", Deltaf_HVDC_2, " Hz")
        # println("Area 2 - condition 2 holds")
    end

    if plg2vec[j] <= fast_reserve_procured_2_per_hour[string(j)] + rg_ini_2[string(j)]*Edeployment["1"]/G_dt["1"]
        Deltaf_no_HVDC_2 = f2*plg2vec[j]^2 / (4*Inertia_nadir_frequency_2[string(j)]*(rg_ini_2[string(j)]/G_dt["1"] + fast_reserve_procured_2_per_hour[string(j)]/Edeployment["1"]))
        # println("Area 2 - Delta f N-1 contingency without HVDC: ", Deltaf_no_HVDC_2, " Hz (condition 1)")
    else
        Deltaf_no_HVDC_2 = f2/(4*Inertia_nadir_frequency_2[string(j)]) * ((plg2vec[j] - fast_reserve_procured_2_per_hour[string(j)])^2 * G_dt["1"] / rg_ini_2[string(j)] + fast_reserve_procured_2_per_hour[string(j)]*Edeployment["1"])
       # println("Area 2 - Delta f N-1 contingency without HVDC: ", Deltaf_no_HVDC_2, " Hz (condition 2)")
    end
    # println("Area 2 - Loss of power N-1: ", plg2vec[j], " MW")
    # println("Area 2 - Loss of Inertia N-1: ", N_1_loss_of_Inertia_2, " Mws")
    # println("---------------")


    #Iteratively disconnect generators until the system exceeds the thresholds of Δf, ROCOF or power balance. The loop will stop when one of these thresholds is exceeded.

    extra_loss_of_power_2=0
    extra_loss_of_reserve_2=0
    extra_loss_of_inertia_2=0
    total_loss_of_inertia_2= N_1_loss_of_Inertia_2
    total_loss_of_reserve_2= N_1_loss_of_reserve_2
    contador_iter_2=1
    #Last state in which no threshold was exceeded
    safe_loss_of_power_2=0
    safe_loss_of_reserve_2=0
    safe_loss_of_inertia_2=0
    safe_contingency_2=1
    safe_Deltaf_2=Deltaf_HVDC_2
    safe_rocof_2=plg2[string(j)]*f2/(2*Initial_inertia_2[string(j)])
    safe_power_balance_2= - plg2[string(j)] + available_HVDC_reserve_2[string(j)]+fast_reserve_procured_2_per_hour[string(j)]+rg_ini_2[string(j)]
    last_gen_2=nothing
    for i in set_gen_fail_WWS2[string(j)]

            contador_iter_2+=1
            # println("Area 2 - N-", contador_iter_2, " contingency")

            Initial_inertia_2[string(j)]= Initial_inertia_2[string(j)]-zgvec[string(i),string(j)]*ic[string(i)]*pmax[string(i)]*baseMVA
            plg2[string(j)]      = plg2[string(j)] + pg[i,string(j)]
            rg_ini_2[string(j)]          = rg_ini_2[string(j)] - r_proc_g_2[string(i),string(j)]*zgvec[string(i),string(j)]
            extra_loss_of_power_2+= pg[i,string(j)]
            extra_loss_of_reserve_2+= r_proc_g_2[string(i),string(j)]*zgvec[string(i),string(j)]
            extra_loss_of_inertia_2+= zgvec[string(i),string(j)]*ic[string(i)]*pmax[string(i)]*baseMVA
            total_loss_of_inertia_2+= zgvec[string(i),string(j)]*ic[string(i)]*pmax[string(i)]*baseMVA
            total_loss_of_reserve_2+= r_proc_g_2[string(i),string(j)]*zgvec[string(i),string(j)]
            rocof_HVDC_2[string(j)] = plg2[string(j)] * f2 / (2 * Initial_inertia_2[string(j)])  # Hz/s
            power_balance_condition_2 = - plg2[string(j)] + available_HVDC_reserve_2[string(j)]+fast_reserve_procured_2_per_hour[string(j)]+rg_ini_2[string(j)]

            if  plg2[string(j)] <=available_HVDC_reserve_2[string(j)]+fast_reserve_procured_2_per_hour[string(j)]+rg_ini_2[string(j)]*Edeployment["1"]/G_dt["1"]
            Deltaf_HVDC_2 = f2*plg2[string(j)]^2 / (4*Initial_inertia_2[string(j)]*(rg_ini_2[string(j)]/G_dt["1"] + available_HVDC_reserve_2[string(j)]/Edeployment["1"] + fast_reserve_procured_2_per_hour[string(j)]/Edeployment["1"]))
            # println("Area 2 - Delta f N-", contador_iter_2, " contingency: ", Deltaf_HVDC_2, " Hz")
            # println("Area 2 - condition 1 holds")
            else
            Deltaf_HVDC_2 = f2/(4*Initial_inertia_2[string(j)]) * ((plg2[string(j)] - available_HVDC_reserve_2[string(j)] - fast_reserve_procured_2_per_hour[string(j)])^2 * G_dt["1"] / rg_ini_2[string(j)] + available_HVDC_reserve_2[string(j)]*Edeployment["1"] + fast_reserve_procured_2_per_hour[string(j)]*Edeployment["1"])
            # println("Area 2 - Delta f N-", contador_iter_2, " contingency: ", Deltaf_HVDC_2, " Hz")
            # println("Area 2 - condition 2 holds")
            # println("*************")
            end

            if Deltaf_HVDC_2 > 1|| rocof_HVDC_2[string(j)] > 1 || power_balance_condition_2 < 0
                println("Area 2 - Stopping loop: Δf = ", Deltaf_HVDC_2,
                        ", ROCOF = ", rocof_HVDC_2[string(j)],
                        ", Power Balance = ", power_balance_condition_2,
                        " → Threshold exceeded.")
                break
            end

            safe_loss_of_power_2=extra_loss_of_power_2
            safe_loss_of_reserve_2=extra_loss_of_reserve_2
            safe_loss_of_inertia_2=extra_loss_of_inertia_2
            safe_contingency_2=contador_iter_2
            safe_Deltaf_2=Deltaf_HVDC_2
            safe_rocof_2=rocof_HVDC_2[string(j)]
            safe_power_balance_2=power_balance_condition_2
            last_gen_2=i
    end

    # println("Area 2 - Extra loss of power: ", extra_loss_of_power_2)
    # println("Area 2 - Extra loss of reserve: ", extra_loss_of_reserve_2)
    # println("Area 2 - Extra loss of inertia: ", extra_loss_of_inertia_2)

    # println("Area 2 - Max contingency tolerated: N-", safe_contingency_2, " (last generator disconnected: ", last_gen_2, ")")
    # println("Area 2 - Extra loss of power tolerated: ", safe_loss_of_power_2)
    # println("Area 2 - Extra loss of reserve tolerated: ", safe_loss_of_reserve_2)
    # println("Area 2 - Extra loss of inertia tolerated: ", safe_loss_of_inertia_2)
    # println("Area 2 - Delta f at last tolerated contingency: ", safe_Deltaf_2, " Hz")
    # println("Area 2 - RoCoF at last tolerated contingency: ", safe_rocof_2, " Hz/s")
    # println("Area 2 - Power balance at last tolerated contingency: ", safe_power_balance_2, " MW")

    extra_loss_of_power_2_per_hour[string(j)]    = extra_loss_of_power_2
    extra_loss_of_reserve_2_per_hour[string(j)]  = extra_loss_of_reserve_2
    extra_loss_of_inertia_2_per_hour[string(j)]  = extra_loss_of_inertia_2
    safe_contingency_2_per_hour[string(j)]       = safe_contingency_2
    last_gen_2_per_hour[string(j)]               = last_gen_2
    safe_loss_of_power_2_per_hour[string(j)]     = safe_loss_of_power_2
    safe_loss_of_reserve_2_per_hour[string(j)]   = safe_loss_of_reserve_2
    safe_loss_of_inertia_2_per_hour[string(j)]   = safe_loss_of_inertia_2
    safe_Deltaf_2_per_hour[string(j)]            = safe_Deltaf_2
    safe_rocof_2_per_hour[string(j)]             = safe_rocof_2
    safe_power_balance_2_per_hour[string(j)]     = safe_power_balance_2


    end  


# ============================================================
# RESULTS
# ============================================================

total_power_loss_withstandable_1 = Dict(t => Initial_plg1[parse(Int,t)] + v for (t, v) in safe_loss_of_power_1_per_hour)
total_power_loss_withstandable_2 = Dict(t => Initial_plg2[parse(Int,t)] + v for (t, v) in safe_loss_of_power_2_per_hour)

# ============================================================
# ORDERED VECTORS (hour 1 -> last hour in T)
# ============================================================

total_power_loss_withstandable_1_vec = [get(total_power_loss_withstandable_1, string(t), 0.0) for t in T]
total_power_loss_withstandable_2_vec = [get(total_power_loss_withstandable_2, string(t), 0.0) for t in T]
safe_loss_of_inertia_1_vec = [get(safe_loss_of_inertia_1_per_hour, string(t), 0.0) for t in T]
safe_loss_of_inertia_2_vec = [get(safe_loss_of_inertia_2_per_hour, string(t), 0.0) for t in T]

# ============================================================
# PLOTS (one figure per variable, saved next to this file)
# ============================================================

fig_total_power_1 = Figure()
ax_total_power_1 = fig_total_power_1[1, 1] = Axis(fig_total_power_1,
    title  = "Total withstandable power loss - Area 1 (Nordic)",
    xlabel = "Time (hours)",
    ylabel = "Power (MW)"
)
lines!(ax_total_power_1, total_power_loss_withstandable_1_vec, label = "Total withstandable power loss Area 1")
fig_total_power_1[1, 2] = Legend(fig_total_power_1, ax_total_power_1, "Total withstandable power loss", framevisible = false)
save(joinpath(@__DIR__, "total_power_loss_withstandable_1.png"), fig_total_power_1)

fig_total_power_2 = Figure()
ax_total_power_2 = fig_total_power_2[1, 1] = Axis(fig_total_power_2,
    title  = "Total withstandable power loss - Area 2 (GB)",
    xlabel = "Time (hours)",
    ylabel = "Power (MW)"
)
lines!(ax_total_power_2, total_power_loss_withstandable_2_vec, label = "Total withstandable power loss Area 2")
fig_total_power_2[1, 2] = Legend(fig_total_power_2, ax_total_power_2, "Total withstandable power loss", framevisible = false)
save(joinpath(@__DIR__, "total_power_loss_withstandable_2.png"), fig_total_power_2)

# ============================================================
# RESERVE BY SOURCE: HVDC, generators, electrolyzers, storage
# ============================================================

reserve_hvdc_1_vec         = [get(available_HVDC_reserve_1, string(t), 0.0) for t in T]
reserve_generators_1_vec   = [get(slow_reserve_procured_1_per_hour, string(t), 0.0) for t in T]
reserve_electrolyzers_1_vec= [get(electrolyzer_reserve_1_per_hour, string(t), 0.0) for t in T]
reserve_storage_1_vec      = [get(storage_reserve_1_per_hour, string(t), 0.0) for t in T]

reserve_hvdc_2_vec         = [get(available_HVDC_reserve_2, string(t), 0.0) for t in T]
reserve_generators_2_vec   = [get(slow_reserve_procured_2_per_hour, string(t), 0.0) for t in T]
reserve_electrolyzers_2_vec= [get(electrolyzer_reserve_2_per_hour, string(t), 0.0) for t in T]
reserve_storage_2_vec      = [get(storage_reserve_2_per_hour, string(t), 0.0) for t in T]

fig_reserve_1 = Figure()
ax_reserve_1 = fig_reserve_1[1, 1] = Axis(fig_reserve_1,
    title  = "Available reserve by source - Area 1 (Nordic)",
    xlabel = "Time (hours)",
    ylabel = "Reserve (MW)"
)
lines!(ax_reserve_1, reserve_hvdc_1_vec, label = "HVDC")
lines!(ax_reserve_1, reserve_generators_1_vec, label = "Generators")
lines!(ax_reserve_1, reserve_electrolyzers_1_vec, label = "Electrolyzers")
lines!(ax_reserve_1, reserve_storage_1_vec, label = "Storage")
fig_reserve_1[1, 2] = Legend(fig_reserve_1, ax_reserve_1, "Reserve by source", framevisible = false)
save(joinpath(@__DIR__, "reserve_by_source_area1.png"), fig_reserve_1)

fig_reserve_2 = Figure()
ax_reserve_2 = fig_reserve_2[1, 1] = Axis(fig_reserve_2,
    title  = "Available reserve by source - Area 2 (GB)",
    xlabel = "Time (hours)",
    ylabel = "Reserve (MW)"
)
lines!(ax_reserve_2, reserve_hvdc_2_vec, label = "HVDC")
lines!(ax_reserve_2, reserve_generators_2_vec, label = "Generators")
lines!(ax_reserve_2, reserve_electrolyzers_2_vec, label = "Electrolyzers")
lines!(ax_reserve_2, reserve_storage_2_vec, label = "Storage")
fig_reserve_2[1, 2] = Legend(fig_reserve_2, ax_reserve_2, "Reserve by source", framevisible = false)
save(joinpath(@__DIR__, "reserve_by_source_area2.png"), fig_reserve_2)

fig_safe_inertia_1 = Figure()
ax_safe_inertia_1 = fig_safe_inertia_1[1, 1] = Axis(fig_safe_inertia_1,
    title  = "Safe tolerable extra loss of inertia - Area 1 (Nordic)",
    xlabel = "Time (hours)",
    ylabel = "Inertia (MW*s)"
)
lines!(ax_safe_inertia_1, safe_loss_of_inertia_1_vec, label = "Safe loss of inertia Area 1")
fig_safe_inertia_1[1, 2] = Legend(fig_safe_inertia_1, ax_safe_inertia_1, "Safe loss of inertia", framevisible = false)
save(joinpath(@__DIR__, "safe_loss_of_inertia_1.png"), fig_safe_inertia_1)

fig_safe_inertia_2 = Figure()
ax_safe_inertia_2 = fig_safe_inertia_2[1, 1] = Axis(fig_safe_inertia_2,
    title  = "Safe tolerable extra loss of inertia - Area 2 (GB)",
    xlabel = "Time (hours)",
    ylabel = "Inertia (MW*s)"
)
lines!(ax_safe_inertia_2, safe_loss_of_inertia_2_vec, label = "Safe loss of inertia Area 2")
fig_safe_inertia_2[1, 2] = Legend(fig_safe_inertia_2, ax_safe_inertia_2, "Safe loss of inertia", framevisible = false)
save(joinpath(@__DIR__, "safe_loss_of_inertia_2.png"), fig_safe_inertia_2)

# ============================================================
# TXT FILE WITH THE DATA OF EACH PLOT (saved next to this file)
# ============================================================

open(joinpath(@__DIR__, "safe_loss_plots_data.txt"), "w") do io

    println(io, "===== Total withstandable power loss - Area 1 (Nordic) =====")
    println(io, rpad("hour", 8), "total_power_loss_withstandable_1 [MW]")
    for (idx, t) in enumerate(T)
        println(io, rpad(t, 8), total_power_loss_withstandable_1_vec[idx])
    end
    println(io)

    println(io, "===== Total withstandable power loss - Area 2 (GB) =====")
    println(io, rpad("hour", 8), "total_power_loss_withstandable_2 [MW]")
    for (idx, t) in enumerate(T)
        println(io, rpad(t, 8), total_power_loss_withstandable_2_vec[idx])
    end
    println(io)

    println(io, "===== Available reserve by source - Area 1 (Nordic) =====")
    println(io, rpad("hour", 8), rpad("HVDC [MW]", 16), rpad("Generators [MW]", 16), rpad("Electrolyzers [MW]", 18), "Storage [MW]")
    for (idx, t) in enumerate(T)
        println(io, rpad(t, 8), rpad(reserve_hvdc_1_vec[idx], 16), rpad(reserve_generators_1_vec[idx], 16), rpad(reserve_electrolyzers_1_vec[idx], 18), reserve_storage_1_vec[idx])
    end
    println(io)

    println(io, "===== Available reserve by source - Area 2 (GB) =====")
    println(io, rpad("hour", 8), rpad("HVDC [MW]", 16), rpad("Generators [MW]", 16), rpad("Electrolyzers [MW]", 18), "Storage [MW]")
    for (idx, t) in enumerate(T)
        println(io, rpad(t, 8), rpad(reserve_hvdc_2_vec[idx], 16), rpad(reserve_generators_2_vec[idx], 16), rpad(reserve_electrolyzers_2_vec[idx], 18), reserve_storage_2_vec[idx])
    end
    println(io)

    println(io, "===== Safe tolerable extra loss of inertia - Area 1 (Nordic) =====")
    println(io, rpad("hour", 8), "safe_loss_of_inertia_1 [MW*s]")
    for (idx, t) in enumerate(T)
        println(io, rpad(t, 8), safe_loss_of_inertia_1_vec[idx])
    end
    println(io)

    println(io, "===== Safe tolerable extra loss of inertia - Area 2 (GB) =====")
    println(io, rpad("hour", 8), "safe_loss_of_inertia_2 [MW*s]")
    for (idx, t) in enumerate(T)
        println(io, rpad(t, 8), safe_loss_of_inertia_2_vec[idx])
    end

end

println("Safe loss plots and data saved next to res.jl")

return (
    total_power_loss_withstandable_1_vec = total_power_loss_withstandable_1_vec,
    total_power_loss_withstandable_2_vec = total_power_loss_withstandable_2_vec,
    safe_loss_of_inertia_1_vec = safe_loss_of_inertia_1_vec,
    safe_loss_of_inertia_2_vec = safe_loss_of_inertia_2_vec,
    reserve_hvdc_1_vec = reserve_hvdc_1_vec,
    reserve_generators_1_vec = reserve_generators_1_vec,
    reserve_electrolyzers_1_vec = reserve_electrolyzers_1_vec,
    reserve_storage_1_vec = reserve_storage_1_vec,
    reserve_hvdc_2_vec = reserve_hvdc_2_vec,
    reserve_generators_2_vec = reserve_generators_2_vec,
    reserve_electrolyzers_2_vec = reserve_electrolyzers_2_vec,
    reserve_storage_2_vec = reserve_storage_2_vec,
    Initial_plg1 = Initial_plg1,
    Initial_plg2 = Initial_plg2,
    total_power_loss_withstandable_1 = total_power_loss_withstandable_1,
    total_power_loss_withstandable_2 = total_power_loss_withstandable_2,
    available_HVDC_reserve_1 = available_HVDC_reserve_1,
    available_HVDC_reserve_2 = available_HVDC_reserve_2,
    fast_reserve_procured_1_per_hour = fast_reserve_procured_1_per_hour,
    fast_reserve_procured_2_per_hour = fast_reserve_procured_2_per_hour,
    slow_reserve_procured_1_per_hour = slow_reserve_procured_1_per_hour,
    slow_reserve_procured_2_per_hour = slow_reserve_procured_2_per_hour,
    gen_fail_1 = gen_fail_1,
    gen_fail_2 = gen_fail_2,
    extra_loss_of_power_1_per_hour = extra_loss_of_power_1_per_hour,
    extra_loss_of_reserve_1_per_hour = extra_loss_of_reserve_1_per_hour,
    extra_loss_of_inertia_1_per_hour = extra_loss_of_inertia_1_per_hour,
    safe_contingency_1_per_hour = safe_contingency_1_per_hour,
    last_gen_1_per_hour = last_gen_1_per_hour,
    safe_loss_of_power_1_per_hour = safe_loss_of_power_1_per_hour,
    safe_loss_of_reserve_1_per_hour = safe_loss_of_reserve_1_per_hour,
    safe_loss_of_inertia_1_per_hour = safe_loss_of_inertia_1_per_hour,
    safe_Deltaf_1_per_hour = safe_Deltaf_1_per_hour,
    safe_rocof_1_per_hour = safe_rocof_1_per_hour,
    safe_power_balance_1_per_hour = safe_power_balance_1_per_hour,
    extra_loss_of_power_2_per_hour = extra_loss_of_power_2_per_hour,
    extra_loss_of_reserve_2_per_hour = extra_loss_of_reserve_2_per_hour,
    extra_loss_of_inertia_2_per_hour = extra_loss_of_inertia_2_per_hour,
    safe_contingency_2_per_hour = safe_contingency_2_per_hour,
    last_gen_2_per_hour = last_gen_2_per_hour,
    safe_loss_of_power_2_per_hour = safe_loss_of_power_2_per_hour,
    safe_loss_of_reserve_2_per_hour = safe_loss_of_reserve_2_per_hour,
    safe_loss_of_inertia_2_per_hour = safe_loss_of_inertia_2_per_hour,
    safe_Deltaf_2_per_hour = safe_Deltaf_2_per_hour,
    safe_rocof_2_per_hour = safe_rocof_2_per_hour,
    safe_power_balance_2_per_hour = safe_power_balance_2_per_hour,
)

end


resilience_results.extra_loss_of_power_1_per_hour["18"]

resilience_results.safe_loss_of_power_1_per_hour["18"]