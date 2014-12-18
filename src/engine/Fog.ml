(* Several functions relative to fog *)
(* To be implemented somewhere *)

type t = int array array
(* The fog is a double array of int of the size of the map,
if the value of a case is 0, it is hidden. When a unit can see a case, we increment 
the value of the case. When a unit cannot see anymore a case (moved/killed), we decrement the value of the case *)


(* With k=1, this functions modify the fog like if a new unit appears on p with range of vision
        k = -1, this functions modify the fog like if a unit with range was killed at position p*)
let set_fog_for_unit (fog: t) (p:Position.t) range k=
    let (x,y) = Position.topair p in
    let (size_x,size_y)= (Array.length fog,Array.length fog.(0)) in
    fog.(x).(y) <- fog.(x).(y) +1;

    for i=1 to range do
        if (x+i) < size_x then fog.(x+i).(y) <- fog.(x+i).(y) +k;
        if (x-i) >= 0 then fog.(x-i).(y) <- fog.(x-i).(y) +k
    done;
    for j=1 to range do
        if (y+j) < size_y then fog.(x).(y+j) <- fog.(x).(y+j) +k;
        if (y-j) >=0  then fog.(x).(y-j) <- fog.(x).(y-j) +k
    done;
    for i=1 to range do
        for j=1 to range do
            if (i+j) <= range && (i+j)>0 then
            (
                if (x+i) < size_x then
                (
                if (y+j) < size_y then fog.(x+i).(y+j) <- fog.(x+i).(y+j)+1;
                if (y-j) >= 0 then fog.(x+i).(y-j) <- fog.(x+i).(y-j)+1;
                );
                if (x-i) >= 0 then
                (
                if (y+j) < size_y then fog.(x-i).(y+j) <- fog.(x-i).(y+j)+1;
                if (y-j) >=0 then fog.(x-i).(y-j) <- fog.(x-i).(y-j) +1;
                )
            )
        done;
    done

let add_unit_fog fog (p:Position.t) range= set_fog_for_unit fog p range 1
let delete_unit_fog fog (p:Position.t) range= set_fog_for_unit fog p range (-1)
let unit_is_visible fog (u:Unit.t)=
    let (x,y) = Position.topair u#position in
        fog.(x).(y) = 0

let rec visible_army fog (a:Unit.t list)=
    match a with
    |[]->[]
    |u::t-> if unit_is_visible fog u then
                u::(visible_army fog t)
            else
                (visible_army fog t)


