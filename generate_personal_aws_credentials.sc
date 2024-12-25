#! amm

import scala.util.Try
import scala.collection.immutable.ListMap

def getKeychainPassword(item_label: String): Option[String] = {
  val procString = s"security find-generic-password -s $item_label -w"
  val subprocess = os.proc(procString.split(" ")).call(check = false)
  subprocess.exitCode match {
    case 0 => Some(subprocess.out.text().strip())
    case _ => None
  }
}

@arg(doc = "Add personal AWS access key and token to config.")
@main
def main(): Unit = {
  val personalSectionLabel = "[btrachey]"
  val sectionLabelRegex = """^\[(.*)\]$""".r

  val awsCredentialsFilePath = os.home / ".aws" / "credentials"
  val awsCredentialsFile = Try(
    os.read(awsCredentialsFilePath).split("\n").toList
  ).getOrElse(List.empty[String])
  val fileGroupedByKey = awsCredentialsFile.foldLeft(
    ListMap.empty[String, Array[String]]
  )((acc, next) =>
    next match {
      case sectionLabelRegex(m) => acc ++ Map(next -> Array.empty[String])
      case _ => {
        val key = acc.last._1
        val updatedValue = acc(key) :+ next
        acc ++ Map(key -> updatedValue)
      }
    }
  )

  fileGroupedByKey.get(personalSectionLabel) match {
    case Some(_) => exit
    case None => {
      val outputRows = Array(personalSectionLabel) ++ Array(
        "aws_access_key_id",
        "aws_secret_access_key"
      ).flatMap(elem => getKeychainPassword(elem).map(pw => s"$elem = $pw"))
      os.write.append(
        awsCredentialsFilePath,
        outputRows.mkString("\n", "\n", "\n"),
        createFolders = true
      )
    }
  }
}
