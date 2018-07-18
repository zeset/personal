open GraphicsIntf
open List

module CustomShape (Gr: GRAPHICS) = struct
  open Gr
  module G = Graphics

(* Types allowed for figures to have *)
  type shape_class =
    | Circle
    | Rectangle
(* Types of resizing operations available for figures *)
  type resize_op =
    | Enlarge
    | Reduce

(* Type that contains the shape's information, such as it's 
    coordenates, color, size and it's shape class *)
  type shape = {
    class_sh: shape_class;
    x: int;
    y: int;
    size: int;
    color: G.color;
  }

(* This function assigns a color *)
  let set_color c =
    try G.set_color c
    with _ -> ()

(* Function that helps the deletion process being held at delete_shape.
  Given a shape class, it shall match it with an appropiate procedure
  in order to check if the shape contains the (x,y) coordenate *)
  let helper_delete x y sh =
    match sh.class_sh with
    | Circle -> 
      if ((x - sh.x) * (x - sh.x) + (y - sh.y) * (y - sh.y) < sh.size * sh.size)
      then false
      else true  
    | Rectangle ->
      if ((sh.x - sh.size/2 < x && x < sh.x + sh.size/2) &&
      (sh.y - sh.size/2 < y && y < sh.y + sh.size/2))
      then false
      else true


(* Main deleting function.It works by filtering throughout the entire shape
  list the selectes ones and calling the helper function *)
  let delete_shape x y shape_list =
    clear_graph ();
    List.filter (helper_delete x y) shape_list


(* General drawing function. Given a shape class, it will draw
  the shape linked to the given shape class by using it's
  x y and size coordenates , also adding its color *)
  let draw shape =
    match shape.class_sh with
      | Circle -> set_color shape.color;
        fill_circle (shape.x) (shape.y) (shape.size)
      | Rectangle -> set_color shape.color;
        fill_rect (shape.x) (shape.y) (shape.size) (shape.size)

(* Function used to ensure the size of a shape after its resizing is never 
  below 0 *)
  let safe_substraction value amount =
    if value - amount >= 0 then value - amount
    else 0

(* Function used to enlarge selected shapes. It will link a shape to its 
  correct procedure by matching its shape class *)
  let enlarge_shape shape =
    match shape.class_sh with
      | Rectangle -> {shape with size = shape.size + 4}
      | Circle -> {shape with size = shape.size + 2}

(* Function used to decreaze the selected shapes' size. It will match a shape 
  to its correct procedure by matching its shape class *)
  let reduce_shape shape = 
    match shape.class_sh with
      | Rectangle -> {shape with size = safe_substraction shape.size 4 }
      | Circle -> {shape with size = safe_substraction shape.size 2 }

(* Main resizing function that will allow to call any of the resizing function
    above by matching the modf parameter *)
  let resize_shape shape modf =
    match modf with
      | Enlarge -> enlarge_shape shape
      | Reduce -> reduce_shape shape

(* Function that summons the resize_shape function in the elements of the 
    shape list that match with the elements existing in the sel_sh (selected 
    shapes) *)
  let helper_resize sel_sh modf each =
    if List.exists (fun each' -> each' = each) sel_sh
    then resize_shape each modf
    else each  

(* Function that calls the helper_resize function, mapping
  throughout the entire shape list, and applying its correct
  procedures *)
  let resize_selection sel_sh shape_list modf =
    clear_graph ();
    List.map (helper_resize sel_sh modf) shape_list

(* Function that draws everything stored on the shape_list.
     Summoned everytime an operation is completed *)  
  let draw_all shape_list =
    List.iter draw (List.rev shape_list)

(* Function that adds a shape into the current shape_list.
  Matches a given shape class with one of the types available, 
  sets its coordenates and then adds it into the 
  current shape_list *)
  let add_shape x y shape_list sh_class color =
    match sh_class with
      | Rectangle -> let shape = {
        class_sh = Rectangle;
        size = 10;
        x = x - 5;
        y = y - 5;
        color = color
        } in shape::shape_list
      | Circle -> let shape = {
        class_sh = Circle;
        size = 5;
        x = x;
        y = y;
        color = color
        } in shape::shape_list

 (* Function that checks if a given shape is found
    within the points of a current selection *)
  let check_select x1 y1 x2 y2 shape = 
    let cx = (x1 + x2)/2 in
    let cy = (y1 + y2)/2 in
    let dist a b = abs (a - b) in
    if ((dist (shape.x) cx) < (dist x1 cx)
      && (dist (shape.y) cy) < (dist y1 cy))
    then true
    else false


(* Function that filters out the shape list by summoning
    the check_select function to return the shapes
    within a certain area of selection *)
  let select_shape x1 y1 x2 y2 shape_list =
    List.filter (check_select x1 y1 x2 y2) shape_list

end

