module Custom_command = struct
  open Cmdliner

  let run () =
    print_endline "Hello World!";
    0

  let info = Cmd.info "greet" ~doc:"Say hello!" ~exits:Cmd.Exit.defaults
  let term = Term.(const run $ const ())
  let cmd = Cmd.v info term
end

let () =
  Dream_cli.run ~commands:[ Custom_command.cmd ]
  @@ Dream.logger
  @@ Dream.router [ Dream.get "/" (fun _ -> Dream.html "Hello World!") ]
