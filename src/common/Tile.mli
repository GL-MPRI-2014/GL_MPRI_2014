(* Tile interface (draft) *)

type t

(** texture_name tile returns the name of the texture associated to tile *)
val get_name : t -> string

(** Check if a tile is traversable by a given type of movement/unit *)

val traversable_m : t -> Unit.movement -> bool

val traversable : t -> Unit.t -> bool

(** Takes a movement type/unit and return a tile cost. *)

val movement_cost : t -> Unit.movement -> int

val tile_cost : t -> Unit.t -> int

(** Create a tile from the XML file  *)
val create_from_file : string -> string -> t

val create_from_config : string -> t
