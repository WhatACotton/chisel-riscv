package ctest

import chisel3._
import chisel3.util._
import common.Consts._
import common.Instructions._

class Core extends Module {
  val io = IO(new Bundle {
    val imem = Flipped(new ImemPortIo())
    val dmem = Flipped(new DmemPortIo())
    val exit = Output(Bool())
    val gp = Output(UInt(WORD_LEN.W))
  })

  // register
  val regfile = Mem(32, UInt(WORD_LEN.W))
  // csr register
  val csr_regfile = Mem(4096, UInt(WORD_LEN.W))

  // program counter register
  val pc_reg = RegInit(START_ADDR)

  // pc_reg connects to imem
  io.imem.addr := pc_reg

  // instruction fetch
  val inst = io.imem.inst

  // program counter plus4 分岐命令のときに使われる
  val pc_plus4 = pc_reg + 4.U(WORD_LEN.W)

  // 分岐先のカウンタ
  val br_target = Wire(UInt(WORD_LEN.W))
  // 分岐フラグ
  val br_flg = Wire(Bool())

  // 分岐命令かどうか
  val jmp_flg = (inst === JAL || inst === JALR)

  // ALUの出力
  val alu_out = Wire(UInt(WORD_LEN.W))

  // pc_next 次のprogram counter
  // br_flgがtrueのときは分岐先のカウンタ
  // jmp_flgがtrueのときはALUの出力
  // ecallのときはcsr_regfile(0x305)の値
  // どれにも該当しない場合は今のprogram counter+4
  val pc_next = MuxCase(
    pc_plus4,
    Seq(
      br_flg -> br_target,
      jmp_flg -> alu_out,
      (inst === ECALL) -> csr_regfile(0x305)
    )
  )
  // program counterの更新
  pc_reg := pc_next

  // **重要**
  // 命令のデコード
  // ここでrs1, rs2, wb(write back)のアドレスを取り出す
  val rs1_addr = inst(19, 15)
  val rs2_addr = inst(24, 20)
  val wb_addr = inst(11, 7)
  //

  // レジスタからデータを取り出す
  // rs1_addrが0ではないとき、つまりアドレスが指定されているときはそのアドレスのデータを取り出す
  // 0のとき、つまりアドレスが指定されていないときは0として扱う
  val rs1_data =
    Mux((rs1_addr =/= 0.U(WORD_LEN.U)), regfile(rs1_addr), 0.U(WORD_LEN.W))
  // rs2_addrも同様
  val rs2_data =
    Mux((rs2_addr =/= 0.U(WORD_LEN.U)), regfile(rs2_addr), 0.U(WORD_LEN.W))

