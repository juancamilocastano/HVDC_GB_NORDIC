function build_ac_opf_acdc_frequency_sev_var_res_provi!(m::Model)
    # This function builds the polar form of a nonlinear AC power flow formulation

    # Create m.ext entries "variables", "expressions" and "constraints"
    m.ext[:variables] = Dict()
    m.ext[:expressions] = Dict()
    m.ext[:constraints] = Dict()

    # Extract sets
    # AC network
    baseMVA = m.ext[:parameters][:baseMVA]
    N = m.ext[:sets][:N]
    N_sl = m.ext[:sets][:N_sl]
    N1=m.ext[:sets][:N1]
    N2=m.ext[:sets][:N2]
    B = m.ext[:sets][:B]
    B_ac_fr = m.ext[:sets][:B_ac_fr]
    B_ac_to = m.ext[:sets][:B_ac_to]
    G = m.ext[:sets][:G]
    G_ac = m.ext[:sets][:G_ac]
    L = m.ext[:sets][:L]
    L_ac = m.ext[:sets][:L_ac]
    W_ac = m.ext[:sets][:W_ac]
    B_ac = m.ext[:sets][:B_ac]
    B_arcs = m.ext[:sets][:B_arcs]
    bus_ij = m.ext[:sets][:bus_ij]
    bus_ji = m.ext[:sets][:bus_ji]
    bus_ij_ji = m.ext[:sets][:bus_ij_ji]
    G_reservoir = m.ext[:sets][:G_reservoir]
    G_pump = m.ext[:sets][:G_pump]
    G_nuclear = m.ext[:sets][:G_nuclear]
    G_gas = m.ext[:sets][:G_gas]
    G_biomass = m.ext[:sets][:G_biomass]
    G_oil = m.ext[:sets][:G_oil]
    G_solar = m.ext[:sets][:G_solar]
    G_wind = m.ext[:sets][:G_wind]


    # DC network
    CV = m.ext[:sets][:CV]
    ND = m.ext[:sets][:ND]
    BD = m.ext[:sets][:BD]
    ND_arcs = m.ext[:sets][:ND_arcs]
    CV_arcs = m.ext[:sets][:CV_arcs]   
    BD_dc_fr = m.ext[:sets][:BD_dc_fr]
    BD_dc_to = m.ext[:sets][:BD_dc_to]
    BD_dc = m.ext[:sets][:BD_dc]

    busdc_ij = m.ext[:sets][:busdc_ij]
    busdc_ji = m.ext[:sets][:busdc_ji]
    T= m.ext[:sets][:t]

    S = m.ext[:sets][:S]
    S_ac = m.ext[:sets][:S_ac]
    E= m.ext[:sets][:E]
    E_ac= m.ext[:sets][:E_ac]

    # Extract parameters
    #Frequency stability parameters
    f1 = m.ext[:parameters][:f1]
    f2 = m.ext[:parameters][:f2]
    rocof1 = m.ext[:parameters][:rocof1]
    rocof2 = m.ext[:parameters][:rocof2]
    deltaf1 = m.ext[:parameters][:deltaf1]
    deltaf2 = m.ext[:parameters][:deltaf2]         

    # AC network
    gen_bus = m.ext[:parameters][:gen_bus]
    load_bus = m.ext[:parameters][:load_bus]
    
    #shunt_bus = m.ext[:parameters][:shunt_bus]
    vmmin = m.ext[:parameters][:vmmin]
    vmmax = m.ext[:parameters][:vmmax]
    vamin = m.ext[:parameters][:vamin]
    vamax = m.ext[:parameters][:vamax]
    rb =  m.ext[:parameters][:rb]
    xb =  m.ext[:parameters][:xb] 
    gb =  m.ext[:parameters][:gb]
    bb =  m.ext[:parameters][:bb] 
    #gs =  m.ext[:parameters][:gs]
    #bs =  m.ext[:parameters][:bs] 
    gfr = m.ext[:parameters][:gb_sh_fr]
    bfr = m.ext[:parameters][:bb_sh_fr]
    gto = m.ext[:parameters][:gb_sh_to]
    bto = m.ext[:parameters][:bb_sh_to]
    pmaxbranch = m.ext[:parameters][:pmaxbranch]
    angmin = m.ext[:parameters][:angmin]
    angmax = m.ext[:parameters][:angmax]
    b_shift = m.ext[:parameters][:b_shift]
    b_tap = m.ext[:parameters][:b_tap]
    pd = m.ext[:parameters][:pd]
    qd = m.ext[:parameters][:qd]
    pmax = m.ext[:parameters][:pmax]
    pmin = m.ext[:parameters][:pmin]
    #qmax = m.ext[:parameters][:qmax]
    #qmin = m.ext[:parameters][:qmin]
    gen_cost = m.ext[:parameters][:gen_cost]
    ij_ji_ang_max = m.ext[:parameters][:ij_ji_ang_max]
    ij_ji_ang_min = m.ext[:parameters][:ij_ji_ang_min]
    demand = m.ext[:parameters][:demand]
    upramp = m.ext[:parameters][:upramp]
    capacity_factor_solar= m.ext[:parameters][:capacity_factor_solar]
    capacity_factor_wind= m.ext[:parameters][:capacity_factor_wind]
    downramp = m.ext[:parameters][:downramp]
    MUT = m.ext[:parameters][:MUT]
    MDT = m.ext[:parameters][:MDT]
    G_reservecost=m.ext[:parameters][:G_reservecost]
    G_dt=m.ext[:parameters][:G_dt]
    ic=m.ext[:parameters][:ic]
    start_up_cost=m.ext[:parameters][:startup_cost]
    G_storage=m.ext[:parameters][:G_storage]
    MaxFreqDev=m.ext[:parameters][:MaxFreqDev]
    P_pump=m.ext[:parameters][:P_pump]
    G_npumping=m.ext[:parameters][:G_npumping]
    G_ngenerating=m.ext[:parameters][:G_ngenerating] 
    E_reservoirs_min=m.ext[:parameters][:E_reservoirs_min]
    E_reservoirs_ini=m.ext[:parameters][:E_reservoirs_ini]
    E_reservoirs_end=m.ext[:parameters][:E_reservoirs_end]


    # DC network
    # DC bus
    busdc_vm_max = m.ext[:parameters][:busdc][:vm_max]
    busdc_vm_min = m.ext[:parameters][:busdc][:vm_min]
    busdc_vm_set = m.ext[:parameters][:busdc][:vm_set]
    busdc_c = m.ext[:parameters][:busdc][:c]
    busdc_p = m.ext[:parameters][:busdc][:p]

    # Converters
    conv_busdc = m.ext[:parameters][:convdc][:busdc]
    conv_bus = m.ext[:parameters][:convdc][:bus]
    conv_status = m.ext[:parameters][:convdc][:status]
    conv_loss_a = m.ext[:parameters][:convdc][:loss_a]
    conv_loss_b = m.ext[:parameters][:convdc][:loss_b]
    conv_loss_c_inv = m.ext[:parameters][:convdc][:loss_c_inv]
    conv_loss_c_rec = m.ext[:parameters][:convdc][:loss_c_rec]
    conv_p_ac_max = m.ext[:parameters][:convdc][:p_ac_max]
    conv_p_ac_min = m.ext[:parameters][:convdc][:p_ac_min]
    #conv_q_ac_max = m.ext[:parameters][:convdc][:q_ac_max]
    #conv_q_ac_min = m.ext[:parameters][:convdc][:q_ac_min]
    conv_p_dc_max = m.ext[:parameters][:convdc][:p_dc_max]
    conv_p_dc_min = m.ext[:parameters][:convdc][:p_dc_min]
    conv_droop = m.ext[:parameters][:convdc][:droop]
    conv_i_max = m.ext[:parameters][:convdc][:i_max]
    conv_vm_min = m.ext[:parameters][:convdc][:vm_min]
    conv_vm_max = m.ext[:parameters][:convdc][:vm_max]
    conv_vm_dc_set = m.ext[:parameters][:convdc][:vm_dc_set]
    conv_p_g = m.ext[:parameters][:convdc][:p_g]
    #conv_q_g = m.ext[:parameters][:convdc][:q_g]
    conv_b_f = m.ext[:parameters][:convdc][:b_f]
    conv_tf_r = m.ext[:parameters][:convdc][:r_tf]
    conv_tf_g = m.ext[:parameters][:convdc][:g_tf]
    conv_tf_x = m.ext[:parameters][:convdc][:x_tf]
    conv_tf_b = m.ext[:parameters][:convdc][:b_tf]
    conv_pr_r = m.ext[:parameters][:convdc][:r_pr]
    conv_pr_g = m.ext[:parameters][:convdc][:g_pr]
    conv_pr_x = m.ext[:parameters][:convdc][:x_pr]
    conv_pr_b = m.ext[:parameters][:convdc][:b_pr]
    conv_tf_tap = m.ext[:parameters][:convdc][:tap_tf]
    conv_is_tf = m.ext[:parameters][:convdc][:is_tf]
    conv_is_pr = m.ext[:parameters][:convdc][:is_pr]
    conv_is_filter = m.ext[:parameters][:convdc][:is_filter]
    HVDC_reservecost= m.ext[:parameters][:convdc][:HVDC_reservecost]
    HVDC_deployment=m.ext[:parameters][:convdc][:HVDC_deployment]

    # DC branches
    brdc_rate_a = m.ext[:parameters][:branchdc][:rate_a]
    brdc_rate_b = m.ext[:parameters][:branchdc][:rate_b]
    brdc_rate_c = m.ext[:parameters][:branchdc][:rate_c]
    brdc_status = m.ext[:parameters][:branchdc][:status]
    brdc_r = m.ext[:parameters][:branchdc][:r]
    brdc_g = m.ext[:parameters][:branchdc][:g]
    brdc_l = m.ext[:parameters][:branchdc][:l]
    brdc_dcpoles = m.ext[:parameters][:branchdc][:dcpoles]
    

    # Electrolyzer
    Epmax = m.ext[:parameters][:Epmax]
    Epmin = m.ext[:parameters][:Epmin]
    Eefficiency = m.ext[:parameters][:Eefficiency]
    Eloadfactor = m.ext[:parameters][:Eloadfactor] 
    Eflowmax = m.ext[:parameters][:Eflowmax]
    Estoragemax = m.ext[:parameters][:Estoragemax]
    Estoragemin = m.ext[:parameters][:Estoragemin]
    Estorageinitial = m.ext[:parameters][:Estorageinitial]
    Estorageend = m.ext[:parameters][:Estorageend]
    Edeployment = m.ext[:parameters][:Edeployment]
    Ereservecost = m.ext[:parameters][:Ereservecost]
    Hydrogencost = m.ext[:parameters][:Hydrogencost]
    Estartupcost=m.ext[:parameters][:Estartupcost]
    Eeficiencycarga = m.ext[:parameters][:Eeficiencycarga]
    Eeficiencydischarge = m.ext[:parameters][:Eeficiencydischarge]
    Estartupcost = m.ext[:parameters][:Estartupcost]
    Ecompressorpower = m.ext[:parameters][:Ecompressorpower]
    electrolyzer_bus = m.ext[:parameters][:electrolyzer_bus]
    baseKG = m.ext[:parameters][:baseKG]
    

    #storage
    Spmax = m.ext[:parameters][:Spmax]
    Sstoragemax = m.ext[:parameters][:Sstoragemax]
    Sdod = m.ext[:parameters][:Sdod]
    Sefficiencycarga = m.ext[:parameters][:Sefficiencycarga]
    Sefficiencydischarge = m.ext[:parameters][:Sefficiencydischarge]
    Senergyinitial = m.ext[:parameters][:Senergyinitial]
    Senergyend = m.ext[:parameters][:Senergyend]
    Sdeployment = m.ext[:parameters][:Sdeployment]
    Sreservecost = m.ext[:parameters][:Sreservecost]
    storage_bus = m.ext[:parameters][:storage_bus]
    
    #Area elements
    S1= m.ext[:sets][:S1]
    S2= m.ext[:sets][:S2]
    E1= m.ext[:sets][:E1]
    E2= m.ext[:sets][:E2]
    G1 = m.ext[:sets][:G1]
    G2 = m.ext[:sets][:G2]
    CV1 = m.ext[:sets][:CV1]
    CV2 = m.ext[:sets][:CV2]
    G_wind=m.ext[:sets][:G_wind]
    G_wind_1=m.ext[:sets][:G_wind_1]
    G_wind_2=m.ext[:sets][:G_wind_2]
    G_solar=m.ext[:sets][:G_solar]
    G_solar_1=m.ext[:sets][:G_solar_1]
    G_solar_2=m.ext[:sets][:G_solar_2]
    G_reservoir_1=m.ext[:sets][:G_reservoir_1]
    G_reservoir_2=m.ext[:sets][:G_reservoir_2]
    G_pump_1=m.ext[:sets][:G_pump_1]
    G_pump_2=m.ext[:sets][:G_pump_2]
    G_nuclear_1=m.ext[:sets][:G_nuclear_1]
    G_nuclear_2=m.ext[:sets][:G_nuclear_2]
    G_gas_1=m.ext[:sets][:G_gas_1]
    G_gas_2=m.ext[:sets][:G_gas_2]
    G_biomass_1=m.ext[:sets][:G_biomass_1]
    G_biomass_2=m.ext[:sets][:G_biomass_2]
    G_oil_1=m.ext[:sets][:G_oil_1]
    G_oil_2=m.ext[:sets][:G_oil_2]
    all_contingencies = m.ext[:sets][:all_contingencies]
    TG=vcat(G_nuclear, G_gas, G_biomass, G_oil)
    TG1=vcat(G_nuclear_1, G_gas_1, G_biomass_1, G_oil_1) #Thermal 1
    TG2=vcat(G_nuclear_2, G_gas_2, G_biomass_2, G_oil_2) #Thermal 2
    Set_WWS=m.ext[:sets][:WWS] = setdiff(m.ext[:sets][:G], m.ext[:sets][:G_solar],m.ext[:sets][:G_wind])
    Set_WWS1=m.ext[:sets][:WWS1] = setdiff(m.ext[:sets][:G1], m.ext[:sets][:G_solar_1],m.ext[:sets][:G_wind_1])
    Set_WWS2=m.ext[:sets][:WWS2] = setdiff(m.ext[:sets][:G2], m.ext[:sets][:G_solar_2],m.ext[:sets][:G_wind_2])



    ##### Create variables 
    # AC components
    # Bus variables



   
    # Generator variables
    pg = m.ext[:variables][:pg] = @variable(m, [g=G,t=T],lower_bound=0, upper_bound=pmax[g], base_name = "pg") # active power generation
    rg_lg1 = m.ext[:variables][:rg_lg1] = @variable(m, [g=G1,t=T],lower_bound=0,upper_bound=upramp[g]*G_dt[g]/3600, base_name = "rg_lg1") # frequency reserve generators loss of generation area 1
    rg_lc1 = m.ext[:variables][:rg_lc1] = @variable(m, [g=G1,t=T],lower_bound=0, upper_bound=upramp[g]*G_dt[g]/3600, base_name = "rg_lc1") # frequency reserve generators loss of converter area 1
    rg_lg2 = m.ext[:variables][:rg_lg2] = @variable(m, [g=G2,t=T],lower_bound=0, upper_bound=upramp[g]*G_dt[g]/3600, base_name = "rg_lg2") # frequency reserve generators loss of generation area 2
    rg_lc2 = m.ext[:variables][:rg_lc2] = @variable(m, [g=G2,t=T],lower_bound=0, upper_bound=upramp[g]*G_dt[g]/3600, base_name = "rg_lc2") # frequency reserve generators loss of converter area 2
    rg_l_reserve_1= m.ext[:variables][:rg_l_reserve_1] = @variable(m, [g=G1,t=T],lower_bound=0,upper_bound=upramp[g]*G_dt[g]/3600, base_name = "rg_l_reserve_1") # frequency reserve generators loss of generation area 
    rg_l_reserve_2= m.ext[:variables][:rg_l_reserve_2] = @variable(m, [g=G2,t=T],lower_bound=0, upper_bound=upramp[g]*G_dt[g]/3600, base_name = "rg_l_reserve_2") # frequency reserve generators loss of generation area 2

    
    # Branch variables
  

    # Status variable generators
    zg = m.ext[:variables][:zg] = @variable(m, [g=G,t=T],binary= true , base_name = "zg") # status variable generator
    betag = m.ext[:variables][:betag] = @variable(m, [g=G,t=T], binary= true, base_name = "betag") #
    gammag = m.ext[:variables][:gammag] = @variable(m, [g=G,t=T], binary= true, base_name = "gammag") #
    δg= m.ext[:variables][:δg] = @variable(m, [g=G,t=T], binary=true, base_name="δg") #Binary variable event generator
    

    # DC components
    
    # Branches
    brdc_p = m.ext[:variables][:brdc_p] = @variable(m, [(d,e,f)=BD_dc, t=T], lower_bound=-brdc_rate_a[d], upper_bound=brdc_rate_a[d], base_name="brdc_p")
    conv_p_ac = m.ext[:variables][:conv_p_ac] = @variable(m, [cv=CV,t=T], lower_bound=-conv_p_ac_max[cv], upper_bound=conv_p_ac_max[cv], base_name="conv_p_ac") # converter active power
    conv_p_ac_abs = m.ext[:variables][:conv_p_ac_abs] = @variable(m, [cv=CV,t=T], lower_bound=0,upper_bound=conv_p_ac_max[cv], base_name="conv_p_ac_abs") # absorve power converter
    conv_p_ac_inj= m.ext[:variables][:conv_p_ac_inj] = @variable(m, [cv=CV,t=T], lower_bound=0, upper_bound=conv_p_ac_max[cv], base_name="conv_p_ac_inj") # injected power converter
    u_conv_p_ac = m.ext[:variables][:u_conv_p_ac] = @variable(m, [cv=CV,t=T], binary=true, base_name="u_conv_p_ac") # binary variable for converter active power
    conv_p_dc = m.ext[:variables][:conv_p_dc] = @variable(m, [cv=CV,t=T], lower_bound=-conv_p_dc_max[cv], upper_bound=conv_p_dc_max[cv], base_name="conv_p_dc") # converter active power
    δhvdc= m.ext[:variables][:δhvdc] = @variable(m, [cv=CV,t=T], binary=true, base_name="δhvdc") #binary variable event converter
    rhvdc_lg1 = m.ext[:variables][:rhvdc_lg1] = @variable(m, [cv=CV1,t=T], lower_bound=0,  upper_bound=2*(40/40)conv_p_dc_max[cv], base_name="rhvdc_lg1") #frequency reserve HHDC loss of generation area 1
    rhvdc_lc1 = m.ext[:variables][:rhvdc_lc1] = @variable(m, [cv=CV1,t=T], lower_bound=0,  upper_bound=2*(40/40)conv_p_dc_max[cv], base_name="rhvdc_lc1") #frequency reserve HVDC loss of converter area 1
    rhvdc_lg2 = m.ext[:variables][:rhvdc_lg2] = @variable(m, [cv=CV2,t=T], lower_bound=0,  upper_bound=2*(40/40)conv_p_dc_max[cv], base_name="rhvdc_lg2") #frequency reserve HVDC loss of generation area 2
    rhvdc_lc2 = m.ext[:variables][:rhvdc_lc2] = @variable(m, [cv=CV2,t=T], lower_bound=0,  upper_bound=2*(40/40)conv_p_dc_max[cv], base_name="rhvdc_lc2") #frequency reserve HVDC loss of converter area 2

   #Reservoir storage variables
    e_reservoir = m.ext[:variables][:e_reservoir] = @variable(m, [g=G_reservoir,t=T], lower_bound=0, upper_bound=G_storage[g], base_name = "e_reservoir") # energy storage reservoir
     #Pump generators variables
    p_charge_pump = m.ext[:variables][:p_charge_pump] = @variable(m, [g=G_pump,t=T], base_name = "p_charge_pump")
    e_pump = m.ext[:variables][:e_pump] = @variable(m, [g=G_pump,t=T], lower_bound=0, upper_bound=G_storage[g], base_name = "e_pump") # energy storage pump
   

    # Electrolyzer variables
    pe= m.ext[:variables][:pe] = @variable(m, [e=E,t=T], lower_bound=0, upper_bound=Epmax[e], base_name="pe") # Electrolyzer power consumption
    pe_compressor= m.ext[:variables][:pe_compressor] = @variable(m, [e=E,t=T], lower_bound=0, base_name="pe_compressor") # Electrolyzer power consumption for compressor
    pes= m.ext[:variables][:pes] = @variable(m, [e=E,t=T], lower_bound=0, base_name="pes") # Electrolyzer reserve power
    hfe= m.ext[:variables][:hfe] = @variable(m, [e=E,t=T], lower_bound=0, upper_bound=Eflowmax[e], base_name="hfe") # Electrolyzer hydrogen flow
    hfginyect= m.ext[:variables][:hfginyect] = @variable(m, [e=E,t=T], lower_bound=0, upper_bound=Eflowmax[e], base_name="hfginyect") # Electrolyzer hydrogen flow injected to the hydrogen grid
    hfgconsum= m.ext[:variables][:hfgconsum] = @variable(m, [e=E,t=T], lower_bound=0, upper_bound=Eflowmax[e], base_name="hfgconsum") # Electrolyzer hydrogen flow consumed from the hydrogen grid
    hss= m.ext[:variables][:hss] = @variable(m, [e=E,t=T], lower_bound=Estoragemin[e], upper_bound=Estoragemax[e], base_name="hss") # Electrolyzer storage level
    ze= m.ext[:variables][:ze] = @variable(m, [e=E,t=T], binary=true, base_name="ze") # Electrolyzer status
    zesu= m.ext[:variables][:zesu] =@variable(m, [e=E,t=T], binary=true, base_name="zesu") #Electrolyzer start up 
    zestb= m.ext[:variables][:zestb] = @variable(m, [e=E,t=T], binary=true, base_name="zestb") #Electrolyzer stanby indicator
    re_lg1=  m.ext[:variables][:re_lg1] = @variable(m, [e=E1,t=T], lower_bound=0, base_name="re_lg1") #frequency reserve electrolyzers loss of generation area 1
    re_lc1=  m.ext[:variables][:re_lc1] = @variable(m, [e=E1,t=T], lower_bound=0, base_name="re_lc1") #frequency reserve electrolyzers loss of converter area 1
    re_lg2=  m.ext[:variables][:re_lg2] = @variable(m, [e=E2,t=T], lower_bound=0, base_name="re_lg2") #frequency reserve electrolyzer loss of generation area 2
    re_lc2=  m.ext[:variables][:re_lc2] = @variable(m, [e=E2,t=T], lower_bound=0, base_name="re_lc2") #frequency reserve electrolyzer loss of converter area 2
    re_l_reserve_1= m.ext[:variables][:re_l_reserve_1] = @variable(m, [e=E1,t=T], lower_bound=0, base_name="re_l_reserve_1") #frequency reserve for FCR provision
    re_l_reserve_2= m.ext[:variables][:re_l_reserve_2] = @variable(m, [e=E2,t=T], lower_bound=0, base_name="re_l_reserve_2") #frequency reserve for FCR provision

    
    # Storage variables
    psc = m.ext[:variables][:psc] = @variable(m, [s=S,t=T],lower_bound=0, base_name="psc") #Charging power of the batteries
    psd = m.ext[:variables][:psd] = @variable(m, [s=S,t=T],lower_bound=0, base_name="psd") #Discharging power of the batteries
    es = m.ext[:variables][:es] = @variable(m, [s=S,t=T], lower_bound= Sstoragemax[s]*(1-Sdod[s]), upper_bound=Sstoragemax[s] , base_name="es") #Energy bounds of the batteries
    zs = m.ext[:variables][:zs] = @variable(m, [s=S,t=T], binary=true, base_name="zb") #standby indicator of the batteries
    rs_lg1=  m.ext[:variables][:rs_lg1] = @variable(m, [s=S1,t=T], lower_bound=0, base_name="rs_lg1") #frequency reserve batteries loss of generation area 1
    rs_lg2=  m.ext[:variables][:rs_lg2] = @variable(m, [s=S2,t=T], lower_bound=0, base_name="rs_lg2") #frequency reserve batteries loss of generation area 2
    rs_lc1=  m.ext[:variables][:rs_lc1] = @variable(m, [s=S1,t=T], lower_bound=0, base_name="rs_lc1") #frequency reserve batteries loss of converter area 1
    rs_lc2=  m.ext[:variables][:rs_lc2] = @variable(m, [s=S2,t=T], lower_bound=0, base_name="rs_lc2") #frequency reserve batteries loss of converter area 2
    rs_l_reserve_1= m.ext[:variables][:rs_l_reserve_1] = @variable(m, [s=S1,t=T], lower_bound=0, base_name="rs_l_reserve_1") #frequency reserve for FCR provision
    rs_l_reserve_2= m.ext[:variables][:rs_l_reserve_2] = @variable(m, [s=S2,t=T], lower_bound=0, base_name="rs_l_reserve_2") #frequency reserve for FCR provision


    # Frequency stability variables
    plg1= m.ext[:variables][:plg1] = @variable(m, [t=T], lower_bound=0, base_name="plg1") # loss of power generators area 1
    plg2= m.ext[:variables][:plg2] = @variable(m, [t=T], lower_bound=0, base_name="plg2") # loss of power generators area 2
    plc1= m.ext[:variables][:plc1] = @variable(m, [t=T], lower_bound=0, base_name="plc1") # loss of power converters area 1
    plc2= m.ext[:variables][:plc2] = @variable(m, [t=T], lower_bound=0, base_name="plc2") # loss of power converters area 2
    plreserve_1= m.ext[:variables][:plreserve_1] = @variable(m, [t=T], lower_bound=0, base_name="plreserve_1") # loss of power due to the FCR provision
    plreserve_2= m.ext[:variables][:plreserve_2] = @variable(m, [t=T], lower_bound=0, base_name="plreserve_2") # loss of power due to the FCR provision
    


    #Auxiliary variables for rotated second order cone constraints
    ypg1 = m.ext[:variables][:ypg1] = @variable(m, [t=T],lower_bound=0, base_name="ypg1") #Auxiliary variable rotate second order cone generators fault area 1
    zpg1 = m.ext[:variables][:zpg1] = @variable(m, [t=T],lower_bound=0, base_name="zpg1") #Auxiliary variable rotate second order cone generators fault area 1
    ypc1 = m.ext[:variables][:ypc1] = @variable(m, [t=T],lower_bound=0, base_name="ypc1") #Auxiliary variable rotate second order cone converters fault area 1
    zpc1 = m.ext[:variables][:zpc1] = @variable(m, [t=T],lower_bound=0, base_name="zpc1") #Auxiliary variable rotate second order cone converters fault area 1
    ypg2 = m.ext[:variables][:ypg2] = @variable(m, [t=T],lower_bound=0, base_name="ypg2") #Auxiliary variable rotate second order cone generators fault area 2
    zpg2 = m.ext[:variables][:zpg2] = @variable(m, [t=T],lower_bound=0, base_name="zpg2") #Auxiliary variable rotate second order cone generators fault area 2
    ypc2 = m.ext[:variables][:ypc2] = @variable(m, [t=T],lower_bound=0, base_name="ypc2") #Auxiliary variable rotate second order cone converters fault area 2
    zpc2 = m.ext[:variables][:zpc2] = @variable(m, [t=T],lower_bound=0, base_name="zpc2") #Auxiliary variable rotate second order cone converters fault area 2
    ypreserve1 = m.ext[:variables][:ypreserve1] = @variable(m, [t=T],lower_bound=0, base_name="ypreserve1") #Auxiliary variable rotate second order cone reserve provision fault area 1
    zpreserve1 = m.ext[:variables][:zpreserve1] = @variable(m, [t=T],lower_bound=0, base_name="zpreserve1") #   Auxiliary variable rotate second order cone reserve provision fault area 1
    ypreserve2 = m.ext[:variables][:ypreserve2] = @variable(m, [t=T],lower_bound=0, base_name="ypreserve2") #Auxiliary variable rotate second order cone reserve provision fault area 2
    zpreserve2 = m.ext[:variables][:zpreserve2] = @variable(m, [t=T],lower_bound=0, base_name="zpreserve2") #Auxiliary variable rotate second order cone reserve provision fault area 2
    # Other variables
   
    #Second stage variables
    
    keys_contingency = collect(keys(all_contingencies))


    

    ##### Objective
    max_gen_ncost = m.ext[:parameters][:gen_max_ncost]
    if max_gen_ncost == 1
        m.ext[:objective] = @objective(m, Min,
                sum(gen_cost[g][1]
                        for g in G)
                            +sum(start_up_cost[g]*betag[g,t] for g in G, t in T)
                            +sum(Estartupcost[e]*zesu[e,t] for e in E, t in T)*baseMVA
                            +sum(Hydrogencost[e]*baseKG*(-hfginyect[e,t]+hfgconsum[e,t]) for e in E, t in T)
                            +sum(Ereservecost[e]*re_lg1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lg2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_2[e,t] for e in E2, t in T)*baseMVA

                            +sum(Sreservecost[s]*rs_lg1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lg2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_2[s,t] for s in S2, t in T)*baseMVA

                            +sum(G_reservecost[g]*rg_lg1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lg2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_2[g,t] for g in G2, t in T)*baseMVA
                             

        )
    elseif max_gen_ncost == 2
       m.ext[:objective] = @objective(m, Min,
            sum(gen_cost[g][1] * pg[g, t] + gen_cost[g][2] 
                    for g in G, t in T)
                            +sum(Estartupcost[e]*zesu[e,t] for e in E, t in T)
                            +sum(start_up_cost[g]*betag[g,t] for g in G, t in T)
                            +sum(Hydrogencost[e]*baseKG*(-hfginyect[e,t]+hfgconsum[e,t]) for e in E, t in T)
                            +sum(Ereservecost[e]*re_lg1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lg2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_2[e,t] for e in E2, t in T)*baseMVA

                            +sum(Sreservecost[s]*rs_lg1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lg2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_2[s,t] for s in S2, t in T)*baseMVA

                            +sum(G_reservecost[g]*rg_lg1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lg2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_2[g,t] for g in G2, t in T)*baseMVA

        )
    elseif max_gen_ncost == 3
        m.ext[:objective] = @objective(m, Min,
                sum(c[g][1]*pg[g,t]^2 + gen_cost[g][2]*pg[g,t] + gen_cost[g][3]
                        for g in G, t in T)
                            +sum(Estartupcost[e]*zesu[e,t] for e in E, t in T)
                            +sum(start_up_cost[g]*betag[g,t] for g in G, t in T)
                            +sum(Hydrogencost[e]*baseKG*(-hfginyect[e,t]+hfgconsum[e,t]) for e in E, t in T)
                            +sum(Ereservecost[e]*re_lg1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lg2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_2[e,t] for e in E2, t in T)*baseMVA

                            +sum(Sreservecost[s]*rs_lg1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lg2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_2[s,t] for s in S2, t in T)*baseMVA

                            +sum(G_reservecost[g]*rg_lg1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lg2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_2[g,t] for g in G2, t in T)*baseMVA
                             
       )   
    elseif max_gen_ncost == 4
        m.ext[:objective] = @NLobjective(m, Min,
                sum(gen_cost[g][1]*pg[g,t]^3 + gen_cost[g][2]*pg[g,t]^2 + gen_cost[g][3]*pg[g,t] + gen_cost[g][4]
                        for g in G, t in T)
                            +sum(Estartupcost[e]*zesu[e,t] for e in E, t in T)
                            +sum(start_up_cost[g]*betag[g,t] for g in G, t in T)
                            +sum(Hydrogencost[e]*baseKG*(-hfginyect[e,t]+hfgconsum[e,t]) for e in E, t in T)
                            +sum(Ereservecost[e]*re_lg1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lg2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_lc2[e,t] for e in E2, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_1[e,t] for e in E1, t in T)*baseMVA
                            +sum(Ereservecost[e]*re_l_reserve_2[e,t] for e in E2, t in T)*baseMVA

                            +sum(Sreservecost[s]*rs_lg1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lg2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_lc2[s,t] for s in S2, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_1[s,t] for s in S1, t in T)*baseMVA
                            +sum(Sreservecost[s]*rs_l_reserve_2[s,t] for s in S2, t in T)*baseMVA

                            +sum(G_reservecost[g]*rg_lg1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lg2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_lc2[g,t] for g in G2, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_1[g,t] for g in G1, t in T)*baseMVA
                            +sum(G_reservecost[g]*rg_l_reserve_2[g,t] for g in G2, t in T)*baseMVA

                             
       )
    end

    ####################################################################################################
    ####################    AC NETWORK AND AC/DC CONSTRAINTS
    ####################################################################################################
    

    # Bus angle difference limits

        # Voltage angle on reference bus = 0



    #Nodal power balance constraint AC taken from https://github.com/Electa-Git/OPES/blob/main/opf_acdc/build_ac_opf_acdc_tap.jl line 421
        m.ext[:constraints][:power_balance_1] = @constraint(m, [t=T],
        sum(pg[g,t] for g in G1 )-sum(p_charge_pump[g,t] for g in G_pump_1)+  sum(conv_p_ac[cv,t] for cv in CV1) +sum(psd[s,t] for s in S1)-sum(psc[s,t] for s in S1)-sum(pe[e,t] for e in E1) -sum(pe_compressor[e,t] for e in E1)-demand["1"][t]== 0 #3.7
        )
        m.ext[:constraints][:power_balance_2] = @constraint(m, [t=T],
        sum(pg[g,t] for g in G2 )-sum(p_charge_pump[g,t] for g in G_pump_2)+  sum(conv_p_ac[cv,t] for cv in CV2) +sum(psd[s,t] for s in S2)-sum(psc[s,t] for s in S2)-sum(pe[e,t] for e in E2) -sum(pe_compressor[e,t] for e in E2)-demand["2"][t]== 0 #3.7
        )

    #Online-unit contingency eligibility constraint
    m.ext[:constraints][:event_binary_constraint]= @constraint(m, [g=G,t=T],
    zg[g,t]>=δg[g,t])

    #Enforce  hvdc links power flow direction constraints
    # m.ext[:constraints][:hvdc_flow_direction_1] = @constraint(m, [t=T],
    #     conv_p_ac["2",t]==-conv_p_ac_max["2"])

    # m.ext[:constraints][:hvdc_flow_direction_2] = @constraint(m, [t=T],
    # conv_p_ac["3",t]==-conv_p_ac_max["3"])



    # Power flow constraints in from and to direction



    # # Power flow constraints in from and to direction
    # m.ext[:constraints][:pbij] = @constraint(m, [(b,i,j) = B_ac_fr,t=T], pb[(b, i, j),t] ==  - 1/0.13*  (va[i,t] - va[j,t])) # active power i to j
    # m.ext[:constraints][:pbji] = @constraint(m, [(b,j,i) = B_ac_to,t=T], pb[(b, j, i),t] ==  - 1/0.13* (va[j,t] - va[i,t])) # active power j to i

    # # Branch angle limits
    # m.ext[:constraints][:thetaij] = @constraint(m, [(b,i,j) = B_ac_fr,t=T], va[i,t] - va[j,t] <= angmax[b])
    # m.ext[:constraints][:thetaji] = @constraint(m, [(b,i,j) = B_ac_fr,t=T], va[i,t] - va[j,t] >= angmin[b])
    # m.ext[:constraints][:thetaij] = @constraint(m, [(b,j,i) = B_ac_to,t=T], va[j,t] - va[i,t] <= angmax[b])
    # m.ext[:constraints][:thetaji] = @constraint(m, [(b,j,i) = B_ac_to,t=T], va[j,t] - va[i,t] >= angmin[b])
  

     # active power i to j (I am not sure if this constraints has to be)
    #m.ext[:constraints][:pbji] = @constraint(m, [(b,j,i) = B_ac_to,t=T],      
    # pb[(b, i, j),t] ==  1/0.13*(va[i,t] - va[j,t])
    #)

 


    # Nodal power balance DC  taken from https://github.com/Electa-Git/OPES/blob/main/opf_acdc/build_ac_opf_acdc_tap.jl line 431
    m.ext[:constraints][:nodal_p_dc_balance] = @constraint(m, [nd=ND,t=T],
        sum(conv_p_dc[cv,t] for cv in CV if conv_busdc[cv] == nd)- sum(brdc_p[(d,f,e),t] for (d,f,e) in ND_arcs[nd])==0
         
         )#3.14

    # Converter AC-side and DC-side power balance taken from https://github.com/Electa-Git/OPES/blob/main/opf_acdc/build_ac_opf_acdc_tap.jl line 408
        m.ext[:constraints][:conv_p_loss] = @constraint(m, [cv=CV,t=T],
        conv_p_ac[cv,t] + conv_p_dc[cv,t]==0
    )#3.17

    #Converter Net Power Balance
    m.ext[:constraints][:conv_injec_ac_abs_inj] = @constraint(m, [cv=CV,t=T],
    conv_p_ac[cv,t] == conv_p_ac_inj[cv,t]-conv_p_ac_abs[cv,t]
    )

                    #It is assumed that the reactance is 0.13 p.u. based on the test system data
    m.ext[:constraints][:direccional_flow_dc] = @constraint(m, [(d,f,e) = BD_dc_fr,t=T],
        brdc_p[(d,f,e),t] ==  -brdc_p[(d, e, f),t]
        )

    #Converter injection and absorption limits
    m.ext[:constraints][:conv_injec_ac_limit] = @constraint(m, [cv=CV,t=T],
    conv_p_ac_inj[cv,t] <= conv_p_ac_max[cv]*u_conv_p_ac[cv,t]
    )
    m.ext[:constraints][:conv_abs_limit] = @constraint(m, [cv=CV,t=T],
    conv_p_ac_abs[cv,t] <= conv_p_ac_max[cv]*(1-u_conv_p_ac[cv,t])
    )
       #Solar generation constraint
    m.ext[:constraints][:solar_generation_1] = @constraint(m, [g=G_solar_1,t=T],
        pg[g,t] <= capacity_factor_solar["Nordic"][t]*pmax[g]
    )
    m.ext[:constraints][:solar_generation_2] = @constraint(m, [g=G_solar_2,t=T],
        pg[g,t] <= capacity_factor_solar["GB"][t]*pmax[g]
    )
  

     #wind gneration constraint
    m.ext[:constraints][:wind_generation] = @constraint(m, [g=G_wind_1,t=T],
        pg[g,t] <= capacity_factor_wind["Nordic"][t]*pmax[g]
    )

    m.ext[:constraints][:wind_generation_2] = @constraint(m, [g=G_wind_2,t=T],
        pg[g,t] <= capacity_factor_wind["GB"][t]*pmax[g]
    )
    #Renewable frecuency reserve constraints
    renewable_1=vcat(G_solar_1,G_wind_1)
    renewable_2=vcat(G_solar_2,G_wind_2)

    m.ext[:constraints][:renewable_reserve_rg_lg1] = @constraint(m, [g=renewable_1,t=T],
    rg_lg1[g,t] == 0
    )
    
    m.ext[:constraints][:renewable_reserve_rg_lc1] = @constraint(m, [g=renewable_1,t=T],
    rg_lc1[g,t] == 0
    )
    
    m.ext[:constraints][:renewable_reserve_l_reserve_1] = @constraint(m, [g=renewable_1,t=T],
    rg_l_reserve_1[g,t] == 0
    )

    m.ext[:constraints][:renewable_reserve_rg_lg2] = @constraint(m, [g=renewable_2,t=T],
    rg_lg2[g,t] == 0
    )

    m.ext[:constraints][:renewable_reserve_rg_lc2] = @constraint(m, [g=renewable_2,t=T],
    rg_lc2[g,t] == 0
    )

    m.ext[:constraints][:renewable_reserve_l_reserve_2] = @constraint(m, [g=renewable_2,t=T],
    rg_l_reserve_2[g,t] == 0
    )

    #On status of nuclear generators constraint
    m.ext[:constraints][:nuclear_status] = @constraint(m, [g=G_nuclear,t=T],
    zg[g,t] == 1
    )
    #Unit commitment constraints
  m.ext[:constraints][:max_gen_power] = @constraint(m, [g=G,t=T],
        pg[g,t] <= pmax[g]*zg[g,t]
        )#3.11

    m.ext[:constraints][:min_gen_power] = @constraint(m, [g=G,t=T],
        pg[g,t]>= pmin[g]*zg[g,t]
        )#3.11

        m.ext[:constraints][:max_gen_power_rg_g_1] = @constraint(m, [g=G1,t=T],
        pg[g,t]+ rg_lg1[g,t]<= pmax[g]*zg[g,t]
        )

        m.ext[:constraints][:min_gen_power_rg_g_1] = @constraint(m, [g=G1,t=T],
         pg[g,t]+ rg_lg1[g,t]>= pmin[g]*zg[g,t]
        )

        m.ext[:constraints][:max_gen_power_rg_c_1] = @constraint(m, [g=G1,t=T],
        pg[g,t]+ rg_lc1[g,t]<= pmax[g]*zg[g,t]
        )

        m.ext[:constraints][:min_gen_power_rg_c_1] = @constraint(m, [g=G1,t=T],
         pg[g,t]+ rg_lc1[g,t]>= pmin[g]*zg[g,t]
        )

        m.ext[:constraints][:max_gen_power_rg_reserve_1] = @constraint(m, [g=G1,t=T],
        pg[g,t]+ rg_l_reserve_1[g,t]<= pmax[g]*zg[g,t]
        )

        m.ext[:constraints][:min_gen_power_rg_reserve_1] = @constraint(m, [g=G1,t=T],
         pg[g,t]+ rg_l_reserve_1[g,t]>= pmin[g]*zg[g,t]
        )

        m.ext[:constraints][:max_gen_power_rg_g_2] = @constraint(m, [g=G2,t=T],
        pg[g,t]+ rg_lg2[g,t]<= pmax[g]*zg[g,t]
        )

        m.ext[:constraints][:min_gen_power_rg_g_2] = @constraint(m, [g=G2,t=T],
         pg[g,t]+ rg_lg2[g,t]>= pmin[g]*zg[g,t]
        )

        m.ext[:constraints][:max_gen_power_rg_c_2] = @constraint(m, [g=G2,t=T],
        pg[g,t]+ rg_lc2[g,t]<= pmax[g]*zg[g,t]
        )

        m.ext[:constraints][:min_gen_power_rg_c_2] = @constraint(m, [g=G2,t=T],
         pg[g,t]+ rg_lc2[g,t]>= pmin[g]*zg[g,t]
        )

         m.ext[:constraints][:max_gen_power_rg_reserve_2] = @constraint(m, [g=G2,t=T],
        pg[g,t]+ rg_l_reserve_2[g,t]<= pmax[g]*zg[g,t]
        )

        m.ext[:constraints][:min_gen_power_rg_reserve_2] = @constraint(m, [g=G2,t=T],
         pg[g,t]+ rg_l_reserve_2[g,t]>= pmin[g]*zg[g,t]
        )

    #Unit commitment constraints

    Tlabels = collect(T)         # ensure indexable by position
    NT = length(Tlabels)

    #Ramp-down limit for generators
          m.ext[:constraints][:up_and_down_2_b] = @constraint(m, [g in TG, k in 2:NT],
        pg[g, Tlabels[k-1]] - pg[g, Tlabels[k]] <= downramp[g]+pmin[g]*gammag[g, Tlabels[k]]
    )#3.20


    #Ramp-up limit for generators
        m.ext[:constraints][:up_and_down_2_a] = @constraint(m, [g in TG, k in 2:NT],
        pg[g, Tlabels[k]] - pg[g, Tlabels[k-1]] <= upramp[g]+(pmin[g]- upramp[g])*betag[g, Tlabels[k]]
    )#3.19

 

 
  #Initial status generators (unit commitment)
        m.ext[:constraints][:up_and_down_3] = @constraint(m, [g in TG],
        1 - zg[g, Tlabels[1]] + betag[g, Tlabels[1]] - gammag[g, Tlabels[1]] == 0
    )

    #Status generators (unit commitment)
        m.ext[:constraints][:up_and_down_4] = @constraint(m, [g in TG, k in 2:NT],
        zg[g, Tlabels[k-1]] - zg[g, Tlabels[k]] + betag[g, Tlabels[k]] - gammag[g, Tlabels[k]] == 0
    )#3.23

    #Startup and shutdown exclusivity
        m.ext[:constraints][:up_and_down_4_1] = @constraint(m, [g in TG, t in T],
        betag[g,t] + gammag[g,t] <= 1
    )

    #Minimum up time constraint
        m.ext[:constraints][:up_and_down_6] = Dict()
        for g in TG
            if MUT[g] > 0  # Only proceed if MUT[g] is positive
                for k in MUT[g]:NT
                    m.ext[:constraints][:up_and_down_6][g, Tlabels[k]] = @constraint(m,
                    zg[g, Tlabels[k]] >= sum(betag[g, Tlabels[k-τ]] for τ in 0:MUT[g]-1)#3.22
                    )
                end
            end
        end
        



    #Minimum down time constraint
    m.ext[:constraints][:up_and_down_7] = Dict()
    for g in TG
        if MDT[g] > 0  # Only proceed if MDT[g] is positive
            for k in MDT[g]:NT
                m.ext[:constraints][:up_and_down_7][g, Tlabels[k]] = @constraint(m,
                1 - zg[g, Tlabels[k]] >= sum(gammag[g, Tlabels[k-τ]] for τ in 0:MDT[g]-1)#3.21
                )
            end
        end
    end

