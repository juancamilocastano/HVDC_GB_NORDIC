function printparameters_frequency_sev_var_res_provi!(m::Model)
G=m.ext[:sets][:G]
G1=m.ext[:sets][:G1]
G2=m.ext[:sets][:G2]
E=m.ext[:sets][:E]
E1=m.ext[:sets][:E1]
E2=m.ext[:sets][:E2]
S=m.ext[:sets][:S]
S1=m.ext[:sets][:S1]
S2=m.ext[:sets][:S2]
CV=m.ext[:sets][:CV]
CV1=m.ext[:sets][:CV1]
CV2=m.ext[:sets][:CV2]
T=m.ext[:sets][:t]
N1=m.ext[:sets][:N1]
N2=m.ext[:sets][:N2]

baseKG=m.ext[:parameters][:baseKG]
baseMVA=m.ext[:parameters][:baseMVA]
pmax = m.ext[:parameters][:pmax]
ic = m.ext[:parameters][:ic]
f1 = m.ext[:parameters][:f1]
f2 = m.ext[:parameters][:f2]
Edeployment = m.ext[:parameters][:Edeployment]
G_dt = m.ext[:parameters][:G_dt]

Ereservecost = m.ext[:parameters][:Ereservecost]
G_reservecost = m.ext[:parameters][:G_reservecost]
Sreservecost = m.ext[:parameters][:Sreservecost]
Hydrogencost = m.ext[:parameters][:Hydrogencost]
gen_cost = m.ext[:parameters][:gen_cost]
Estartupcost = m.ext[:parameters][:Estartupcost]
start_up_cost=m.ext[:parameters][:startup_cost]


conv_p_ac=JuMP.value.(m.ext[:variables][:conv_p_ac])*baseMVA
zgvec=JuMP.value.(m.ext[:variables][:zg])
δgvec=JuMP.value.(m.ext[:variables][:δg])
δhvdc=JuMP.value.(m.ext[:variables][:δhvdc])
u_conv_p_ac=JuMP.value.(m.ext[:variables][:u_conv_p_ac])



demand = m.ext[:parameters][:demand]
#wind = m.ext[:parameters][:wind]
baseKG=m.ext[:parameters][:baseKG]
baseMVA=m.ext[:parameters][:baseMVA]
pg=JuMP.value.(m.ext[:variables][:pg])*baseMVA
pgvec= [pg[g,t] for g in G, t in T]
pev=JuMP.value.(m.ext[:variables][:pe])*baseMVA
pevec= [pev[e,t] for e in E, t in T]
hfe=JuMP.value.(m.ext[:variables][:hfe])*baseKG
hfevec= [hfe[e,t] for e in E, t in T]
hss=JuMP.value.(m.ext[:variables][:hss])*baseKG
hssvec= [hss[e,t] for e in E, t in T]
hfgconsum=JuMP.value.(m.ext[:variables][:hfgconsum])*baseKG
hfgconsumvec= [hfgconsum[e,t] for e in E, t in T]
hfginyect=JuMP.value.(m.ext[:variables][:hfginyect])*baseKG
hfginyectvec= [hfginyect[e,t] for e in E, t in T]
psc=JuMP.value.(m.ext[:variables][:psc])*baseMVA
pscvec= [psc[s,t] for s in S, t in T]
psd=JuMP.value.(m.ext[:variables][:psd])*baseMVA
psdvec= [psd[s,t] for s in S, t in T]
pe_compressor=JuMP.value.(m.ext[:variables][:pe_compressor])*baseMVA
pevec_compressor= [pe_compressor[e,t] for e in E, t in T]
es=JuMP.value.(m.ext[:variables][:es])*baseMVA
esvec= [es[s,t] for s in S, t in T]
pg=JuMP.value.(m.ext[:variables][:pg])*baseMVA
pg1= [pg[g,t] for g in G1, t in T]
pg2= [pg[g,t] for g in G2, t in T]
plg1= JuMP.value.(m.ext[:variables][:plg1])*baseMVA
plg2= JuMP.value.(m.ext[:variables][:plg2])*baseMVA
plc1= JuMP.value.(m.ext[:variables][:plc1])*baseMVA
plc2= JuMP.value.(m.ext[:variables][:plc2])*baseMVA
plreserve_1= JuMP.value.(m.ext[:variables][:plreserve_1])*baseMVA
plreserve_2= JuMP.value.(m.ext[:variables][:plreserve_2])*baseMVA
plg1vec= Array(plg1)
plg2vec= Array(plg2)
plc1vec= Array(plc1)    
plc2vec= Array(plc2)
plreserve_1vec= Array(plreserve_1)
plreserve_2vec= Array(plreserve_2)
rg_lg1=JuMP.value.(m.ext[:variables][:rg_lg1])*baseMVA
rg_lc1=JuMP.value.(m.ext[:variables][:rg_lc1])*baseMVA
rg_l_reserve_1=JuMP.value.(m.ext[:variables][:rg_l_reserve_1])*baseMVA

re_lg1=JuMP.value.(m.ext[:variables][:re_lg1])*baseMVA
re_lc1=JuMP.value.(m.ext[:variables][:re_lc1])*baseMVA
re_l_reserve_1=JuMP.value.(m.ext[:variables][:re_l_reserve_1])*baseMVA

rs_lg1=JuMP.value.(m.ext[:variables][:rs_lg1])*baseMVA
rs_lc1=JuMP.value.(m.ext[:variables][:rs_lc1])*baseMVA
rs_l_reserve_1=JuMP.value.(m.ext[:variables][:rs_l_reserve_1])*baseMVA

rhvdc_lg1=JuMP.value.(m.ext[:variables][:rhvdc_lg1])*baseMVA
rhvdc_lc1=JuMP.value.(m.ext[:variables][:rhvdc_lc1])*baseMVA

rg_lg2=JuMP.value.(m.ext[:variables][:rg_lg2])*baseMVA
rg_lc2=JuMP.value.(m.ext[:variables][:rg_lc2])*baseMVA
rg_l_reserve_2=JuMP.value.(m.ext[:variables][:rg_l_reserve_2])*baseMVA

re_lg2=JuMP.value.(m.ext[:variables][:re_lg2])*baseMVA
re_lc2=JuMP.value.(m.ext[:variables][:re_lc2])*baseMVA
re_l_reserve_2=JuMP.value.(m.ext[:variables][:re_l_reserve_2])*baseMVA

rs_lg2=JuMP.value.(m.ext[:variables][:rs_lg2])*baseMVA
rs_lc2=JuMP.value.(m.ext[:variables][:rs_lc2])*baseMVA
rs_l_reserve_2=JuMP.value.(m.ext[:variables][:rs_l_reserve_2])*baseMVA

rhvdc_lg2=JuMP.value.(m.ext[:variables][:rhvdc_lg2])*baseMVA
rhvdc_lc2=JuMP.value.(m.ext[:variables][:rhvdc_lc2])*baseMVA
rg_lg1vec= [rg_lg1[g,t] for g in G1, t in T]
rg_lc1vec= [rg_lc1[g,t] for g in G1, t in T]
rg_l_reserve_1vec= [rg_l_reserve_1[g,t] for g in G1, t in T]

