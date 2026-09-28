import sbt._
import Keys._
import scala.sys.process._
import scala.util._
import java.io.{ByteArrayOutputStream, PrintWriter}

object ShellPrompt extends AutoPlugin {
  override def trigger = allRequirements

  val promptStart = "\u001b]133;P;k=i\u0007"
  val promptEnd = "\u001b]133;B\u0007"
  val sbtSymbol = " "
  val dot = fansi.Color.Magenta(" 󰇙 ")
  val arrowR = fansi.Color.Magenta("  ")
  override def projectSettings = Seq(
    shellPrompt := { state =>
      val extracted = Project.extract(state)
      val project = extracted.currentRef.project
      val root = extracted.rootProject(extracted.currentRef.build)
      val term = extracted.runTask(terminal, state)._2
      val columns = term.getWidth
      val projLabel = {
        val label =
          if (project == root)
            project
          else
            s"$root/$project"
        fansi.Color.Green(sbtSymbol + label)
      }
      promptStart + projLabel + dot +
        fansi.Color.Yellow("git symbolic-ref --short HEAD".!!.trim) + arrowR +
        promptEnd
    }
  )
}
