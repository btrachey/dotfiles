import sbt._
import com.github.sbt.git.SbtGit._
import Keys._
import scala.sys.process._
import scala.util._
import java.io.{ByteArrayOutputStream, PrintWriter}

object ShellPrompt extends AutoPlugin {
  override def requires = com.github.sbt.git.GitPlugin
  override def trigger = allRequirements

  def gitBranch(state: State, extracted: Extracted, dir: File) = {
    val reader = extracted.get(GitKeys.gitReader)
    val branchFromReader = reader.withGit(_.branch)
    if (branchFromReader != null)
      branchFromReader
    else {
      val (_, runner) = extracted.runTask(GitKeys.gitRunner, state)

      runner("symbolic-ref", "--short", "HEAD")(dir, NoOpSbtLogger)
    }
  }

  private object NoOpSbtLogger extends Logger {
    def trace(t: => Throwable): Unit = {}
    def success(message: => String): Unit = {}
    def log(level: Level.Value, message: ⇒ String): Unit = {}
  }

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
        fansi
          .Color
          .Yellow(gitBranch(state, extracted, extracted.get(baseDirectory))) +
        arrowR + promptEnd
    }
  )
}