re_lg1vec= [re_lg1[e,t] for e in E1, t in T]
re_lc1vec= [re_lc1[e,t] for e in E1, t in T]
re_l_reserve_1vec= [re_l_reserve_1[e,t] for e in E1, t in T]

rs_lg1vec= [rs_lg1[s,t] for s in S1, t in T]
rs_lc1vec= [rs_lc1[s,t] for s in S1, t in T]
rs_l_reserve_1vec= [rs_l_reserve_1[s,t] for s in S1, t in T]

rhvdc_lg1vec= [rhvdc_lg1[cv,t] for cv in CV1, t in T]
rhvdc_lc1vec= [rhvdc_lc1[cv,t] for cv in CV1, t in T]
rg_lg2vec= [rg_lg2[g,t] for g in G2, t in T]
rg_lc2vec= [rg_lc2[g,t] for g in G2, t in T]
rg_l_reserve_2vec= [rg_l_reserve_2[g,t] for g in G2, t in T]


re_lg2vec= [re_lg2[e,t] for e in E2, t in T]
re_lc2vec= [re_lc2[e,t] for e in E2, t in T]
re_l_reserve_2vec= [re_l_reserve_2[e,t] for e in E2, t in T]

rs_lg2vec= [rs_lg2[s,t] for s in S2, t in T]
rs_lc2vec= [rs_lc2[s,t] for s in S2, t in T]
rs_l_reserve_2vec= [rs_l_reserve_2[s,t] for s in S2, t in T]

keys_1 = axes(rhvdc_lg1, 1)
order_keys_1 = sort(keys_1, by = x -> parse(Int, x))
keys_2 = axes(rhvdc_lg2, 1)
order_keys_2 = sort(keys_2, by = x -> parse(Int, x))
rhvdc_lg1vec= Array(rhvdc_lg1[order_keys_1, :])
rhvdc_lc1vec= Array(rhvdc_lc1[order_keys_1, :])
rhvdc_lg2vec= Array(rhvdc_lg2[order_keys_2, :])
rhvdc_lc2vec= Array(rhvdc_lc2[order_keys_2, :])




flows_hvdc=JuMP.value.(m.ext[:variables][:brdc_p])*baseMVA
flows_hvdc12= Array(flows_hvdc[("1", "1", "2"),:])
#flows_hvdc31= Array(flows_hvdc[("2", "3", "1"),:])
conv_p_ac=JuMP.value.(m.ext[:variables][:conv_p_ac])*baseMVA
keys_conv = axes(conv_p_ac, 1)
order_keys_conv = sort(keys_conv, by = x -> parse(Int, x))
conv_p_ac_vec= Array(conv_p_ac[order_keys_conv, :])
conv_p_dc=JuMP.value.(m.ext[:variables][:conv_p_dc])*baseMVA
δhvdc=JuMP.value.(m.ext[:variables][:δhvdc])
demandmatrix1= [demand[n][t] for n in N1, t in T]
demandwithoutEB1=vec(sum(demandmatrix1, dims=1))*baseMVA
demandmatrix2= [demand[n][t] for n in N2, t in T]
demandwithoutEB2=vec(sum(demandmatrix2, dims=1))*baseMVA
# wind1= [wind[n][t] for n in N1, t in T]
# wind1vec=vec(sum(wind1, dims=1))*baseMVA
# wind2= [wind[n][t] for n in N2, t in T]
# wind2vec=vec(sum(wind2, dims=1))*baseMVA
# pb=JuMP.value.(m.ext[:variables][:pb])*baseMVA
# pb_13= Array(pb[("2", "1", "3"),:])
# pb_23= Array(pb[("3", "2", "3"),:])
# pb_12= Array(pb[("1", "1", "2"),:])
# pb_56= Array(pb[("6", "5", "6"),:])
# pb_45= Array(pb[("4", "4", "5"),:])
# pb_46= Array(pb[("5", "4", "6"),:])


betag=JuMP.value.(m.ext[:variables][:betag]) #start up variables of generators
zesu=JuMP.value.(m.ext[:variables][:zesu]) #start up variables of electrolyzers


rocof_plg1=Dict()
rocof_plg2=Dict()
rocof_plc1=Dict()
rocof_plc2=Dict()
rocof_plreserve_1=Dict()
rocof_plreserve_2=Dict()
Inertia_nadir_frequency_1=Dict()
Inertia_nadir_frequency_2=Dict()
Inertia_nadir_frequency_converter_1=Dict()
Inertia_nadir_frequency_converter_2=Dict()
Inertia_nadir_frequency_reserve_1=Dict()
Inertia_nadir_frequency_reserve_2=Dict()
procured_inertia_1=Dict()
procured_inertia_2=Dict()
Deltaf_nadir_plg1=Dict()
Deltaf_nadir_plg2=Dict()
Deltaf_nadir_plc1=Dict()
Deltaf_nadir_plc2=Dict()
Deltaf_nadir_plreserve_1=Dict()
Deltaf_nadir_plreserve_2=Dict()
total_rg_lg1=Dict()
total_rg_lc1=Dict()
total_rg_l_reserve_1=Dict()
total_re_lg1=Dict()
total_re_lc1=Dict()
total_re_l_reserve_1=Dict()
total_rs_lg1=Dict()
total_rs_lc1=Dict()
total_rs_l_reserve_1=Dict()
total_rhvdc_lg1=Dict()
total_rhvdc_lc1=Dict()
total_rg_lg2=Dict()
total_rg_lc2=Dict()
total_rg_l_reserve_2=Dict()
total_re_lg2=Dict()
total_re_lc2=Dict()
total_re_l_reserve_2=Dict()
total_rs_lg2=Dict()
total_rs_lc2=Dict()
total_rs_l_reserve_2=Dict()
total_rhvdc_lg2=Dict()
total_rhvdc_lc2=Dict()
total_fast_reserve_lg1=Dict()
total_fast_reserve_lg2=Dict()
total_fast_reserve_1=Dict()
total_fast_reserve_lc1=Dict()
total_fast_reserve_lc2=Dict()
total_fast_reserve_2=Dict()



t_nadir_plg1=Dict()
t_nadir_plg2=Dict()
t_nadir_plc1=Dict()
t_nadir_plc2=Dict()





