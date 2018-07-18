
module type GRAPHICS = sig
  type status = Graphics.status
  type event = Graphics.event

  exception Graphic_failure of string

  val open_graph : string -> unit

  val clear_graph : unit -> unit

  val draw_rect : int -> int -> int -> int -> unit

  val fill_rect : int -> int -> int -> int -> unit

  val draw_circle : int -> int -> int -> unit

  val fill_circle : int -> int -> int -> unit

  val draw_string : string -> unit

  val wait_next_event : event list -> status

  val button_down : event
  val button_up : event
  val key_pressed : event
  val mouse_motion : event
  val poll : event

end
