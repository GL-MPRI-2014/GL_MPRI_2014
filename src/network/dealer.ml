open Unix
open Marshal
open Types


class dealer (s : file_descr) =
object (self)
	 
  (* The socket we read from and write into to communicate with the net player over the network *)
  val mutable sockfd = s

  (* in_channel and out_channel corresponding to that socket *)
  val mutable in_channel = in_channel_of_descr s
  val mutable out_channel = out_channel_of_descr s

  (* list of all the other (logical) players *)
  val mutable logicPlayerList = []

  (* my client player *)
  val mutable clientPlayer = None
		

  (* for initialization *)

  method set_logicPlayerList id_list = 
    let rec create_list logp_list = function
      | [] -> logp_list
      | t::q -> create_list (new Player.logicPlayer ?id:(Some t) [] []::logp_list) q
    in
    let logp_list = create_list [] id_list in
    logicPlayerList <- logp_list

  method set_clientPlayer id =
    let clip = new ClientPlayer.client_player ?id:(Some id) [] [] in
    clientPlayer <- Some clip



  (* Mazzocchi asked for it *)
	
  method change_socket s =
    sockfd <- s;
    in_channel <- in_channel_of_descr s;
    out_channel <- out_channel_of_descr s




  (* scans tab_players and retreives the player with id id *)

  method list_scan id = 
    let rec fonction_a_la_con id = function
      | [] -> raise Not_found
      | t::q when t#get_id = id -> t 
      | _::q -> fonction_a_la_con id q
    in
    fonction_a_la_con id logicPlayerList


  (* verifies that clientPlayer has been set *)
  
  method is_set = 
    match clientPlayer with
    | None -> failwith "Player not set"
    | Some clip -> clip


  (* gives the player which id is id - or fails *)

  method get_player id =
    let clip = self#is_set in 
    if clip#get_id = id
    then (clip : ClientPlayer.client_player :> Player.logicPlayer)
    else
      try
	self#list_scan id
      with
	(*TO DO : add a raise exception *)
	Not_found -> (to_channel out_channel (Error Wrong_id_player) [Closures]; failwith "Wrong id")
	

  (* TODO *)
  method set_map str =
    ()



  (* manages Get_next_action *)

  method manage_gna = 
    let clip = self#is_set in 
    let action = clip#get_next_action in
    to_channel out_channel (Next_action action) [Closures]
    

  (* do what has to be done with an update... *)

  method manage_update = function
    | Game_over -> ()
    | Classement -> ()
    | Set_army (l,id) -> (self#get_player id)#set_army l
    | Set_building (l,id) -> (self#get_player id)#set_buildings l
    | Add_unit (u,id) -> (self#get_player id)#add_unit u
    | Add_building (b,id) -> (self#get_player id)#add_building b
    | Delete_unit (u,id) -> (self#get_player id)#delete_unit u
    | Delete_building (b,id) -> (self#get_player id)#delete_building b
    | Move_unit (u,p,id) -> (self#get_player id)#move_unit u p
    | Set_unit_hp (u,h,id) -> (self#get_player id)#set_unit_hp u h
(* for initialization only *)
    | Set_client_player id -> self#set_clientPlayer id
    | Set_logic_player_list lst -> self#set_logicPlayerList lst
    | Map str -> self#set_map str

  (* please give a call to this method just after having created this object *)

  method run = 
    while true 
    do 
      let m = (from_channel in_channel : send) in
      match m with
      | Get_next_action -> self#manage_gna
      | Update update -> self#manage_update update
    done
      

end

type t = dealer

let create_dealer sockfd = new dealer sockfd