for t in T 
        Inertia_nadir_frequency_1[t]=sum((zgvec[g,t]-δgvec[g,t])*ic[g]*pmax[g]*baseMVA for g in G1)
        Inertia_nadir_frequency_2[t]=sum((zgvec[g,t]-δgvec[g,t])*ic[g]*pmax[g]*baseMVA for g in G2)
        Inertia_nadir_frequency_converter_1[t]=sum((zgvec[g,t])*ic[g]*pmax[g]*baseMVA for g in G1)
        Inertia_nadir_frequency_converter_2[t]=sum((zgvec[g,t])*ic[g]*pmax[g]*baseMVA for g in G2)
        Inertia_nadir_frequency_reserve_1[t]=Inertia_nadir_frequency_converter_1[t]
        Inertia_nadir_frequency_reserve_2[t]=Inertia_nadir_frequency_converter_2[t]
        procured_inertia_1[t]=Inertia_nadir_frequency_converter_1[t] # When the converter fails, the total inertia is the inertia corresponding to the total procured inertia
        procured_inertia_2[t]=Inertia_nadir_frequency_converter_2[t]
        total_rg_lg1[t]=sum(rg_lg1[g,t] for g in G1)
        total_re_lg1[t]=sum(re_lg1[e,t] for e in E1)
        total_rs_lg1[t]=sum(rs_lg1[s,t] for s in S1)
        total_rhvdc_lg1[t]=sum(rhvdc_lg1[cv,t] for cv in CV1)
        total_fast_reserve_lg1[t]=sum(re_lg1[e,t] for e in E1)+sum(rs_lg1[s,t] for s in S1)+sum(rhvdc_lg1[cv,t] for cv in CV1)
        total_rg_lc1[t]=sum(rg_lc1[g,t] for g in G1)
        total_re_lc1[t]=sum(re_lc1[e,t] for e in E1)
        total_rs_lc1[t]=sum(rs_lc1[s,t] for s in S1)     
        total_rhvdc_lc1[t]=sum(rhvdc_lc1[cv,t] for cv in CV1)
        total_fast_reserve_lc1[t]=sum(re_lc1[e,t] for e in E1)+sum(rs_lc1[s,t] for s in S1)+sum(rhvdc_lc1[cv,t] for cv in CV1)
        total_rg_l_reserve_1[t]=sum(rg_l_reserve_1[g,t] for g in G1)
        total_re_l_reserve_1[t]=sum(re_l_reserve_1[e,t] for e in E1)
        total_rs_l_reserve_1[t]=sum(rs_l_reserve_1[s,t] for s in S1)
        total_fast_reserve_1[t]=sum(re_l_reserve_1[e,t] for e in E1)+sum(rs_l_reserve_1[s,t] for s in S1)
        total_rg_lg2[t]=sum(rg_lg2[g,t] for g in G2)
        total_re_lg2[t]=sum(re_lg2[e,t] for e in E2)
        total_rs_lg2[t]=sum(rs_lg2[s,t] for s in S2)
        total_rhvdc_lg2[t]=sum(rhvdc_lg2[cv,t] for cv in CV2)
        total_fast_reserve_lg2[t]=+sum(re_lg2[e,t] for e in E2)+sum(rs_lg2[s,t] for s in S2)+sum(rhvdc_lg2[cv,t] for cv in CV2)
        total_rg_lc2[t]=sum(rg_lc2[g,t] for g in G2)
        total_re_lc2[t]=sum(re_lc2[e,t] for e in E2)
        total_rs_lc2[t]=sum(rs_lc2[s,t] for s in S2)
        total_rhvdc_lc2[t]=sum(rhvdc_lc2[cv,t] for cv in CV2)
        total_fast_reserve_lc2[t]=sum(re_lc2[e,t] for e in E2)+sum(rs_lc2[s,t] for s in S2)+sum(rhvdc_lc2[cv,t] for cv in CV2) 
        total_rg_l_reserve_2[t]=sum(rg_l_reserve_2[g,t] for g in G2)
        total_re_l_reserve_2[t]=sum(re_l_reserve_2[e,t] for e in E2)
        total_rs_l_reserve_2[t]=sum(rs_l_reserve_2[s,t] for s in S2)
        total_fast_reserve_2[t]=sum(re_l_reserve_2[e,t] for e in E2)+sum(rs_l_reserve_2[s,t] for s in S2)
end

Inertia_nadir_frequency_1_vec = [Inertia_nadir_frequency_1[t] for t in T]
Inertia_nadir_frequency_2_vec = [Inertia_nadir_frequency_2[t] for t in T]
Inertia_nadir_frequency_converter_1_vec = [Inertia_nadir_frequency_converter_1[t] for t in T]
Inertia_nadir_frequency_converter_2_vec = [Inertia_nadir_frequency_converter_2[t] for t in T]
Inertia_nadir_frequency_reserve_1_vec = [Inertia_nadir_frequency_reserve_1[t] for t in T]
Inertia_nadir_frequency_reserve_2_vec = [Inertia_nadir_frequency_reserve_2[t] for t in T]


for t in T
        rocof_plg1[t]= f1*plg1[t]/(2*Inertia_nadir_frequency_1[t])
        rocof_plg2[t]= f2*plg2[t]/(2*Inertia_nadir_frequency_2[t])
        rocof_plc1[t]= f1*plc1[t]/(2*Inertia_nadir_frequency_converter_1[t])
        rocof_plc2[t]= f2*plc2[t]/(2*Inertia_nadir_frequency_converter_2[t])
        rocof_plreserve_1[t]= f1*plreserve_1[t]/(2*Inertia_nadir_frequency_reserve_1[t])
        rocof_plreserve_2[t]= f2*plreserve_2[t]/(2*Inertia_nadir_frequency_reserve_2[t])
        Deltaf_nadir_plg1[t] =((plg1[t]- sum(re_lg1[e, t] for e in E1)- sum(rs_lg1[s, t] for s in S1)- sum(rhvdc_lg1[cv, t] for cv in CV1))^2*G_dt["1"]/sum(rg_lg1[g, t]  for g in G1) + (sum(re_lg1[e, t] for e in E1) + sum(rs_lg1[s, t] for s in S1) + sum(rhvdc_lg1[cv, t]  for cv in CV1)) * Edeployment["1"] ) * f1 / (4 * Inertia_nadir_frequency_1[t])
        Deltaf_nadir_plg2[t] =((plg2[t]- sum(re_lg2[e, t] for e in E2)- sum(rs_lg2[s, t] for s in S2)- sum(rhvdc_lg2[cv, t] for cv in CV2))^2*G_dt["1"]/sum(rg_lg2[g, t]  for g in G2) + (sum(re_lg2[e, t] for e in E2) + sum(rs_lg2[s, t] for s in S2) + sum(rhvdc_lg2[cv, t]  for cv in CV2)) * Edeployment["1"] ) * f2 / (4 * Inertia_nadir_frequency_2[t])
        Deltaf_nadir_plc1[t] =((plc1[t]- sum(re_lc1[e, t] for e in E1)- sum(rs_lc1[s, t] for s in S1)- sum(rhvdc_lc1[cv, t] for cv in CV1))^2*G_dt["1"]/sum(rg_lc1[g, t]  for g in G1) + (sum(re_lc1[e, t] for e in E1) + sum(rs_lc1[s, t] for s in S1) + sum(rhvdc_lc1[cv, t]  for cv in CV1)) * Edeployment["1"] ) * f1 / (4 * Inertia_nadir_frequency_converter_1[t])
        Deltaf_nadir_plc2[t] =((plc2[t]- sum(re_lc2[e, t] for e in E2)- sum(rs_lc2[s, t] for s in S2)- sum(rhvdc_lc2[cv, t] for cv in CV2))^2*G_dt["1"]/sum(rg_lc2[g, t]  for g in G2) + (sum(re_lc2[e, t] for e in E2) + sum(rs_lc2[s, t] for s in S2) + sum(rhvdc_lc2[cv, t]  for cv in CV2)) * Edeployment["1"] ) * f2 / (4 * Inertia_nadir_frequency_converter_2[t])
        Deltaf_nadir_plreserve_1[t] =((plreserve_1[t]- sum(re_l_reserve_1[e, t] for e in E1)- sum(rs_l_reserve_1[s, t] for s in S1))^2*G_dt["1"]/sum(rg_l_reserve_1[g, t]  for g in G1) + (sum(re_l_reserve_1[e, t] for e in E1) + sum(rs_l_reserve_1[s, t] for s in S1)) * Edeployment["1"] ) * f1 / (4 * Inertia_nadir_frequency_reserve_1[t])
        Deltaf_nadir_plreserve_2[t] =((plreserve_2[t]- sum(re_l_reserve_2[e, t] for e in E2)- sum(rs_l_reserve_2[s, t] for s in S2))^2*G_dt["1"]/sum(rg_l_reserve_2[g, t]  for g in G2) + (sum(re_l_reserve_2[e, t] for e in E2) + sum(rs_l_reserve_2[s, t] for s in S2)) * Edeployment["1"] ) * f2 / (4 * Inertia_nadir_frequency_reserve_2[t])
 end



