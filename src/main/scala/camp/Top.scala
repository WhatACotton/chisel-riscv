package camp

import chisel3._
import common.Consts._

class Top extends Module {
  val io = IO(new Bundle {
    // プログラムの終了フラグ
    val exit = Output(Bool())
    val debug_pc = Output(UInt(WORD_LEN.W))
    val gpio_out = Output(UInt(32.W))
    val anodes = Output(UInt(8.W))
    val cathodes = Output(UInt(8.W))
    val success = Output(Bool())
    // val uart_tx = Output(Bool())
    val uart_rx = Input(Bool())
  })
  val baseAddress = BigInt("00000000", 16)
  val memSize = 8192
  val core = Module(new Core(startAddress = baseAddress.U(WORD_LEN.W)))
  val decoder = Module(
    new DMemDecoder(
      Seq(
        (BigInt(0x00000000L), BigInt(memSize)), // メモリ
        (BigInt(0xa0000000L), BigInt(64)), // GPIO
        (BigInt(0xb0000000L), BigInt(64)) // UARTTX
        // (BigInt(0xc0000000L), BigInt(64)) // UARTRX
      )
    )
  )
  val gpio = Module(new Gpio)
  // val uartTx = Module(new UartTx(27000000, 115200))
  // val uartRx = Module(new UartRx(8, 27000000 / 115200, 3))
  // val uartTxConnector = Module(new UartTxConnector)
  // val uartRxConnector = Module(new UartRxConnector)
  val ledMatrix = Module(new LedMatrix)
  // // モジュールのインスタンス化

  // // メモリのインスタンス化
  val memory = Module(
    new Memory(
      Some(i => f"../sw/bootrom_${i}.hex"),
      baseAddress.U(WORD_LEN.W),
      memSize
    )
  )

  // メモリの接続
  core.io.imem <> memory.io.imem
  core.io.dmem <> decoder.io.initiator // CPUにデコーダを接続
  decoder.io.targets(0) <> memory.io.dmem // 0番ポートにメモリを接続
  decoder.io.targets(1) <> gpio.io.mem // 1番ポートにGPIOを接続
  decoder.io.targets(2) <> ledMatrix.io.mem // 2番ポートにLEDマトリクスを接続
  // decoder.io.targets(2) <> uartTxConnector.io.mem // 2番ポートにUARTを接続
  // decoder.io.targets(3) <> uartRxConnector.io.mem // 3番ポートにUARTを接続
  // uartTxConnector.io.data <> uartTx.io.data
  // uartTxConnector.io.ready <> uartTx.io.ready
  // uartTxConnector.io.valid <> uartTx.io.valid

  // uartRxConnector.io.data := uartRx.io.out.bits
  // uartRxConnector.io.valid := uartRx.io.out.valid
  // uartRx.io.out.ready := uartRxConnector.io.ready
  // uartRx.io.rx := io.uart_rx
  io.anodes := ledMatrix.io.anodes
  io.cathodes := ledMatrix.io.cathodes

  io.gpio_out := gpio.io.out // GPIOの出力を外部ポートに接続
  // io.uart_tx := uartTx.io.tx // UARTの出力を外部ポートに接続

  // 終了フラグ
  io.exit := core.io.exit
  io.debug_pc := core.io.debug_pc
  io.success := core.io.success

}
