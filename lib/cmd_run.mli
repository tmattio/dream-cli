val info : Cmdliner.Cmd.info

val term
  :  ?interface:string
  -> ?port:int
  -> ?stop:unit Lwt.t
  -> ?error_handler:Dream.error_handler
  -> ?tls:bool
  -> ?certificate_file:string
  -> ?key_file:string
  -> ?builtins:bool
  -> ?greeting:bool
  -> ?adjust_terminal:bool
  -> Dream.handler
  -> int Cmdliner.Term.t

val cmd
  :  ?interface:string
  -> ?port:int
  -> ?stop:unit Lwt.t
  -> ?error_handler:Dream.error_handler
  -> ?tls:bool
  -> ?certificate_file:string
  -> ?key_file:string
  -> ?builtins:bool
  -> ?greeting:bool
  -> ?adjust_terminal:bool
  -> Dream.handler
  -> int Cmdliner.Cmd.t