# ===============================
# Write results to a TXT file
# ===============================

output_file = "frequency_results.txt"

open(output_file, "w") do io


    println(io, "===== ROCOF =====")
    println(io, "rocof_plg1:")
    for t in T
        println(io, "t=$t  value=$(rocof_plg1[t])")
    end
    println(io)

    println(io, "rocof_plg2:")
    for t in T
        println(io, "t=$t  value=$(rocof_plg2[t])")
    end
    println(io)

    println(io, "rocof_plc1:")
    for t in T
        println(io, "t=$t  value=$(rocof_plc1[t])")
    end
    println(io)

    println(io, "rocof_plc2:")
    for t in T
        println(io, "t=$t  value=$(rocof_plc2[t])")
    end

    println(io, "rocof_plreserve_1:")
    for t in T
        println(io, "t=$t  value=$(rocof_plreserve_1[t])")
    end

    println(io, "rocof_plreserve_2:")
    for t in T
        println(io, "t=$t  value=$(rocof_plreserve_2[t])")
    end

    println(io)

    println(io, "===== INERTIA =====")
    println(io, "Inertia_nadir_frequency_1:")

    for t in T
        println(io, "t=$t  value=$(Inertia_nadir_frequency_1[t])")
    end
    println(io)

    println(io, "Inertia_nadir_frequency_2:")
    for t in T
        println(io, "t=$t  value=$(Inertia_nadir_frequency_2[t])")
    end
    println(io)

    println(io, "procured_inertia_1:")
    for t in T
        println(io, "t=$t  value=$(procured_inertia_1[t])")
    end
    println(io)

    println(io, "procured_inertia_2:")
    for t in T
        println(io, "t=$t  value=$(procured_inertia_2[t])")
    end
    println(io)

    println(io, "===== NADIR FREQUENCY DEVIATION =====")

    println(io, "Deltaf_nadir_plg1:")
    for t in T
        println(io, "t=$t  value=$(Deltaf_nadir_plg1[t])")
    end
    println(io)

    println(io, "Deltaf_nadir_plg2:")
    for t in T
        println(io, "t=$t  value=$(Deltaf_nadir_plg2[t])")
    end
    println(io)

    println(io, "Deltaf_nadir_plc1:")
    for t in T
        println(io, "t=$t  value=$(Deltaf_nadir_plc1[t])")
    end
    println(io)

    println(io, "Deltaf_nadir_plc2:")
    for t in T
        println(io, "t=$t  value=$(Deltaf_nadir_plc2[t])")
    end
    println(io)

    println(io, "Deltaf_nadir_plreserve_1:")
    for t in T
        println(io, "t=$t  value=$(Deltaf_nadir_plreserve_1[t])")
    end
    println(io)

    println(io, "Deltaf_nadir_plreserve_2:")
    for t in T
        println(io, "t=$t  value=$(Deltaf_nadir_plreserve_2[t])")
    end
    println(io)

    println(io, "===== TOTAL RESERVES LG1 =====")
    for t in T
        println(io, "t=$t  rg_lg1 =$(total_rg_lg1[t])",", re_lg1=$(total_re_lg1[t])", ", rs_lg1=$(total_rs_lg1[t])", ", rhvdc_lg1=$(total_rhvdc_lg1[t])", ", fast_reserve_lg1=$(total_fast_reserve_lg1[t])")
    end
    println(io)

    println(io, "===== TOTAL RESERVES LC1 =====")
   
    for t in T
        println(io, "t=$t  rg_lc1 =$(total_rg_lc1[t])",", re_lc1=$(total_re_lc1[t])", ", rs_lc1=$(total_rs_lc1[t])", ", rhvdc_lc1=$(total_rhvdc_lc1[t])", ", fast_reserve_lc1=$(total_fast_reserve_lc1[t])")
    end

    println(io, "===== TOTAL RESERVES LG2 =====")
    for t in T
        println(io, "t=$t  rg_lg2 =$(total_rg_lg2[t])",", re_lg2=$(total_re_lg2[t])", ", rs_lg2=$(total_rs_lg2[t])", ", rhvdc_lg2=$(total_rhvdc_lg2[t])", ", fast_reserve_lg2=$(total_fast_reserve_lg2[t])")
    end

    println(io, "===== TOTAL RESERVES LC2 =====")
    for t in T
        println(io, "t=$t  rg_lc2 =$(total_rg_lc2[t])",", re_lc2=$(total_re_lc2[t])", ", rs_lc2=$(total_rs_lc2[t])", ", rhvdc_lc2=$(total_rhvdc_lc2[t])", ", fast_reserve_lc2=$(total_fast_reserve_lc2[t])")
    end

    println(io, "===== TOTAL RESERVES RESERVE PROCUREMENT LOSS OF POWER 1 =====")
    for t in T
        println(io, "t=$t  rg_l_reserve_1 =$(total_rg_l_reserve_1[t])",", re_l_reserve_1=$(total_re_l_reserve_1[t])", ", rs_l_reserve_1=$(total_rs_l_reserve_1[t])", ", fast_reserve_1=$(total_fast_reserve_1[t])")
    end

    println(io, "===== TOTAL RESERVES RESERVE PROCUREMENT LOSS OF POWER 2 =====")
    for t in T
        println(io, "t=$t  rg_l_reserve_2 =$(total_rg_l_reserve_2[t])",", re_l_reserve_2=$(total_re_l_reserve_2[t])", ", rs_l_reserve_2=$(total_rs_l_reserve_2[t])", ", fast_reserve_2=$(total_fast_reserve_2[t])")     
    end

     println(io, "===== LOSS OF POWER A1 =====")

     for t in T
         println(io, "t=$t  PLG1=$(plg1[t])", ", PLC1=$(plc1[t])", ", PLRESERVE_1=$(plreserve_1[t])")
     end

     println(io, "===== LOSS OF POWER A2 =====")
  
     for t in T
         println(io, "t=$t  PLG2=$(plg2[t])", ", PLC2=$(plc2[t]), PLRESERVE_2=$(plreserve_2[t])")
     end
     println(io)

