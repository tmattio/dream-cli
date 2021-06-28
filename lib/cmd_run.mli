val cmd
  :  ?interface:string
  -> ?port:int
  -> ?stop:unit Lwt.t
  -> ?debug:bool
  -> ?error_handler:Dream.error_handler
  -> ?secret:string
  -> ?old_secrets:string
  -> ?prefix:string
  -> ?https:bool
  -> ?certificate_file:string
  -> ?key_file:string
  -> ?builtins:bool
  -> ?greeting:bool
  -> ?adjust_terminal:bool
  -> Dream.handler
  -> int Cmdliner.Term.t * Cmdliner.Term.info
