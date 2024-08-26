## ----setup,include=FALSE------------------------------------------------------
library(osum)

## ----populate-----------------------------------------------------------------
a <- month.name
b <- sample(c("FALSE", "TRUE"), size = 5, replace = TRUE)
cars <- mtcars
.hidden <- -1L
.secret <- "Shhht!"
x1 <- rnorm(n = 10)
x2 <- runif(n = 20)
x3 <- rbinom(n = 30, size = 10, prob = 0.5)
lst <- list(first = x1, second = x2, third = x3)
fun <- function(x) {sqrt(x)}

## ----defaul-------------------------------------------------------------------
objects.summary()

## ----hidden-------------------------------------------------------------------
objects.summary(all.objects = TRUE)

## ----inside.function----------------------------------------------------------
# shows an empty list because inside myfunc no variables are defined
myfunc <- function() {objects.summary()}
myfunc()
# define a local variable inside myfunc
myfunc <- function() {y <- 1; objects.summary()}
myfunc()

## ----pattern------------------------------------------------------------------
objects.summary(pattern = "^x")
objects.summary(names = c("a", "b"))

## ----where--------------------------------------------------------------------
idx <- grep("package:graphics", search())
objects.summary(idx, pattern = "^plot")
objects.summary("package:graphics", pattern = "^plot")

## ----environment--------------------------------------------------------------
e <- new.env()
e$a <- 1:10
e$b <- rnorm(25)
e$df <- iris
e$arr <- iris3
objects.summary(e)

## ----clean.environment,include=FALSE------------------------------------------
rm(e, myfunc)

## ----package------------------------------------------------------------------
# check if the package foreign is attached
length(grep("package:foreign", search())) > 0L
objects.summary("package:foreign", pattern = "^write")
# check if the package foreign is attached
length(grep("package:foreign", search())) > 0L


## ----what---------------------------------------------------------------------
objects.summary(what = c("data.class", "storage.mode", "extent", "object.size"))
objects.summary(what = c("data", "stor", "ext", "obj"))

## ----what.order---------------------------------------------------------------
objects.summary(what = c("m", "s", "t", "o", "d", "e"))

## ----filter-------------------------------------------------------------------
objects.summary("package:datasets", pattern = "^[sU]", what = c("dat", "typ", "ext", "obj"),
                data.class = c("data.frame", "matrix"))

## ----filter.all.classes-------------------------------------------------------
objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj"), data.class = "array")
objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj"), 
                all.classes = TRUE, data.class = "array")

## ----filter.expression--------------------------------------------------------
objects.summary("package:grDevices", filter = mode != "function")

## ----filter.expression2-------------------------------------------------------
objects.summary("package:datasets", filter = mode != storage.mode)[1:10, ]

## ----filter.expression3-------------------------------------------------------
objects.summary("package:datasets", all.classes = TRUE, 
                filter = sapply(data.class, length) > 2L)

## ----sort---------------------------------------------------------------------
# filter on 'mode' and sort on 'data.class'
objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj"), mode = "numeric", 
                order = data.class)[1:10, ]
# filter on 'mode' and sort (descending) on 'object.size'
objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj"), mode = "numeric", 
                order = (-object.size))[1:10, ]
objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj"),  
                order = c(data.class, -object.size))[1:10, ]

## ----sort.extent--------------------------------------------------------------
# get all two-dimensional objects of from the datasets package, with more than 7 columns, 
# sorted by number on columns (ascending) and then on number of rows (descending) 
objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj"), 
                filter = sapply(extent, length) == 2L & sapply(extent, "[", 2L) > 7L,
                order = c(sapply(extent, "[", 2L), -sapply(extent, "[", 1L)))

## ----sort.reverse-------------------------------------------------------------
# get five biggest objects from package datasets
objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj"), 
                reverse=TRUE)[1:10, ]

## ----sort.cols----------------------------------------------------------------
objects.summary("package:datasets", what = c("dat", "typ", "ext"), pattern = "st", 
                filter = mode %in% c("list", "numeric"), order = object.size)

## ----print--------------------------------------------------------------------
os <- objects.summary("package:datasets", what = c("dat", "ext", "obj"), 
                      all.classes = TRUE, order = object.size, reverse = TRUE)
print(os, data.class.width = 25, max.rows = 12)

multi_class_objects <- row.names(objects.summary("package:datasets", all.classes = TRUE, 
                                                 filter =  sapply(data.class, length) > 1L))
os <- objects.summary("package:datasets", names = multi_class_objects, all.classes = TRUE, 
                      what = c("dat", "ext", "obj"))
print(os, data.class.width = 32, max.rows = 12)

## ----print.extent-------------------------------------------------------------
multi_dim_objects <- row.names(objects.summary("package:datasets", all.classes = TRUE, 
                                               data.class = c("array", "table")))
os <- objects.summary("package:datasets", names = multi_dim_objects, 
                      what = c("dat", "ext", "obj"))
print(os[rev(order(sapply(os$extent, length))), ], 
      format.extent = TRUE, max.rows = 12) # default
print(os[rev(order(sapply(os$extent, length))), ], 
      format.extent = FALSE, max.rows = 12)

## ----print.pass.down----------------------------------------------------------
print(objects.summary("package:datasets", what = c("dat", "typ", "ext", "obj")), 
      format.extent = TRUE, max.rows = 12, right = FALSE, quote = TRUE)

## ----summary------------------------------------------------------------------
os <- objects.summary("package:datasets", all.classes = TRUE, what = c("dat", "ext", "obj"),
                      filter = sapply(data.class, length) > 1L)
summary(os, data.class.width = 32, format.extent = FALSE)

## ----summary.pass.down--------------------------------------------------------
summary(os, data.class.width = 32, maxsum = 10, quantile.type = 5)

## ----options------------------------------------------------------------------
# see all current options
osum.options()

## ----options.set--------------------------------------------------------------
# set some values
old_opt <- osum.options(osum.data.class.width = 12, osum.max.rows = 25)
# previous values of the changed 'osum' options
old_opt

## ----options.info-------------------------------------------------------------
# set which attributes are retrieved by default
osum.options(osum.information = c("dat", "mod", "ext", "obj"))
# get the current value of the option
osum.options("osum.information")
# if the argument 'what' is not specified, the new default values are used
objects.summary("package:base", filter = data.class != "function")

