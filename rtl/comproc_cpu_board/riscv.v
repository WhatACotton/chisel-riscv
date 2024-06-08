module Core(
  input         clock,
  input         reset,
  output [31:0] io_imem_addr,
  input  [31:0] io_imem_inst,
  output [31:0] io_dmem_addr,
  input  [31:0] io_dmem_rdata,
  output        io_dmem_wen,
  output [31:0] io_dmem_wdata,
  output        io_exit,
  output [31:0] io_gp
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regfile [0:31]; // @[Core.scala 16:20]
  wire [31:0] regfile_rs1_data_MPORT_data; // @[Core.scala 16:20]
  wire [4:0] regfile_rs1_data_MPORT_addr; // @[Core.scala 16:20]
  wire [31:0] regfile_rs2_data_MPORT_data; // @[Core.scala 16:20]
  wire [4:0] regfile_rs2_data_MPORT_addr; // @[Core.scala 16:20]
  wire [31:0] regfile_io_gp_MPORT_data; // @[Core.scala 16:20]
  wire [4:0] regfile_io_gp_MPORT_addr; // @[Core.scala 16:20]
  wire [31:0] regfile_MPORT_2_data; // @[Core.scala 16:20]
  wire [4:0] regfile_MPORT_2_addr; // @[Core.scala 16:20]
  wire [31:0] regfile_MPORT_1_data; // @[Core.scala 16:20]
  wire [4:0] regfile_MPORT_1_addr; // @[Core.scala 16:20]
  wire  regfile_MPORT_1_mask; // @[Core.scala 16:20]
  wire  regfile_MPORT_1_en; // @[Core.scala 16:20]
  reg [31:0] csr_regfile [0:4095]; // @[Core.scala 17:24]
  wire [31:0] csr_regfile_pc_next_MPORT_data; // @[Core.scala 17:24]
  wire [11:0] csr_regfile_pc_next_MPORT_addr; // @[Core.scala 17:24]
  wire [31:0] csr_regfile_csr_rdata_data; // @[Core.scala 17:24]
  wire [11:0] csr_regfile_csr_rdata_addr; // @[Core.scala 17:24]
  wire [31:0] csr_regfile_MPORT_data; // @[Core.scala 17:24]
  wire [11:0] csr_regfile_MPORT_addr; // @[Core.scala 17:24]
  wire  csr_regfile_MPORT_mask; // @[Core.scala 17:24]
  wire  csr_regfile_MPORT_en; // @[Core.scala 17:24]
  reg [31:0] pc_reg; // @[Core.scala 19:23]
  wire [31:0] pc_plus4 = pc_reg + 32'h4; // @[Core.scala 22:25]
  wire [31:0] _jmp_flg_T = io_imem_inst & 32'h7f; // @[Core.scala 25:23]
  wire  _jmp_flg_T_1 = 32'h6f == _jmp_flg_T; // @[Core.scala 25:23]
  wire [31:0] _jmp_flg_T_2 = io_imem_inst & 32'h707f; // @[Core.scala 25:39]
  wire  _jmp_flg_T_3 = 32'h67 == _jmp_flg_T_2; // @[Core.scala 25:39]
  wire  jmp_flg = 32'h6f == _jmp_flg_T | 32'h67 == _jmp_flg_T_2; // @[Core.scala 25:31]
  wire  _pc_next_T_1 = 32'h73 == io_imem_inst; // @[Core.scala 32:13]
  wire  _csignals_T_1 = 32'h2003 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_3 = 32'h2023 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_4 = io_imem_inst & 32'hfe00707f; // @[Lookup.scala 31:38]
  wire  _csignals_T_5 = 32'h33 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_7 = 32'h13 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_9 = 32'h40000033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_11 = 32'h7033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_13 = 32'h6033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_15 = 32'h4033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_17 = 32'h7013 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_19 = 32'h6013 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_21 = 32'h4013 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_23 = 32'h1033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_25 = 32'h5033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_27 = 32'h40005033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_29 = 32'h1013 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_31 = 32'h5013 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_33 = 32'h40005013 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_35 = 32'h2033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_37 = 32'h3033 == _csignals_T_4; // @[Lookup.scala 31:38]
  wire  _csignals_T_39 = 32'h2013 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_41 = 32'h3013 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_43 = 32'h63 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_45 = 32'h1063 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_47 = 32'h5063 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_49 = 32'h7063 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_51 = 32'h4063 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_53 = 32'h6063 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_59 = 32'h37 == _jmp_flg_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_61 = 32'h17 == _jmp_flg_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_63 = 32'h1073 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_65 = 32'h5073 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_67 = 32'h2073 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_69 = 32'h6073 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_71 = 32'h3073 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire  _csignals_T_73 = 32'h7073 == _jmp_flg_T_2; // @[Lookup.scala 31:38]
  wire [4:0] _csignals_T_77 = _csignals_T_73 ? 5'h12 : 5'h0; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_78 = _csignals_T_71 ? 5'h12 : _csignals_T_77; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_79 = _csignals_T_69 ? 5'h12 : _csignals_T_78; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_80 = _csignals_T_67 ? 5'h12 : _csignals_T_79; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_81 = _csignals_T_65 ? 5'h12 : _csignals_T_80; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_82 = _csignals_T_63 ? 5'h12 : _csignals_T_81; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_83 = _csignals_T_61 ? 5'h1 : _csignals_T_82; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_84 = _csignals_T_59 ? 5'h1 : _csignals_T_83; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_85 = _jmp_flg_T_3 ? 5'h11 : _csignals_T_84; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_86 = _jmp_flg_T_1 ? 5'h1 : _csignals_T_85; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_87 = _csignals_T_53 ? 5'hf : _csignals_T_86; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_88 = _csignals_T_51 ? 5'hd : _csignals_T_87; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_89 = _csignals_T_49 ? 5'h10 : _csignals_T_88; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_90 = _csignals_T_47 ? 5'he : _csignals_T_89; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_91 = _csignals_T_45 ? 5'hc : _csignals_T_90; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_92 = _csignals_T_43 ? 5'hb : _csignals_T_91; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_93 = _csignals_T_41 ? 5'ha : _csignals_T_92; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_94 = _csignals_T_39 ? 5'h9 : _csignals_T_93; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_95 = _csignals_T_37 ? 5'ha : _csignals_T_94; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_96 = _csignals_T_35 ? 5'h9 : _csignals_T_95; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_97 = _csignals_T_33 ? 5'h8 : _csignals_T_96; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_98 = _csignals_T_31 ? 5'h7 : _csignals_T_97; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_99 = _csignals_T_29 ? 5'h6 : _csignals_T_98; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_100 = _csignals_T_27 ? 5'h8 : _csignals_T_99; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_101 = _csignals_T_25 ? 5'h7 : _csignals_T_100; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_102 = _csignals_T_23 ? 5'h6 : _csignals_T_101; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_103 = _csignals_T_21 ? 5'h5 : _csignals_T_102; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_104 = _csignals_T_19 ? 5'h4 : _csignals_T_103; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_105 = _csignals_T_17 ? 5'h3 : _csignals_T_104; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_106 = _csignals_T_15 ? 5'h5 : _csignals_T_105; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_107 = _csignals_T_13 ? 5'h4 : _csignals_T_106; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_108 = _csignals_T_11 ? 5'h3 : _csignals_T_107; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_109 = _csignals_T_9 ? 5'h2 : _csignals_T_108; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_110 = _csignals_T_7 ? 5'h1 : _csignals_T_109; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_111 = _csignals_T_5 ? 5'h1 : _csignals_T_110; // @[Lookup.scala 33:37]
  wire [4:0] _csignals_T_112 = _csignals_T_3 ? 5'h1 : _csignals_T_111; // @[Lookup.scala 33:37]
  wire [4:0] csignals_0 = _csignals_T_1 ? 5'h1 : _csignals_T_112; // @[Lookup.scala 33:37]
  wire  _alu_out_T = csignals_0 == 5'h1; // @[Core.scala 126:16]
  wire [1:0] _csignals_T_113 = _pc_next_T_1 ? 2'h2 : 2'h0; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_114 = _csignals_T_73 ? 2'h3 : _csignals_T_113; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_115 = _csignals_T_71 ? 2'h0 : _csignals_T_114; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_116 = _csignals_T_69 ? 2'h3 : _csignals_T_115; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_117 = _csignals_T_67 ? 2'h0 : _csignals_T_116; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_118 = _csignals_T_65 ? 2'h3 : _csignals_T_117; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_119 = _csignals_T_63 ? 2'h0 : _csignals_T_118; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_120 = _csignals_T_61 ? 2'h1 : _csignals_T_119; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_121 = _csignals_T_59 ? 2'h2 : _csignals_T_120; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_122 = _jmp_flg_T_3 ? 2'h0 : _csignals_T_121; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_123 = _jmp_flg_T_1 ? 2'h1 : _csignals_T_122; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_124 = _csignals_T_53 ? 2'h0 : _csignals_T_123; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_125 = _csignals_T_51 ? 2'h0 : _csignals_T_124; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_126 = _csignals_T_49 ? 2'h0 : _csignals_T_125; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_127 = _csignals_T_47 ? 2'h0 : _csignals_T_126; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_128 = _csignals_T_45 ? 2'h0 : _csignals_T_127; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_129 = _csignals_T_43 ? 2'h0 : _csignals_T_128; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_130 = _csignals_T_41 ? 2'h0 : _csignals_T_129; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_131 = _csignals_T_39 ? 2'h0 : _csignals_T_130; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_132 = _csignals_T_37 ? 2'h0 : _csignals_T_131; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_133 = _csignals_T_35 ? 2'h0 : _csignals_T_132; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_134 = _csignals_T_33 ? 2'h0 : _csignals_T_133; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_135 = _csignals_T_31 ? 2'h0 : _csignals_T_134; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_136 = _csignals_T_29 ? 2'h0 : _csignals_T_135; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_137 = _csignals_T_27 ? 2'h0 : _csignals_T_136; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_138 = _csignals_T_25 ? 2'h0 : _csignals_T_137; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_139 = _csignals_T_23 ? 2'h0 : _csignals_T_138; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_140 = _csignals_T_21 ? 2'h0 : _csignals_T_139; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_141 = _csignals_T_19 ? 2'h0 : _csignals_T_140; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_142 = _csignals_T_17 ? 2'h0 : _csignals_T_141; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_143 = _csignals_T_15 ? 2'h0 : _csignals_T_142; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_144 = _csignals_T_13 ? 2'h0 : _csignals_T_143; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_145 = _csignals_T_11 ? 2'h0 : _csignals_T_144; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_146 = _csignals_T_9 ? 2'h0 : _csignals_T_145; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_147 = _csignals_T_7 ? 2'h0 : _csignals_T_146; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_148 = _csignals_T_5 ? 2'h0 : _csignals_T_147; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_149 = _csignals_T_3 ? 2'h0 : _csignals_T_148; // @[Lookup.scala 33:37]
  wire [1:0] csignals_1 = _csignals_T_1 ? 2'h0 : _csignals_T_149; // @[Lookup.scala 33:37]
  wire  _op1_data_T = csignals_1 == 2'h0; // @[Core.scala 106:16]
  wire [4:0] rs1_addr = io_imem_inst[19:15]; // @[Core.scala 36:22]
  wire [31:0] rs1_data = rs1_addr != 5'h0 ? regfile_rs1_data_MPORT_data : 32'h0; // @[Core.scala 40:8]
  wire  _op1_data_T_1 = csignals_1 == 2'h1; // @[Core.scala 107:16]
  wire  _op1_data_T_2 = csignals_1 == 2'h3; // @[Core.scala 108:16]
  wire [31:0] imm_z_uext = {27'h0,rs1_addr}; // @[Cat.scala 30:58]
  wire [31:0] _op1_data_T_3 = _op1_data_T_2 ? imm_z_uext : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _op1_data_T_4 = _op1_data_T_1 ? pc_reg : _op1_data_T_3; // @[Mux.scala 98:16]
  wire [31:0] op1_data = _op1_data_T ? rs1_data : _op1_data_T_4; // @[Mux.scala 98:16]
  wire [2:0] _csignals_T_150 = _pc_next_T_1 ? 3'h0 : 3'h1; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_151 = _csignals_T_73 ? 3'h0 : _csignals_T_150; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_152 = _csignals_T_71 ? 3'h0 : _csignals_T_151; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_153 = _csignals_T_69 ? 3'h0 : _csignals_T_152; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_154 = _csignals_T_67 ? 3'h0 : _csignals_T_153; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_155 = _csignals_T_65 ? 3'h0 : _csignals_T_154; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_156 = _csignals_T_63 ? 3'h0 : _csignals_T_155; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_157 = _csignals_T_61 ? 3'h5 : _csignals_T_156; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_158 = _csignals_T_59 ? 3'h5 : _csignals_T_157; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_159 = _jmp_flg_T_3 ? 3'h2 : _csignals_T_158; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_160 = _jmp_flg_T_1 ? 3'h4 : _csignals_T_159; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_161 = _csignals_T_53 ? 3'h1 : _csignals_T_160; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_162 = _csignals_T_51 ? 3'h1 : _csignals_T_161; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_163 = _csignals_T_49 ? 3'h1 : _csignals_T_162; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_164 = _csignals_T_47 ? 3'h1 : _csignals_T_163; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_165 = _csignals_T_45 ? 3'h1 : _csignals_T_164; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_166 = _csignals_T_43 ? 3'h1 : _csignals_T_165; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_167 = _csignals_T_41 ? 3'h2 : _csignals_T_166; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_168 = _csignals_T_39 ? 3'h2 : _csignals_T_167; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_169 = _csignals_T_37 ? 3'h1 : _csignals_T_168; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_170 = _csignals_T_35 ? 3'h1 : _csignals_T_169; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_171 = _csignals_T_33 ? 3'h2 : _csignals_T_170; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_172 = _csignals_T_31 ? 3'h2 : _csignals_T_171; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_173 = _csignals_T_29 ? 3'h2 : _csignals_T_172; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_174 = _csignals_T_27 ? 3'h1 : _csignals_T_173; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_175 = _csignals_T_25 ? 3'h1 : _csignals_T_174; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_176 = _csignals_T_23 ? 3'h1 : _csignals_T_175; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_177 = _csignals_T_21 ? 3'h2 : _csignals_T_176; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_178 = _csignals_T_19 ? 3'h2 : _csignals_T_177; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_179 = _csignals_T_17 ? 3'h2 : _csignals_T_178; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_180 = _csignals_T_15 ? 3'h1 : _csignals_T_179; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_181 = _csignals_T_13 ? 3'h1 : _csignals_T_180; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_182 = _csignals_T_11 ? 3'h1 : _csignals_T_181; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_183 = _csignals_T_9 ? 3'h1 : _csignals_T_182; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_184 = _csignals_T_7 ? 3'h2 : _csignals_T_183; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_185 = _csignals_T_5 ? 3'h1 : _csignals_T_184; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_186 = _csignals_T_3 ? 3'h3 : _csignals_T_185; // @[Lookup.scala 33:37]
  wire [2:0] csignals_2 = _csignals_T_1 ? 3'h2 : _csignals_T_186; // @[Lookup.scala 33:37]
  wire  _op2_data_T = csignals_2 == 3'h1; // @[Core.scala 115:16]
  wire [4:0] rs2_addr = io_imem_inst[24:20]; // @[Core.scala 37:22]
  wire [31:0] rs2_data = rs2_addr != 5'h0 ? regfile_rs2_data_MPORT_data : 32'h0; // @[Core.scala 42:8]
  wire  _op2_data_T_1 = csignals_2 == 3'h2; // @[Core.scala 116:16]
  wire [11:0] imm_i = io_imem_inst[31:20]; // @[Core.scala 43:19]
  wire [19:0] imm_i_sext_hi = imm_i[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] imm_i_sext = {imm_i_sext_hi,imm_i}; // @[Cat.scala 30:58]
  wire  _op2_data_T_2 = csignals_2 == 3'h3; // @[Core.scala 117:16]
  wire [6:0] imm_s_hi = io_imem_inst[31:25]; // @[Core.scala 45:23]
  wire [4:0] imm_s_lo = io_imem_inst[11:7]; // @[Core.scala 45:37]
  wire [11:0] imm_s = {imm_s_hi,imm_s_lo}; // @[Cat.scala 30:58]
  wire [19:0] imm_s_sext_hi = imm_s[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] imm_s_sext = {imm_s_sext_hi,imm_s_hi,imm_s_lo}; // @[Cat.scala 30:58]
  wire  _op2_data_T_3 = csignals_2 == 3'h4; // @[Core.scala 118:16]
  wire  imm_j_hi_hi = io_imem_inst[31]; // @[Core.scala 49:23]
  wire [7:0] imm_j_hi_lo = io_imem_inst[19:12]; // @[Core.scala 49:33]
  wire  imm_j_lo_hi = io_imem_inst[20]; // @[Core.scala 49:47]
  wire [9:0] imm_j_lo_lo = io_imem_inst[30:21]; // @[Core.scala 49:57]
  wire [19:0] imm_j = {imm_j_hi_hi,imm_j_hi_lo,imm_j_lo_hi,imm_j_lo_lo}; // @[Cat.scala 30:58]
  wire [10:0] imm_j_sext_hi_hi = imm_j[19] ? 11'h7ff : 11'h0; // @[Bitwise.scala 72:12]
  wire [31:0] imm_j_sext = {imm_j_sext_hi_hi,imm_j_hi_hi,imm_j_hi_lo,imm_j_lo_hi,imm_j_lo_lo,1'h0}; // @[Cat.scala 30:58]
  wire  _op2_data_T_4 = csignals_2 == 3'h5; // @[Core.scala 119:16]
  wire [19:0] imm_u = io_imem_inst[31:12]; // @[Core.scala 51:19]
  wire [31:0] imm_u_shifted = {imm_u,12'h0}; // @[Cat.scala 30:58]
  wire [31:0] _op2_data_T_5 = _op2_data_T_4 ? imm_u_shifted : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _op2_data_T_6 = _op2_data_T_3 ? imm_j_sext : _op2_data_T_5; // @[Mux.scala 98:16]
  wire [31:0] _op2_data_T_7 = _op2_data_T_2 ? imm_s_sext : _op2_data_T_6; // @[Mux.scala 98:16]
  wire [31:0] _op2_data_T_8 = _op2_data_T_1 ? imm_i_sext : _op2_data_T_7; // @[Mux.scala 98:16]
  wire [31:0] op2_data = _op2_data_T ? rs2_data : _op2_data_T_8; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_2 = op1_data + op2_data; // @[Core.scala 126:42]
  wire  _alu_out_T_3 = csignals_0 == 5'h2; // @[Core.scala 127:16]
  wire [31:0] _alu_out_T_5 = op1_data - op2_data; // @[Core.scala 127:42]
  wire  _alu_out_T_6 = csignals_0 == 5'h3; // @[Core.scala 128:16]
  wire [31:0] _alu_out_T_7 = op1_data & op2_data; // @[Core.scala 128:42]
  wire  _alu_out_T_8 = csignals_0 == 5'h4; // @[Core.scala 129:16]
  wire [31:0] _alu_out_T_9 = op1_data | op2_data; // @[Core.scala 129:41]
  wire  _alu_out_T_10 = csignals_0 == 5'h5; // @[Core.scala 130:16]
  wire [31:0] _alu_out_T_11 = op1_data ^ op2_data; // @[Core.scala 130:42]
  wire  _alu_out_T_12 = csignals_0 == 5'h6; // @[Core.scala 131:16]
  wire [62:0] _GEN_10 = {{31'd0}, op1_data}; // @[Core.scala 131:42]
  wire [62:0] _alu_out_T_14 = _GEN_10 << op2_data[4:0]; // @[Core.scala 131:42]
  wire  _alu_out_T_16 = csignals_0 == 5'h7; // @[Core.scala 132:16]
  wire [31:0] _alu_out_T_18 = op1_data >> op2_data[4:0]; // @[Core.scala 132:42]
  wire  _alu_out_T_19 = csignals_0 == 5'h8; // @[Core.scala 133:16]
  wire [31:0] _alu_out_T_20 = _op1_data_T ? rs1_data : _op1_data_T_4; // @[Core.scala 133:48]
  wire [31:0] _alu_out_T_23 = $signed(_alu_out_T_20) >>> op2_data[4:0]; // @[Core.scala 133:76]
  wire  _alu_out_T_24 = csignals_0 == 5'h9; // @[Core.scala 134:16]
  wire [31:0] _alu_out_T_26 = _op2_data_T ? rs2_data : _op2_data_T_8; // @[Core.scala 134:68]
  wire  _alu_out_T_27 = $signed(_alu_out_T_20) < $signed(_alu_out_T_26); // @[Core.scala 134:51]
  wire  _alu_out_T_28 = csignals_0 == 5'ha; // @[Core.scala 135:16]
  wire  _alu_out_T_29 = op1_data < op2_data; // @[Core.scala 135:43]
  wire  _alu_out_T_30 = csignals_0 == 5'h11; // @[Core.scala 136:16]
  wire [31:0] _alu_out_T_34 = _alu_out_T_2 & 32'hfffffffe; // @[Core.scala 136:56]
  wire  _alu_out_T_35 = csignals_0 == 5'h12; // @[Core.scala 137:16]
  wire [31:0] _alu_out_T_36 = _alu_out_T_35 ? op1_data : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_37 = _alu_out_T_30 ? _alu_out_T_34 : _alu_out_T_36; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_38 = _alu_out_T_28 ? {{31'd0}, _alu_out_T_29} : _alu_out_T_37; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_39 = _alu_out_T_24 ? {{31'd0}, _alu_out_T_27} : _alu_out_T_38; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_40 = _alu_out_T_19 ? _alu_out_T_23 : _alu_out_T_39; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_41 = _alu_out_T_16 ? _alu_out_T_18 : _alu_out_T_40; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_42 = _alu_out_T_12 ? _alu_out_T_14[31:0] : _alu_out_T_41; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_43 = _alu_out_T_10 ? _alu_out_T_11 : _alu_out_T_42; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_44 = _alu_out_T_8 ? _alu_out_T_9 : _alu_out_T_43; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_45 = _alu_out_T_6 ? _alu_out_T_7 : _alu_out_T_44; // @[Mux.scala 98:16]
  wire [31:0] _alu_out_T_46 = _alu_out_T_3 ? _alu_out_T_5 : _alu_out_T_45; // @[Mux.scala 98:16]
  wire [31:0] alu_out = _alu_out_T ? _alu_out_T_2 : _alu_out_T_46; // @[Mux.scala 98:16]
  wire  _br_flg_T = csignals_0 == 5'hb; // @[Core.scala 144:16]
  wire  _br_flg_T_1 = op1_data == op2_data; // @[Core.scala 144:41]
  wire  _br_flg_T_2 = csignals_0 == 5'hc; // @[Core.scala 145:16]
  wire  _br_flg_T_4 = ~_br_flg_T_1; // @[Core.scala 145:31]
  wire  _br_flg_T_5 = csignals_0 == 5'hd; // @[Core.scala 146:16]
  wire  _br_flg_T_9 = csignals_0 == 5'he; // @[Core.scala 147:16]
  wire  _br_flg_T_13 = ~_alu_out_T_27; // @[Core.scala 147:31]
  wire  _br_flg_T_14 = csignals_0 == 5'hf; // @[Core.scala 148:16]
  wire  _br_flg_T_16 = csignals_0 == 5'h10; // @[Core.scala 149:16]
  wire  _br_flg_T_18 = ~_alu_out_T_29; // @[Core.scala 149:32]
  wire  _br_flg_T_20 = _br_flg_T_14 ? _alu_out_T_29 : _br_flg_T_16 & _br_flg_T_18; // @[Mux.scala 98:16]
  wire  _br_flg_T_21 = _br_flg_T_9 ? _br_flg_T_13 : _br_flg_T_20; // @[Mux.scala 98:16]
  wire  _br_flg_T_22 = _br_flg_T_5 ? _alu_out_T_27 : _br_flg_T_21; // @[Mux.scala 98:16]
  wire  _br_flg_T_23 = _br_flg_T_2 ? _br_flg_T_4 : _br_flg_T_22; // @[Mux.scala 98:16]
  wire  br_flg = _br_flg_T ? _br_flg_T_1 : _br_flg_T_23; // @[Mux.scala 98:16]
  wire  imm_b_hi_lo = io_imem_inst[7]; // @[Core.scala 47:33]
  wire [5:0] imm_b_lo_hi = io_imem_inst[30:25]; // @[Core.scala 47:42]
  wire [3:0] imm_b_lo_lo = io_imem_inst[11:8]; // @[Core.scala 47:56]
  wire [11:0] imm_b = {imm_j_hi_hi,imm_b_hi_lo,imm_b_lo_hi,imm_b_lo_lo}; // @[Cat.scala 30:58]
  wire [18:0] imm_b_sext_hi_hi = imm_b[11] ? 19'h7ffff : 19'h0; // @[Bitwise.scala 72:12]
  wire [31:0] imm_b_sext = {imm_b_sext_hi_hi,imm_j_hi_hi,imm_b_hi_lo,imm_b_lo_hi,imm_b_lo_lo,1'h0}; // @[Cat.scala 30:58]
  wire [31:0] br_target = pc_reg + imm_b_sext; // @[Core.scala 140:23]
  wire [1:0] _csignals_T_223 = _csignals_T_3 ? 2'h1 : 2'h0; // @[Lookup.scala 33:37]
  wire [1:0] csignals_3 = _csignals_T_1 ? 2'h0 : _csignals_T_223; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_225 = _csignals_T_73 ? 2'h1 : 2'h0; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_226 = _csignals_T_71 ? 2'h1 : _csignals_T_225; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_227 = _csignals_T_69 ? 2'h1 : _csignals_T_226; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_228 = _csignals_T_67 ? 2'h1 : _csignals_T_227; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_229 = _csignals_T_65 ? 2'h1 : _csignals_T_228; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_230 = _csignals_T_63 ? 2'h1 : _csignals_T_229; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_231 = _csignals_T_61 ? 2'h1 : _csignals_T_230; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_232 = _csignals_T_59 ? 2'h1 : _csignals_T_231; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_233 = _jmp_flg_T_3 ? 2'h1 : _csignals_T_232; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_234 = _jmp_flg_T_1 ? 2'h1 : _csignals_T_233; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_235 = _csignals_T_53 ? 2'h0 : _csignals_T_234; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_236 = _csignals_T_51 ? 2'h0 : _csignals_T_235; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_237 = _csignals_T_49 ? 2'h0 : _csignals_T_236; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_238 = _csignals_T_47 ? 2'h0 : _csignals_T_237; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_239 = _csignals_T_45 ? 2'h0 : _csignals_T_238; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_240 = _csignals_T_43 ? 2'h0 : _csignals_T_239; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_241 = _csignals_T_41 ? 2'h1 : _csignals_T_240; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_242 = _csignals_T_39 ? 2'h1 : _csignals_T_241; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_243 = _csignals_T_37 ? 2'h1 : _csignals_T_242; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_244 = _csignals_T_35 ? 2'h1 : _csignals_T_243; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_245 = _csignals_T_33 ? 2'h1 : _csignals_T_244; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_246 = _csignals_T_31 ? 2'h1 : _csignals_T_245; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_247 = _csignals_T_29 ? 2'h1 : _csignals_T_246; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_248 = _csignals_T_27 ? 2'h1 : _csignals_T_247; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_249 = _csignals_T_25 ? 2'h1 : _csignals_T_248; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_250 = _csignals_T_23 ? 2'h1 : _csignals_T_249; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_251 = _csignals_T_21 ? 2'h1 : _csignals_T_250; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_252 = _csignals_T_19 ? 2'h1 : _csignals_T_251; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_253 = _csignals_T_17 ? 2'h1 : _csignals_T_252; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_254 = _csignals_T_15 ? 2'h1 : _csignals_T_253; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_255 = _csignals_T_13 ? 2'h1 : _csignals_T_254; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_256 = _csignals_T_11 ? 2'h1 : _csignals_T_255; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_257 = _csignals_T_9 ? 2'h1 : _csignals_T_256; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_258 = _csignals_T_7 ? 2'h1 : _csignals_T_257; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_259 = _csignals_T_5 ? 2'h1 : _csignals_T_258; // @[Lookup.scala 33:37]
  wire [1:0] _csignals_T_260 = _csignals_T_3 ? 2'h0 : _csignals_T_259; // @[Lookup.scala 33:37]
  wire [1:0] csignals_4 = _csignals_T_1 ? 2'h1 : _csignals_T_260; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_262 = _csignals_T_73 ? 3'h3 : 3'h0; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_263 = _csignals_T_71 ? 3'h3 : _csignals_T_262; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_264 = _csignals_T_69 ? 3'h3 : _csignals_T_263; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_265 = _csignals_T_67 ? 3'h3 : _csignals_T_264; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_266 = _csignals_T_65 ? 3'h3 : _csignals_T_265; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_267 = _csignals_T_63 ? 3'h3 : _csignals_T_266; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_268 = _csignals_T_61 ? 3'h0 : _csignals_T_267; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_269 = _csignals_T_59 ? 3'h0 : _csignals_T_268; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_270 = _jmp_flg_T_3 ? 3'h2 : _csignals_T_269; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_271 = _jmp_flg_T_1 ? 3'h2 : _csignals_T_270; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_272 = _csignals_T_53 ? 3'h0 : _csignals_T_271; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_273 = _csignals_T_51 ? 3'h0 : _csignals_T_272; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_274 = _csignals_T_49 ? 3'h0 : _csignals_T_273; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_275 = _csignals_T_47 ? 3'h0 : _csignals_T_274; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_276 = _csignals_T_45 ? 3'h0 : _csignals_T_275; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_277 = _csignals_T_43 ? 3'h0 : _csignals_T_276; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_278 = _csignals_T_41 ? 3'h0 : _csignals_T_277; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_279 = _csignals_T_39 ? 3'h0 : _csignals_T_278; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_280 = _csignals_T_37 ? 3'h0 : _csignals_T_279; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_281 = _csignals_T_35 ? 3'h0 : _csignals_T_280; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_282 = _csignals_T_33 ? 3'h0 : _csignals_T_281; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_283 = _csignals_T_31 ? 3'h0 : _csignals_T_282; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_284 = _csignals_T_29 ? 3'h0 : _csignals_T_283; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_285 = _csignals_T_27 ? 3'h0 : _csignals_T_284; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_286 = _csignals_T_25 ? 3'h0 : _csignals_T_285; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_287 = _csignals_T_23 ? 3'h0 : _csignals_T_286; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_288 = _csignals_T_21 ? 3'h0 : _csignals_T_287; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_289 = _csignals_T_19 ? 3'h0 : _csignals_T_288; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_290 = _csignals_T_17 ? 3'h0 : _csignals_T_289; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_291 = _csignals_T_15 ? 3'h0 : _csignals_T_290; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_292 = _csignals_T_13 ? 3'h0 : _csignals_T_291; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_293 = _csignals_T_11 ? 3'h0 : _csignals_T_292; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_294 = _csignals_T_9 ? 3'h0 : _csignals_T_293; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_295 = _csignals_T_7 ? 3'h0 : _csignals_T_294; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_296 = _csignals_T_5 ? 3'h0 : _csignals_T_295; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_297 = _csignals_T_3 ? 3'h0 : _csignals_T_296; // @[Lookup.scala 33:37]
  wire [2:0] csignals_5 = _csignals_T_1 ? 3'h1 : _csignals_T_297; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_298 = _pc_next_T_1 ? 3'h4 : 3'h0; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_299 = _csignals_T_73 ? 3'h3 : _csignals_T_298; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_300 = _csignals_T_71 ? 3'h3 : _csignals_T_299; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_301 = _csignals_T_69 ? 3'h2 : _csignals_T_300; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_302 = _csignals_T_67 ? 3'h2 : _csignals_T_301; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_303 = _csignals_T_65 ? 3'h1 : _csignals_T_302; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_304 = _csignals_T_63 ? 3'h1 : _csignals_T_303; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_305 = _csignals_T_61 ? 3'h0 : _csignals_T_304; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_306 = _csignals_T_59 ? 3'h0 : _csignals_T_305; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_307 = _jmp_flg_T_3 ? 3'h0 : _csignals_T_306; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_308 = _jmp_flg_T_1 ? 3'h0 : _csignals_T_307; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_309 = _csignals_T_53 ? 3'h0 : _csignals_T_308; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_310 = _csignals_T_51 ? 3'h0 : _csignals_T_309; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_311 = _csignals_T_49 ? 3'h0 : _csignals_T_310; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_312 = _csignals_T_47 ? 3'h0 : _csignals_T_311; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_313 = _csignals_T_45 ? 3'h0 : _csignals_T_312; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_314 = _csignals_T_43 ? 3'h0 : _csignals_T_313; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_315 = _csignals_T_41 ? 3'h0 : _csignals_T_314; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_316 = _csignals_T_39 ? 3'h0 : _csignals_T_315; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_317 = _csignals_T_37 ? 3'h0 : _csignals_T_316; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_318 = _csignals_T_35 ? 3'h0 : _csignals_T_317; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_319 = _csignals_T_33 ? 3'h0 : _csignals_T_318; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_320 = _csignals_T_31 ? 3'h0 : _csignals_T_319; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_321 = _csignals_T_29 ? 3'h0 : _csignals_T_320; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_322 = _csignals_T_27 ? 3'h0 : _csignals_T_321; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_323 = _csignals_T_25 ? 3'h0 : _csignals_T_322; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_324 = _csignals_T_23 ? 3'h0 : _csignals_T_323; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_325 = _csignals_T_21 ? 3'h0 : _csignals_T_324; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_326 = _csignals_T_19 ? 3'h0 : _csignals_T_325; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_327 = _csignals_T_17 ? 3'h0 : _csignals_T_326; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_328 = _csignals_T_15 ? 3'h0 : _csignals_T_327; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_329 = _csignals_T_13 ? 3'h0 : _csignals_T_328; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_330 = _csignals_T_11 ? 3'h0 : _csignals_T_329; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_331 = _csignals_T_9 ? 3'h0 : _csignals_T_330; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_332 = _csignals_T_7 ? 3'h0 : _csignals_T_331; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_333 = _csignals_T_5 ? 3'h0 : _csignals_T_332; // @[Lookup.scala 33:37]
  wire [2:0] _csignals_T_334 = _csignals_T_3 ? 3'h0 : _csignals_T_333; // @[Lookup.scala 33:37]
  wire [2:0] csignals_6 = _csignals_T_1 ? 3'h0 : _csignals_T_334; // @[Lookup.scala 33:37]
  wire  _csr_addr_T = csignals_6 == 3'h4; // @[Core.scala 157:30]
  wire  _csr_wdata_T = csignals_6 == 3'h1; // @[Core.scala 162:16]
  wire  _csr_wdata_T_1 = csignals_6 == 3'h2; // @[Core.scala 163:16]
  wire [31:0] _csr_wdata_T_2 = csr_regfile_csr_rdata_data | op1_data; // @[Core.scala 163:41]
  wire  _csr_wdata_T_3 = csignals_6 == 3'h3; // @[Core.scala 164:16]
  wire [31:0] _csr_wdata_T_4 = ~op1_data; // @[Core.scala 164:43]
  wire [31:0] _csr_wdata_T_5 = csr_regfile_csr_rdata_data & _csr_wdata_T_4; // @[Core.scala 164:41]
  wire [31:0] _csr_wdata_T_7 = _csr_addr_T ? 32'hb : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _csr_wdata_T_8 = _csr_wdata_T_3 ? _csr_wdata_T_5 : _csr_wdata_T_7; // @[Mux.scala 98:16]
  wire [31:0] _csr_wdata_T_9 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_8; // @[Mux.scala 98:16]
  wire  _wb_data_T = csignals_5 == 3'h1; // @[Core.scala 176:15]
  wire  _wb_data_T_1 = csignals_5 == 3'h2; // @[Core.scala 177:15]
  wire  _wb_data_T_2 = csignals_5 == 3'h3; // @[Core.scala 178:15]
  wire [31:0] _wb_data_T_3 = _wb_data_T_2 ? csr_regfile_csr_rdata_data : alu_out; // @[Mux.scala 98:16]
  wire [31:0] _wb_data_T_4 = _wb_data_T_1 ? pc_plus4 : _wb_data_T_3; // @[Mux.scala 98:16]
  wire [31:0] wb_data = _wb_data_T ? io_dmem_rdata : _wb_data_T_4; // @[Mux.scala 98:16]
  wire  _T_3 = ~reset; // @[Core.scala 187:9]
  assign regfile_rs1_data_MPORT_addr = io_imem_inst[19:15];
  assign regfile_rs1_data_MPORT_data = regfile[regfile_rs1_data_MPORT_addr]; // @[Core.scala 16:20]
  assign regfile_rs2_data_MPORT_addr = io_imem_inst[24:20];
  assign regfile_rs2_data_MPORT_data = regfile[regfile_rs2_data_MPORT_addr]; // @[Core.scala 16:20]
  assign regfile_io_gp_MPORT_addr = 5'h3;
  assign regfile_io_gp_MPORT_data = regfile[regfile_io_gp_MPORT_addr]; // @[Core.scala 16:20]
  assign regfile_MPORT_2_addr = 5'h3;
  assign regfile_MPORT_2_data = regfile[regfile_MPORT_2_addr]; // @[Core.scala 16:20]
  assign regfile_MPORT_1_data = _wb_data_T ? io_dmem_rdata : _wb_data_T_4;
  assign regfile_MPORT_1_addr = io_imem_inst[11:7];
  assign regfile_MPORT_1_mask = 1'h1;
  assign regfile_MPORT_1_en = csignals_4 == 2'h1;
  assign csr_regfile_pc_next_MPORT_addr = 12'h305;
  assign csr_regfile_pc_next_MPORT_data = csr_regfile[csr_regfile_pc_next_MPORT_addr]; // @[Core.scala 17:24]
  assign csr_regfile_csr_rdata_addr = _csr_addr_T ? 12'h342 : imm_i;
  assign csr_regfile_csr_rdata_data = csr_regfile[csr_regfile_csr_rdata_addr]; // @[Core.scala 17:24]
  assign csr_regfile_MPORT_data = _csr_wdata_T ? op1_data : _csr_wdata_T_9;
  assign csr_regfile_MPORT_addr = _csr_addr_T ? 12'h342 : imm_i;
  assign csr_regfile_MPORT_mask = 1'h1;
  assign csr_regfile_MPORT_en = csignals_6 > 3'h0;
  assign io_imem_addr = pc_reg; // @[Core.scala 20:16]
  assign io_dmem_addr = _alu_out_T ? _alu_out_T_2 : _alu_out_T_46; // @[Mux.scala 98:16]
  assign io_dmem_wen = csignals_3[0]; // @[Core.scala 154:15]
  assign io_dmem_wdata = rs2_addr != 5'h0 ? regfile_rs2_data_MPORT_data : 32'h0; // @[Core.scala 42:8]
  assign io_exit = io_imem_inst == 32'hc0001073; // @[Core.scala 186:20]
  assign io_gp = regfile_io_gp_MPORT_data; // @[Core.scala 185:9]
  always @(posedge clock) begin
    if(regfile_MPORT_1_en & regfile_MPORT_1_mask) begin
      regfile[regfile_MPORT_1_addr] <= regfile_MPORT_1_data; // @[Core.scala 16:20]
    end
    if(csr_regfile_MPORT_en & csr_regfile_MPORT_mask) begin
      csr_regfile[csr_regfile_MPORT_addr] <= csr_regfile_MPORT_data; // @[Core.scala 17:24]
    end
    if (reset) begin // @[Core.scala 19:23]
      pc_reg <= 32'h0; // @[Core.scala 19:23]
    end else if (br_flg) begin // @[Mux.scala 98:16]
      pc_reg <= br_target;
    end else if (jmp_flg) begin // @[Mux.scala 98:16]
      if (_alu_out_T) begin // @[Mux.scala 98:16]
        pc_reg <= _alu_out_T_2;
      end else begin
        pc_reg <= _alu_out_T_46;
      end
    end else if (_pc_next_T_1) begin // @[Mux.scala 98:16]
      pc_reg <= csr_regfile_pc_next_MPORT_data;
    end else begin
      pc_reg <= pc_plus4;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"io.pc      : 0x%x\n",pc_reg); // @[Core.scala 187:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"inst       : 0x%x\n",io_imem_inst); // @[Core.scala 188:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"gp         : %d\n",regfile_MPORT_2_data); // @[Core.scala 189:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"rs1_addr   : %d\n",rs1_addr); // @[Core.scala 190:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"rs2_addr   : %d\n",rs2_addr); // @[Core.scala 191:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"wb_addr    : %d\n",imm_s_lo); // @[Core.scala 192:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"rs1_data   : 0x%x\n",rs1_data); // @[Core.scala 193:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"rs2_data   : 0x%x\n",rs2_data); // @[Core.scala 194:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"wb_data    : 0x%x\n",wb_data); // @[Core.scala 195:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"dmem.addr  : %d\n",io_dmem_addr); // @[Core.scala 196:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"dmem.rdata : %d\n",io_dmem_rdata); // @[Core.scala 197:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"---------\n"); // @[Core.scala 198:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regfile[initvar] = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    csr_regfile[initvar] = _RAND_1[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  pc_reg = _RAND_2[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Memory(
  input         clock,
  input  [31:0] io_imem_addr,
  output [31:0] io_imem_inst,
  input  [31:0] io_dmem_addr,
  output [31:0] io_dmem_rdata,
  input         io_dmem_wen,
  input  [31:0] io_dmem_wdata
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [7:0] mem [0:16383]; // @[Memory.scala 24:16]
  wire [7:0] mem_io_imem_inst_hi_hi_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_imem_inst_hi_hi_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_io_imem_inst_hi_lo_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_imem_inst_hi_lo_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_io_imem_inst_lo_hi_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_imem_inst_lo_hi_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_io_imem_inst_lo_lo_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_imem_inst_lo_lo_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_io_dmem_rdata_hi_hi_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_dmem_rdata_hi_hi_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_io_dmem_rdata_hi_lo_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_dmem_rdata_hi_lo_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_io_dmem_rdata_lo_hi_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_dmem_rdata_lo_hi_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_io_dmem_rdata_lo_lo_data; // @[Memory.scala 24:16]
  wire [13:0] mem_io_dmem_rdata_lo_lo_addr; // @[Memory.scala 24:16]
  wire [7:0] mem_MPORT_data; // @[Memory.scala 24:16]
  wire [13:0] mem_MPORT_addr; // @[Memory.scala 24:16]
  wire  mem_MPORT_mask; // @[Memory.scala 24:16]
  wire  mem_MPORT_en; // @[Memory.scala 24:16]
  wire [7:0] mem_MPORT_1_data; // @[Memory.scala 24:16]
  wire [13:0] mem_MPORT_1_addr; // @[Memory.scala 24:16]
  wire  mem_MPORT_1_mask; // @[Memory.scala 24:16]
  wire  mem_MPORT_1_en; // @[Memory.scala 24:16]
  wire [7:0] mem_MPORT_2_data; // @[Memory.scala 24:16]
  wire [13:0] mem_MPORT_2_addr; // @[Memory.scala 24:16]
  wire  mem_MPORT_2_mask; // @[Memory.scala 24:16]
  wire  mem_MPORT_2_en; // @[Memory.scala 24:16]
  wire [7:0] mem_MPORT_3_data; // @[Memory.scala 24:16]
  wire [13:0] mem_MPORT_3_addr; // @[Memory.scala 24:16]
  wire  mem_MPORT_3_mask; // @[Memory.scala 24:16]
  wire  mem_MPORT_3_en; // @[Memory.scala 24:16]
  wire [31:0] _io_imem_inst_T_1 = io_imem_addr + 32'h3; // @[Memory.scala 28:22]
  wire [31:0] _io_imem_inst_T_4 = io_imem_addr + 32'h2; // @[Memory.scala 29:22]
  wire [31:0] _io_imem_inst_T_7 = io_imem_addr + 32'h1; // @[Memory.scala 30:22]
  wire [15:0] io_imem_inst_lo = {mem_io_imem_inst_lo_hi_data,mem_io_imem_inst_lo_lo_data}; // @[Cat.scala 30:58]
  wire [15:0] io_imem_inst_hi = {mem_io_imem_inst_hi_hi_data,mem_io_imem_inst_hi_lo_data}; // @[Cat.scala 30:58]
  wire [31:0] _io_dmem_rdata_T_1 = io_dmem_addr + 32'h3; // @[Memory.scala 34:22]
  wire [31:0] _io_dmem_rdata_T_4 = io_dmem_addr + 32'h2; // @[Memory.scala 35:22]
  wire [31:0] _io_dmem_rdata_T_7 = io_dmem_addr + 32'h1; // @[Memory.scala 36:22]
  wire [15:0] io_dmem_rdata_lo = {mem_io_dmem_rdata_lo_hi_data,mem_io_dmem_rdata_lo_lo_data}; // @[Cat.scala 30:58]
  wire [15:0] io_dmem_rdata_hi = {mem_io_dmem_rdata_hi_hi_data,mem_io_dmem_rdata_hi_lo_data}; // @[Cat.scala 30:58]
  assign mem_io_imem_inst_hi_hi_addr = _io_imem_inst_T_1[13:0];
  assign mem_io_imem_inst_hi_hi_data = mem[mem_io_imem_inst_hi_hi_addr]; // @[Memory.scala 24:16]
  assign mem_io_imem_inst_hi_lo_addr = _io_imem_inst_T_4[13:0];
  assign mem_io_imem_inst_hi_lo_data = mem[mem_io_imem_inst_hi_lo_addr]; // @[Memory.scala 24:16]
  assign mem_io_imem_inst_lo_hi_addr = _io_imem_inst_T_7[13:0];
  assign mem_io_imem_inst_lo_hi_data = mem[mem_io_imem_inst_lo_hi_addr]; // @[Memory.scala 24:16]
  assign mem_io_imem_inst_lo_lo_addr = io_imem_addr[13:0];
  assign mem_io_imem_inst_lo_lo_data = mem[mem_io_imem_inst_lo_lo_addr]; // @[Memory.scala 24:16]
  assign mem_io_dmem_rdata_hi_hi_addr = _io_dmem_rdata_T_1[13:0];
  assign mem_io_dmem_rdata_hi_hi_data = mem[mem_io_dmem_rdata_hi_hi_addr]; // @[Memory.scala 24:16]
  assign mem_io_dmem_rdata_hi_lo_addr = _io_dmem_rdata_T_4[13:0];
  assign mem_io_dmem_rdata_hi_lo_data = mem[mem_io_dmem_rdata_hi_lo_addr]; // @[Memory.scala 24:16]
  assign mem_io_dmem_rdata_lo_hi_addr = _io_dmem_rdata_T_7[13:0];
  assign mem_io_dmem_rdata_lo_hi_data = mem[mem_io_dmem_rdata_lo_hi_addr]; // @[Memory.scala 24:16]
  assign mem_io_dmem_rdata_lo_lo_addr = io_dmem_addr[13:0];
  assign mem_io_dmem_rdata_lo_lo_data = mem[mem_io_dmem_rdata_lo_lo_addr]; // @[Memory.scala 24:16]
  assign mem_MPORT_data = io_dmem_wdata[7:0];
  assign mem_MPORT_addr = io_dmem_addr[13:0];
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = io_dmem_wen;
  assign mem_MPORT_1_data = io_dmem_wdata[15:8];
  assign mem_MPORT_1_addr = _io_dmem_rdata_T_7[13:0];
  assign mem_MPORT_1_mask = 1'h1;
  assign mem_MPORT_1_en = io_dmem_wen;
  assign mem_MPORT_2_data = io_dmem_wdata[23:16];
  assign mem_MPORT_2_addr = _io_dmem_rdata_T_4[13:0];
  assign mem_MPORT_2_mask = 1'h1;
  assign mem_MPORT_2_en = io_dmem_wen;
  assign mem_MPORT_3_data = io_dmem_wdata[31:24];
  assign mem_MPORT_3_addr = _io_dmem_rdata_T_1[13:0];
  assign mem_MPORT_3_mask = 1'h1;
  assign mem_MPORT_3_en = io_dmem_wen;
  assign io_imem_inst = {io_imem_inst_hi,io_imem_inst_lo}; // @[Cat.scala 30:58]
  assign io_dmem_rdata = {io_dmem_rdata_hi,io_dmem_rdata_lo}; // @[Cat.scala 30:58]
  always @(posedge clock) begin
    if(mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[Memory.scala 24:16]
    end
    if(mem_MPORT_1_en & mem_MPORT_1_mask) begin
      mem[mem_MPORT_1_addr] <= mem_MPORT_1_data; // @[Memory.scala 24:16]
    end
    if(mem_MPORT_2_en & mem_MPORT_2_mask) begin
      mem[mem_MPORT_2_addr] <= mem_MPORT_2_data; // @[Memory.scala 24:16]
    end
    if(mem_MPORT_3_en & mem_MPORT_3_mask) begin
      mem[mem_MPORT_3_addr] <= mem_MPORT_3_data; // @[Memory.scala 24:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16384; initvar = initvar+1)
    mem[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Top(
  input         clock,
  input         reset,
  output        io_exit,
  output [31:0] io_gp
);
  wire  core_clock; // @[Top.scala 11:20]
  wire  core_reset; // @[Top.scala 11:20]
  wire [31:0] core_io_imem_addr; // @[Top.scala 11:20]
  wire [31:0] core_io_imem_inst; // @[Top.scala 11:20]
  wire [31:0] core_io_dmem_addr; // @[Top.scala 11:20]
  wire [31:0] core_io_dmem_rdata; // @[Top.scala 11:20]
  wire  core_io_dmem_wen; // @[Top.scala 11:20]
  wire [31:0] core_io_dmem_wdata; // @[Top.scala 11:20]
  wire  core_io_exit; // @[Top.scala 11:20]
  wire [31:0] core_io_gp; // @[Top.scala 11:20]
  wire  memory_clock; // @[Top.scala 12:22]
  wire [31:0] memory_io_imem_addr; // @[Top.scala 12:22]
  wire [31:0] memory_io_imem_inst; // @[Top.scala 12:22]
  wire [31:0] memory_io_dmem_addr; // @[Top.scala 12:22]
  wire [31:0] memory_io_dmem_rdata; // @[Top.scala 12:22]
  wire  memory_io_dmem_wen; // @[Top.scala 12:22]
  wire [31:0] memory_io_dmem_wdata; // @[Top.scala 12:22]
  Core core ( // @[Top.scala 11:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_imem_addr(core_io_imem_addr),
    .io_imem_inst(core_io_imem_inst),
    .io_dmem_addr(core_io_dmem_addr),
    .io_dmem_rdata(core_io_dmem_rdata),
    .io_dmem_wen(core_io_dmem_wen),
    .io_dmem_wdata(core_io_dmem_wdata),
    .io_exit(core_io_exit),
    .io_gp(core_io_gp)
  );
  Memory memory ( // @[Top.scala 12:22]
    .clock(memory_clock),
    .io_imem_addr(memory_io_imem_addr),
    .io_imem_inst(memory_io_imem_inst),
    .io_dmem_addr(memory_io_dmem_addr),
    .io_dmem_rdata(memory_io_dmem_rdata),
    .io_dmem_wen(memory_io_dmem_wen),
    .io_dmem_wdata(memory_io_dmem_wdata)
  );
  assign io_exit = core_io_exit; // @[Top.scala 15:11]
  assign io_gp = core_io_gp; // @[Top.scala 16:9]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = memory_io_imem_inst; // @[Top.scala 13:16]
  assign core_io_dmem_rdata = memory_io_dmem_rdata; // @[Top.scala 14:16]
  assign memory_clock = clock;
  assign memory_io_imem_addr = core_io_imem_addr; // @[Top.scala 13:16]
  assign memory_io_dmem_addr = core_io_dmem_addr; // @[Top.scala 14:16]
  assign memory_io_dmem_wen = core_io_dmem_wen; // @[Top.scala 14:16]
  assign memory_io_dmem_wdata = core_io_dmem_wdata; // @[Top.scala 14:16]
endmodule
