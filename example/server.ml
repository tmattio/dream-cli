(** Main entry point for our application. *)

let () =
  Dream_cli.run ~debug:true
  @@ Dream.logger
  @@ Dream.router [ Dream.get "/" (fun _ -> Dream.html "Hello World!") ]
  @@ Dream.not_found
