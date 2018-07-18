open App
open OUnit2

open GraphicsTest

(* Los tests funcionan del siguiente modo: la función `load` toma dos listas. La
   primera contiene los eventos (mouse, teclado), la segunda las acciones (sobre
   Graphics) que se esperan. Por ejemplo:

     load [key 'e'] [Open]

   Toma un único evento (la tecla 'e'), y espera una única acción (abrir la ventana).
   En el módulo `graphicsTest` pueden ver todos los eventos y las acciones.
*)
module TestApp = App(G)
open G

(* Definimos algunos eventos *)
(* keys *)
let ke = key 'e'
let kc = key 'c'
let kr = key 'r'
let kd = key 'd'
let ks = key 's'
let kadd = key '+' 
let ksub = key '-'
let k2 = key '2'

(* clicks *)
let p1 = mouse (5, 10)
let p2 = mouse (9, 11)
let p4 = mouse (100, 100)
let p0 = mouse (10, 10)
let p3 = mouse (55, 55)
let p5 = mouse (50, 50)
let p6 = mouse (0, 5)


(* Definimos unas acciones *)
(* rectangles *)
let r1 = (0, 5, 10, 10)
let r2 = (4, 6, 10, 10)
let r3 = (50, 50, 14, 14)
let r4 = (50, 50, 10, 10)

(* circles *)
let c1 = (5, 10, 5)
let c2 = (9, 11, 5)
let c3 = (50, 50, 5)
let c4 = (50, 50, 3)

let op = Open
let wc = DrawString "waiting for circle"
let wr = DrawString "waiting for rectangle"
let wd = DrawString "waiting for deletion"
let ws1 = DrawString "waiting for 1st point of selection"
let ws2 = DrawString "waiting for 2nd point of selection"
let fc1 = FillCircle c1
let fc2 = FillCircle c2
let fc3 = FillCircle c3
let fc4 = FillCircle c4
let fr1 = FillRect r1
let fr2 = FillRect r2
let fr3 = FillRect r3
let fr4 = FillRect r4
let cl = Clear

let exit _ =
  let open G in
  G.load [ke] [op];
  TestApp.start ();
  G.close ()

let circle _ =
  let open G in
  G.load [kc; p1; ke] [op; wc; fc1];
  TestApp.start ();
  G.close ()

let rectangle _ =
  let open G in
  G.load [kr; p1; ke] [op; wr; fr1];
  TestApp.start ();
  G.close ()

let two_rectangles _ =
  let open G in
  G.load [kr; p1; p2; ke] [op; wr; fr1; fr1; fr2];
  TestApp.start ();
  G.close ()

let two_circles _ =
  let open G in
  G.load [kc; p1; p2; ke] [op; wc; fc1; fc1; fc2];
  TestApp.start ();
  G.close ()

let deleting_nothing _ =
  let open G in
  G.load [kd; p1; ke] [op; wd; cl];
  TestApp.start ();
  G.close ()

(* A circle is created and then deleted *)
let deleting_circle _ =
  let open G in
  G.load [kc; p1; kd; p1; ke] [op; wc; fc1; wd; fc1;cl];
  TestApp.start ();
  G.close ()

(* A rectangle is created and then deleted *)
let deleting_rectangle _ =
  let open G in
  G.load [kr; p1; kd; p6; ke] [op; wr; fr1; wd; fr1;cl];
  TestApp.start ();
  G.close ()

(* A rectangle is created and increased *)
let increase_figure _ =
  let open G in
  G.load [kr; p3; ks; p0; p4; kadd; ke] [op; wr; fr4; ws1; fr4; ws2; fr4; fr4; cl; fr3];
  TestApp.start ();
  G.close ()

(* A circle is created and decreased *)
let decrease_figure _ =
  let open G in
  G.load [kc; p5; ks; p0; p4; ksub; ke] [op; wc; fc3; ws1; fc3; ws2; fc3; fc3; cl; fc4];
  TestApp.start ();
  G.close ()

(* A rectangle is created, increased, and then deleted *)
let increase_figure_delete _ =
  let open G in
  G.load [kr; p3; ks; p0; p4; kadd; kd; p5; ke] 
  [op; wr; fr4; ws1; fr4; ws2; fr4; fr4; cl; fr3; wd; fr3; cl];
  TestApp.start ();
  G.close ()

(* A circle is created, decreased, and then deleted *)
let decrease_figure_delete _ =
  let open G in
  G.load [kc; p5; ks; p0; p4; ksub; kd; p5; ke]
  [op; wc; fc3; ws1; fc3; ws2; fc3; fc3; cl; fc4; wd; fc4; cl];
  TestApp.start ();
  G.close ()

(* A rectangle is created, and then deleted *)
let deleting_rectangle _ =
  let open G in
  G.load [kr; p1; kd; p6; ke] [op; wr; fr1; wd; fr1;cl];
  TestApp.start ();
  G.close ()
  
(* A red rectangle is created *)
let red_rectangle _ =
  let open G in
  G.load [kr; k2; p1; ke;] [op; wr; fr1];
  TestApp.start ();
  G.close ()

let normal_suite =
  "Coreldro normal" >:::
  ["exit">::exit
  ;"circle">::circle
  ;"rectangle">::rectangle
  ;"two rectangles">::two_rectangles
  ;"two circles">::two_circles
  ]

let border_suite =
  "Coreldro border cases" >:::
  ["deleting nothing">::deleting_nothing]

let custom_suite =
  "Coreldro pro cases" >:::
  ["deleting_circle">::deleting_circle
  ;"deleting_rectangle">::deleting_rectangle
  ;"increase_figure">::increase_figure
  ;"decrease_figure">::decrease_figure
  ;"increase_figure_delete">::increase_figure_delete
  ;"decrease_figure_delete">::decrease_figure_delete
  ;"red_rectangle">::red_rectangle
  ]

let _ =
  run_test_tt_main normal_suite;
  run_test_tt_main border_suite;
  run_test_tt_main custom_suite
