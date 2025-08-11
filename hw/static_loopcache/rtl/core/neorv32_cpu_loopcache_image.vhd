-- Loopcache memory initialization file

-- prototype defined in 'neorv32_package.vhd'
package body neorv32_cpu_loopcache_image is

-- 1 cached loops, 1 LAR, 16 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"0000037c", -- loop 1 start addr in IMEM
-- x"000003a8", -- loop 1 end addr in IMEM
-- x"ffffff25", -- loop 1 pc offset 
-- x"01986bb3", -- loop 1 start (lpc = 4)
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3"  -- loop 1 end
-- );

-- 2 cached loops, 1 LAR, 29 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"0000037c", -- loop 1 start addr in IMEM
-- x"000003dc", -- loop 1 end addr in IMEM
-- x"ffffff25", -- loop 1 pc offset 
-- x"01986bb3", -- loop 1 start (lpc = 4)
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f"  -- loop 1 end
-- );

-- 3 cached loops, 2 LARs, 41 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"0000037c", -- loop 1 start addr in IMEM
-- x"000003dc", -- loop 1 end addr in IMEM
-- x"ffffff28", -- loop 1 pc offset 
-- x"000007c4", -- loop 2 start addr in IMEM
-- x"000007e4", -- loop 2 end addr in IMEM
-- x"fffffe2f", -- loop 2 pc offset 
-- x"01986bb3", -- loop 1 start (lpc = 7)
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f", -- loop 1 end
-- x"00e306b3", -- loop 2 start (lpc = 32)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3"  -- loop 2 end
-- );

-- 4 cached loops, 2 LARs, 55 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"0000035c", -- loop 1 start addr in IMEM
-- x"000003f4", -- loop 1 end addr in IMEM
-- x"ffffff30", -- loop 1 pc offset 
-- x"000007c4", -- loop 2 start addr in IMEM
-- x"000007e4", -- loop 2 end addr in IMEM
-- x"fffffe3d", -- loop 2 pc offset 
-- x"02812803", -- loop 1 start (lpc = 7)
-- x"090b5c63",
-- x"007a8a33",
-- x"00098913",
-- x"00000f13",
-- x"0480006f",
-- x"00068493",
-- x"fc1ff06f",
-- x"01986bb3",
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f",
-- x"00c12803",
-- x"001b0b13",
-- x"010989b3",
-- x"01012803",
-- x"010a8ab3",
-- x"f69ff06f", -- loop 1 end
-- x"00e306b3", -- loop 2 start (lpc = 46)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3"  -- loop 2 end
-- );

-- 5 cached loops, 3 LARs, 67 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"0000035c", -- loop 1 start addr in IMEM
-- x"000003f4", -- loop 1 end addr in IMEM
-- x"ffffff33", -- loop 1 pc offset 
-- x"000007c4", -- loop 2 start addr in IMEM
-- x"000007e4", -- loop 2 end addr in IMEM
-- x"fffffe40", -- loop 2 pc offset 
-- x"00000850", -- loop 3 start addr in IMEM
-- x"00000870", -- loop 3 end addr in IMEM
-- x"fffffe26", -- loop 3 pc offset 
-- x"02812803", -- loop 1 start (lpc = 10)
-- x"090b5c63",
-- x"007a8a33",
-- x"00098913",
-- x"00000f13",
-- x"0480006f",
-- x"00068493",
-- x"fc1ff06f",
-- x"01986bb3",
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f",
-- x"00c12803",
-- x"001b0b13",
-- x"010989b3",
-- x"01012803",
-- x"010a8ab3",
-- x"f69ff06f", -- loop 1 end
-- x"00e306b3", -- loop 2 start (lpc = 49)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3", -- loop 2 end
-- x"00e306b3", -- loop 3 start (lpc = 58)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3"  -- loop 3 end
-- );

