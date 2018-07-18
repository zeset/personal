open GraphicsIntf
open Graphics

module G : GRAPHICS = struct
  type status = Graphics.status
  type event = Graphics.event
  exception Graphic_failure = Graphics.Graphic_failure

  let button_down = Graphics.Button_down
  let button_up = Graphics.Button_up
  let key_pressed = Graphics.Key_pressed
  let mouse_motion = Graphics.Mouse_motion
  let poll = Graphics.Poll

  let open_graph title =
    open_graph "";
    set_window_title title

  let clear_graph = clear_graph


  let draw_rect = draw_rect

  let draw_circle = draw_circle

  let fill_rect = fill_rect

  let fill_circle = fill_circle

  let draw_string s =
    (* we clear out the lower rectangle *)
    set_color background;
    let (_, h) = text_size "O" in
    fill_rect 0 0 (size_x ()-1) h;
    set_color foreground;
    moveto 0 0;
    draw_string s

  let wait_next_event = wait_next_event

end
