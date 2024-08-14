package camp
import chisel3._
import chisel3.util._

class UartRxConnector extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val data = Input(UInt(32.W))
    val ready = Output(Bool())
    val valid = Input(Bool())
  })
  val received = RegInit(false.B)
  val data = RegInit(0.U(8.W))
  io.mem.rvalid := received

  io.ready := !received
  when(!received && io.valid) {
    data := io.data(7, 0)
    // receivedがtrueになると、io.readyがfalseになる
    received := true.B
  }
  io.mem.rdata := MuxLookup(io.mem.addr(1, 0), received.asUInt)(
    Seq(0.U -> data)
  )

  when(io.mem.ren && received) {
    io.mem.rdata := data
    received := false.B
  }

}

class UartRx(numberOfBits: Int, baudDivider: Int, rxSyncStages: Int)
    extends Module {
  val io = IO(new Bundle {
    val out = Decoupled(UInt(numberOfBits.W)) // 受信データを出力
    val rx = Input(Bool()) // UART信号入力
    val overrun = Output(Bool()) // UARTデータ取りこぼし発生？
  })
  val rateCounter = RegInit(0.U(log2Ceil(baudDivider * 3 / 2).W))
  val bitCounter = RegInit(0.U(log2Ceil(numberOfBits).W))
  val bits = Reg(Vec(numberOfBits, Bool()))
  val rxRegs = RegInit(VecInit((0 to rxSyncStages + 1 - 1).map(_ => false.B)))
  val overrun = RegInit(false.B)
  val running = RegInit(false.B)
// 受信データの出力信号 (VALID/READYハンドシェーク)
  val outValid = RegInit(false.B)
  val outBits = Reg(UInt(numberOfBits.W))
  val outReady = WireDefault(io.out.ready)
  io.out.valid := outValid
  io.out.bits := outBits
  when(outValid && outReady) {
    outValid := false.B // VALID&READY成立したのでVALIDを落とす
  }
// RX信号をクロックに同期
  rxRegs(rxSyncStages) := io.rx
  (0 to rxSyncStages - 1).foreach(i => rxRegs(i) := rxRegs(i + 1))
  io.overrun := overrun
  when(!running) {
    when(!rxRegs(1) && rxRegs(0)) { // スタートビット検出
      rateCounter := (baudDivider * 3 / 2 - 1).U // Wait until the center of LSB.
      bitCounter := (numberOfBits - 1).U
      running := true.B
    }
  }.otherwise {
    when(rateCounter === 0.U) { // 1ビット周期ごとに処理
      bits(numberOfBits - 1) := rxRegs(0) // つぎのビットを出力
      (0 to numberOfBits - 2).foreach(i => bits(i) := bits(i + 1)) // 1ビット右シフト
      when(bitCounter === 0.U) { // ストップビットまで出力し終わった?
        outValid := true.B
        outBits := Cat(rxRegs(0), Cat(bits.slice(1, numberOfBits).reverse))
        overrun := outValid // 前のデータが処理される前に次のデータの受信完了した
        running := false.B
      }.otherwise {
        rateCounter := (baudDivider - 1).U
        bitCounter := bitCounter - 1.U
      }
    }.otherwise {
      rateCounter := rateCounter - 1.U
    }
  }
}
