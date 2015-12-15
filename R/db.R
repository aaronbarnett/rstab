
require('dbConnect')


### overridable

if(!exists('stab.db.driver')) {
	stab.log('Setting up default db driver')
	library(RMySQL)
	stab.db.driver = dbDriver("MySQL");
}else{
	stab.log('Using db driver', class(stab.db.driver))
}

if(!exists('stab.db.params')) {
	stab.log('Setting up default db params')
	stab.db.params = list(
		name     = "default",
		user     = "root", 
		password = "", 
		host     = "localhost", 
		dbname   = "",
		port     = 3306
	)
}else{
	stab.log('Using db params', stab.db.params$name)
}


# query 

stab.query = function(sql, db.params=stab.db.params) { 
	stab.log( 'Query ', sql)
	
	result <- list()
	
	stab.db(function(conn) { 
		rs = dbSendQuery(conn, sql)
		result <<- fetch(rs, n = -1)
	}, db.params)
	
	result
}
# sql = stab.query
# query = stab.query

stab.query.in = function(from, where, .in) {
	stab.query(paste0('select * from ', from, ' where ', where, ' in (', .in, ')'))
}


# connection

stab.db = function(scope, db.params=stab.db.params) {

	stab.log( 'Connecting to', db.params$name)

	connection = dbConnect(
		stab.db.driver, 
		user     = db.params$user, 
		password = db.params$password, 
		host     = db.params$host, 
		dbname   = db.params$dbname,
		port     = db.params$port
	)
	
	# wakeup connection pool
	rs = dbSendQuery(connection, "SET NAMES 'utf8'");

	attr(connection, 'name') = db.params$name

	if( !missing(scope) && class(scope) == 'function' ) {		
		scope(connection)
		err = dbGetException(connection)
		stab.log(paste('stab.db', err, collapse=": "))
		stab.db.release(connection)
	} else {
		return(connection)
	}
}

stab.db.release <- function(connection) {
	stab.log('Releasing connection to', attr(connection, 'name') )
	dbDisconnect(connection)
}


