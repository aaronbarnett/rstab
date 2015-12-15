
# aliases

lc <- function() class(.Last.value)
lv <- function() .Last.value
tb <- traceback

buffer <- function(s) { options("max.print" = s) }

# curry

`%@%` <- function(x, f) eval.parent(as.call(append(as.list(substitute(f)), list(x), 1)))

# concat

`% %` <- function(a, b) paste(a, b)
`%.%` <- function(a, b) paste(a, b, sep='.')

# out.filename = 'out/out.csv'
read.out = function(filename="out.csv") {
  read.csv(out.filename(filename))
}

write.out = function(out, filename="out.csv") {
  write.csv(out, out.filename(filename), row.names=F)
}

# clipboard

clip.paste = function(header=T){ 
  read.table(pipe("pbpaste"), sep="\t", header) 
}
.paste = clip.paste
.v = clip.paste
.V = function() clip.paste(header=F)

clip.copy = function(out, header=T){
  cb <- pipe('pbcopy','w')
  write.table(out,file=cb, sep='\t', quote=F, row.names=FALSE, col.names=header)
  close(cb)
  out
}
.copy = clip.copy
.c = clip.copy
.C = function(out) clip.copy(out, header=F)

.cl = function(header=T) clip.copy(lv(), header=header)

.p = paste0

#

stab.parallelize = function() {
  library("parallel")
  cores = detectCores() /2
  stab.cluster <<- makeCluster(cores)
  registerDoParallel(stab.cluster, cores = cores)
  #http://stackoverflow.com/questions/1395309/how-to-make-r-use-all-processors
  #stopCluster(stab.cluster)
}


toJSON.df <- function(df) {
  rownames(df) <- df[[ 1 ]]
  
  #df$User_Name <- iconv(df$User_Name, to = "utf8")
  #for(i in seq(1, length(df))) if( class(df[[ i ]]) == 'character') df[[ i ]] << 
  for(i in seq(1, length(df))) 
    if( class(df[[ i ]]) == 'character') 
      df[[ i ]] <- iconv(df[[ i ]], to = "utf8")

  l <- apply(df, 1, function(x){ return(toJSON(x)) })
  json <- toJSON(l)

  return(json)
}



### cleaning

clean = function(x, ...)  UseMethod("clean")

clean.data.frame = function(d.f){
  for(col in colnames(d.f)){
    # kona$log('col!', col)
    d.f[[ col ]]= clean(d.f[[ col ]])
  }

  d.f
}


clean.numeric = function(d.c){
  d.c[is.na(d.c)] = 0
  d.c
}
clean.integer= clean.numeric

clean.Date = function(d.c){
  #format(d.c, '%m/%d/%Y')
  d.c
}

clean.character = function(d.c){
  d.c[is.na(d.c)] = ''
  d.c
}

clean.factor = function(d.c){
  clean(as.character(d.c))
}

clean.default = function(d.c){
  d.c[is.na(d.c)] <- ''
  d.c
}


# rbind for mixed columns
sbind = function(x, y, fill=NA) {
  sbind.fill = function(d, cols){ 
    for(c in cols)
      d[[c]] = fill
    d
  }

  x = sbind.fill(x, setdiff(names(y),names(x)))
  y = sbind.fill(y, setdiff(names(x),names(y)))
  
  rbind(x, y)
}

intify.data.frame = function(d.f) {
  lapply(seq(1, ncol(d.f)), function(i){ 
      d.f[[i]] <<- as.integer(d.f[[i]])
    })
  d.f
}


to.c = as.character

to.i = as.integer




