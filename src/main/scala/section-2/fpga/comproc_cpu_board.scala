package fpga

import chisel3._
import chisel3.stage.ChiselStage
import ctest.Top

object Elaborate_ComProcCpuBoard extends App {
  (new ChiselStage).emitVerilog(
    new Top,
    Array(
      "-o",
      "riscv.v",
      "--target-dir",
      "rtl/comproc_cpu_board"
    )
  )
}
