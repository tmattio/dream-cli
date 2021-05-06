# Dream CLI

[![Actions Status](https://github.com/tmattio/dream-cli/workflows/CI/badge.svg)](https://github.com/tmattio/dream-cli/actions)

Command Line Interface for Dream applications.

The API is the same as `Dream.run`, but will generate a CLI:

```ocaml
let () =
  Dream_cli.run ~debug:true
  @@ Dream.logger
  @@ Dream.router [ Dream.get "/" (fun _ -> Dream.html "Hello World!") ]
  @@ Dream.not_found
```

## To Do

- [ ] Add a function to register custom commands
