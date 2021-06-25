vsim -gui work.proccessor
# vsim -gui work.proccessor 
# Start time: 04:43:39 on May 31,2020
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.proccessor(a_data)
# Loading work.fetch(a_fetch)
# Loading work.my_ndff(a_my_ndff)
# Loading work.mux_generic(with_select_mux)
# Loading ieee.numeric_std(body)
# Loading work.ram(syncrama)
# Loading work.mux2(whenmux)
# Loading work.n_adder(struct)
# Loading work.my_adder(a_my_adder)
# Loading work.buff(arch1)
# Loading work.control(a_control)
# Loading work.decode(a_decode)
# Loading work.regfile(a_reg)
# Loading work.exe_mem(struct_exe_mem)
# Loading work.execute(arch1)
# Loading work.alu2(struct_alu2)
# Loading work.parta2(structa2)
# Loading work.partb2(structb2)
# Loading work.partc2(structc2)
# Loading work.ccr(struct_ccr)
# Loading work.mem_stage(struct_mem)
# Loading work.su(struct_su)
# Loading work.s_dff(struct_s_dff)
# Loading work.mem_ram(syncrama)
# ** Warning: (vsim-3473) Component instance "M3 : muxbit" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /proccessor File: D:/vhdl/proj_v10/work/proj_v12/Full.vhd
mem load -i D:/vhdl/OneOperand_mc_new_2.mem /proccessor/fet/IM/ram
add wave -position insertpoint sim:/proccessor/*
add wave -position insertpoint sim:/proccessor/fet/*
add wave -position insertpoint sim:/proccessor/dec/*
add wave -position insertpoint sim:/proccessor/EXMem/*
add wave -position insertpoint sim:/proccessor/EXMem/u0/*
add wave -position insertpoint sim:/proccessor/EXMem/u1/*
add wave -position insertpoint sim:/proccessor/EXMem/fu/*
add wave -position insertpoint sim:/proccessor/EXMem/mOp1/*
add wave -position insertpoint sim:/proccessor/EXMem/mOp2/*
add wave -position insertpoint sim:/proccessor/mux8/*
add wave -position insertpoint sim:/proccessor/mux9/*
force -freeze sim:/proccessor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/proccessor/RST 1 0
force -freeze sim:/proccessor/Interrupt 0 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /proccessor/dec/RF
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /proccessor/dec/RF
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /proccessor/fet/IM
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /proccessor/fet/IM
force -freeze sim:/proccessor/RST 0 0
run
run
run
run
run
run
run
run
run
force -freeze sim:/proccessor/INPORT 16'h5 0
run
force -freeze sim:/proccessor/INPORT 16'h10 0