end

println("Results written to frequency_results.txt")

# =========================
# RECONSTRUCCIÓN OBJETIVO CASO 2
# COSTOS POR ÁREA Y COSTO TOTAL
# =========================

# Parámetro que faltaba en tu bloque
HVDC_reservecost = m.ext[:parameters][:convdc][:HVDC_reservecost]

# -------------------------------------------------
# 1) COSTOS ÁREA 1
# -------------------------------------------------

# Generación
obj_gen_1 = sum(
    gen_cost[g][1] * (pg[g,t] / baseMVA) + gen_cost[g][2]
    for g in G1, t in T
)
total_gen_area_1 = sum(pg[g,t] for g in G1, t in T)

# Arranque electrolizadores
obj_estart_1 = sum(
    Estartupcost[e] * zesu[e,t]
    for e in E1, t in T
)

# Arranque generadores
obj_gstart_1 = sum(
    start_up_cost[g] * betag[g,t]
    for g in G1, t in T
)

# Hidrógeno
obj_h2_1 = sum(
    Hydrogencost[e] * (-hfginyect[e,t] + hfgconsum[e,t])
    for e in E1, t in T
)

# Reservas electrolizadores
obj_res_e_1 = sum(Ereservecost[e] * re_lg1[e,t] for e in E1, t in T) +
              sum(Ereservecost[e] * re_lc1[e,t] for e in E1, t in T) +
              sum(Ereservecost[e] * re_l_reserve_1[e,t] for e in E1, t in T)

# Reservas almacenamiento
obj_res_s_1 = sum(Sreservecost[s] * rs_lg1[s,t] for s in S1, t in T) +
              sum(Sreservecost[s] * rs_lc1[s,t] for s in S1, t in T) +
              sum(Sreservecost[s] * rs_l_reserve_1[s,t] for s in S1, t in T)

# Reservas HVDC
obj_res_hvdc_1 = sum(HVDC_reservecost[cv] * rhvdc_lg1[cv,t] for cv in CV1, t in T) +
                 sum(HVDC_reservecost[cv] * rhvdc_lc1[cv,t] for cv in CV1, t in T)

# Reservas generadores
obj_res_g_1 = sum(G_reservecost[g] * rg_lg1[g,t] for g in G1, t in T) +
              sum(G_reservecost[g] * rg_lc1[g,t] for g in G1, t in T) +
              sum(G_reservecost[g] * rg_l_reserve_1[g,t] for g in G1, t in T)

# Costo total área 1
obj_area_1 = obj_gen_1 + obj_estart_1 + obj_gstart_1 + obj_h2_1 +
             obj_res_e_1 + obj_res_s_1 + obj_res_hvdc_1 + obj_res_g_1


# -------------------------------------------------
# 2) COSTOS ÁREA 2
# -------------------------------------------------

# Generación
obj_gen_2 = sum(
    gen_cost[g][1] * (pg[g,t] / baseMVA) + gen_cost[g][2]
    for g in G2, t in T
)
total_gen_area_2 = sum(pg[g,t] for g in G2, t in T)

# Arranque electrolizadores
obj_estart_2 = sum(
    Estartupcost[e] * zesu[e,t]
    for e in E2, t in T
)

# Arranque generadores
obj_gstart_2 = sum(
    start_up_cost[g] * betag[g,t]
    for g in G2, t in T
)

# Hidrógeno
obj_h2_2 = sum(
    Hydrogencost[e] * (-hfginyect[e,t] + hfgconsum[e,t])
    for e in E2, t in T
)

# Reservas electrolizadores
obj_res_e_2 = sum(Ereservecost[e] * re_lg2[e,t] for e in E2, t in T) +
              sum(Ereservecost[e] * re_lc2[e,t] for e in E2, t in T) +
              sum(Ereservecost[e] * re_l_reserve_2[e,t] for e in E2, t in T)

# Reservas almacenamiento
obj_res_s_2 = sum(Sreservecost[s] * rs_lg2[s,t] for s in S2, t in T) +
              sum(Sreservecost[s] * rs_lc2[s,t] for s in S2, t in T) +
              sum(Sreservecost[s] * rs_l_reserve_2[s,t] for s in S2, t in T)

# Reservas HVDC
obj_res_hvdc_2 = sum(HVDC_reservecost[cv] * rhvdc_lg2[cv,t] for cv in CV2, t in T) +
                 sum(HVDC_reservecost[cv] * rhvdc_lc2[cv,t] for cv in CV2, t in T)

# Reservas generadores
obj_res_g_2 = sum(G_reservecost[g] * rg_lg2[g,t] for g in G2, t in T) +
              sum(G_reservecost[g] * rg_lc2[g,t] for g in G2, t in T) +
              sum(G_reservecost[g] * rg_l_reserve_2[g,t] for g in G2, t in T)

# Costo total área 2
obj_area_2 = obj_gen_2 + obj_estart_2 + obj_gstart_2 + obj_h2_2 +
             obj_res_e_2 + obj_res_s_2 + obj_res_hvdc_2 + obj_res_g_2


# -------------------------------------------------
# 3) COSTO TOTAL
# -------------------------------------------------
obj_total_reconstruido = obj_area_1 + obj_area_2

# Valor del objetivo del modelo
obj_modelo = JuMP.objective_value(m)

# -------------------------------------------------
# 4) RESULTADOS EN DICCIONARIOS
# -------------------------------------------------

costos_area_1 = Dict(
    "generacion" => obj_gen_1,
    "startup_electrolizadores" => obj_estart_1,
    "startup_generadores" => obj_gstart_1,
    "hidrogeno" => obj_h2_1,
    "reservas_electrolizadores" => obj_res_e_1,
    "reservas_storage" => obj_res_s_1,
    "reservas_hvdc" => obj_res_hvdc_1,
    "reservas_generadores" => obj_res_g_1,
    "total_area_1" => obj_area_1,
    "total_generacion_area_1" => total_gen_area_1
)

costos_area_2 = Dict(
    "generacion" => obj_gen_2,
    "startup_electrolizadores" => obj_estart_2,
    "startup_generadores" => obj_gstart_2,
    "hidrogeno" => obj_h2_2,
    "reservas_electrolizadores" => obj_res_e_2,
    "reservas_storage" => obj_res_s_2,
    "reservas_hvdc" => obj_res_hvdc_2,
    "reservas_generadores" => obj_res_g_2,
    "total_area_2" => obj_area_2,
    "total_generacion_area_2" => total_gen_area_2
)

