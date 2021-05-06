open Cmdliner

(* Command line interface *)

let doc = "Command Line Interface for Dream applications"

let sdocs = Manpage.s_common_options

let exits = Common.exits

let man =
  [ `S Manpage.s_description
  ; `P doc
  ; `S Manpage.s_commands
  ; `S Manpage.s_common_options
  ; `S Manpage.s_exit_status
  ; `P "These environment variables affect the execution of $(mname):"
  ; `S Manpage.s_environment
  ]

let default_cmd =
  let term =
    let open Common.Syntax in
    Term.ret
    @@ let+ _ = Common.term in
       `Help (`Pager, None)
  in
  let info = Term.info "dream" ~version:"%%VERSION%%" ~doc ~sdocs ~exits ~man in
  term, info

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
  Term.(exit_status @@ eval_choice default_cmd [ cmd_run; cmd_gen_key ])
