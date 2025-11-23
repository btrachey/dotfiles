sbtPlugin := true
libraryDependencies ++= Seq("com.lihaoyi" %% "fansi" % "0.5.1")
libraryDependencies += {
  val currentSbtVersion = (pluginCrossBuild / sbtBinaryVersion).value
  Defaults.sbtPluginExtra(
    "com.github.sbt" % "sbt-git" % "2.1.0",
    currentSbtVersion,
    scalaBinaryVersion.value
  )
}
