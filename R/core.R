
# install.packages('reshape')
# install.packages(c('dbConnect'), repos='http://cran.us.r-project.org', dependencies=T)


# if(interactive()) reload = function() { source("/Users/aaron/opt/bhg/stab.R"); }

# stab stab stab

stab.dir.base = ".";

stab.filename = function(filename) { paste(stab.dir.base, filename, sep="/"); }

data.dir = stab.filename("data");
out.dir = stab.filename("out");

data.filename = function(filename) paste(data.dir, filename, sep="/");
out.filename = function(filename) paste(out.dir, filename, sep="/");


### logging

stab.options = list(
	echo_log=T
);

# if( !exists('stab.logfile') )
# 	stab.logfile = file( out.filename("/tmp/stab.log"), 'a' );

stab.log = function(..., sep=' ', collapse='; ') {
  out = paste(
      'stab :', Sys.time(), ':'
      , paste(..., sep=sep, collapse=collapse)
    )

  # write(out, stab.logfile, append=T)
  if(stab.options$echo_log) write(out, stdout())

}


stab.err = function(..., sep=' ', collapse='; ') {
  out = paste(
  		'stab !', Sys.time(), '!'
  		, paste(..., sep=sep, collapse=collapse)
  	)

  # write(out, stab.logfile, append=T)
  if(stab.options$echo_log) write(out, stderr())

}

stab.flush = function(){
  flush(stdout())
  flush(stderr())
}


#

add_class <- function(obj, cls) {
  class(obj) <- c(class(obj), cls)
  obj
}


as.Generic = function(x, class.name) {
	class(x)= unique(c(class(x), class.name));
	attr(x, "klass")=  class.name;
	x
}



stab.source_all = function(...) {
  path = paste(..., sep='/')
  files = list.files(path, pattern = "\\.[Rr]$", recursive=T);
  lapply(files, function(f){ 
  	stab.log(' source', f);
  	source(file.path(path, f));
	});
  T
}

stab.load = function(base.dir) {
  stab.log('loading', base.dir);
  # stab.source_all(paste(base.dir, 'R', sep='/'));
  stab.source_all(base.dir);
}

#
# f.name = gsub('-', '.', mission)
# f = get(f.name)
# x = do.call(f, list())



### Kick Off

# stab.env = 'default'
# hostname = system('hostname -s', intern=T)
# if( nchar( hostname ) > 0 ) {
#   stab.env = hostname
# }

# stab.local.settings.file = paste(stab.dir.base, 'R/env/', stab.env, '.R', sep='')
# source(stab.local.settings.file), chdir=T)

# buffer(100)
# options("deparse.max.lines"=9)


# stab.load()



