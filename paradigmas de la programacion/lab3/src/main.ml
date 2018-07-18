open App

(* We apply the App _functor_ with the implementation of Graphics *)
module AppG = App(GraphicsImpl.G)

let _ =
  AppG.start ()