-- 6 cached loops, 3 LARs, 81 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"0000035c", -- loop 1 start addr in IMEM
-- x"0000042c", -- loop 1 end addr in IMEM
-- x"ffffff33", -- loop 1 pc offset 
-- x"000007c4", -- loop 2 start addr in IMEM
-- x"000007e4", -- loop 2 end addr in IMEM
-- x"fffffe4e", -- loop 2 pc offset 
-- x"00000850", -- loop 3 start addr in IMEM
-- x"00000870", -- loop 3 end addr in IMEM
-- x"fffffe34", -- loop 3 pc offset 
-- x"02812803", -- loop 1 start (lpc = 10)
-- x"090b5c63",
-- x"007a8a33",
-- x"00098913",
-- x"00000f13",
-- x"0480006f",
-- x"00068493",
-- x"fc1ff06f",
-- x"01986bb3",
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f",
-- x"00c12803",
-- x"001b0b13",
-- x"010989b3",
-- x"01012803",
-- x"010a8ab3",
-- x"f69ff06f",
-- x"02012803",
-- x"02080063",
-- x"01c12803",
-- x"00082803",
-- x"0106f6d3",
-- x"00000813",
-- x"a1069853",
-- x"00080463",
-- x"00000693",
-- x"00d52023",
-- x"01d585b3",
-- x"00148693",
-- x"00450513",
-- x"f49714e3", -- loop 1 end
-- x"00e306b3", -- loop 2 start (lpc = 63)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3", -- loop 2 end
-- x"00e306b3", -- loop 3 start (lpc = 72)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3"  -- loop 3 end
-- );

-- 7 cached loops, 3 LARs, 90 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"00000338", -- loop 1 start addr in IMEM
-- x"0000042c", -- loop 1 end addr in IMEM
-- x"ffffff3c", -- loop 1 pc offset 
-- x"000007c4", -- loop 2 start addr in IMEM
-- x"000007e4", -- loop 2 end addr in IMEM
-- x"fffffe57", -- loop 2 pc offset 
-- x"00000850", -- loop 3 start addr in IMEM
-- x"00000870", -- loop 3 end addr in IMEM
-- x"fffffe3d", -- loop 3 pc offset 
-- x"02412803", -- loop 1 start (lpc = 10)
-- x"00259693",
-- x"00000a93",
-- x"00d806b3",
-- x"00d12423",
-- x"00000993",
-- x"00000693",
-- x"00000b13",
-- x"00b88d33",
-- x"02812803",
-- x"090b5c63",
-- x"007a8a33",
-- x"00098913",
-- x"00000f13",
-- x"0480006f",
-- x"00068493",
-- x"fc1ff06f",
-- x"01986bb3",
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f",
-- x"00c12803",
-- x"001b0b13",
-- x"010989b3",
-- x"01012803",
-- x"010a8ab3",
-- x"f69ff06f",
-- x"02012803",
-- x"02080063",
-- x"01c12803",
-- x"00082803",
-- x"0106f6d3",
-- x"00000813",
-- x"a1069853",
-- x"00080463",
-- x"00000693",
-- x"00d52023",
-- x"01d585b3",
-- x"00148693",
-- x"00450513",
-- x"f49714e3", -- loop 1 end
-- x"00e306b3", -- loop 2 start (lpc = 72)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3", -- loop 2 end
-- x"00e306b3", -- loop 3 start (lpc = 81)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3"  -- loop 3 end
-- );

-- 8 cached loops, 4 LARs, 99 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"00000338", -- loop 1 start addr in IMEM
-- x"0000042c", -- loop 1 end addr in IMEM
-- x"ffffff3f", -- loop 1 pc offset 
-- x"000007c4", -- loop 2 start addr in IMEM
-- x"000007e4", -- loop 2 end addr in IMEM
-- x"fffffe5a", -- loop 2 pc offset 
-- x"00000850", -- loop 3 start addr in IMEM
-- x"00000870", -- loop 3 end addr in IMEM
-- x"fffffe40", -- loop 3 pc offset 
-- x"000020a8", -- loop 4 start addr in IMEM
-- x"000020bc", -- loop 4 end addr in IMEM
-- x"fffff833", -- loop 4 pc offset 
-- x"02412803", -- loop 1 start (lpc = 13)
-- x"00259693",
-- x"00000a93",
-- x"00d806b3",
-- x"00d12423",
-- x"00000993",
-- x"00000693",
-- x"00000b13",
-- x"00b88d33",
-- x"02812803",
-- x"090b5c63",
-- x"007a8a33",
-- x"00098913",
-- x"00000f13",
-- x"0480006f",
-- x"00068493",
-- x"fc1ff06f",
-- x"01986bb3",
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f",
-- x"00c12803",
-- x"001b0b13",
-- x"010989b3",
-- x"01012803",
-- x"010a8ab3",
-- x"f69ff06f",
-- x"02012803",
-- x"02080063",
-- x"01c12803",
-- x"00082803",
-- x"0106f6d3",
-- x"00000813",
-- x"a1069853",
-- x"00080463",
-- x"00000693",
-- x"00d52023",
-- x"01d585b3",
-- x"00148693",
-- x"00450513",
-- x"f49714e3", -- loop 1 end
-- x"00e306b3", -- loop 2 start (lpc = 75)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3", -- loop 2 end
-- x"00e306b3", -- loop 3 start (lpc = 84)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3", -- loop 3 end
-- x"0015f693", -- loop 4 start (lpc = 93)
-- x"00068463",
-- x"00c50533",
-- x"0015d593",
-- x"00161613",
-- x"fe0596e3"  -- loop 4 end
-- );

