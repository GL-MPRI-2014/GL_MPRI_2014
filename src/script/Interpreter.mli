(** Script interpreter *)

type script

exception Unbound_variable of string

exception Unbound_function of string

exception Entry_point_missing of string

(** Creates a script from an AST and some global values.
  * The global part of the script will be interpreted. *)
val new_script : ScriptTypes.prog_type -> 
    (string * ScriptValues.value) list -> script

(** Creates an empty script *)
val empty_script : unit -> script

(** Calls the init method of a script *)
val init_script : script -> unit

(** Calls the main method of a script. 
  * This should return the next unit to play *)
val main_script : script -> Unit.t 

(** [move_script s u] calls the move methods of the script [s]
  * @return a move for the unit [u] *)
val move_script : script -> Unit.t -> Action.movement

(** [attack_script s m u] calls the attack methods of the script [s]
  * @return a unit attacked by the unit [u] after the movement [m] *)
val attack_script : script -> Action.movement -> Unit.t -> Unit.t

(** [building_script s b] calls the build methods of the script [s]
  * @return a unit to build by the building b *)
val building_script : script -> Building.t -> Unit.unbound_t

(** [call_f f] calls a function [f] of type unit -> 'a,
  for debugging purpose *)
val call_f : script -> string -> ScriptValues.value

