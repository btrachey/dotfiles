import sbt._
import Keys._
import scala.sys.process._
import scala.util._
import java.io.{ByteArrayOutputStream, PrintWriter}

object ShellPrompt extends AutoPlugin {
  override def trigger = allRequirements

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
      case (exit, _, _) if (exit != 0) =>
        ""
      case (_, stdout, _) =>
        stdout
    }
  }

  def makeItem(v: fansi.Str, i: Int): fansi.Str = {
    val prefix: fansi.Str =
      if (i == 0)
        lineStart
      else
        itemStart
    if (v.length > 0)
      prefix ++ v ++ itemEnd
    else
      fansi.Str("")
  }

  def gitBranch = {
    val res = runCommand("git rev-parse --abbrev-ref HEAD".split(" ").toSeq)
    if (res.nonEmpty)
      fansi.Color.Yellow(branchSymbol + res)
    else
      fansi.Color.Yellow(res)
  }

  def time = {
    val now = java.time.LocalTime.now()
    val fmt = java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss")
    fansi.Color.Yellow(now.format(fmt))
  }

  def addSpace(
      width: Int,
      segmentCount: Int,
      idx: Int,
      item: fansi.Str
  ): String = {
    val oneItemSpace = width / segmentCount
    val remSpace = oneItemSpace - item.length
    val spaceToAdd = (remSpace / 2).toInt
    if (idx == 0)
      item + (" " * remSpace)
    else if (idx == segmentCount)
      (" " * remSpace) + item
    else
      (" " * spaceToAdd) + item + (" " * spaceToAdd)
  }

  def textColor(color: Int) = {
    s"\033[38;5;${color}m"
  }
  def backgroundColor(color: Int) = {
    s"\033[48;5;${color}m"
  }
  def reset = {
    s"\033[0m"
  }

  def formatText(str: String)(txtColor: Int, backColor: Option[Int] = None) = {
    s"${textColor(txtColor)}${backColor
        .map(backgroundColor)
        .getOrElse("")}${str}${reset}"
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
  val lineStart = fansi.Color.Blue("╭─┤ ")
  val itemStart = fansi.Color.Blue("╾─┤ ")
  val itemEnd = fansi.Color.Blue(" ├─╼")
  val promptStart = fansi.Color.Blue("╰╼ ")
  override def projectSettings = Seq(
    shellPrompt := { state =>
      "sbt Hey (%s)> ".format(Project.extract(state).currentProject.id)
    }
    // shellPrompt := { state =>
    //   val term = Project.extract(state).runTask(terminal, state)._2
    //   val columns = term.getWidth
    //   val proj = fansi
    //     .Color
    //     .Green(sbtSymbol + Project.extract(state).currentRef.project)
    //   val components = Seq(proj, time, gitBranch).filter(_.length > 0)
    //   val componentCount = components.length
    //   "\n" +
    //     components
    //       .zipWithIndex
    //       .map { case (item, idx) =>
    //         addSpace(columns, componentCount, idx, makeItem(item, idx))
    //       }
    //       .mkString("") + "\n" + promptStartEsc + promptStart + promptEnd
    // }
  )
}
