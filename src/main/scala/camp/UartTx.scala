package camp
import chisel3._
import chisel3.util._

class UartConnector extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val data = Output(UInt(8.W))
    val ready = Input(Bool())
    val valid = Output(Bool())
  })
  val data = RegInit(0.U(8.W))
  io.data := WireDefault(0.U)
  io.mem.rdata := io.ready
  io.mem.rvalid := true.B
  io.valid := io.mem.wen
  io.data := io.mem.wdata

//   when(io.mem.wen) {
//     val mask = Cat(
//       (0 to 3).map(i => Mux(io.mem.wstrb(i), 0xff.U(8.W), 0x00.U(8.W))).reverse
//     )
//     switch(io.mem.addr(3, 2)) {
//       // Output
//       is(0.U) {
//         out := (out & ~mask) | (io.mem.wdata & mask)
//       }
//     }
//   }
}

class UartTx(clockFrequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val tx = Output(Bool())
    val data = Input(UInt(8.W))
    val ready = Output(Bool())
    val valid = Input(Bool())
  })
  val baudDivider = clockFrequency / baudRate // クロック周波数/ボー・レート
  val rateCounter = RegInit(0.U(log2Ceil(baudDivider).W)) // ボー・レート周期生成用カウンタ
  val bitCounter = RegInit(0.U(log2Ceil(8 + 2).W)) // 残り送信ビット数カウンタ
  val bits = Reg(Vec(8 + 2, Bool())) // 送信ビット・バッファ
  io.tx := bitCounter === 0.U || bits(0) // 送信中ならbit0を出力。それ以外は'1'を出力
  val ready = bitCounter === 0.U // ビット・カウンタ == 0なので、次の送信を開始できるか？
  io.ready := ready
  when(io.valid && ready) {
    bits := Cat(1.U, io.data, 0.U).asBools // STOP(1), 'A', START(0)
    bitCounter := (8 + 2).U // 残送信ビット数 = 10bit (STOP + DATA + START)
    rateCounter := (baudDivider - 1).U // レートカウンタを初期化
  }
  when(bitCounter > 0.U) {
    when(rateCounter === 0.U) { // 次のボーレート周期の送信タイミング
      (0 to 8).foreach(i => bits(i) := bits(i + 1)) // ビットバッファを右シフトする
      bitCounter := bitCounter - 1.U
      rateCounter := (baudDivider - 1).U
    }.otherwise {
      rateCounter := rateCounter - 1.U
    }
  }
}