  // 命令のデコード
  // 即値
  // I形式
  //  ↓ここ
  // |31 imm[11:0] 20|19 rs1 15|14 funct3 12|11 rd 7|6 opcode 0|
  // 符号拡張即値
  // |31 --inst[31]-- 11|10 inst[30:25] 5|4 inst[24:21] 1|0 inst[20] 0|
  val imm_i = inst(31, 20)
  // オフセットの符号拡張
  // imm_iの頭の符号ビットで上の20bitを埋める
  // sext: sign extension
  val imm_i_sext = Cat(Fill(20, imm_i(11)), imm_i)
  // S形式
  //  ↓ここ                                             ↓ここ
  // |31 imm[11:5] 25|24 rs2 20|19 rs1 15|14 funct3 12|11 imm[4:0] 7|6 opcode 0|
  // |31 --inst[31]-- 11|10 inst[30:25] 5|4 inst[11:8] 1|0 inst[7] 0|
  val imm_s = Cat(inst(31, 25), inst(11, 7))
  val imm_s_sext = Cat(Fill(20, imm_s(11)), imm_s)
  // B形式
  //  ↓ここ                                                 ↓ここ
  // |31 imm[12|10:5] 25|24 rs2 20|19 rs1 15|14 funct3 12|11 imm[4:1|11] 7|6 opcode 0|
  // |31 --inst[31]-- 12|11 inst[7] 10|9 inst[30:25] 5|4 inst[11:8] 1|0 0 0|
  // 符号拡張したときに必ず最後が0になるのはRiscVの命令長が必ず2byteの整数倍長だから
  val imm_b = Cat(inst(31), inst(7), inst(30, 25), inst(11, 8))
  val imm_b_sext = Cat(Fill(19, imm_b(11)), imm_b, 0.U(1.U))
  // J形式
  //  ↓ここ
  // |31 imm[20|10:1|11|19:12] 12|11 rd 7|6 opcode 0|
  // |31 --inst[31]-- 20|19 inst[19:12] 12|11 inst[20] 11|10 inst[30:25] 5|4 inst[24:21] 1|0 0 0|
  // 符号拡張したときに必ず最後が0になるのはRiscVの命令長が必ず2byteの整数倍長だから
  val imm_j = Cat(inst(31), inst(19, 12), inst(20), inst(30, 21))
  val imm_j_sext = Cat(Fill(11, imm_j(19)), imm_j, 0.U(1.U))
  // U形式
  //  ↓ここ
  // |31 imm[31:12] 12|11 rd 7|6 opcode 0|
  // |31 inst[31] 31|30 inst[30:20] 20|19 inst[19:12] 12|11 --0-- 0|
  val imm_u = inst(31, 12)
  val imm_u_shifted = Cat(imm_u, Fill(12, 0.U))
  // CSR用の即値(I形式)
  // ↓ここ
  // |31 imm[11:0] 20|19 rs1 15|14 funct3 12|11 rd 7|6 opcode 0|
  // |31 --0-- 4|3 inst[19:15] 0|
  val imm_z = inst(19, 15)
  val imm_z_uext = Cat(Fill(27, 0.U), imm_z)