-- 9 cached loops, 5 LARs, 126 words --
-- constant loopcache_init_image : mem32_t := (
-- x"ffffffff",
-- x"00000338", -- loop 1 start addr in IMEM
-- x"0000042c", -- loop 1 end addr in IMEM
-- x"ffffff42", -- loop 1 pc offset 
-- x"000007c4", -- loop 2 start addr in IMEM
-- x"000007e4", -- loop 2 end addr in IMEM
-- x"fffffe5d", -- loop 2 pc offset 
-- x"00000850", -- loop 3 start addr in IMEM
-- x"00000870", -- loop 3 end addr in IMEM
-- x"fffffe43", -- loop 3 pc offset 
-- x"000020a8", -- loop 4 start addr in IMEM
-- x"000020bc", -- loop 4 end addr in IMEM
-- x"fffff836", -- loop 4 pc offset 
-- x"000004a0", -- loop 5 start addr in IMEM
-- x"000004fc", -- loop 5 end addr in IMEM
-- x"ffffff3e", -- loop 5 pc offset 
-- x"02412803", -- loop 1 start (lpc = 16)
-- x"00259693",
-- x"00000a93",
-- x"00d806b3",
-- x"00d12423",
-- x"00000993",
-- x"00000693",
-- x"00000b13",
-- x"00b88d33",
-- x"02812803",
-- x"090b5c63",
-- x"007a8a33",
-- x"00098913",
-- x"00000f13",
-- x"0480006f",
-- x"00068493",
-- x"fc1ff06f",
-- x"01986bb3",
-- x"000bce63",
-- x"00fcdc63",
-- x"00f85a63",
-- x"000e2b83",
-- x"00032d83",
-- x"11bbfbd3",
-- x"0176f6d3",
-- x"00180813",
-- x"004e0e13",
-- x"00430313",
-- x"fda81ae3",
-- x"001f0f13",
-- x"00fa0a33",
-- x"01190933",
-- x"031f5463",
-- x"00812803",
-- x"002a1e13",
-- x"00291313",
-- x"010e0e33",
-- x"02c12803",
-- x"008f0cb3",
-- x"00680333",
-- x"00058813",
-- x"fa1ff06f",
-- x"00c12803",
-- x"001b0b13",
-- x"010989b3",
-- x"01012803",
-- x"010a8ab3",
-- x"f69ff06f",
-- x"02012803",
-- x"02080063",
-- x"01c12803",
-- x"00082803",
-- x"0106f6d3",
-- x"00000813",
-- x"a1069853",
-- x"00080463",
-- x"00000693",
-- x"00d52023",
-- x"01d585b3",
-- x"00148693",
-- x"00450513",
-- x"f49714e3", -- loop 1 end
-- x"00e306b3", -- loop 2 start (lpc = 78)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3", -- loop 2 end
-- x"00e306b3", -- loop 3 start (lpc = 87)
-- x"0006a683",
-- x"00072f03",
-- x"0007ae83",
-- x"00470713",
-- x"11e6f6d3",
-- x"01d6f6d3",
-- x"00d7a023",
-- x"ff0710e3", -- loop 3 end
-- x"0015f693", -- loop 4 start (lpc = 96)
-- x"00068463",
-- x"00c50533",
-- x"0015d593",
-- x"00161613",
-- x"fe0596e3", -- loop 4 end
-- x"00062483", -- loop 5 start (lpc = 102)
-- x"00462e03",
-- x"0008a303",
-- x"0048a283",
-- x"a1c49953",
-- x"00100713",
-- x"00091663",
-- x"00048e13",
-- x"00000713",
-- x"a06e14d3",
-- x"fa0496e3",
-- x"000e0313",
-- x"a0531e53",
-- x"fa0e14e3",
-- x"00030293",
-- x"d0077753",
-- x"01050333",
-- x"00532023",
-- x"01058333",
-- x"00e32023",
-- x"00480813",
-- x"00860613",
-- x"00888893",
-- x"fbf812e3"  -- loop 5 end
-- );