costos_totales = Dict(
    "total_area_1" => obj_area_1,
    "total_area_2" => obj_area_2,
    "total_reconstruido" => obj_total_reconstruido,
    "objetivo_modelo" => obj_modelo,
    "error_absoluto" => abs(obj_total_reconstruido - obj_modelo)
)

# -------------------------------------------------
# 5) IMPRESIÓN
# -------------------------------------------------

println("===== COSTOS ÁREA 1 =====")
for (k,v) in costos_area_1
    println(rpad(k, 30), " = ", v)
end

println("\n===== COSTOS ÁREA 2 =====")
for (k,v) in costos_area_2
    println(rpad(k, 30), " = ", v)
end

println("\n===== COSTOS TOTALES =====")
for (k,v) in costos_totales
    println(rpad(k, 30), " = ", v)
end

# -------------------------------------------------
# 7) SAVE RESULTS TO TXT FILE
# -------------------------------------------------

output_file = "operating_costs_results.txt"

open(output_file, "w") do io

    println(io, "===== AREA 1 COSTS =====")
    for (k,v) in costos_area_1
        println(io, rpad(k, 35), " = ", v)
    end

    println(io, "\n===== AREA 2 COSTS =====")
    for (k,v) in costos_area_2
        println(io, rpad(k, 35), " = ", v)
    end

    println(io, "\n===== TOTAL COSTS =====")
    for (k,v) in costos_totales
        println(io, rpad(k, 35), " = ", v)
    end

end

println("Results saved to: ", output_file)











# =========================
# OPERATING COSTS BY AREA
# USING MAXIMUM PROCURED POWER PER HOUR
# AND THE COST ASSOCIATED WITH THE SELECTED RESERVE
# =========================

HVDC_reservecost = m.ext[:parameters][:convdc][:HVDC_reservecost]

# -------------------------------------------------
# Helper function:
# Given candidate reserve powers and candidate reserve costs,
# select the cost associated with the largest procured power
# -------------------------------------------------
function select_cost_from_max_power(power_candidates::Vector{Float64},
                                    cost_candidates::Vector{Float64})
    idx = argmax(power_candidates)
    return power_candidates[idx], cost_candidates[idx], idx
end

# -------------------------------------------------
# 1) NON-RESERVE COSTS AREA 1
# -------------------------------------------------

obj_gen_1 = sum(
    gen_cost[g][1] * (pg[g,t] / baseMVA) + gen_cost[g][2]
    for g in G1, t in T
)

obj_estart_1 = sum(
    Estartupcost[e] * zesu[e,t]
    for e in E1, t in T
)

obj_gstart_1 = sum(
    start_up_cost[g] * betag[g,t]
    for g in G1, t in T
)

obj_h2_1 = sum(
    Hydrogencost[e] * (-hfginyect[e,t] + hfgconsum[e,t])
    for e in E1, t in T
)

# -------------------------------------------------
# 2) NON-RESERVE COSTS AREA 2
# -------------------------------------------------

obj_gen_2 = sum(
    gen_cost[g][1] * (pg[g,t] / baseMVA) + gen_cost[g][2]
    for g in G2, t in T
)

obj_estart_2 = sum(
    Estartupcost[e] * zesu[e,t]
    for e in E2, t in T
)

obj_gstart_2 = sum(
    start_up_cost[g] * betag[g,t]
    for g in G2, t in T
)

obj_h2_2 = sum(
    Hydrogencost[e] * (-hfginyect[e,t] + hfgconsum[e,t])
    for e in E2, t in T
)

# -------------------------------------------------
# 3) RESERVE COSTS BASED ON MAX PROCURED POWER - AREA 1
# -------------------------------------------------

max_power_e_1 = Dict()
selected_cost_e_1 = Dict()
selected_type_e_1 = Dict()

max_power_s_1 = Dict()
selected_cost_s_1 = Dict()
selected_type_s_1 = Dict()

max_power_g_1 = Dict()
selected_cost_g_1 = Dict()
selected_type_g_1 = Dict()

max_power_hvdc_1 = Dict()
selected_cost_hvdc_1 = Dict()
selected_type_hvdc_1 = Dict()

for t in T
    # Electrolyzers - area 1
    p_lg = sum(re_lg1[e,t] for e in E1)
    p_lc = sum(re_lc1[e,t] for e in E1)
    p_lr = sum(re_l_reserve_1[e,t] for e in E1)

    c_lg = sum(Ereservecost[e] * re_lg1[e,t] for e in E1)
    c_lc = sum(Ereservecost[e] * re_lc1[e,t] for e in E1)
    c_lr = sum(Ereservecost[e] * re_l_reserve_1[e,t] for e in E1)

    max_power_e_1[t], selected_cost_e_1[t], idx = select_cost_from_max_power(
        [p_lg, p_lc, p_lr],
        [c_lg, c_lc, c_lr]
    )
    selected_type_e_1[t] = ["lg", "lc", "l_reserve"][idx]

    # Storage - area 1
    p_lg = sum(rs_lg1[s,t] for s in S1)
    p_lc = sum(rs_lc1[s,t] for s in S1)
    p_lr = sum(rs_l_reserve_1[s,t] for s in S1)

    c_lg = sum(Sreservecost[s] * rs_lg1[s,t] for s in S1)
    c_lc = sum(Sreservecost[s] * rs_lc1[s,t] for s in S1)
    c_lr = sum(Sreservecost[s] * rs_l_reserve_1[s,t] for s in S1)

    max_power_s_1[t], selected_cost_s_1[t], idx = select_cost_from_max_power(
        [p_lg, p_lc, p_lr],
        [c_lg, c_lc, c_lr]
    )
    selected_type_s_1[t] = ["lg", "lc", "l_reserve"][idx]

    # Generators - area 1
    p_lg = sum(rg_lg1[g,t] for g in G1)
    p_lc = sum(rg_lc1[g,t] for g in G1)
    p_lr = sum(rg_l_reserve_1[g,t] for g in G1)

    c_lg = sum(G_reservecost[g] * rg_lg1[g,t] for g in G1)
    c_lc = sum(G_reservecost[g] * rg_lc1[g,t] for g in G1)
    c_lr = sum(G_reservecost[g] * rg_l_reserve_1[g,t] for g in G1)

    max_power_g_1[t], selected_cost_g_1[t], idx = select_cost_from_max_power(
        [p_lg, p_lc, p_lr],
        [c_lg, c_lc, c_lr]
    )
    selected_type_g_1[t] = ["lg", "lc", "l_reserve"][idx]

    # HVDC - area 1
    p_lg = sum(rhvdc_lg1[cv,t] for cv in CV1)
    p_lc = sum(rhvdc_lc1[cv,t] for cv in CV1)

    c_lg = sum(HVDC_reservecost[cv] * rhvdc_lg1[cv,t] for cv in CV1)
    c_lc = sum(HVDC_reservecost[cv] * rhvdc_lc1[cv,t] for cv in CV1)

    max_power_hvdc_1[t], selected_cost_hvdc_1[t], idx = select_cost_from_max_power(
        [p_lg, p_lc],
        [c_lg, c_lc]
    )
    selected_type_hvdc_1[t] = ["lg", "lc"][idx]