  // csignals 制御信号をまとめたもの
  // ListLookup
  // instと各bitPatを比較して、一致するものがあればそれを返す
  // なければデフォルトのものを返す
  val csignals = ListLookup(
    inst,
    // どの命令にも一致しないときは全ての信号をXにする
    List(ALU_X, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),
    Array(
      // LW  Load Word命令 I形式
      // 指定したレジスタに即値を加算したアドレスのメモリのデータを書き込む
      // x[rd] = M[x[rs1] + sext(offset)]
      // ALU: ADD
      // OP1: RS1 (rs1_data) 命令のデコードでregfileから取り出したデータ
      // OP2: IMI (imm_i_sext)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: S(書き込む)
      // WriteBack: MEM
      // CSR: X(なし)

      LW -> List(ALU_ADD, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM, CSR_X),

      // SW  Store Word命令 S形式
      // M[x[rs1] + sext(offset)] = x[rs2]
      // ALU: ADD
      // OP1: RS1 (rs1_data)
      // OP2: IMI (imm_s_sext)
      // DMEMとやり取りをするか: S(する)
      // レジスタファイルに書き込むか: X(しない)
      // WriteBack: X(しない)
      // CSR: X(なし)

      SW -> List(ALU_ADD, OP1_RS1, OP2_IMS, MEN_S, REN_X, WB_X, CSR_X),

      // 加減算・論理演算命令
      // R形式
      // OP1: RS1 (rs1_data)
      // OP2: RS2 (rs2_data)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: S(書き込む)
      // WriteBack: ALU
      // CSR: X(なし)

      // Add命令
      // x[rd] = x[rs1] + x[rs2]
      // ALU: ADD
      ADD -> List(ALU_ADD, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // Sub命令
      // x[rd] = x[rs1] - x[rs2]
      // ALU: SUB
      SUB -> List(ALU_SUB, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // And命令 R形式
      // x[rd] = x[rs1] & x[rs2]
      // ALU: AND
      AND -> List(ALU_AND, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // Or命令 R形式
      // x[rd] = x[rs1] | x[rs2]
      // ALU: OR
      OR -> List(ALU_OR, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // Xor命令 R形式
      // x[rd] = x[rs1] ^ x[rs2]
      // ALU: XOR
      XOR -> List(ALU_XOR, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // 即値加算・論理演算命令
      // OP1: RS1 (rs1_data)
      // OP2: IMI (imm_i_sext)

      // Addi命令
      // x[rd] = x[rs1] + sext(imm)
      // ALU: ADD
      ADDI -> List(ALU_ADD, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),

      // Andi命令 I形式
      // x[rd] = x[rs1] & sext(imm)
      // ALU: AND
      ANDI -> List(ALU_AND, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),

      // Ori命令 I形式
      // x[rd] = x[rs1] | sext(imm)
      // ALU: OR
      ORI -> List(ALU_OR, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),

      // Xori命令 I形式
      // x[rd] = x[rs1] ^ sext(imm)
      // ALU: XOR
      XORI -> List(ALU_XOR, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),

      // シフト命令 R形式
      // OP1: RS1 (rs1_data)
      // OP2: RS2 (rs2_data)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: S(書き込む)
      // WriteBack: ALU
      // CSR: X(なし)

      // Sll  Shift Left Logical 命令
      // x[rd] = x[rs1] << x[rs2]
      // ALU: SLL
      SLL -> List(ALU_SLL, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // Srl  Shift Right Logical 命令 論理右シフト
      // x[rd] = x[rs1] >> x[rs2]
      // ALU: SRL
      SRL -> List(ALU_SRL, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // Sra  Shift Right Arithmetic 命令 算術右シフト
      // x[rd] = x[rs1] >> x[rs2]
      // ALU: SRA
      SRA -> List(ALU_SRA, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // 即値シフト命令 I形式
      // OP2: IMI (imm_i_sext)

      // Slli  Shift Left Logical Immediate 命令
      // x[rd] = x[rs1] << imm
      // ALU: SLL
      SLLI -> List(ALU_SLL, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      // Srli  Shift Right Logical Immediate 命令 論理右シフト
      // x[rd] = x[rs1] >> imm
      // ALU: SRL
      SRLI -> List(ALU_SRL, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      // Srai  Shift Right Arithmetic Immediate 命令 算術右シフト
      // x[rd] = x[rs1] >> imm
      // ALU: SRA
      SRAI -> List(ALU_SRA, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),

      // 比較演算命令 R形式
      // OP1: RS1 (rs1_data)
      // OP2: RS2 (rs2_data)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: S(書き込む)
      // WriteBack: ALU
      // CSR: X(なし)

      // Slt  Set Less Than 命令
      // x[rd] = (x[rs1] < x[rs2]) ? 1 : 0
      // ALU: SLT
      SLT -> List(ALU_SLT, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // Sltu  Set Less Than Unsigned 命令
      // x[rd] = (x[rs1] < x[rs2]) ? 1 : 0
      // ALU: SLTU
      SLTU -> List(ALU_SLTU, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),

      // 即値比較演算命令 I形式
      // OP1: RS1 (rs1_data)
      // OP2: IMI (imm_i_sext)

      // Slti  Set Less Than Immediate 命令
      // x[rd] = (x[rs1] < imm) ? 1 : 0
      // ALU: SLT
      SLTI -> List(ALU_SLT, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),

      // Sltiu  Set Less Than Immediate Unsigned 命令
      // x[rd] = (x[rs1] < imm) ? 1 : 0
      // ALU: SLTU
      SLTIU -> List(ALU_SLTU, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),

      // 分岐命令 B形式
      // OP1: RS1 (rs1_data)
      // OP2: RS2 (rs2_data)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: X(しない)
      // WriteBack: X(しない)
      // CSR: X(なし)
      // ALU: X(しない)

      // Beq  Branch if Equal 命令
      // if (x[rs1] == x[rs2]) pc += offset(imm_b_sext)
      BEQ -> List(BR_BEQ, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),

      // Bne  Branch if Not Equal 命令
      // if (x[rs1] != x[rs2]) pc += offset(imm_b_sext)
      BNE -> List(BR_BNE, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),

      // Bge  Branch if Greater or Equal 命令
      // if (x[rs1] >= x[rs2]) pc += offset(imm_b_sext)
      BGE -> List(BR_BGE, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),

      // Bgeu  Branch if Greater or Equal Unsigned 命令
      // if (x[rs1] >= x[rs2]) pc += offset(imm_b_sext)
      BGEU -> List(BR_BGEU, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),

      // Blt  Branch if Less Than 命令
      // if (x[rs1] < x[rs2]) pc += offset(imm_b_sext)
      BLT -> List(BR_BLT, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),

      // Bltu  Branch if Less Than Unsigned 命令
      // if (x[rs1] < x[rs2]) pc += offset(imm_b_sext)
      BLTU -> List(BR_BLTU, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),

      // ジャンプ命令 J形式
      // OP1: PC (pc_reg)
      // OP2: IMJ (imm_j_sext)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: S(書き込む)
      // WriteBack: PC
      // CSR: X(なし)

      // Jal  Jump and Link 命令
      // x[rd] = pc + 4; pc += offset(imm_j_sext)
      // ALU: ADD
      JAL -> List(ALU_ADD, OP1_PC, OP2_IMJ, MEN_X, REN_S, WB_PC, CSR_X),

      // Jalr  Jump and Link Register 命令
      // x[rd] = pc + 4; pc = x[rs1] + imm
      // ALU: JALR
      JALR -> List(ALU_JALR, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_PC, CSR_X),

      // 即値ロード命令 U形式
      // OP1: X(しない)
      // OP2: IMU (imm_u_shifted)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: S(書き込む)
      // WriteBack: ALU
      // CSR: X(なし)

      // この命令を使うことで任意の場所に相対的にジャンプできる

      // Lui  Load Upper Immediate 命令
      // x[rd] = imm
      // ALU: ADD
      LUI -> List(ALU_ADD, OP1_X, OP2_IMU, MEN_X, REN_S, WB_ALU, CSR_X),

      // Auipc  Add Upper Immediate to PC 命令
      // x[rd] = pc + imm
      // ALU: ADD
      AUIPC -> List(ALU_ADD, OP1_PC, OP2_IMU, MEN_X, REN_S, WB_ALU, CSR_X),

      // CSR Control and Status Register 命令
      // OP1: RS1 (rs1_data)
      // OP2: X(しない)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: S(書き込む)
      // WriteBack: CSR
      // CSR: W(書き込む), S(セット), C(クリア), E(例外)

      // Csrrw  Control and Status Register Read and Write 命令
      // x[rd] = csr; csr = x[rs1]
      // ALU: COPY1
      CSRRW -> List(ALU_COPY1, OP1_RS1, OP2_X, MEN_X, REN_S, WB_CSR, CSR_W),

      // Csrrwi  Control and Status Register Read and Write Immediate 命令
      // x[rd] = csr; csr = imm_z
      // ALU: COPY1
      CSRRWI -> List(ALU_COPY1, OP1_IMZ, OP2_X, MEN_X, REN_S, WB_CSR, CSR_W),

      // Csrrs  Control and Status Register Read and Set 命令
      // x[rd] = csr; csr = csr | x[rs1]
      // ALU: COPY1
      CSRRS -> List(ALU_COPY1, OP1_RS1, OP2_X, MEN_X, REN_S, WB_CSR, CSR_S),

      // Csrrsi  Control and Status Register Read and Set Immediate 命令
      // x[rd] = csr; csr = csr | imm_z
      // ALU: COPY1
      CSRRSI -> List(ALU_COPY1, OP1_IMZ, OP2_X, MEN_X, REN_S, WB_CSR, CSR_S),

      // Csrrc  Control and Status Register Read and Clear 命令
      // x[rd] = csr; csr = csr & ~x[rs1]
      // ALU: COPY1
      CSRRC -> List(ALU_COPY1, OP1_RS1, OP2_X, MEN_X, REN_S, WB_CSR, CSR_C),

      // Csrrci  Control and Status Register Read and Clear Immediate 命令
      // x[rd] = csr; csr = csr & ~imm_z
      // ALU: COPY1
      CSRRCI -> List(ALU_COPY1, OP1_IMZ, OP2_X, MEN_X, REN_S, WB_CSR, CSR_C),

      // Ecall  Environment Call 命令
      // ALU: X(しない)
      // OP1: X(しない)
      // OP2: X(しない)
      // DMEMとやり取りをするか: X(しない)
      // レジスタファイルに書き込むか: X(しない)
      // WriteBack: X(しない)
      // CSR: E(例外)
      ECALL -> List(ALU_X, OP1_X, OP2_X, MEN_X, REN_X, WB_X, CSR_E)
    )
  )

  // csignalsから取り出した制御信号をそれぞれの変数に格納
  val exe_fun :: op1_sel :: op2_sel :: mem_wen :: rf_wen :: wb_sel :: csr_cmd :: Nil =
    csignals

  // operand1の選択
  // どれにも当てはまらない場合は0
  val op1_data = MuxCase(
    0.U(WORD_LEN.W),
    Seq(
      (op1_sel === OP1_RS1) -> rs1_data,
      (op1_sel === OP1_PC) -> pc_reg,
      (op1_sel === OP1_IMZ) -> imm_z_uext
    )
  )

  // operand2の選択
  val op2_data = MuxCase(
    0.U(WORD_LEN.W),
    Seq(
      (op2_sel === OP2_RS2) -> rs2_data,
      (op2_sel === OP2_IMI) -> imm_i_sext,
      (op2_sel === OP2_IMS) -> imm_s_sext,
      (op2_sel === OP2_IMJ) -> imm_j_sext,
      (op2_sel === OP2_IMU) -> imm_u_shifted
    )
  )

  // ALUの実装
  // exe_funによって選択された演算を行う
  alu_out := MuxCase(
    0.U(WORD_LEN.W),
    Seq(
      // 加算
      (exe_fun === ALU_ADD) -> (op1_data + op2_data),
      // 減算
      (exe_fun === ALU_SUB) -> (op1_data - op2_data),
      // AND
      (exe_fun === ALU_AND) -> (op1_data & op2_data),
      // OR
      (exe_fun === ALU_OR) -> (op1_data | op2_data),
      // XOR
      (exe_fun === ALU_XOR) -> (op1_data ^ op2_data),
      // SLL 論理左シフト
      // op2_dataの下位5bitを取り出してシフトする
      // シフト後の値の下位32bitを取り出す
      (exe_fun === ALU_SLL) -> (op1_data << op2_data(4, 0))(31, 0),
      // SRL 論理右シフト
      // op2_dataの下位5bitを取り出してシフトする
      // .asUIntを使うことでビット幅をシフト量分だけ拡張する
      (exe_fun === ALU_SRL) -> (op1_data >> op2_data(4, 0)).asUInt(),
      // SRA 算術右シフト
      // op2_dataの下位5bitを取り出してシフトする
      // .asSIntを使うこでビット幅をシフト量分だけ拡張する
      (exe_fun === ALU_SRA) -> (op1_data.asSInt() >> op2_data(4, 0)).asUInt(),
      // SLT 符号付き比較
      // op1_dataがop2_dataより小さいとき1、そうでないとき0
      // asUIntを使うことでBoolをUIntに変換する
      (exe_fun === ALU_SLT) -> (op1_data.asSInt() < op2_data.asSInt()).asUInt(),
      // SLTU 符号なし比較
      (exe_fun === ALU_SLTU) -> (op1_data < op2_data).asUInt(),
      // JALR ジャンプ命令
      // ~1.U(WORD_LEN.W) これは下位ビットが0でその他が1のビット列を作る
      // これを使ってANDを取ると下位ビットが必ず0になるのでジャンプ先のアドレスが確実に命令の先頭になる（意図的に即値に飛ばすこともできるけど...）
      (exe_fun === ALU_JALR) -> ((op1_data + op2_data) & ~1.U(WORD_LEN.W)),
      // COPY1
      (exe_fun === ALU_COPY1) -> op1_data
    )
  )

  // 分岐先のカウンタ
  br_target := pc_reg + imm_b_sext

  // 分岐命令の実装
  br_flg := MuxCase(
    // 分岐しないときはfalse
    false.B,
    Seq(
      (exe_fun === BR_BEQ) -> (op1_data === op2_data),
      (exe_fun === BR_BNE) -> !(op1_data === op2_data),
      (exe_fun === BR_BLT) -> (op1_data.asSInt() < op2_data.asSInt()),
      (exe_fun === BR_BGE) -> !(op1_data.asSInt() < op2_data.asSInt()),
      (exe_fun === BR_BLTU) -> (op1_data < op2_data),
      (exe_fun === BR_BGEU) -> !(op1_data < op2_data)
    )
  )

  // 以降の演算でaluの結果を使用したいので、alu_outをdmemに渡す
  io.dmem.addr := alu_out

  // SW命令のときにしか使われない MEN_Sの命令はSWのみ
  // write enable
  io.dmem.wen := mem_wen
  io.dmem.wdata := rs2_data

  // CSRの実装
  // ECALL命令のときは0x305の値を返す
  val csr_addr = Mux(csr_cmd === CSR_E, 0x342.U(CSR_ADDR_LEN.W), inst(31, 20))

  val csr_rdata = csr_regfile(csr_addr)
  val csr_wdata = MuxCase(
    0.U(WORD_LEN.W),
    Seq(
      (csr_cmd === CSR_W) -> op1_data,
      (csr_cmd === CSR_S) -> (csr_rdata | op1_data),
      (csr_cmd === CSR_C) -> (csr_rdata & ~op1_data),
      (csr_cmd === CSR_E) -> 11.U(WORD_LEN.W)
    )
  )

  // 命令がCSR命令のとき
  when(csr_cmd > 0.U) {
    csr_regfile(csr_addr) := csr_wdata
  }

  // write backの実装
  val wb_data = MuxCase(
    // デフォルトはalu_outが出力される
    alu_out,
    Seq(
      // メモリに書き込むとき
      (wb_sel === WB_MEM) -> io.dmem.rdata,
      // program counterを書き込むとき
      (wb_sel === WB_PC) -> pc_plus4,
      // csrの値を書き込むとき
      (wb_sel === WB_CSR) -> csr_rdata
    )
  )

  // レジスタファイルへの書き込み
  when(rf_wen === REN_S) {
    regfile(wb_addr) := wb_data
  }

  // デバッグ用
  io.gp := regfile(3)
  // io.exitがtrueのときプログラムを終了する
  io.exit := (inst === UNIMP)

  printf(p"io.pc      : 0x${Hexadecimal(pc_reg)}\n")
  printf(p"inst       : 0x${Hexadecimal(inst)}\n")
  printf(p"gp         : ${regfile(3)}\n")
  printf(p"rs1_addr   : $rs1_addr\n")
  printf(p"rs2_addr   : $rs2_addr\n")
  printf(p"wb_addr    : $wb_addr\n")
  printf(p"rs1_data   : 0x${Hexadecimal(rs1_data)}\n")
  printf(p"rs2_data   : 0x${Hexadecimal(rs2_data)}\n")
  printf(p"wb_data    : 0x${Hexadecimal(wb_data)}\n")
  printf(p"dmem.addr  : ${io.dmem.addr}\n")
  printf(p"dmem.rdata : ${io.dmem.rdata}\n")
  printf("---------\n")

}
