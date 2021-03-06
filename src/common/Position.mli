(**
 * This module handles positions on the battlefield, and provides some utility
 * functions to manipulate those positions.
 *)

(** The type of the positions *)
type t

(** in order to use Sets *)
val compare : t -> t -> int

(** Creates a position *)
val create : int * int -> t

(** Returns the effective position for manipulation *)
val topair : t -> int * int

(** [clamp p pmin pmax] returns the position [p] clamped to the square delimited
  * by [pmin] and [pmax] *)
val clamp : t -> t -> t -> t

(** [out_of_bounds p pmin pmax] returns true iff [p] is outside the square
 * delimited by [pmin] and [pmax] *)
val out_of_bounds : t -> t -> t -> bool

(** Moves the given position to the left *)
val left : t -> t

(** Moves the given position to the right *)
val right : t -> t

(** Moves the given position downwards *)
val down : t -> t

(** Moves the given position upwards *)
val up : t -> t

(** [add p1 p2] returns the position [p1 + p2] *)
val add : t -> t -> t

(** [diff p1 p2] returns the position [p1 - p2] *)
val diff : t -> t -> t

(** square p1 p2 returns the list of positions in the square p1 x p2 
  * including p1 and p2, from left to right, top to bottom *)
val square : t -> t -> t list

(** [circle c r] returns the circle (for the norm |(x,y)| = |x| + |y|)
  * of center [c] and radius [r] *)
val circle : t -> int -> t list

(** Same as circle, but returns the ball *)
val filled_circle : t -> int -> t list

(** [range center minr maxr] returns the positions at distance d of [center]
  * such that minr <= d <= maxr *)
val range : t -> int -> int -> t list

(** [project p c i] returns the couple corresponding to (p - c) * i *)
val project : t -> t -> int -> (int * int)

(**  [dist a b] returns the Manhattan distance between a and b *)
val dist : t -> t -> int

(** [eucl_dist a b] returns the Euclidian distance between a and b *)
val eucl_dist : t -> t -> int

(** [get_eucl_disk p d] returns the list of pos with an Euclidian distance to p inferior or equal to d *)
val get_eucl_disk : t -> int -> t list

