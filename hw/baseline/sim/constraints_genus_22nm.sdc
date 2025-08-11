# Tmin = 3360ps -> ~297 MHz, closest integer freq = T = 4000 -> 250 MHz
create_clock -name clk_i -period 4000 -waveform {0 2000} [get_ports "clk_i"]