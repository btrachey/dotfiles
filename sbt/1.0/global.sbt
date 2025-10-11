import scala.sys.process._
import scala.util._
import java.io.{ByteArrayOutputStream, PrintWriter}

def runCommand(cmd: Seq[String]): String = {
  val stdout = new ByteArrayOutputStream
  val stderr = new ByteArrayOutputStream
  val stdoutWriter = new PrintWriter(stdout)
  val stderrWriter = new PrintWriter(stderr)

  val exitValue = cmd.!(
    ProcessLogger(
      out => stdoutWriter.print(out),
      err => stderrWriter.print(err)
    )
  )

  stdoutWriter.close()
  stderrWriter.close()
  (exitValue, stdout.toString, stderr.toString) match {
    case (exit, _, _) if (exit != 0) => ""
    case (_, stdout, _)              => stdout
  }
}

def makeItem(v: String, i: Int): String = {
  val prefix = if (i == 0) lineStart else itemStart
  if (v.nonEmpty) prefix + v + itemEnd else ""
}

def gitBranch = {
  val res = runCommand("git rev-parse --abbrev-ref HEAD".split(" ").toSeq)
  if (res.nonEmpty) branchSymbol + res
  else res
}

def time = {
  val now = java.time.LocalTime.now()
  val fmt = java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss")
  now.format(fmt)
}

def addSpace(width: Int, segmentCount: Int, idx: Int, item: String): String = {
  val oneItemSpace = width / segmentCount
  val remSpace = oneItemSpace - item.length
  val spaceToAdd = (remSpace / 2).toInt
  if (idx == 0) item + (" " * remSpace)
  else if (idx == segmentCount) (" " * remSpace) + item
  else
    (" " * spaceToAdd) + item + (" " * spaceToAdd)
}

def textColor(color: Int) = { s"\033[38;5;${color}m" }
def backgroundColor(color: Int) = { s"\033[48;5;${color}m" }
def reset = { s"\033[0m" }

def formatText(str: String)(txtColor: Int, backColor: Option[Int] = None) = {
  s"${textColor(txtColor)}${backColor.map(backgroundColor).getOrElse("")}${str}${reset}"
}
val blank = 0
val red = 1
val green = 2
val blue = 4
val yellow = 11
val white = 15
val black = 16
val orange = 166
val promptStartEsc = "\033]133;P;k=i\007"
val promptEnd = "\033]133;B\007"
val branchSymbol = " "
val sbtSymbol = " "
val lineStart = "╭─┤ "
// val lineStart = fansi.Color.Blue("╭─┤ ")
// val lineStart = formatText("╭─┤ ")(blue)
val itemStart = "╾─┤ "
// val itemStart = formatText("╾─┤ ")(blue)
val itemEnd = " ├─╼"
// val itemEnd = formatText(" ├─╼")(blue)
val promptStart = "╰╼ "
// val promptStart = formatText("╰╼ ")(blue)

Global / semanticdbEnabled := true
Global / watchBeforeCommand := Watch.clearScreen
Global / javaOptions += "-XX:+UseG1GC"
// Global / shellPrompt := { state =>
//   val term = Project.extract(state).runTask(terminal, state)._2
//   val columns = term.getWidth
//   val proj =
//     sbtSymbol + Project.extract(state).currentRef.project
//   // formatText(sbtSymbol + Project.extract(state).currentRef.project)(green)
//   val components = Seq(proj, time, gitBranch).filter(_.nonEmpty)
//   val componentCount = components.length
//   components.zipWithIndex
//     .map { case (item, idx) =>
//       addSpace(columns, componentCount, idx, makeItem(item, idx))
//     }
//     .mkString("") + "\n" + promptStartEsc + promptStart + promptEnd
// }
