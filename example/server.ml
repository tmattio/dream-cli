module Custom_command = struct
  open Cmdliner

  let run () =
    print_endline "Hello World!";
    0

  let info = Term.info "greet" ~doc:"Say hello!" ~exits:Term.default_exits

  let term = Term.(const run $ const ())

  let cmd = term, info
end

let () =
  Dream_cli.run ~debug:true ~commands:[ Custom_command.cmd ]
  @@ Dream.logger
  @@ Dream.router [ Dream.get "/" (fun _ -> Dream.html "Hello World!") ]
  @@ Dream.not_found
