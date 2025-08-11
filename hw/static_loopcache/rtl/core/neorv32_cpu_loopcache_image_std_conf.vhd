-- Loopcache memory initialization file

-- prototype defined in 'neorv32_package.vhd'
package body neorv32_cpu_loopcache_image is

constant loopcache_init_image : mem32_t := (
x"ffffffff",
x"0000037c", -- loop start addr in IMEM
x"000003e8", -- loop end addr in IMEM
x"ffffff25", -- loop pc offset 
x"01986bb3", -- loop start (lpc = 4)
x"000bce63",
x"00fcdc63",
x"00f85a63",
x"000e2b83",
x"00032d83",
x"11bbfbd3",
x"0176f6d3",
x"00180813",
x"004e0e13",
x"00430313",
x"fda81ae3",
x"001f0f13",
x"00fa0a33",
x"01190933",
x"031f5463",
x"00812803",
x"002a1e13",
x"00291313",
x"010e0e33",
x"02c12803",
x"008f0cb3",
x"00680333",
x"00058813",
x"fa1ff06f",
x"00c12803",
x"001b0b13",
x"010989b3"  -- loop end
);

end neorv32_cpu_loopcache_image;
