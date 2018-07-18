open GraphicsIntf
open OUnit2
open Printf

module G = struct
  type status = Graphics.status
  type event = Graphics.event
  exception Graphic_failure = Graphics.Graphic_failure

  let button_down = Graphics.Button_down
  let button_up = Graphics.Button_up
  let key_pressed = Graphics.Key_pressed
  let mouse_motion = Graphics.Mouse_motion
  let poll = Graphics.Poll

  type expected =
    | Open
    | Clear
    | FillRect of (int*int*int*int)
    | FillCircle of (int*int*int)
    | DrawString of string

  let empty_status =
    let open Graphics in
    { mouse_x = 0; mouse_y = 0; button = false;
      keypressed = false; key = Char.chr 0 }

  let expectations : expected list ref = ref []
  let current_exp_index = ref 0

  let key key =
    let open Graphics in
    { empty_status with keypressed = true; key }

  let mouse (mouse_x, mouse_y) =
    let open Graphics in
    { empty_status with button = true; mouse_x; mouse_y }

  (* We allow an error of 3 pixels *)
  let err = 3

  let equal e1 e2 =
    match e1, e2 with
    | Open, Open -> true
    | Clear, Clear -> true
    | FillRect (x1,y1,x2,y2), FillRect (w1,z1,w2,z2) ->
       abs(x1-w1) < err
       && abs(y1-z1) < err
       && abs(x2-w2) < err
       && abs(y2-z2) < err
    | FillCircle (x, y, s), FillCircle (w, z, r) ->
       abs(x-w) < err
       && abs(y-z) < err
       && s = r
    | DrawString s, DrawString r ->
       let open String in
       lowercase (trim s) = lowercase (trim r)
    | _, _ -> false

  let to_string = function
    | Open -> "open_graph"
    | Clear -> "clear_graph"
    | FillRect (a, b, c, d) -> Printf.sprintf "fill_rect %d %d %d %d" a b c d
    | FillCircle (a, b, c) -> Printf.sprintf "fill_circle %d %d %d" a b c
    | DrawString s -> Printf.sprintf "draw_string %s" s

  let expect e =
    let not_empty =
      Printf.sprintf "Nothing else is expected, got %s" (to_string e) in
    assert_bool not_empty (!expectations <> []);
    let exp = List.hd !expectations in
    let not_equal =
      Printf.sprintf "Different expectation, expected [%s] but got [%s] at position %d"
        (to_string exp) (to_string e) !current_exp_index in
    assert_bool not_equal (equal e exp);
    expectations := List.tl !expectations;
    current_exp_index := !current_exp_index + 1

  let open_graph _ = expect Open

  let clear_graph () = expect Clear

  let fill_rect a b c d = expect (FillRect (a, b, c, d))

  let fill_circle a b c = expect (FillCircle (a, b, c))

  let draw_rect a b c d = expect (FillRect (a, b, c, d))

  let draw_circle a b c = expect (FillCircle (a, b, c))

  let draw_string s = expect (DrawString s)

  let events : status list ref = ref []

  let wait_next_event _ =
    assert_bool "No more events" (!events <> []);
    let e = List.hd !events in
    events := List.tl !events;
    e

  let load evs exps =
    expectations := exps;
    events := evs;
    current_exp_index := 0

  let close () =
    assert_bool "There are events pending" (!events = []);
    assert_bool "There are expectations pending" (!expectations = [])

end
