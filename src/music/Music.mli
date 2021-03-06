(**
   Defines the basic elements for music generation.

   Defines types ['a Music.t] and [Music.param] :
   the first one is a single note with parameters in ['a],
   the second is a type for parameters, one then builds
   music with the base type [Music.param Music.t]

   Borrows much from @author "Paul Hudak"'s Haskell library Euterpea 
*)

exception Negative_duration_note
exception Not_found

(** {2 Type definitions} *)

type 'a t = Note of (Time.t * 'a)
	    | Rest of Time.t

type octave = int
type pitchClass  = Cff | Cf | C | Dff | Cs | Df | Css | D | Eff | Ds 
		   | Ef | Fff | Dss | E | Ff | Es | F | Gff | Ess | Fs
		   | Gf | Fss | G | Aff | Gs | Af | Gss | A | Bff | As 
		   | Bf | Ass | B | Bs | Bss
type pitch = pitchClass * octave

(** Velocity values [vel] should be verify : [0 <= vel <= 127] *)  
type velocity = int

val pitch_to_string : pitch -> string 

(** Reads a string like ["Aff4"] or ["C5"] and returns the associated pitch.

    Raises [Not_found] if the string does not denote a correct pitch.
 *)
val pitch_of_string : string -> pitch
  
(**
   The class [param] defines an instantiation for the type ['a t]

   We use a class here for extensivity.
 *)
class param : pitch -> velocity ->
	      object
		val mutable pitch : pitch (** The note's pitch *)
		val mutable velocity : velocity (** The note's velocity *)
		
		method pitch : pitch (** Get note's pitch *)
		method velocity : velocity (** Get note's velocity *)

		method setPitch : pitch -> unit  (** Set note's pitch *)
		method setVelocity : velocity -> unit  (** Set note's velocity *)
	      end

(**
   The instantiation of ['a t] used in other modules
*)
type event = param t

(** 
   Event comparison function, *with* some semantical meaning :
   Rests are lower than events,
   Events are compared with help of the value :
   (duration^4 + velocity^2 + frequency_of_pitch).
   
   This function is used during the DList normalisation process,
   to build sets of events.

   Same specification as [Pervasives.compare]
 *)
val compare : event -> event -> int

(** 
   Event syntactic equality
 *)
val is_equal : event -> event -> bool

(**
   Checks if the input event has null velocity
 *)
val is_silent : event -> bool

(** {2 Basic Music creation} *)

(**
   @return the note of duration [time] with parameter ['a]
*)
val note : Time.t -> 'a -> 'a t 

(**
   @return a rest of duration [Time.t]
*)
val rest : Time.t -> 'a t

(**
   @return the length of an event
*)
val duration : 'a t -> Time.t

(** {2 Testing functions} *)

(** {3 Pretty-printing} *)

(**
   Pretty prints the input [event] and outputs to the channel
   defined by the [Format.formatter]
*)
val fprintf : Format.formatter -> event -> unit

(** {2 MIDI conversion}
    Based on @author "Savonet"'s mm Midi event type
*)

(**
   Used for the rendering of music

   @param int is the samplerate of the conversion
   @param MIDI.division is the chosen grid division
   @return the conversion of the given ['a t] into a MIDI event
*)
val toMidi : ?channels:int -> ?samplerate:int -> ?division:MIDI.division ->
	     ?tempo:Time.Tempo.t -> ?context:Modify.Context.t ->
	     event -> MIDI.Multitrack.buffer
