open Cmdliner

let run
    ?interface
    ?port
    ?stop
    ?debug
    ?error_handler
    ?secret
    ?old_secrets
    ?prefix
    ?https
    ?certificate_file
    ?key_file
    ?builtins
    ?greeting
    ?adjust_terminal
    ?(commands = [])
    handler
  =
  let cmd_run =
    Cmd_run.cmd
      ?interface
      ?port
      ?stop
      ?debug
      ?error_handler
      ?secret
      ?old_secrets
      ?prefix
      ?https
      ?certificate_file
      ?key_file
      ?builtins
      ?greeting
      ?adjust_terminal
      handler
  in
  let cmd_gen_key = Cmd_gen_key.cmd in
  Term.(exit_status @@ eval_choice cmd_run ([ cmd_gen_key ] @ commands))
