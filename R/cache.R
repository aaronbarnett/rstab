
as.Cache = function(x) as.Generic(x, 'Cache')

cache.config = list(
	# cache_entry = function() stab.query("SELECT DISTINCT ...")
)

cache.options = list(
	expire = 60*60*24*7 # a week
	
)

cache.options.set.expire = function(days){
	cache.options$expire = 60*60*24* days
}

###

cache.path = function(set.name) {
	data.filename(
		paste(
			'cache/'
			, set.name
			, '.Rda'
			, sep=""
		)
	)
}

cache.fetch = function(set.name, f) {
	if(missing(f) || is.null(f))
		f = cache.config[[ set.name ]]	
	
	cache = NULL

	if(is.null(f)){
		stab.err("cache.fetch", set.name, " f() not supplied or found")
	}else{
		stab.log("cache.fetch generate", set.name)
		stab.flush()
		cache = f() #as.Cache(f())
		# cache = as.Cache( do.call(f) )
		cache.save(cache, set.name)	
	}
	
	cache
}


cache.fetch.all = function() {
	lapply(names(cache.config), FUN=function(name) {
		cache.fetch(name)
	})
}

cache.save = function(cache, set.name) {
	save('cache', file=cache.path(set.name))
	cache
}

cache.load = function(set.name, f) {
	set.path = cache.path(set.name)
	stab.log("cache.fetch path", set.path)
	cache = NULL
	if(file.exists(set.path) ){
		expired = Sys.time() - cache.options$expire
		mtime = file.info(set.path)$mtime
		age = Sys.time() - mtime
		if(mtime > expired){
			stab.log("cache.fetch local", set.name, set.path, age)
			load(set.path) #implicitly sets cache
		}else{
			stab.log("cache.fetch expired", set.name)
			cache = cache.fetch(set.name, f)	
		}
	}else{
		cache = cache.fetch(set.name, f)
	}
	cache
}


