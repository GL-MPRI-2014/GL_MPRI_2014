(**
   TPTM module
*)

open Music

type time = Time.t
type event = Music.event

type t = Tile of DList.t

(** {2 Base tiles} *)

let zero : t = Tile (DList.zero)

let isZero : t -> bool = fun t ->
  t = zero

let delay : time -> t = fun dur ->
  Tile (DList.sync dur)

let make : event -> t = fun event ->
  Tile (DList.return event)

(** {2 Tile manipulation} *)

let (%) : t -> t -> t = fun (Tile(events1)) (Tile(events2)) ->
  Tile(DList.(/::/) events1 events2)

let make_withDelay : Music.event -> t = fun event ->
  make event % delay (Music.duration event) 

let duration : t -> time = function
  | Tile(events) -> DList.duration events

let reset : t -> t = fun t ->
  let dur = duration t in
  let back_delay = delay (Time.inverse dur) in
  t % back_delay

let coreset : t -> t = fun t ->
  let dur = duration t in
  let back_delay = delay (Time.inverse dur) in
  back_delay % t

let inverse : t -> t = fun t ->
  let dur = duration t in
  let back_delay = delay (Time.inverse dur) in
  back_delay % t % back_delay

let join : t -> t -> t = fun t1 t2 ->
  t1 % (coreset t2)

let fork : t -> t -> t = fun t1 t2 ->
  (reset t1) % t2

(** {2 Normalization} *)

let headTail : t -> (t * t) = fun (Tile events) ->
  let (head, tail) = DList.headTail events in
  (Tile head, Tile tail)

let rec normalize : t -> t = fun t ->
  let (head, tail) = headTail t in
  if isZero tail then
    head
  else head % normalize tail

(** {2 Testing functions} *)

(** {3 Tile <-> event list transform} *)

let fromList : t list -> t = function list ->
  List.fold_left (%) zero list

(** {3 Pretty-printing} *)

let rec fprintf : Format.formatter -> t -> unit = fun fmt -> function
  | Tile(t) -> Format.fprintf fmt "@[Tile(%a@,)@]@." DList.fprintf t
  
let rec printf : t -> unit = fprintf Format.std_formatter

let play : ?samplerate:int -> ?division:MIDI.division ->
	   ?tempo:Time.Tempo.t -> t -> unit =
  fun ?samplerate:(samplerate = MidiV.samplerate) ?division:(division = MidiV.division)
      ?tempo:(tempo = Time.Tempo.base) ->
  fun t ->
  let Tile(dl) = normalize t in
  let events = DList.toMidi ~samplerate ~division ~tempo dl in
  match events with
  | None -> ()
  | Some(buf) -> 
     let midi_player = new MidiPlayer.asynchronousMidiPlayer
     and multi_track = Array.make 16 (buf) in
     multi_track.(0) <- buf;
     midi_player#add multi_track;
     (Thread.create midi_player#play ());
     midi_player#stop ()
