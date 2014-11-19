open List

class logicplayer (a : Unit.t list) (b : Building.t list) =
  object (self)
    val mutable army = (a : Unit.t list)
    val mutable buildings = (b : Building.t list)
                            
    (*Quite dirty mutable id. Can't we do without it ?*)
    val mutable id = 0
    method get_army = army
    method get_id = id
    method set_army a = army <- a
    method add_unit u = army <- u::army
    method set_buildings b = buildings <- b
    method get_buildings = buildings
    method add_building b = buildings <- b::buildings


    (* TODO : implement these methods *)
    method delete_unit (u : Unit.t) = ()
    method move_unit (u : Unit.t) (p : Action.movement) = ()
    method delete_building (b : Building.t) = ()

    initializer id <- Oo.id self
  end


class virtual player (a : Unit.t list) (b : Building.t list) = 
object (self) 
  inherit logicplayer a b
  method virtual get_next_action :  Action.t

end

class clientplayer (a : Unit.t list) (b : Building.t list) =
object (self) inherit player a b
  method get_next_action = ([],Wait)
(*
Ce get_next_action doit renvoyer ce que veut faire le joueur, à brancher sur l'interface
 *)
end




class dummy_player army_ buildings_ (a: Action.t list) =
  object
    inherit player army_ buildings_
    val mutable actions = (a: Action.t list)
    method get_next_action  =
      if length a == 0 then
        ([Position.create (0,0)], Wait)
      else
        let action= hd(actions) in
        actions<-tl(actions);
        action
  end


type t = logicplayer

type actif = player

let create_player () = new dummy_player [] []  []
