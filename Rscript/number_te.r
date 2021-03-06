if(!require(ggplot2)){
    install.packages("ggplot2")
    library(ggplot2)
}
if(!require("optparse")){
    install.packages("optparse")
    library(optparse)
}

if(!require("RColorBrewer")){
  install.packages("RColorBrewer")
  library(RColorBrewer)
}
# script options
option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="dataset file name i.e. 'result/output_TE.tsv'", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="result/count_TE_transposons.pdf", 
              help="output filename name (PDF) [default= %default]", metavar="character")
)
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

# no option given to script
if (is.null(opt$file)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file). ", call.=FALSE)
}

#load result file
filename = opt$file
data = read.table(file = filename, sep = '\t', header = TRUE)
df = data[with(data, order(data$TE_Type)), ]
#print(df)

find_element = function(df){
  elements = c()
  element = df$TE_Type[1] #print the first row of the TE_Type column
  #print(element)
  elements <- c(elements,element)
  #print(elements)
  for(i in 1:length(df$TE_Type)){
    if(df$TE_Type[i]!=element){
      element = df$TE_Type[i]
      elements <- c(elements,element)
      #print(elements)
    }
  } 
  #print(elements)
  return(elements)
}


number_of_element = function(df, element){
  compter = 0
  for(i in 1:length(df$TE_Type)){
      if(df$TE_Type[i]==element){
        print(df$TE_Type[i])
        print(element)
        compter = compter + 1
      }
    }
    return(compter)
}


#main 
list_of_element = find_element(df)
print(list_of_element)
number = c()
for( i in list_of_element){
  a = number_of_element(df, i)
  print(a)
  number <- c(number,a)
}
print(number)

# Define the number of colors you want
nb.cols <- length(list_of_element)
mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(nb.cols)
print(mycolors)
#graph 
dat <- data.frame(x=list_of_element, y=number)
# Open a pdf file
pdf(opt$out)
barplot(dat$y, names.arg=dat$x,
        main = "Number of transposon for each type of TE ",
        ylab="number", 
        xlab="type",
        col=mycolors)
invisible(dev.off())
print("Number of elements calculated, plot generated.")
