(** Unit interface *)

type movement = Walk | Roll | Tread | Swim | Fly | Amphibious_Walk
  | Amphibious_Roll | Amphibious_Tread | All

type armor = Light | Normal | Heavy

(** Unit type *)
type t = <
  name : string;
  position : Position.t;
  id : int;
  player_id : int;
  move : Position.t -> unit;
  movement_type : movement;
  vision_range : int;
  min_attack_range : int;
  attack_range : int;
  move_range : int;
  spawn_number : int;
  attack_base : int;
  armor : armor;
  price : int;
  percentage_light : int;
  percentage_normal : int;
  percentage_heavy : int;
  life_max : int;
  hp : int;
  attack : armor -> int -> int;
  take_damage : int -> unit
>

(** Type for units without a position *)
type unbound_t = <
  name : string;
  movement_type : movement;
  vision_range : int;
  min_attack_range : int;
  attack_range : int;
  move_range : int;
  spawn_number : int;
  attack_base : int;
  armor : armor;
  price : int;
  percentage_light : int;
  percentage_normal : int;
  percentage_heavy : int;
  life_max : int
>

(** Create a unit from a unbound unit, a position and the controlling player id *)
val bind : unbound_t -> Position.t -> int -> t

(** create an unbound unit from a parsed record*)
val create_unbound_from_parsed_unit : Unit_t.t -> unbound_t

