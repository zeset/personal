# Laboratorio 2 - Paradigmas 2018




## Programación con Frameworks



Nahuel Borda



En este laboratorio se nos fue pedida la tarea de desarrollar el front end de 
la aplicación Deliveru del laboratorio 1, a través del framework ReactJS.
En este README, detallaremos las decisiones de diseño tomadas durante el 
desarrollo y la implementacion de codigo de este laboratorio.
En cuanto a este topico, cabe destacar dos medidas que tomamos en cuanto a las
ordenes, y a los items. Pensamos que no afecta al desempeño de la aplicacion
la posibilidad de crear items sin nombre y con precio cero, asi como tampoco
la posibilidad de crear ordenes nulas, siendo que ninguna de las dos acciones
afecta al balance de ninguno de los usuarios involucrados. 



~ Punto Estrella ~ 

Se implementaron las redirecciones que consideramos necesarias para la fluidez 
y el funcionamiento de la aplicacion. Por ejemplo, en el caso de que un provider 
quiera entrar a la home, sera redigirido a su perfil , en vista que desde
su usuario de provider no esta contemplado hacer pedidos.