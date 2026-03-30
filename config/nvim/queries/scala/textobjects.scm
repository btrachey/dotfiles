;; extends
(arguments
  .
  _ @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(arguments
  "," @parameter.outer
  .
  _ @parameter.inner @parameter.outer)

(bindings
  .
  _ @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(bindings
  "," @parameter.outer
  .
  _ @parameter.inner @parameter.outer)

(tuple_expression
  .
  _ @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(tuple_expression
  "," @parameter.outer
  .
  _ @parameter.inner @parameter.outer)

(lambda_expression
  .
  _ @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(lambda_expression
  "," @parameter.outer
  .
  _ @parameter.inner @parameter.outer)

(parameters
  .
  _ @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(parameters
  "," @parameter.outer
  .
  _ @parameter.inner @parameter.outer)
