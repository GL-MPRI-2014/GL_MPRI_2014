(** Config and settings gestion module*)

(** Default tiles config file *)
val tiles_config : string
(** Default units config file *)
val units_config : string

(* config parsing *)

(** Create a tile based on the tiles config file *)
val create_tile : string -> Tile.t

(** Return the list of tiles based on the tiles config file *)
val create_tile_list : unit -> Tile.t list

(** Create a unit based on the the units config file *)
val create_unbound_unit : string -> Unit.unbound_t

(** Return the list of units based on the tiles config file *)
val create_unbound_unit_list : unit -> Unit.unbound_t list



(* for using other config files than the default ones (tests?) *)

(** Create a tile based on a json file containing a tile list*)
val create_tile_from_file : string -> string -> Tile.t

(** Return the list of tiles contained in a json file *)
val create_tile_list_from_file : string -> Tile.t list

(** Create a unit based on a json file containing a unit list*)
val create_unbound_unit_from_file : string -> string -> Unit.unbound_t

(** Return the list of units based on a json file *)
val create_unbound_unit_list_from_file : string -> Unit.unbound_t list

