file://<WORKSPACE>/src/main/scala/common/Consts.scala
### java.lang.IndexOutOfBoundsException: 0

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 3.3.3
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala3-library_3/3.3.3/scala3-library_3-3.3.3.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.12/scala-library-2.13.12.jar [exists ]
Options:



action parameters:
offset: 886
uri: file://<WORKSPACE>/src/main/scala/common/Consts.scala
text:
```scala
package common

import chisel3._
import chisel3.util._

object Consts {
  val WORD_LEN = 32
  val START_ADDR = 0.U(WORD_LEN.W)
  val BUBBLE = 0x00000013.U(WORD_LEN.W)
  val UNIMP = 0xc0001073L.U(WORD_LEN.W)
  val ADDR_LEN = 5
  val CSR_ADDR_LEN = 12
  val VLEN = 128
  val LMUL_LWN = 2
  val SEW_LEN = 11
  val VL_ADDR = 0xC20
  val VTYPE_ADDR = 0xC21
  
  val EXE_FUN_LEN = 5
  val ALU_X = 0.U(EXE_FUN_LEN.W)
  val ALU_ADD = 1.U(EXE_FUN_LEN.W)
  val ALU_SUB = 2.U(EXE_FUN_LEN.W)
  val ALU_AND = 3.U(EXE_FUN_LEN.W)
  val ALU_OR = 4.U(EXE_FUN_LEN.W)
  val ALU_XOR = 5.U(EXE_FUN_LEN.W)
  val ALU_SLL = 6.U(EXE_FUN_LEN.W)
  val ALU_SRL = 7.U(EXE_FUN_LEN.W)
  val ALU_SRA = 8.U(EXE_FUN_LEN.W)
  val ALU_SLT = 9.U(EXE_FUN_LEN.W)
  val ALU_SLTU = 10.U(EXE_FUN_LEN.W)
  val BR_BEQ = 11.U(EXE_FUN_LEN.W)
  val BR_BNE = 12.U(EXE_FUN_LEN.W)
  val BR_BLT = 13.U(EXE_FUN_LEN.W)
  val BR_BGE = 14.U(@@)
}

```



#### Error stacktrace:

```
scala.collection.LinearSeqOps.apply(LinearSeq.scala:131)
	scala.collection.LinearSeqOps.apply$(LinearSeq.scala:128)
	scala.collection.immutable.List.apply(List.scala:79)
	dotty.tools.dotc.util.Signatures$.countParams(Signatures.scala:501)
	dotty.tools.dotc.util.Signatures$.applyCallInfo(Signatures.scala:186)
	dotty.tools.dotc.util.Signatures$.computeSignatureHelp(Signatures.scala:94)
	dotty.tools.dotc.util.Signatures$.signatureHelp(Signatures.scala:63)
	scala.meta.internal.pc.MetalsSignatures$.signatures(MetalsSignatures.scala:17)
	scala.meta.internal.pc.SignatureHelpProvider$.signatureHelp(SignatureHelpProvider.scala:51)
	scala.meta.internal.pc.ScalaPresentationCompiler.signatureHelp$$anonfun$1(ScalaPresentationCompiler.scala:412)
```
#### Short summary: 

java.lang.IndexOutOfBoundsException: 0