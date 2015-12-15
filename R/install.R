
stab.packages = c(
	"devtools"
	
	, "foreach"
	, "doMC"
	, "parallel"

	, "reshape2"
	, "plyr"

	, "openxlsx"
	, "cowplot"
	
	, "dbConnect"
	, 'RPostgreSQL'
)


stab.install.deps = function(packages=stab.packages, reinstall=F) {

	new.packages = packages[!(packages %in% installed.packages()[,"Package"])]
	
	if(length(new.packages)) install.packages(new.packages
		, repos='http://cran.us.r-project.org'
		, dependencies=TRUE
		)

}

stab.install.package = function(pack) {
	install.packages(
		pack
		, repos='http://cran.us.r-project.org'
		, dependencies=TRUE
		)
}

