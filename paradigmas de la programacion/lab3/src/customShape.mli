open GraphicsIntf

module CustomShape : functor (Gr: GRAPHICS) -> sig
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
    coordenates, size, color and it's shape class *)
  type shape = {
    class_sh: shape_class;
    x: int;
    y: int;
    size: int;
    color: G.color;
  }
(*Available methods*)
  val draw_all : shape list -> unit

  val resize_selection : shape list -> shape list -> resize_op -> shape list

  val add_shape : int -> int -> shape list -> shape_class -> G.color -> shape list

  val delete_shape : int -> int -> shape list -> shape list

  val select_shape : int -> int -> int -> int -> shape list -> shape list 

end