#Storage constraints

    m.ext[:constraints][:upper_bound_storage_charging] = @constraint(m, [s = S, t = T],
    psc[s,t] <= Spmax[s] * (1 - zs[s,t])
    )#3.25

    m.ext[:constraints][:upper_bound_storage_discharging] = @constraint(m, [s = S, t = T],
    psd[s,t] <= Spmax[s] * zs[s,t]
    )#3.26


        # Initial energy value of the batteries
        m.ext[:constraints][:initial_energy_value] = @constraint(m, [s in S],
            es[s, Tlabels[1]] == Senergyinitial[s]
        )#3.27


        # End energy value of the batteries
        
        m.ext[:constraints][:end_energy_value] = @constraint(m, [s in S],
            Senergyend[s] - es[s, Tlabels[NT]] ==
                Sefficiencycarga[s] * psc[s, Tlabels[NT]] -
                psd[s, Tlabels[NT]] / Sefficiencydischarge[s]
        )#3.27

        # Charging–discharging energy balance of the batteries
        m.ext[:constraints][:energy_balance] = @constraint(m, [s in S, k in 1:NT-1],
        es[s, Tlabels[k+1]] - es[s, Tlabels[k]] ==
            Sefficiencycarga[s] * psc[s, Tlabels[k]] -
            psd[s, Tlabels[k]] / Sefficiencydischarge[s]
    )#3.27



        #Reservoir constraints
 m.ext[:constraints][:initial_energy_value_reservoir] = @constraint(m, [g in G_reservoir],
        e_reservoir[g, Tlabels[1]] == E_reservoirs_ini[g]
    )

    
    m.ext[:constraints][:end_energy_value_reservoir] = @constraint(m, [g in G_reservoir],
        E_reservoirs_end[g] <=
            e_reservoir[g, Tlabels[NT]] -
            pg[g, Tlabels[NT]]/G_ngenerating[g]
    )

    m.ext[:constraints][:transition_energy_value_reservoir]=@constraint(m, [g in G_reservoir, k in 1:NT-1],
        e_reservoir[g, Tlabels[k+1]] ==
            e_reservoir[g, Tlabels[k]] -
            pg[g, Tlabels[k]]/G_ngenerating[g]
    )

         #Pump constraints
    #-P_pump is included since the charging of the pump is provided as a negative power in the input data.
    m.ext[:constraints][:upper_bound_pump_charging] = @constraint(m, [g = G_pump, t = T],
    p_charge_pump[g,t] <= (-P_pump[g] )* (1 -zg[g,t])
    )

    #Minimun charging power assumed as 10% of the maximum charging power (this is an assumption that can be changed based on the characteristics of the pump)
    m.ext[:constraints][:lower_bound_pump_charging] = @constraint(m, [g = G_pump, t = T],
    p_charge_pump[g,t] >= 0.1*(-P_pump[g] )* (1 -zg[g,t])
    )


    m.ext[:constraints][:initial_energy_value_pump] = @constraint(m, [g in G_pump],
        e_pump[g, Tlabels[1]] == E_reservoirs_ini[g]
    )

    m.ext[:constraints][:end_energy_value_pump] = @constraint(m, [g in G_pump],
        E_reservoirs_end[g] ==
            e_pump[g, Tlabels[NT]] +
            p_charge_pump[g, Tlabels[NT]]*G_npumping[g] -
            pg[g, Tlabels[NT]]/G_ngenerating[g]
    )
    m.ext[:constraints][:energy_balance_pump] = @constraint(m, [g in G_pump, k in 1:NT-1],
        e_pump[g, Tlabels[k+1]] ==
            e_pump[g, Tlabels[k]] +
            p_charge_pump[g, Tlabels[k]]*G_npumping[g] -
            pg[g, Tlabels[k]]/G_ngenerating[g]
    )

    # Electrolyzer constraints

    #Hydrogen production constraint
        m.ext[:constraints][:hydrogen_production] = @constraint(m, [e in E, t in T],
        hfe[e,t] == pe[e,t]/Eefficiency[e]-0.05*Epmax[e]*zestb[e,t]/Eefficiency[e]
        )

    # Bounds on electrolyzer power considering standby
    m.ext[:constraints][:e_lower_bound] = @constraint(m, [e = E, t = T],
    pe[e,t] >= Epmin[e] * ze[e,t] + 0.05 * Epmax[e] * zestb[e,t]
    )    

    m.ext[:constraints][:e_upper_bound] = @constraint(m, [e = E, t = T],
    pe[e,t] <= Epmax[e] * ze[e,t] + 0.05 * Epmax[e] * zestb[e,t]
    )

    # Status constraint of electrolyzers (first time period)
    m.ext[:constraints][:e_status_ini] = @constraint(m, [e in E],
        zesu[e, Tlabels[1]] >= (ze[e, Tlabels[1]] - 1) + (zestb[e, Tlabels[1]] - 0)
    )

    # Startup constraint of electrolyzers (subsequent periods)
    m.ext[:constraints][:e_status_subsequent] = @constraint(m, [e in E, k in 2:NT],
    zesu[e, Tlabels[k]] >=
        (ze[e, Tlabels[k]]     - ze[e, Tlabels[k-1]]) +
        (zestb[e, Tlabels[k]]  - zestb[e, Tlabels[k-1]])
    )

    # Standby constraint of electrolyzers
    m.ext[:constraints][:e_standby] = @constraint(m, [e = E, t = T],
    zestb[e,t] + ze[e,t] <= 1
    )

        
    # Initial value of the hydrogen storage (relation between period 1 and 2)
        m.ext[:constraints][:initial_hydrogen_value] = @constraint(m, [e in E],
            hss[e, Tlabels[1]] == Estorageinitial[e]
        )
    # End value of the hydrogen storage
        m.ext[:constraints][:end_hydrogen_value] = @constraint(m, [e in E],
        Estorageend[e] ==
            hss[e, Tlabels[NT]] +
            hfe[e, Tlabels[NT]] -
            hfginyect[e, Tlabels[NT]] / Eeficiencycarga[e] +
            hfgconsum[e, Tlabels[NT]] * Eeficiencydischarge[e] -
            Eloadfactor[e] * Epmax[e] / Eefficiency[e]
        )

    # Charging–discharging of the hydrogen storage
        m.ext[:constraints][:charging_discharging_hydrogen] = @constraint(m, [e in E, k in 1:NT-1],
            hss[e, Tlabels[k+1]] ==
                hss[e, Tlabels[k]] +
                hfe[e, Tlabels[k]] -
                hfginyect[e, Tlabels[k]] / Eeficiencycarga[e] +
                hfgconsum[e, Tlabels[k]] * Eeficiencydischarge[e] -
                Eloadfactor[e] * Epmax[e] / Eefficiency[e]
        )
    #Compresor power constraint
        m.ext[:constraints][:compressor_power] = @constraint(m, [e in E, t in T],
        pe_compressor[e,t] == Ecompressorpower[e]*(hfe[e,t]+hfgconsum[e,t]+hfginyect[e,t])
        )



    
   


    #Events constraints (loss of generators)

    # m.ext[:constraints][:event_binary_constraint]= @constraint(m, [g=G,t=T],
    # zg[g,t]>=δg[g,t])

    m.ext[:constraints][:gen_constraint_1]= @constraint(m, [g=G1,t=T],
    pg[g,t]<=plg1[t]
    )

    m.ext[:constraints][:gen_constraint_2]= @constraint(m, [g=G2,t=T],
    pg[g,t]<=plg2[t] 
    )
    #Events constraints (loss of converters)
    m.ext[:constraints][:conv_constraint_1]= @constraint(m, [cv=CV1,t=T],
    conv_p_ac_inj[cv,t]<=plc1[t]
    )
    m.ext[:constraints][:conv_constraint_2]= @constraint(m, [cv=CV2,t=T],
    conv_p_ac_inj[cv,t]<=plc2[t]
    )

    #  m.ext[:constraints][:event_binary_constraint_c]= @constraint(m, [cv=CV,t=T],
    # u_conv_p_ac[cv,t]>=δhvdc[cv,t])

    #event constraint (frequency reserve provision)
    m.ext[:constraints][:loss_of_power_frequency_reserve_G_A_1]= @constraint(m, [t=T],
    sum(rhvdc_lg2[cv,t] for cv in CV2)<=plreserve_1[t]
    )
    m.ext[:constraints][:loss_of_power_frequency_reserve_C_A_1]= @constraint(m, [t=T],
    sum(rhvdc_lc2[cv,t] for cv in CV2)<=plreserve_1[t]
    )
    
    m.ext[:constraints][:loss_of_power_frequency_reserve_G_A_2]= @constraint(m, [t=T],
    sum(rhvdc_lg1[cv,t] for cv in CV1)<=plreserve_2[t]
    )
    m.ext[:constraints][:loss_of_power_frequency_reserve_C_A_2]= @constraint(m, [t=T],
    sum(rhvdc_lc1[cv,t] for cv in CV1)<=plreserve_2[t]
    )

    
    #Constraints that define that just one single events is considered per area

    m.ext[:constraints][:single_event_generator_1]= @constraint(m, [t=T],
    sum(δg[g,t] for g in G1) ==1
    )
 
    m.ext[:constraints][:single_event_generator_2]= @constraint(m, [t=T],
    sum(δg[g,t] for g in G2) ==1
    )

      m.ext[:constraints][:single_event_converter_1]= @constraint(m, [t=T],
    sum(δhvdc[cv,t] for cv in CV1) ==1
    )
    m.ext[:constraints][:single_event_converter_2]= @constraint(m, [t=T],
    sum(δhvdc[cv,t] for cv in CV2) ==1
    ) 
 



    bigMG=Dict()
    bigMC=Dict()
    for g in G
        bigMG[g]=pmax[g]
    end

    maxbigMG=maximum(values(bigMG))
    

    for cv in CV
        bigMC[cv]=conv_p_ac_max[cv]
    end

    maxbigMC=maximum(values(bigMC))
   
     m.ext[:constraints][:big_m1_gen_1]= @constraint(m, [g=G1,t=T],
    (δg[g,t]-1)*maxbigMC<= plg1[t]-pg[g,t]
    )
    m.ext[:constraints][:big_m2_gen_1]= @constraint(m, [g=G1,t=T],
    plg1[t]-pg[g,t] <= (1-δg[g,t])*maxbigMG
    )
    
    m.ext[:constraints][:big_m1_gen_2]= @constraint(m, [g=G2,t=T],
    (δg[g,t]-1)*maxbigMG<= plg2[t]-pg[g,t]
    )
    m.ext[:constraints][:big_m2_gen_2]= @constraint(m, [g=G2,t=T],
    plg2[t]-pg[g,t] <= (1-δg[g,t])*maxbigMG
    )

    m.ext[:constraints][:big_m1_conv_1]= @constraint(m, [cv=CV1,t=T],
    (δhvdc[cv,t]-1)*maxbigMC<= plc1[t]-conv_p_ac_inj[cv,t]
    )

    m.ext[:constraints][:big_m2_conv_1]= @constraint(m, [cv=CV1,t=T],
    plc1[t]-conv_p_ac_inj[cv,t] <= (1-δhvdc[cv,t])*maxbigMC
    )

    m.ext[:constraints][:big_m1_conv_2]= @constraint(m, [cv=CV2,t=T],
    (δhvdc[cv,t]-1)*maxbigMC<= plc2[t]-conv_p_ac_inj[cv,t]
    )

    m.ext[:constraints][:big_m2_conv_2]= @constraint(m, [cv=CV2,t=T],
    plc2[t]-conv_p_ac_inj[cv,t] <= (1-δhvdc[cv,t])*maxbigMC
    )

    # Inertia value per area after the event
    Inertia_nadir_frequency_1=Dict()
    Inertia_nadir_frequency_2=Dict()
    Inertia_nadir_frequency_converter_1=Dict()
    Inertia_nadir_frequency_converter_2=Dict()
    for t in T 
        Inertia_nadir_frequency_1[t]=sum((zg[g,t]-δg[g,t])*ic[g]*pmax[g] for g in G1)
        Inertia_nadir_frequency_2[t]=sum((zg[g,t]-δg[g,t])*ic[g]*pmax[g] for g in G2)
        Inertia_nadir_frequency_converter_1[t]=sum(zg[g,t]*ic[g]*pmax[g] for g in G1)
        Inertia_nadir_frequency_converter_2[t]=sum(zg[g,t]*ic[g]*pmax[g] for g in G2)
    end
    

  #bounding the FFR and FCR contributions of all generator andconverter assets
  m.ext[:constraints][:fcr_bound_gen_lg1]= @constraint(m, [g in G1, t in T],
     rg_lg1[g,t]<=(1-δg[g,t])*upramp[g]*G_dt[g]/3600
    )
    m.ext[:constraints][:fcr_bound_gen_lc1]= @constraint(m, [g in G1, t in T],
     rg_lc1[g,t]<=upramp[g]*G_dt[g]/3600
    )

    m.ext[:constraints][:fcr_bound_gen_lreserve_1]= @constraint(m, [g in G1, t in T],
     rg_l_reserve_1[g,t]<=upramp[g]*G_dt[g]/3600
    )
    
    m.ext[:constraints][:fcr_bound_gen_lg2]= @constraint(m, [g in G2, t in T],
     rg_lg2[g,t]<=(1-δg[g,t])*upramp[g]*G_dt[g]/3600
    )

    m.ext[:constraints][:fcr_bound_gen_lc2]= @constraint(m, [g in G2, t in T],
     rg_lc2[g,t]<=upramp[g]*G_dt[g]/3600
    )
    m.ext[:constraints][:fcr_bound_gen_lreserve_2]= @constraint(m, [g in G2, t in T],
     rg_l_reserve_2[g,t]<=upramp[g]*G_dt[g]/3600
    )


    m.ext[:constraints][:fcr_bound_conv_lg1]= @constraint(m, [cv in CV1, t in T],
         rhvdc_lg1[cv,t]<=2*conv_p_ac_max[cv]
     )
     m.ext[:constraints][:fcr_bound_conv_lc1]= @constraint(m, [cv in CV1, t in T],
         rhvdc_lc1[cv,t]<=(1-δhvdc[cv,t])*2*conv_p_ac_max[cv]
     )

    m.ext[:constraints][:fcr_bound_conv_lg2]= @constraint(m, [cv in CV2, t in T],
        rhvdc_lg2[cv,t]<=2*conv_p_ac_max[cv]
    )

    m.ext[:constraints][:fcr_bound_conv_lc2]= @constraint(m, [cv in CV2, t in T],
        rhvdc_lc2[cv,t]<=(1-δhvdc[cv,t])*2*conv_p_ac_max[cv]
    )







    #HVDC headroom reserve constraints
    m.ext[:constraints][:hvdc_headroom_reserve_upper_lg1]= @constraint(m, [cv in CV1, t in T],
        conv_p_ac[cv,t]+rhvdc_lg1[cv,t] <= conv_p_ac_max[cv]
    )

    m.ext[:constraints][:hvdc_headroom_reserve_lower_lg1]= @constraint(m, [cv in CV1, t in T],
        -conv_p_ac_max[cv]<=conv_p_ac[cv,t]+rhvdc_lg1[cv,t] 
    )

    m.ext[:constraints][:hvdc_headroom_reserve_upper_lc1]= @constraint(m, [cv in CV1, t in T],
        conv_p_ac[cv,t]+rhvdc_lc1[cv,t] <= conv_p_ac_max[cv]
    )

    m.ext[:constraints][:hvdc_headroom_reserve_lower_lc1]= @constraint(m, [cv in CV1, t in T],
        -conv_p_ac_max[cv]<=conv_p_ac[cv,t]+rhvdc_lc1[cv,t] 
    )

    m.ext[:constraints][:hvdc_headroom_reserve_upper_lg2]= @constraint(m, [cv in CV2, t in T],
        conv_p_ac[cv,t]+rhvdc_lg2[cv,t] <= conv_p_ac_max[cv]
    )
    m.ext[:constraints][:hvdc_headroom_reserve_lower_lg2]= @constraint(m, [cv in CV2, t in T],
        -conv_p_ac_max[cv]<=conv_p_ac[cv,t]+rhvdc_lg2[cv,t] 
    )

    m.ext[:constraints][:hvdc_headroom_reserve_upper_lc2]= @constraint(m, [cv in CV2, t in T],
        conv_p_ac[cv,t]+rhvdc_lc2[cv,t] <= conv_p_ac_max[cv]
    )

    m.ext[:constraints][:hvdc_headroom_reserve_lower_lc2]= @constraint(m, [cv in CV2, t in T],
        -conv_p_ac_max[cv]<=conv_p_ac[cv,t]+rhvdc_lc2[cv,t] 
    )

        #Reserve storage bound constraints per areas and type of contigency
        m.ext[:constraints][:reserve_storage_lg1]=@constraint(m, [s=S1, t=T],
            rs_lg1[s,t] <=  Spmax[s]+psc[s,t]-psd[s,t]
        )
        m.ext[:constraints][:reserve_storage_lc1]=@constraint(m, [s=S1, t=T],
            rs_lc1[s,t] <=  Spmax[s]+psc[s,t]-psd[s,t]
        )

        m.ext[:constraints][:reserve_storage_l_reserve_1]=@constraint(m, [s=S1, t=T],
        rs_l_reserve_1[s,t] <=  Spmax[s]+psc[s,t]-psd[s,t]
        )

        m.ext[:constraints][:reserve_storage_lg2]=@constraint(m, [s=S2, t=T],
            rs_lg2[s,t] <=  Spmax[s]+psc[s,t]-psd[s,t]
        )
        m.ext[:constraints][:reserve_storage_lc2]=@constraint(m, [s=S2, t=T],
            rs_lc2[s,t] <=  Spmax[s]+psc[s,t]-psd[s,t]
        )
        m.ext[:constraints][:reserve_storage_l_reserve_2]=@constraint(m, [s=S2, t=T],
        rs_l_reserve_2[s,t] <=  Spmax[s]+psc[s,t]-psd[s,t]
        )


        #Reserve electrolyzer bound constraint per areas and type of contigency
        m.ext[:constraints][:reserve_electrolyzer_lg1]=@constraint(m, [e=E1, t=T],
            re_lg1[e,t] <=  pe[e,t]-Epmin[e] * ze[e,t] 
        )
        m.ext[:constraints][:reserve_electrolyzer_lc1]=@constraint(m, [e=E1, t=T],
            re_lc1[e,t] <=  pe[e,t]-Epmin[e] * ze[e,t] 
        )

        m.ext[:constraints][:reserve_electrolyzer_l_reserve_1]=@constraint(m, [e=E1, t=T],
        re_l_reserve_1[e,t] <=  pe[e,t]-Epmin[e] * ze[e,t] 
        )

        m.ext[:constraints][:reserve_electrolyzer_lg2]=@constraint(m, [e=E2, t=T],
            re_lg2[e,t] <=  pe[e,t]-Epmin[e] * ze[e,t] 
        )
        m.ext[:constraints][:reserve_electrolyzer_lc2]=@constraint(m, [e=E2, t=T],
            re_lc2[e,t] <=  pe[e,t]-Epmin[e] * ze[e,t] 
        )
        m.ext[:constraints][:reserve_electrolyzer_l_reserve_2]=@constraint(m, [e=E2, t=T],
        re_l_reserve_2[e,t] <=  pe[e,t]-Epmin[e] * ze[e,t] 
        )

        
    #Reserve bound constraints
    m.ext[:constraints][:reserve_bound_rg_lg1] = @constraint(m, [g in G1, t in T],
    rg_lg1[g,t] <= MaxFreqDev[g]*zg[g,t]
    )

    m.ext[:constraints][:reserve_bound_rg_lc1] = @constraint(m, [g in G1, t in T],
    rg_lc1[g,t] <= MaxFreqDev[g]*zg[g,t]
    )

    m.ext[:constraints][:reserve_bound_rg_l_reserve_1] = @constraint(m, [g in G1, t in T],
    rg_l_reserve_1[g,t] <= MaxFreqDev[g]*zg[g,t]
    )

    m.ext[:constraints][:reserve_bound_rg_lg2] = @constraint(m, [g in G2, t in T],
    rg_lg2[g,t] <= MaxFreqDev[g]*zg[g,t]
    )

    m.ext[:constraints][:reserve_bound_rg_lc2] = @constraint(m, [g in G2, t in T],
    rg_lc2[g,t] <= MaxFreqDev[g]*zg[g,t]
    )

    m.ext[:constraints][:reserve_bound_rg_l_reserve_2] = @constraint(m, [g in G2, t in T],
    rg_l_reserve_2[g,t] <= MaxFreqDev[g]*zg[g,t]
    )
    

   



    #Rocof constraints generators and converters per areas
    m.ext[:constraints][:rocof_constraint_plg_1]= @constraint(m, [t in T],
        f1*plg1[t] <= rocof1*(2*Inertia_nadir_frequency_1[t] )
    )

    m.ext[:constraints][:rocof_constraint_plc_1]= @constraint(m, [t in T], 
        f1*plc1[t] <= rocof1*(2*Inertia_nadir_frequency_converter_1[t] )
    )
    
    m.ext[:constraints][:rocof_constraint_plg_2]= @constraint(m, [t in T],
        f2*plg2[t] <= rocof2*(2*Inertia_nadir_frequency_2[t] )
    )

    m.ext[:constraints][:rocof_constraint_plc_2]= @constraint(m, [t in T],
        f2*plc2[t] <= rocof2*(2*Inertia_nadir_frequency_converter_2[t] )
    )

    m.ext[:constraints][:rocof_constraint_plreserve_1]= @constraint(m, [t in T],
        f1*plreserve_1[t] <= rocof1*(2*Inertia_nadir_frequency_converter_1[t] )
    )

    m.ext[:constraints][:rocof_constraint_plreserve_2]= @constraint(m, [t in T],
        f2*plreserve_2[t] <= rocof2*(2*Inertia_nadir_frequency_converter_2[t] )
    )

    #Power balance constraint

        m.ext[:constraints][:power_balance_lg1]= @constraint(m, [t in T],
        sum(rs_lg1[s,t] for s in S1)+sum(re_lg1[e,t] for e in E1)+sum(rg_lg1[g,t] for g in G1)+sum(rhvdc_lg1[cv,t] for cv in CV1)>=plg1[t]
    )
    m.ext[:constraints][:power_balance_lc1]= @constraint(m, [t in T],
      sum(rs_lc1[s,t] for s in S1)+sum(re_lc1[e,t] for e in E1)+sum(rg_lc1[g,t] for g in G1)+sum(rhvdc_lc1[cv,t] for cv in CV1)>=plc1[t]
    )

     m.ext[:constraints][:power_balance_lg2]= @constraint(m, [t in T],
        sum(rs_lg2[s,t] for s in S2)+sum(re_lg2[e,t] for e in E2)+sum(rg_lg2[g,t] for g in G2)+sum(rhvdc_lg2[cv,t] for cv in CV2)>=plg2[t]
    )
     m.ext[:constraints][:power_balance_lc2]= @constraint(m, [t in T],
        sum(rs_lc2[s,t] for s in S2)+sum(re_lc2[e,t] for e in E2)+sum(rg_lc2[g,t] for g in G2)+sum(rhvdc_lc2[cv,t] for cv in CV2)>=plc2[t]
    )

    m.ext[:constraints][:power_balance_lreserve_1]= @constraint(m, [t in T],
        sum(rs_l_reserve_1[s,t] for s in S1)+sum(re_l_reserve_1[e,t] for e in E1)+sum(rg_l_reserve_1[g,t] for g in G1)>=plreserve_1[t]
    )
    m.ext[:constraints][:power_balance_lreserve_2]= @constraint(m, [t in T],
        sum(rs_l_reserve_2[s,t] for s in S2)+sum(re_l_reserve_2[e,t] for e in E2)+sum(rg_l_reserve_2[g,t] for g in G2)>=plreserve_2[t]
    )

   # Constraint frequency nadir generators and converters area 1

    m.ext[:constraints][:nadir_frequency_g_1_constraint_1]= @constraint(m, [t in T],
    ypg1[t]==2*deltaf1*(Inertia_nadir_frequency_1[t] )/f1-sum(re_lg1[e,t]*Edeployment[e] for e in E1)/2-sum(rs_lg1[s,t]*Sdeployment[s] for s in S1)/2-sum(rhvdc_lg1[cv,t]*HVDC_deployment[cv] for cv in CV1)/2   
    )

    m.ext[:constraints][:nadir_frequency_g_1_constraint_2]= @constraint(m, [t in T],
    zpg1[t]==sum(rg_lg1[g,t]/G_dt[g] for g in G1)   
    )


    m.ext[:constraints][:nadir_frequency_g_1_constraint_3] = @constraint(m,[t in T],
    [ypg1[t]; zpg1[t]; plg1[t]-sum(re_lg1[e,t] for e in E1)-sum(rs_lg1[s,t] for s in S1)-sum(rhvdc_lg1[cv,t] for cv in CV1)] in RotatedSecondOrderCone()
    )

    m.ext[:constraints][:nadir_frequency_c_1_constraint_1]= @constraint(m, [t in T],
    ypc1[t]==2*deltaf1*(Inertia_nadir_frequency_converter_1[t] )/f1-sum(re_lc1[e,t]*Edeployment[e] for e in E1)/2-sum(rs_lc1[s,t]*Sdeployment[s] for s in S1)/2-sum(rhvdc_lc1[cv,t]*HVDC_deployment[cv] for cv in CV1)/2 
    )

    m.ext[:constraints][:nadir_frequency_c_1_constraint_2]= @constraint(m, [t in T],
    zpc1[t]==sum(rg_lc1[g,t]/G_dt[g] for g in G1)
    )

    m.ext[:constraints][:nadir_frequency_c_1_constraint_3] = @constraint(m,[t in T],
    [ypc1[t]; zpc1[t]; plc1[t]-sum(re_lc1[e,t] for e in E1)-sum(rs_lc1[s,t] for s in S1)-sum(rhvdc_lc1[cv,t] for cv in CV1)] in RotatedSecondOrderCone()
    )

    m.ext[:constraints][:nadir_frequency_reserve_1_constraint_1]= @constraint(m, [t in T],
    ypreserve1[t]==2*deltaf1*(Inertia_nadir_frequency_converter_1[t] )/f1-sum(re_l_reserve_1[e,t]*Edeployment[e] for e in E1)/2-sum(rs_l_reserve_1[s,t]*Sdeployment[s] for s in S1)/2
    )

    m.ext[:constraints][:nadir_frequency_reserve_1_constraint_2]= @constraint(m, [t in T],
    zpreserve1[t]==sum(rg_l_reserve_1[g,t]/G_dt[g] for g in G1)
    )
    m.ext[:constraints][:nadir_frequency_reserve_1_constraint_3] = @constraint(m,[t in T],
    [ypreserve1[t]; zpreserve1[t]; plreserve_1[t]-sum(re_l_reserve_1[e,t] for e in E1)-sum(rs_l_reserve_1[s,t] for s in S1)] in RotatedSecondOrderCone()
    )

    # #Constraint frequency nadir generators and converters area 2

    m.ext[:constraints][:nadir_frequency_g_2_constraint_1]= @constraint(m, [t in T],
    ypg2[t]==2*deltaf2*(Inertia_nadir_frequency_2[t] )/f2-sum(re_lg2[e,t]*Edeployment[e] for e in E2)/2-sum(rs_lg2[s,t]*Sdeployment[s] for s in S2)/2-sum(rhvdc_lg2[cv,t]*HVDC_deployment[cv] for cv in CV2)/2   
    )

    m.ext[:constraints][:nadir_frequency_g_2_constraint_2]= @constraint(m, [t in T],
    zpg2[t]==sum(rg_lg2[g,t]/G_dt[g] for g in G2)   
    )

    m.ext[:constraints][:nadir_frequency_g_2_constraint_3] = @constraint(m,[t in T],
    [ypg2[t]; zpg2[t]; plg2[t]-sum(re_lg2[e,t] for e in E2)-sum(rs_lg2[s,t] for s in S2)-sum(rhvdc_lg2[cv,t] for cv in CV2) ] in RotatedSecondOrderCone()
    )

    m.ext[:constraints][:nadir_frequency_c_2_constraint_1]= @constraint(m, [t in T],
    ypc2[t]==2*deltaf2*(Inertia_nadir_frequency_converter_2[t] )/f2-sum(re_lc2[e,t]*Edeployment[e] for e in E2)/2-sum(rs_lc2[s,t]*Sdeployment[s] for s in S2)/2-sum(rhvdc_lc2[cv,t]*HVDC_deployment[cv] for cv in CV2)/2 
    )

    m.ext[:constraints][:nadir_frequency_c_2_constraint_2]= @constraint(m, [t in T],
    zpc2[t]==sum(rg_lc2[g,t]/G_dt[g] for g in G2)
    )

    m.ext[:constraints][:nadir_frequency_c_2_constraint_3] = @constraint(m,[t in T],
    [ypc2[t]; zpc2[t]; plc2[t]-sum(re_lc2[e,t] for e in E2)-sum(rs_lc2[s,t] for s in S2)-sum(rhvdc_lc2[cv,t] for cv in CV2) ] in RotatedSecondOrderCone()
    )

    m.ext[:constraints][:nadir_frequency_reserve_2_constraint_1]= @constraint(m, [t in T],
    ypreserve2[t]==2*deltaf2*(Inertia_nadir_frequency_converter_2[t] )/f2-sum(re_l_reserve_2[e,t]*Edeployment[e] for e in E2)/2-sum(rs_l_reserve_2[s,t]*Sdeployment[s] for s in S2)/2
    )

    m.ext[:constraints][:nadir_frequency_reserve_2_constraint_2]= @constraint(m, [t in T],
    zpreserve2[t]==sum(rg_l_reserve_2[g,t]/G_dt[g] for g in G2)
    )
    m.ext[:constraints][:nadir_frequency_reserve_2_constraint_3] = @constraint(m,[t in T],
    [ypreserve2[t]; zpreserve2[t]; plreserve_2[t]-sum(re_l_reserve_2[e,t] for e in E2)-sum(rs_l_reserve_2[s,t] for s in S2)] in RotatedSecondOrderCone()
    )
   

    # #Constraint time occurrence nadir
    m.ext[:constraints][:time_nadir_occurrence_g1_1]= @constraint(m, [t in T],
    plg1[t]<= 0.0000001+ sum(re_lg1[e,t] for e in E1)+sum(rs_lg1[s,t] for s in S1)+sum(rhvdc_lg1[cv,t] for cv in CV1)+sum(rg_lg1[g,t] for g in G1)
    )
    m.ext[:constraints][:time_nadir_occurrence_g1_2]= @constraint(m, [t in T],
    plg1[t]>=0.0000001+ sum(re_lg1[e,t] for e in E1)+sum(rs_lg1[s,t] for s in S1)+sum(rhvdc_lg1[cv,t] for cv in CV1)+sum(rg_lg1[g,t] for g in G1)*Edeployment["1"]/G_dt["1"]
    )

    m.ext[:constraints][:time_nadir_occurrence_c1_1]= @constraint(m, [t in T],
    plc1[t]<= 0.0000001+ sum(re_lc1[e,t] for e in E1)+sum(rs_lc1[s,t] for s in S1)+sum(rhvdc_lc1[cv,t] for cv in CV1)+sum(rg_lc1[g,t] for g in G1)
    )
    m.ext[:constraints][:time_nadir_occurrence_c1_2]= @constraint(m, [t in T],
    plc1[t]>=0.0000001+ sum(re_lc1[e,t] for e in E1)+sum(rs_lc1[s,t] for s in S1)+sum(rhvdc_lc1[cv,t] for cv in CV1)+sum(rg_lc1[g,t] for g in G1)*Edeployment["1"]/G_dt["1"]
    )

    m.ext[:constraints][:time_nadir_occurrence_g2_1]= @constraint(m, [t in T],
    plg2[t]<= 0.0000001 +sum(re_lg2[e,t] for e in E2)+sum(rs_lg2[s,t] for s in S2)+sum(rhvdc_lg2[cv,t] for cv in CV2)+sum(rg_lg2[g,t] for g in G2)
    )
    m.ext[:constraints][:time_nadir_occurrence_g2_2]= @constraint(m, [t in T],
    plg2[t]>=0.0000001 +sum(re_lg2[e,t] for e in E2)+sum(rs_lg2[s,t] for s in S2)+sum(rhvdc_lg2[cv,t] for cv in CV2)+sum(rg_lg2[g,t] for g in G2)*Edeployment["1"]/G_dt["1"]
    )

    m.ext[:constraints][:time_nadir_occurrence_c2_1]= @constraint(m, [t in T],
    plc2[t]<= 0.0000001 +sum(re_lc2[e,t] for e in E2)+sum(rs_lc2[s,t] for s in S2)+sum(rhvdc_lc2[cv,t] for cv in CV2)+sum(rg_lc2[g,t] for g in G2)
    )
    m.ext[:constraints][:time_nadir_occurrence_c2_2]= @constraint(m, [t in T],
    plc2[t]>=0.0000001 +sum(re_lc2[e,t] for e in E2)+sum(rs_lc2[s,t] for s in S2)+sum(rhvdc_lc2[cv,t] for cv in CV2)+sum(rg_lc2[g,t] for g in G2)*Edeployment["1"]/G_dt["1"]
    )

    m.ext[:constraints][:time_nadir_occurrence_reserve_1_1]= @constraint(m, [t in T],
    plreserve_1[t]<= 0.0000001 +sum(re_l_reserve_1[e,t] for e in E1)+sum(rs_l_reserve_1[s,t] for s in S1)+sum(rg_l_reserve_1[g,t] for g in G1)
    )
    m.ext[:constraints][:time_nadir_occurrence_reserve_1_2]= @constraint(m, [t in T],
    plreserve_1[t]>=0.0000001 +sum(re_l_reserve_1[e,t] for e in E1)+sum(rs_l_reserve_1[s,t] for s in S1)+sum(rg_l_reserve_1[g,t] for g in G1)*Edeployment["1"]/G_dt["1"]
    )

    m.ext[:constraints][:time_nadir_occurrence_reserve_2_1]= @constraint(m, [t in T],
    plreserve_2[t]<= 0.0000001 +sum(re_l_reserve_2[e,t] for e in E2)+sum(rs_l_reserve_2[s,t] for s in S2)+sum(rg_l_reserve_2[g,t] for g in G2)
    )
    m.ext[:constraints][:time_nadir_occurrence_reserve_2_2]= @constraint(m, [t in T],
    plreserve_2[t]>=0.0000001 +sum(re_l_reserve_2[e,t] for e in E2)+sum(rs_l_reserve_2[s,t] for s in S2)+sum(rg_l_reserve_2[g,t] for g in G2)*Edeployment["1"]/G_dt["1"]
    )

    #Absolute value constraints
  





      
    return m 
end