end

obj_res_e_1 = sum(selected_cost_e_1[t] for t in T)
obj_res_s_1 = sum(selected_cost_s_1[t] for t in T)
obj_res_g_1 = sum(selected_cost_g_1[t] for t in T)
obj_res_hvdc_1 = sum(selected_cost_hvdc_1[t] for t in T)

obj_reserve_1 = obj_res_e_1 + obj_res_s_1 + obj_res_g_1 + obj_res_hvdc_1

obj_area_1 = obj_gen_1 + obj_estart_1 + obj_gstart_1 + obj_h2_1 + obj_reserve_1

# -------------------------------------------------
# 4) RESERVE COSTS BASED ON MAX PROCURED POWER - AREA 2
# -------------------------------------------------

max_power_e_2 = Dict()
selected_cost_e_2 = Dict()
selected_type_e_2 = Dict()

max_power_s_2 = Dict()
selected_cost_s_2 = Dict()
selected_type_s_2 = Dict()

max_power_g_2 = Dict()
selected_cost_g_2 = Dict()
selected_type_g_2 = Dict()

max_power_hvdc_2 = Dict()
selected_cost_hvdc_2 = Dict()
selected_type_hvdc_2 = Dict()

for t in T
    # Electrolyzers - area 2
    p_lg = sum(re_lg2[e,t] for e in E2)
    p_lc = sum(re_lc2[e,t] for e in E2)
    p_lr = sum(re_l_reserve_2[e,t] for e in E2)

    c_lg = sum(Ereservecost[e] * re_lg2[e,t] for e in E2)
    c_lc = sum(Ereservecost[e] * re_lc2[e,t] for e in E2)
    c_lr = sum(Ereservecost[e] * re_l_reserve_2[e,t] for e in E2)

    max_power_e_2[t], selected_cost_e_2[t], idx = select_cost_from_max_power(
        [p_lg, p_lc, p_lr],
        [c_lg, c_lc, c_lr]
    )
    selected_type_e_2[t] = ["lg", "lc", "l_reserve"][idx]

    # Storage - area 2
    p_lg = sum(rs_lg2[s,t] for s in S2)
    p_lc = sum(rs_lc2[s,t] for s in S2)
    p_lr = sum(rs_l_reserve_2[s,t] for s in S2)

    c_lg = sum(Sreservecost[s] * rs_lg2[s,t] for s in S2)
    c_lc = sum(Sreservecost[s] * rs_lc2[s,t] for s in S2)
    c_lr = sum(Sreservecost[s] * rs_l_reserve_2[s,t] for s in S2)

    max_power_s_2[t], selected_cost_s_2[t], idx = select_cost_from_max_power(
        [p_lg, p_lc, p_lr],
        [c_lg, c_lc, c_lr]
    )
    selected_type_s_2[t] = ["lg", "lc", "l_reserve"][idx]

    # Generators - area 2
    p_lg = sum(rg_lg2[g,t] for g in G2)
    p_lc = sum(rg_lc2[g,t] for g in G2)
    p_lr = sum(rg_l_reserve_2[g,t] for g in G2)

    c_lg = sum(G_reservecost[g] * rg_lg2[g,t] for g in G2)
    c_lc = sum(G_reservecost[g] * rg_lc2[g,t] for g in G2)
    c_lr = sum(G_reservecost[g] * rg_l_reserve_2[g,t] for g in G2)

    max_power_g_2[t], selected_cost_g_2[t], idx = select_cost_from_max_power(
        [p_lg, p_lc, p_lr],
        [c_lg, c_lc, c_lr]
    )
    selected_type_g_2[t] = ["lg", "lc", "l_reserve"][idx]

    # HVDC - area 2
    p_lg = sum(rhvdc_lg2[cv,t] for cv in CV2)
    p_lc = sum(rhvdc_lc2[cv,t] for cv in CV2)

    c_lg = sum(HVDC_reservecost[cv] * rhvdc_lg2[cv,t] for cv in CV2)
    c_lc = sum(HVDC_reservecost[cv] * rhvdc_lc2[cv,t] for cv in CV2)

    max_power_hvdc_2[t], selected_cost_hvdc_2[t], idx = select_cost_from_max_power(
        [p_lg, p_lc],
        [c_lg, c_lc]
    )
    selected_type_hvdc_2[t] = ["lg", "lc"][idx]
end

obj_res_e_2 = sum(selected_cost_e_2[t] for t in T)
obj_res_s_2 = sum(selected_cost_s_2[t] for t in T)
obj_res_g_2 = sum(selected_cost_g_2[t] for t in T)
obj_res_hvdc_2 = sum(selected_cost_hvdc_2[t] for t in T)

obj_reserve_2 = obj_res_e_2 + obj_res_s_2 + obj_res_g_2 + obj_res_hvdc_2

obj_area_2 = obj_gen_2 + obj_estart_2 + obj_gstart_2 + obj_h2_2 + obj_reserve_2

# -------------------------------------------------
# 5) TOTAL COST
# -------------------------------------------------

obj_total_reconstructed = obj_area_1 + obj_area_2

# -------------------------------------------------
# 6) OUTPUT DICTIONARIES
# -------------------------------------------------

costos_area_1 = Dict(
    "generation" => obj_gen_1,
    "startup_electrolyzers" => obj_estart_1,
    "startup_generators" => obj_gstart_1,
    "hydrogen" => obj_h2_1,
    "reserve_electrolyzers" => obj_res_e_1,
    "reserve_storage" => obj_res_s_1,
    "reserve_generators" => obj_res_g_1,
    "reserve_hvdc" => obj_res_hvdc_1,
    "total_reserve_area_1" => obj_reserve_1,
    "total_area_1" => obj_area_1
)

costos_area_2 = Dict(
    "generation" => obj_gen_2,
    "startup_electrolyzers" => obj_estart_2,
    "startup_generators" => obj_gstart_2,
    "hydrogen" => obj_h2_2,
    "reserve_electrolyzers" => obj_res_e_2,
    "reserve_storage" => obj_res_s_2,
    "reserve_generators" => obj_res_g_2,
    "reserve_hvdc" => obj_res_hvdc_2,
    "total_reserve_area_2" => obj_reserve_2,
    "total_area_2" => obj_area_2
)

costos_totales = Dict(
    "total_area_1" => obj_area_1,
    "total_area_2" => obj_area_2,
    "total_reconstructed" => obj_total_reconstructed
)

# -------------------------------------------------
# 7) PRINT TO TXT FILE (ORDERED)
# -------------------------------------------------

output_file = "real_cost_results.txt"

