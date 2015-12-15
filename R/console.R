
if(interactive()){

  .First = function() try(loadhistory(".Rhistory"))
  .Last  = function() try(savehistory(".Rhistory"))

  .adjustWidth = function(...){
    try( options(width=Sys.getenv("COLUMNS")), silent = TRUE)
    TRUE
  } 
  .adjustWidthCallBack = addTaskCallback(.adjustWidth)

  # removeTaskCallback(.updatePromptCallBack )
  .updatePrompt = function(...) {
      lv     = .Last.value
      
      meta = paste(class(lv), collapse='/')
      sep = ': '  
      x = prettyNum( length(lv), big.mark=',', scientific=F)
      size = if( any(class(lv) %in% 'data.frame') ){
          y = prettyNum( nrow(lv), big.mark=',', scientific=F)
          paste(x, 'x', y)
      } else {
          x
      }
      ps  = ' > '

      if(length(grep('xterm', Sys.getenv('TERM')))>0 && length(grep('xtermStyle',installed.packages()[ ,1]))>0) {
          library('xtermStyle')
          meta = style(meta, fg='cyan')
          sep  = style(sep , fg='white')
          size = style(size, fg='yellow')
          ps   = style(ps  , fg='cyan')
      }
      

      ps1 = paste( meta, sep, size, ps, sep='')
      
      # ps1 = paste(p, "> ", sep=' ')
      
      options(prompt=ps1)
      
      TRUE
  }
  .updatePromptCallBack = addTaskCallback(.updatePrompt)


  # removeTaskCallback(.updatePromptCallBack )
  # .traceback.if = function(...) {
  #     if( !is.null(.Traceback)) {
  #         traceback()
  #         assign(".Traceback",NULL,"package:base")
  #     }
  #     TRUE
  # }
  # .tracebackIfCallback = addTaskCallback(.traceback.if)

}



