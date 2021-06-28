(** Create a CLI to configure Dream applications. *)

val run
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
  -> ?commands:(int Cmdliner.Term.t * Cmdliner.Term.info) list
  -> Dream.handler
  -> unit
(** Runs the Web application represented by the [handler].

    If one of the optional argument is provided, its value will be used
    statically and no CLI argument will be available to configure it
    dynamically.

    Note that [stop] and [error_handler] don't have any CLI argument, they are
    simply passed to [Dream.run].

    Each optional argument can also be provided through an environment variable
    (e.g. [interface] can be provided with [DREAM_INTERFACE]). Run the binary
    with [--help] to access the CLI manual. *)