open(output_file, "w") do io

    println(io, "===== AREA 1 COSTS =====")

    println(io, "generation                          = ", costos_area_1["generation"])
    println(io, "startup_electrolyzers              = ", costos_area_1["startup_electrolyzers"])
    println(io, "startup_generators                 = ", costos_area_1["startup_generators"])
    println(io, "hydrogen                           = ", costos_area_1["hydrogen"])
    println(io, "total_area_1                       = ", costos_area_1["total_area_1"])
    println(io, "reserve_generators                 = ", costos_area_1["reserve_generators"])
    println(io, "reserve_electrolyzers              = ", costos_area_1["reserve_electrolyzers"])
    println(io, "reserve_storage                    = ", costos_area_1["reserve_storage"])

    println(io, "\n===== AREA 2 COSTS =====")

    println(io, "generation                          = ", costos_area_2["generation"])
    println(io, "startup_electrolyzers              = ", costos_area_2["startup_electrolyzers"])
    println(io, "startup_generators                 = ", costos_area_2["startup_generators"])
    println(io, "hydrogen                           = ", costos_area_2["hydrogen"])
    println(io, "total_area_2                       = ", costos_area_2["total_area_2"])
    println(io, "reserve_generators                 = ", costos_area_2["reserve_generators"])
    println(io, "reserve_electrolyzers              = ", costos_area_2["reserve_electrolyzers"])
    println(io, "reserve_storage                    = ", costos_area_2["reserve_storage"])

    println(io, "\n===== TOTAL =====")
    println(io, "total_reconstructed                = ", costos_totales["total_reconstructed"])

end

output_file_simulink = "Results_for_simulink.txt"

open(output_file_simulink, "w") do io

    # ==========================================================
    # LOSS OF GENERATION — AREA 1
    # ==========================================================
    println(io, "Results loss of generation Area 1")
    println(io, "---------------------------------")

    for t in T
        println(
            io,
            "t=$t;",
            "H_0=$(Inertia_nadir_frequency_1[t]);",
            "Ploss=$(plg1[t]);",
            "rg=$(total_rg_lg1[t]);",
            "rh=$(total_rhvdc_lg1[t]);",
            "re=$(total_re_lg1[t]);",
            "rs=$(total_rs_lg1[t]);",
            "RoCoF=$(rocof_plg1[t]);",
            "MaxDeltaF=$(Deltaf_nadir_plg1[t]);"
        )
    end

    println(io)


    # ==========================================================
    # LOSS OF GENERATION — AREA 2
    # ==========================================================
    println(io, "Results loss of generation Area 2")
    println(io, "---------------------------------")

    for t in T
        println(
            io,
            "t=$t;",
            "H_0=$(Inertia_nadir_frequency_2[t]);",
            "Ploss=$(plg2[t]);",
            "rg=$(total_rg_lg2[t]);",
            "rh=$(total_rhvdc_lg2[t]);",
            "re=$(total_re_lg2[t]);",
            "rs=$(total_rs_lg2[t]);",
            "RoCoF=$(rocof_plg2[t]);",
            "MaxDeltaF=$(Deltaf_nadir_plg2[t]);"
        )
    end

    println(io)


    # ==========================================================
    # LOSS OF CONVERTER — AREA 1
    # ==========================================================
    println(io, "Results loss of converter Area 1")
    println(io, "---------------------------------")

    for t in T
        println(
            io,
            "t=$t;",
            "H_0=$(Inertia_nadir_frequency_converter_1[t]);",
            "Ploss=$(plc1[t]);",
            "rg=$(total_rg_lc1[t]);",
            "rh=$(total_rhvdc_lc1[t]);",
            "re=$(total_re_lc1[t]);",
            "rs=$(total_rs_lc1[t]);",
            "RoCoF=$(rocof_plc1[t]);",
            "MaxDeltaF=$(Deltaf_nadir_plc1[t]);"
        )
    end

    println(io)


    # ==========================================================
    # LOSS OF CONVERTER — AREA 2
    # ==========================================================
    println(io, "Results loss of converter Area 2")
    println(io, "---------------------------------")

    for t in T
        println(
            io,
            "t=$t;",
            "H_0=$(Inertia_nadir_frequency_converter_2[t]);",
            "Ploss=$(plc2[t]);",
            "rg=$(total_rg_lc2[t]);",
            "rh=$(total_rhvdc_lc2[t]);",
            "re=$(total_re_lc2[t]);",
            "rs=$(total_rs_lc2[t]);",
            "RoCoF=$(rocof_plc2[t]);",
            "MaxDeltaF=$(Deltaf_nadir_plc2[t]);"
        )
    end

    println(io)


    # ==========================================================
    # LOSS OF RESERVE — AREA 1
    # ==========================================================
    println(io, "Results loss of reserve Area 1")
    println(io, "---------------------------------")

    for t in T
        println(
            io,
            "t=$t;",
            "H_0=$(Inertia_nadir_frequency_reserve_1[t]);",
            "Ploss=$(plreserve_1[t]);",
            "rg=$(total_rg_l_reserve_1[t]);",
            "rh=0.0;",
            "re=$(total_re_l_reserve_1[t]);",
            "rs=$(total_rs_l_reserve_1[t]);",
            "RoCoF=$(rocof_plreserve_1[t]);",
            "MaxDeltaF=$(Deltaf_nadir_plreserve_1[t]);"
        )
    end

    println(io)


    # ==========================================================
    # LOSS OF RESERVE — AREA 2
    # ==========================================================
    println(io, "Results loss of reserve Area 2")
    println(io, "---------------------------------")

    for t in T
        println(
            io,
            "t=$t;",
            "H_0=$(Inertia_nadir_frequency_reserve_2[t]);",
            "Ploss=$(plreserve_2[t]);",
            "rg=$(total_rg_l_reserve_2[t]);",
            "rh=0.0;",
            "re=$(total_re_l_reserve_2[t]);",
            "rs=$(total_rs_l_reserve_2[t]);",
            "RoCoF=$(rocof_plreserve_2[t]);",
            "MaxDeltaF=$(Deltaf_nadir_plreserve_2[t]);"
        )
    end

end

G_type = m.ext[:parameters][:G_type]
pmax   = m.ext[:parameters][:pmax]

generation_type = Dict(
    1 => "reservoir",
    2 => "pump",
    3 => "nuclear",
    4 => "gas",
    5 => "biomass",
    6 => "oil",
    7 => "solar",
    8 => "wind"
)

G1_set = Set(G1)
G2_set = Set(G2)

output_file = "generator_results.txt"

open(output_file, "w") do file

    for t in axes(δgvec, 2)

        active_generators = [
            g for g in axes(δgvec, 1)
            if δgvec[g, t] > 0.5
        ]

        if !isempty(active_generators)
            println(file, "\nHour $t:")

            for g in active_generators

                type_code = G_type[g]

                type_name = get(
                    generation_type,
                    type_code,
                    "unknown type"
                )

                area = if g in G1_set && g in G2_set
                    "area 1 and area 2"
                elseif g in G1_set
                    "area 1"
                elseif g in G2_set
                    "area 2"
                else
                    "unknown area"
                end

                println(
                    file,
                    "  Generator = $g",
                    ", generation type = $type_name",
                    ", rated power = $(pmax[g] * 100) [MW]",
                    ", area = $area"
                )
            end
        end
    end
end

println("Results saved to: $(abspath(output_file))")

end




