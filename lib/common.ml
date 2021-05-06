open Cmdliner

module Syntax = struct
  let ( let+ ) t f = Term.(const f $ t)

  let ( and+ ) a b = Term.(const (fun x y -> x, y) $ a $ b)
end

open Syntax

let rec set_current_dir dir =
  try Ok (Unix.chdir dir) with
  | Unix.Unix_error (Unix.EINTR, _, _) ->
    set_current_dir dir
  | Unix.Unix_error (e, _, _) ->
    Error (Unix.error_message e)

let term =
  let+ log_level =
    let env = Arg.env_var "DREAM_VERBOSITY" in
    Logs_cli.level ~docs:Manpage.s_common_options ~env ()
  and+ dir =
    let doc =
      "Run as if $(mname) was started in $(docv) instead of the current \
       directory."
    in
    Arg.(value & opt (some string) None & info [ "C" ] ~docv:"PATH" ~doc)
  in
  let level =
    match log_level with
    | Some Logs.Info ->
      Some `Info
    | Some Logs.App ->
      Some `Info
    | Some Logs.Error ->
      Some `Error
    | Some Logs.Warning ->
      Some `Warning
    | Some Logs.Debug ->
      Some `Debug
    | None ->
      None
  in
  Dream.initialize_log ?level ();
  match dir with
  | None ->
    0
  | Some dir ->
    (match set_current_dir dir with
    | Ok () ->
      0
    | Error msg ->
      Logs.err (fun m -> m "%s" msg);
      1)

(* Error handling *)

let handle_errors = function
  | Ok 0 ->
    if Logs.err_count () > 0 then 3 else 0
  | Ok n ->
    n
  | Error _ as r ->
    Logs.on_error_msg ~use:(fun _ -> 3) r

let exits =
  Term.exit_info 3 ~doc:"on indiscriminate errors reported on stderr."
  :: Term.default_exits
