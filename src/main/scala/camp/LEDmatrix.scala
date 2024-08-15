// package camp

// import chisel3._
// import chisel3.util._

// class LEDMatrix(refleshrate: Int) extends Module {
//   val io = IO(new Bundle {
//     val anodes = Output(UInt(8.W))
//     val cathodes = Output(UInt(8.W))
//     val data = Input(UInt(8.W))
//     val ready = Output(Bool())
//     val valid = Input(Bool())
//   })
//   val anodes = RegInit(0.U(8.W))
//   val cathodes = RegInit(0.U(8.W))
//   val data = RegInit(0.U(8.W))
//   val refleshCounter = RegInit(0.U(log2Ceil(refleshrate).W)) // ボー・レート周期生成用カウンタ
//   val rowCounter = RegInit(0.U(log2Ceil(8).W)) // 残り送信ビット数カウンタ
//   val bits = Reg(Vec(8, Bool())) // 送信ビット・バッファ
//   val ready = refleshCounter === 0.U // ビット・カウンタ == 0なので、次の送信を開始できるか？
//   io.ready := ready
//   when(io.valid && ready) {
//     bits := io.data.asBools
//     rowCounter := 8.U // 残送信ビット数 = 8bit
//     refleshCounter := (refleshrate - 1).U // レートカウンタを初期化
//   }
//   when(rowCounter > 0.U) {
//     when(refleshCounter === 0.U) { // 次のボーレート周期の送信タイミング
//       (0 to 6).foreach(i => bits(i) := bits(i + 1)) // ビットバッファを右シフトする
//       rowCounter := rowCounter - 1.U
//       refleshCounter := (refleshrate - 1).U
//     }.otherwise {
//       refleshCounter := refleshCounter - 1.U
//     }
//   }
//   io.anodes := Cat(anodes)
//   io.cathodes := Cat(cathodes)
// }

package camp

import chisel3._
import chisel3.util._
import common.Consts._

class LedMatrix() extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val anodes = Output(UInt(8.W))
    val cathodes = Output(UInt(8.W))
  })

  val anodes = RegInit(1.U(8.W))
  val cathodes = RegInit(1.U(8.W))

  val refleshCounter = RegInit(0.U(log2Ceil(1000000).W)) // ボー・レート周期生成用カウンタ
  val rowCounter = RegInit(0.U(log2Ceil(8).W)) // 残り送信ビット数カウンタ

  io.anodes := anodes
  io.cathodes := ~cathodes

  io.mem.rdata := "xdeadbeef".U
  io.mem.rvalid := true.B
  // // 書き込み可能なときに上位8bitをanodesに、下位8bitをcathodesに書き込む
  when(io.mem.wen) {
    anodes := io.mem.wdata(15, 8)
    io.mem.rvalid := false.B
  }

  when(refleshCounter === 0.U) {
    refleshCounter := (1000000 - 1).U

    when(rowCounter === 0.U) {
      cathodes := Mux(cathodes === 1.U, 128.U, cathodes >> 1)
      rowCounter := 8.U
    }.elsewhen(rowCounter === 8.U) {
      rowCounter := rowCounter - 1.U
    }.otherwise(
      rowCounter := rowCounter - 1.U
    )
  }.otherwise {
    refleshCounter := refleshCounter - 1.U

  }
}
