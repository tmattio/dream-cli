let run ?interface ?port ?stop ?error_handler ?tls ?certificate_file ?key_file
    ?builtins ?greeting ?adjust_terminal ?(commands = []) handler =
  let cmd_run =
    Cmd_run.term ?interface ?port ?stop ?error_handler ?tls ?certificate_file
      ?key_file ?builtins ?greeting ?adjust_terminal handler
  in
  let cmd_gen_secret = Cmd_gen_secret.cmd in
  let main =
    Cmdliner.Cmd.group ~default:cmd_run Cmd_run.info
      ([ cmd_gen_secret ] @ commands)
  in
  Stdlib.exit @@ Cmdliner.Cmd.eval' main
