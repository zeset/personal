open GraphicsIntf

module App : functor (Gr: GRAPHICS) -> sig

  val start : unit -> unit

end
