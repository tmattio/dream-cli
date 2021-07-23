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

The normal Dream configurations are available as command line arguments:

```
-C PATH
    Run as if  was started in PATH instead of the current directory.

--certificate-file=CERTIFICATE_FILE (absent DREAM_CERTIFICATE_FILE env)
    specify the certificate file, when using --https. They are not
    required for development, but are required for production. Dream
    will write a warning to the log if you are using --https, don't
    provide --certificate-file and --key-file, and --interface is not
    "localhost".

--https (absent DREAM_HTTPS env)
    enables HTTPS. You should also specify --certificate-file and
    --key-file. However, for development, Dream includes an insecure
    compiled-in localhost certificate. Enabling HTTPS also enables
    transparent upgrading of connections to HTTP/2.

-i INTERFACE, --interface=INTERFACE (absent=localhost or
DREAM_INTERFACE env)
    the network interface to listen on. Defaults to "localhost". Use
    "0.0.0.0" to listen on all interfaces.

--key-file=KEY_FILE (absent DREAM_KEY_FILE env)
    specify the key file, when using --https. They are not required for
    development, but are required for production. Dream will write a
    warning to the log if you are using --https, don't provide
    --certificate-file and --key-file, and --interface is not
    "localhost".

--no-adjust-terminal (absent DREAM_NO_ADJUST_TERMINAL env)
    disables adjusting the terminal to disable echo and line wrapping.

--no-builtins (absent DREAM_NO_BUILTINS env)
    disables Built-in middleware.

--no-greeting (absent DREAM_NO_GREETING env)

--old-secret=OLD_SECRETS (absent DREAM_OLD_SECRETS env)
    a list of previous secrets that can still be used for decryption,
    but not for encryption. This is intended for key rotation.

-p PORT, --port=PORT (absent=8080 or DREAM_PORT env)
    the port to listen on. Defaults to 8080.

--prefix=PREFIX (absent=/ or DREAM_PREFIX env)
    a site prefix for applications that are not running at the root (/)
    of their domain. The default is "/", for no prefix.

-s SECRET, --secret=SECRET (absent DREAM_SECRET env)
    a key to be used for cryptographic operations, such as signing CSRF
    tokens. By default, a random secret is generated on each call to
    Dream.run. For production, generate a key with gen-secret and load it
    from file. A medium-sized Web app serving 1000 fresh encrypted
    cookies per second should rotate keys about once a year. See
    argument --old-secrets) below for key rotation.
```

Or as environmental variables:

```
DREAM_CERTIFICATE_FILE
    See option --certificate-file.

DREAM_HTTPS
    See option --https.

DREAM_INTERFACE
    See option --interface.

DREAM_KEY_FILE
    See option --key-file.

DREAM_NO_ADJUST_TERMINAL
    See option --no-adjust-terminal.

DREAM_NO_BUILTINS
    See option --no-builtins.

DREAM_NO_GREETING
    See option --no-greeting.

DREAM_OLD_SECRETS
    See option --old-secret.

DREAM_PORT
    See option --port.

DREAM_PREFIX
    See option --prefix.

DREAM_SECRET
    See option --secret.

DREAM_VERBOSITY
    See option --verbosity.
```

Note that in order for the command-line arguments to be recognized by Dream, and not by the build tool, it is necessary to prepend them with a double dash:

```sh
# esy
npx esy start -- -p 9000
# dune
dune exec ./main.ml -- -p 9000
```

## Additional commands

The following subcommands are provided in the generated CLI for convenience:

- `gen-secret` - Generate a random secret.

```sh
# esy
npx esy start gen-secret
# dune
dune exec ./main.ml gen-secret
```

## Custom commands

It is also possible to add custom subcommands to the CLI, by providing a `int Cmdliner.Term.t * Cmdliner.Term.info`:

```ocaml
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
```

Running the above example (also provided in `./example/server.ml`) with `greet` will print `"Hello World!"` to the terminal.
