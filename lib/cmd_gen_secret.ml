let run len =
  let key = Dream.to_base64url (Dream.random len) in
  Logs.app (fun m -> m "%s" key);
  Ok 0

(* Command line interface *)

open Cmdliner

let doc = "Generate a random secret"

let man =
  [ `S Manpage.s_description
  ; `P "$(tname) will generate a random key and encode it as a Base64 string."
  ]

let info = Cmd.info "gen-secret" ~doc ~man

let term =
  let open Common.Syntax in
  let+ _term = Common.term
  and+ length =
    let doc = "The length of the key." in
    let docv = "LENGTH" in
    Arg.(value & opt int 32 & info [ "l"; "length" ] ~doc ~docv)
  in
  run length |> Common.handle_errors

let cmd = Cmd.v info term
