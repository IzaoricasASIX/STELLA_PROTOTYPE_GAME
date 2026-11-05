// ONE door object for the whole game. Configure each door in the room editor:
// select the door -> Properties -> Creation Code, and write for example:
//
//     door_id     = "intro_a_right";   // this door's own name (unique inside its room)
//     target_room = INTRO_2;           // the room it leads to
//     target_door = "intro_2_left";    // the door in THAT room we should appear at
//
// In the other room, place a door whose door_id is "intro_2_left" and whose
// target_room / target_door point back here. That is how you go back and forth.

door_id     = "";
target_room = noone;
target_door = "";
