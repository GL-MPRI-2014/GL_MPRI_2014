open OcsfmlAudio

exception Unknown_sound of string
exception Not_a_valid_sound_file of string

let sound_bank = Hashtbl.create 13
let path = "./resources/sounds/"

let player = new sound ()

let load_sound_file file_name =
  match (Str.split (Str.regexp "\\.") file_name) with
    | [name; "wav"] ->
        let file = path ^ file_name in
        Hashtbl.add sound_bank name (new sound_buffer (`File(file)));
        print_endline ("  [\027[32mstored\027[0m] " ^ name)
    | _ ->
        raise (Not_a_valid_sound_file (file_name ^ " (only WAV are supported)"))

let load_sounds () = 
  print_endline "Loading sounds :";
  let files = Sys.readdir path in
  Array.iter load_sound_file files;
  print_endline "All sounds loaded"


let play_sound sound =
  try
    player#stop;
    player#set_buffer (Hashtbl.find sound_bank sound);
    player#play
  with
    | Not_found -> raise (Unknown_sound sound)