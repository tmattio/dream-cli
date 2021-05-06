val term : int Cmdliner.Term.t

val handle_errors : (int, [ `Msg of string ]) result -> int

val exits : Cmdliner.Term.exit_info list

module Syntax : sig
  val ( let+ ) : 'a Cmdliner.Term.t -> ('a -> 'b) -> 'b Cmdliner.Term.t

  val ( and+ )
    :  'a Cmdliner.Term.t
    -> 'b Cmdliner.Term.t
    -> ('a * 'b) Cmdliner.Term.t
end
