open GraphicsIntf
open CustomShape 

module App (Gr: GRAPHICS) = struct
  open Gr
  (* We make an alias of the original Graphics module of OCaml
     in case we need to access it *)
  module G = Graphics
  module Shape = CustomShape(Gr)

  (* List of the possible current steps *)
  type current =
    | Init
    | Waiting4circle
    | Waiting4rect
    | Waiting4del
    | Waiting4sel1
    | Waiting4sel2


  (* Record that contains the list of shapes drawn currently, the
    selectes shapes list, its color, the current state and two auxiliary 
    integers whose function is to improve the selection process *)
  type state = {
    shape_list: Shape.shape list;
    s_list: Shape.shape list;
    current: current;
    aux_x1: int;
    aux_y1: int;
    current_color: G.color;
  }

  (*Function that matches a keyboard event with its adecuate procedure
    by changing the state.
    It contemplates each of the cases we thought were needed.*)
  let key_press_selection key state =
    match key with
      | 'c' -> draw_string "Waiting for circle";
          Some {state with current = Waiting4circle}
      | 'r' -> draw_string "Waiting for rectangle";
          Some {state with current = Waiting4rect}
      | 'd' -> draw_string "Waiting for deletion";
          Some {state with current = Waiting4del}
      | 's' -> draw_string "Waiting for 1st point of selection";
          Some {state with current = Waiting4sel1}
      | '+' -> Some {state with shape_list = 
          Shape.resize_selection state.s_list state.shape_list Shape.Enlarge} 
      | '-' -> Some {state with shape_list = 
          Shape.resize_selection state.s_list state.shape_list Shape.Reduce}
      | '1' -> Some {state with current_color = G.black}
      | '2' -> Some {state with current_color = G.red}
      | '3' -> Some {state with current_color = G.blue}
      | '4' -> Some {state with current_color = G.green}
      | 'e' -> None
      | _ -> Some {state with current = Init}


  (*Function that matches an event with its adecuate procedure.
    It receives the current status of the program and summons
    the correct function to do what it has to.
    It contemplates each of the cases we thought were needed *)
  let mouse_click_selection current state status =
    match current with
      | Waiting4circle ->
          Some {state with shape_list = Shape.add_shape
          status.G.mouse_x status.G.mouse_y state.shape_list
          Shape.Circle state.current_color}
      | Waiting4rect ->
          Some {state with shape_list = Shape.add_shape
          status.G.mouse_x status.G.mouse_y state.shape_list 
          Shape.Rectangle state.current_color}
      | Waiting4del ->
          Some {state with shape_list = 
          Shape.delete_shape status.G.mouse_x status.G.mouse_y state.shape_list}
      | Waiting4sel1 -> draw_string "Waiting for 2nd point of selection"; 
          Some {state with
          aux_x1 = status.G.mouse_x;
          aux_y1 = status.G.mouse_y;
          current = Waiting4sel2}
      | Waiting4sel2 -> Some {state with 
          s_list = Shape.select_shape state.aux_x1 state.aux_y1 
          status.G.mouse_x status.G.mouse_y state.shape_list}
      | _ -> Some state


 (* This is the program's main loop, which given the configuration of certain 
  events or steps will summon each of the operations that the client wishes to 
  perform by interacting with them, using the information provided by the client 
  If what it receives from the client is a mouse event, it will get redirected 
  to the mouse_click_selection function above. Otherwise, it will get 
  redirected to the keyboard matching function *)
  let rec coreldro state =
    Shape.draw_all state.shape_list;
    let status = wait_next_event [key_pressed; button_down] in
      let state : state option =
        if status.G.keypressed then
          key_press_selection status.G.key state
        else if status.G.button then
          mouse_click_selection state.current state status
        else Some state
      in
        match state with
          | Some state -> coreldro state
          | None -> ()

 (* This is where an initial state is generated, for its later use in coredro 
  to set its initial parameters*)
  let start () =
    try
      open_graph "Coreldro";
      let initial_state = {
        shape_list = [];
        s_list = [];
        current = Init;
        aux_x1 = 0;
        aux_y1 = 0;
        current_color = G.black
      }
      in 
        coreldro initial_state
    with Graphic_failure _->();

end

