let run ?interface ?port ?stop ?error_handler ?tls ?certificate_file ?key_file
    ?builtins ?greeting ?adjust_terminal handler =
  let () =
    Dream.run ?interface ?port ?stop ?error_handler ?tls ?certificate_file
      ?key_file ?builtins ?greeting ?adjust_terminal handler
  in
  Ok 0

(* Command line interface *)

open Cmdliner

let doc = "Runs the Web application, by default at http://localhost:8080"

let man =
  [
    `S Manpage.s_description;
    `P "$(tname) runs the Web application, by default at http://localhost:8080.";
  ]

let info = Cmd.info "dream" ~doc ~man

let term ?interface ?port ?stop ?error_handler ?tls ?certificate_file ?key_file
    ?builtins ?greeting ?adjust_terminal handler =
  let open Common.Syntax in
  let+ _term = Common.term
  and+ interface =
    match interface with
    | Some interface -> Term.const (Some interface)
    | None ->
        let default = Option.value interface ~default:"localhost" in
        let doc =
          "the network interface to listen on. Defaults to \"localhost\". Use \
           \"0.0.0.0\" to listen on all interfaces."
        in
        let docv = "INTERFACE" in
        let env = Cmd.Env.info "DREAM_INTERFACE" in
        Arg.(
          value
          & opt (some string) (Some default)
          & info [ "i"; "interface" ] ~doc ~docv ~env)
  and+ port =
    match port with
    | Some port -> Term.const (Some port)
    | None ->
        let default = Option.value port ~default:8080 in
        let doc = "the port to listen on. Defaults to 8080." in
        let docv = "PORT" in
        let env = Cmd.Env.info "DREAM_PORT" in
        Arg.(
          value
          & opt (some int) (Some default)
          & info [ "p"; "port" ] ~doc ~docv ~env)
  and+ tls =
    match tls with
    | Some tls -> Term.const tls
    | None ->
        let doc =
          "enables TLS. You should also specify $(b,--certificate-file) and \
           $(b,--key-file). However, for development, Dream includes an \
           insecure compiled-in localhost certificate. Enabling HTTPS also \
           enables transparent upgrading of connections to HTTP/2."
        in
        let env = Cmd.Env.info "DREAM_TLS" in
        Arg.(value & flag & info [ "tls" ] ~doc ~env)
  and+ certificate_file =
    match certificate_file with
    | Some certificate_file -> Term.const (Some certificate_file)
    | None ->
        let doc =
          "specify the certificate file, when using $(b,--https). They are not \
           required for development, but are required for production. Dream \
           will write a warning to the log if you are using $(b,--https), \
           don't provide $(b,--certificate-file) and $(b,--key-file), and \
           $(b,--interface) is not \"localhost\"."
        in
        let docv = "CERTIFICATE_FILE" in
        let env = Cmd.Env.info "DREAM_CERTIFICATE_FILE" in
        Arg.(
          value
          & opt (some string) None
          & info [ "certificate-file" ] ~doc ~docv ~env)
  and+ key_file =
    match key_file with
    | Some key_file -> Term.const (Some key_file)
    | None ->
        let doc =
          "specify the key file, when using $(b,--https). They are not \
           required for development, but are required for production. Dream \
           will write a warning to the log if you are using $(b,--https), \
           don't provide $(b,--certificate-file) and $(b,--key-file), and \
           $(b,--interface) is not \"localhost\"."
        in
        let docv = "KEY_FILE" in
        let env = Cmd.Env.info "DREAM_KEY_FILE" in
        Arg.(
          value & opt (some string) None & info [ "key-file" ] ~doc ~docv ~env)
  and+ no_builtins =
    match builtins with
    | Some builtins -> Term.const (not builtins)
    | None ->
        let doc = "disables Built-in middleware." in
        let env = Cmd.Env.info "DREAM_NO_BUILTINS" in
        Arg.(value & flag & info [ "no-builtins" ] ~doc ~env)
  and+ no_greeting =
    match greeting with
    | Some greeting -> Term.const (not greeting)
    | None ->
        let doc =
          "disables the start-up log message that prints a link to the Web \
           application."
        in
        let env = Cmd.Env.info "DREAM_NO_GREETING" in
        Arg.(value & flag & info [ "no-greeting" ] ~doc ~env)
  and+ no_adjust_terminal =
    match adjust_terminal with
    | Some adjust_terminal -> Term.const (not adjust_terminal)
    | None ->
        let doc =
          "disables adjusting the terminal to disable echo and line wrapping."
        in
        let env = Cmd.Env.info "DREAM_NO_ADJUST_TERMINAL" in
        Arg.(value & flag & info [ "no-adjust-terminal" ] ~doc ~env)
  in
  let builtins = not no_builtins in
  let greeting = not no_greeting in
  let adjust_terminal = not no_adjust_terminal in
  run ?interface ?port ?stop ?error_handler ~tls ?certificate_file ?key_file
    ~builtins ~greeting ~adjust_terminal handler
  |> Common.handle_errors

let cmd ?interface ?port ?stop ?error_handler ?tls ?certificate_file ?key_file
    ?builtins ?greeting ?adjust_terminal handler =
  Cmd.v info
    (term ?interface ?port ?stop ?error_handler ?tls ?certificate_file ?key_file
       ?builtins ?greeting ?adjust_terminal handler)
