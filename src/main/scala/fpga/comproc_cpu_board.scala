package fpga

import chisel3._
import _root_.circt.stage.ChiselStage

import camp.Top

object Elaborate_ComProcCpuBoard extends App {
  ChiselStage.emitSystemVerilogFile(
    new Top,
    Array("--target-dir", "rtl/comproc_cpu_board"),
    Array("--lowering-options=disallowLocalVariables")
  )
}
