package camp

import chisel3._
import common.Consts._

class Top extends Module {
  val io = IO(new Bundle {
    // プログラムの終了フラグ
    val exit = Output(Bool())
    val debug_pc = Output(UInt(WORD_LEN.W))
    val success = Output(Bool())

  })
  val base_address = "x00000000".U(WORD_LEN.W)
  // モジュールのインスタンス化
  val core = Module(new Core(startAddress = base_address))

  // メモリのインスタンス化
  val memory = Module(
    new Memory(Some(i => f"../sw/bootrom_${i}.hex"), base_address, 8192)
  )

  // メモリの接続
  core.io.imem <> memory.io.imem
  core.io.dmem <> memory.io.dmem

  // 終了フラグ
  io.exit := core.io.exit
  io.debug_pc := core.io.debug_pc

}
