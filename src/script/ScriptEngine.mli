(** Main script system. Stores the exposed values with their types *)

(** Type of the exposed types *)
type value_type = [
  `Int_t    |
  `Unit_t   |
  `String_t |
  `Bool_t   |
  `List_t  of value_type |
  `Array_t of value_type |
  `Fun_t   of value_type * value_type |
  `Pair_t  of value_type * value_type
]

(** Type of the exposed values *)
type value = [
  `Int    of int              |
  `Unit                       |
  `String of string           |
  `Bool   of bool             |
  `List   of value list       |
  `Array  of value array      |
  `Fun    of (value -> value) |
  `Pair   of value * value
]

exception Script_value_not_found

(** [expose f t s] exposes a value f of type t to the script system.
  * The value will be refered as s in the language *)
val expose : value -> value_type -> string -> unit

(** [type_of s] returns the type of the value refered as s *)
val type_of : string -> value_type

(** [value_of s] returns the value named s *)
val value_of : string -> value