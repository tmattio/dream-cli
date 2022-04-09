(lang dune 2.7)

(name dream-cli)

(documentation "https://tmattio.github.io/dream-cli/")

(source
 (github tmattio/dream-cli))

(license MIT)

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio")

(generate_opam_files true)

(package
 (name dream-cli)
 (synopsis "Command Line Interface for Dream applications")
 (description "Command Line Interface for Dream applications")
 (depends
  (ocaml
   (>= 4.08.0))
  (dream
   (>= 1.0.0~alpha3))
  logs
  fmt
  (cmdliner
   (>= 1.1.0))))
