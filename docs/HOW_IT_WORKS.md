# STELLA – how it works (cheat sheet)

## Controls
| Key | What |
|---|---|
| Arrows / WASD | move |
| Z / Space | jump (hold = higher) |
| X | Stella: dash · Nila: attack |
| Shift | run |
| Down + jump | drop through semi-solids |
| Down in air | fast fall |
| Tab | switch Stella <-> Nila (music switches too) |
| R | retry room |
| M | mute / unmute |
| F3 | debug view (spring arcs, door/warp links) |

## Where things live
| File | Purpose |
|---|---|
| `scripts/scr_platformer` | shared player code: movement, gravity, slopes, wall jump, springs |
| `scripts/scr_enemies` | enemy helpers (stomp, hurt, die, ledge detection) |
| `scripts/scr_music` | `music_play(CHEER)` picks the Stella or Nila version |
| `scripts/scr_character` | `character_switch()` |
| `scripts/scr_fx` | dust particles |
| `objects/obj_controller` | persistent: HUD, fade, R / Tab / M / F3 |

## Placing things in a room (Properties -> Creation Code)
```gml
// obj_BOING (spring)
launch_speed = 14;   // 8 small hop ... 17 rocket
launch_angle = 60;   // 90 = up, 0 = right, 180 = left

// obj_door (press Up)            // obj_warp (just touch it; scale it to resize)
door_id     = "a_right";          target_room = FOREST_1;
target_room = INTRO_2_B;          target_door = "f1_left";
target_door = "b_left";

// obj_spawn: an arrival marker. Feet appear at its bottom-centre.
door_id = "f1_left";

// enemies
spd = 1.6;  hp = 2;               // obj_walker
wake_dist = 200;                  // obj_flyer

// obj_refill (dash crystal)
respawn_time = 120;
```
`obj_oneway` (arrow block): rotate it in the room editor. The arrow shows the only direction you can pass:
0 = right, 90 = up, 180 = left, 270 = down.

## Music
Add songs to `music_variant()` in `scr_music`, then call `music_play(SONG)` in a room's Creation Code.