-- 10 cached loops, 6 LARs, 135 words --
constant loopcache_init_image : mem32_t := (
x"ffffffff",
x"00000338", -- loop 1 start addr in IMEM
x"0000042c", -- loop 1 end addr in IMEM
x"ffffff45", -- loop 1 pc offset 
x"000007c4", -- loop 2 start addr in IMEM
x"000007e4", -- loop 2 end addr in IMEM
x"fffffe60", -- loop 2 pc offset 
x"00000850", -- loop 3 start addr in IMEM
x"00000870", -- loop 3 end addr in IMEM
x"fffffe46", -- loop 3 pc offset 
x"000020a8", -- loop 4 start addr in IMEM
x"000020bc", -- loop 4 end addr in IMEM
x"fffff839", -- loop 4 pc offset 
x"000004a0", -- loop 5 start addr in IMEM
x"000004fc", -- loop 5 end addr in IMEM
x"ffffff41", -- loop 5 pc offset 
x"000020f8", -- loop 6 start addr in IMEM
x"0000210c", -- loop 6 end addr in IMEM
x"fffff843", -- loop 6 pc offset 
x"02412803", -- loop 1 start (lpc = 19)
x"00259693",
x"00000a93",
x"00d806b3",
x"00d12423",
x"00000993",
x"00000693",
x"00000b13",
x"00b88d33",
x"02812803",
x"090b5c63",
x"007a8a33",
x"00098913",
x"00000f13",
x"0480006f",
x"00068493",
x"fc1ff06f",
x"01986bb3",
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
x"010989b3",
x"01012803",
x"010a8ab3",
x"f69ff06f",
x"02012803",
x"02080063",
x"01c12803",
x"00082803",
x"0106f6d3",
x"00000813",
x"a1069853",
x"00080463",
x"00000693",
x"00d52023",
x"01d585b3",
x"00148693",
x"00450513",
x"f49714e3", -- loop 1 end
x"00e306b3", -- loop 2 start (lpc = 81)
x"0006a683",
x"00072f03",
x"0007ae83",
x"00470713",
x"11e6f6d3",
x"01d6f6d3",
x"00d7a023",
x"ff0710e3", -- loop 2 end
x"00e306b3", -- loop 3 start (lpc = 90)
x"0006a683",
x"00072f03",
x"0007ae83",
x"00470713",
x"11e6f6d3",
x"01d6f6d3",
x"00d7a023",
x"ff0710e3", -- loop 3 end
x"0015f693", -- loop 4 start (lpc = 99)
x"00068463",
x"00c50533",
x"0015d593",
x"00161613",
x"fe0596e3", -- loop 4 end
x"00062483", -- loop 5 start (lpc = 105)
x"00462e03",
x"0008a303",
x"0048a283",
x"a1c49953",
x"00100713",
x"00091663",
x"00048e13",
x"00000713",
x"a06e14d3",
x"fa0496e3",
x"000e0313",
x"a0531e53",
x"fa0e14e3",
x"00030293",
x"d0077753",
x"01050333",
x"00532023",
x"01058333",
x"00e32023",
x"00480813",
x"00860613",
x"00888893",
x"fbf812e3", -- loop 5 end
x"00c5e663", -- loop 6 start (lpc = 129)
x"40c585b3",
x"00d56533",
x"0016d693",
x"00165613",
x"fe0696e3"  -- loop 6 end
);

end neorv32_cpu_loopcache_image;
