;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; CODIGO CLP QUE REALIZA UN BUCLE CONTINUO HASTA UNA CONDICION DE PARADA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;  1.- En cada bucle actualiza las variables globales ?*hora* ?*minutos* y ?*segundos* con la hora real o la simulada 
;;;;;;;;;;;; según LO elijamos en el fichero de configuración SituacionInicial.txt, y equivalentemente 
;;;;;;;;;;;; actualiza los hechos  (hora_actual ?h) (minutos_actual ?m) y (segundos_actual ?m)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;; 2.- Utiliza un fichero de configuración (SituacionInicial.txt) donde se elige como se controla el bucle, y
;;;;;;;;;;;;;si se hace con el tiempo real o simulado. 
;;;;;;;;;;;;; En el ejemplo adjuntado se hace simulado, desde las 10 h 3m y 0 segundos,  y en cada paso se simula que ha pasado un segundo.

;;;;;;;; 3.- Ademas se incluyen funciones para manejar tiempo y horas que están comentadas, 

;;;;;;;;;4.- Tambien se actualiza en cada paso del bucle la variable global ?*transcurrido* que mide los segundos transcurridos desde
;;;;;;;;;;;;; el comienzo de la ejecucion y ¡¡¡¡¡PUEDE UTILIZARSE PARA REALIZAR UN TIMESTAMP!!!!! 




(defglobal ?*transcurrido* = 0)      ;;; tiempo tanscurrido (en s) desde que comenzo la ejecucion (run)
(defglobal ?*hora* = 0)              ;;; hora actual (si son las ?h:?m:?s, ?*hora* = ?h
(defglobal ?*minutos* = 0)           ;;; minuto actual (si son las ?h:?m:?s, ?*minutos* = ?m
(defglobal ?*segundos* = 0)          ;;; segundo actual (si son las ?h:?m:?s, ?*segundos* = ?s
(defglobal ?*sumando* = 0)           ;;; Sumando para pasar de tiempo tanscurrido a hora (en formato s desde las 00:00:00); seran los segundos al iniciar la ejejcución
(defglobal ?*inicioejecucion* = 0)   ;;; resultado de (time) al comienzo de la ejecucion, para pasar del resultado de (time) a ?*transcurrido*
(defglobal ?*segundossimulados* = 0) ;;; Segundo que se esta simulando ; para simulacion en tiempo real coincidiría con ?*transcurrido*
(defglobal ?*tiemporeal* = 1)         ;;; 0 si se va a simular la hora, 1 si la simulacion es en tiempo real
(defglobal ?*segundosporciclo* = 1)   ;;; si simulamos el tiempo transcurrido, lo que vamos a suponer que equivale a cada ciclo
(defglobal ?*SO* = 1)                 ;;; Por defecto es Windows (valor 1), se cambia con el hecho (SistemaOperativo XXX), que le hace tomar valor 0 y asi calcular la hora del sistema en el formato linux-macos

;;;;;; Funcion que transforma ?h:?m:?s  en segundos ;;;;;;;;;;;;

(deffunction totalsegundos (?h ?m ?s)
   (bind ?rv (+ (* 3600 ?h) (* ?m 60) ?s))
   ?rv)
   
;;;;;; Funcion que devuelve la salida de ejecutar  ?arg en linea de comandos del sistema ;;;;;;;;;;;;
	  
   (deffunction system-string (?arg)
   (bind ?arg (str-cat ?arg " > temp.txt"))
   (system ?arg)
   (open "temp.txt" temp "r")
   (bind ?rv (readline temp))
   (close temp)
   ?rv)
   
;;;;;; Funcion que devuelve el nº de horas de la hora del sistema, si en el sistema son las ?h:?m:?s, devuelve ?h  ;;;;;;;;;;;;
   
   (deffunction horasistema ()
   (if (= ?*SO* 1) 
      then
         (bind ?rv (integer (string-to-field (sub-string 1 2  (system-string "time /t")))))
	   else 
	     (bind ?rv (string-to-field  (system-string "date +%H"))) 
         )    	 	  
   ?rv)
   
;;;;;; Funcion que devuelve el nº de minutos de la hora del sistema, si en el sistema son las ?h:?m:?s, devuelve ?m  ;;;;;;;;;;;; 
 
   (deffunction minutossistema ()
   (if (= ?*SO* 1) 
       then
          (bind ?rv (integer (string-to-field (sub-string 4 5  (system-string "time /t")))))
	   else 
	     (bind ?rv (string-to-field  (system-string "date +%M")))	  )
   ?rv)
   
;;;;;; Funcion que devuelve el nº de segundos de la hora del sistema, si en el sistema son las ?h:?m:?s, devuelve ?s  ;;;;;;;;;;;;
   
   (deffunction segundossistema ()
   (if (= ?*SO* 1) 
       then
          (bind ?rv (integer (string-to-field (sub-string 7 8  (system-string "@ECHO.%time:~0,8%")))))
	   else 
	     (bind ?rv (string-to-field  (system-string "date +%S")))	  )
   ?rv)
   
;;;;;; Funcion que devuelve el valor de ?h  al pasar ?t segundos al formato ?h:?m:?s  ;;;;;;;;;;
   
    (deffunction hora-segundos (?t)
   (bind ?rv  (div ?t 3600))
   ?rv)
   
;;;;;; Funcion que devuelve el valor de ?m  al pasar ?t segundos al formato ?h:?m:?s  ;;;;;;;;;;   
   (deffunction minuto-segundos (?t)
   (bind ?rv (- ?t (* (hora-segundos ?t) 3600)))
   (bind ?rv (div ?rv 60))
   ?rv)

;;;;;; Funcion que devuelve el valor de ?s  al pasar ?t segundos al formato ?h:?m:?s  ;;;;;;;;;;     
   (deffunction segundo-segundos (?t)
   (bind ?rv (- ?t (* (hora-segundos ?t) 3600)))
   (bind ?rv (- ?rv (* (minuto-segundos ?t) 60)))
   ?rv)
   
;;;;; Funcion que actualiza las variables globales ?*transcurrido* ?*hora* ?*minutos* y ?*segundos*,
;;;;; y devuelve el valor del instante  en formato de segundos transcurridos desde las 00:00:00

   (deffunction momento ()
   (if (= ?*tiemporeal* 1) then
       (bind ?*transcurrido* (- (round (time)) ?*inicioejecucion*))
	else
       (bind ?*transcurrido* (+ ?*transcurrido* ?*segundosporciclo* ) ))		   
   (bind ?rv (+ ?*sumando* ?*transcurrido*))
   (bind ?*hora* (hora-segundos ?rv))
   (bind ?*minutos* (minuto-segundos ?rv))
   (bind ?*segundos* (segundo-segundos ?rv))
   ?rv)
   
;;;; Funcion que devuelve cuantos minutos quedan hasta las ?arg horas en punto
   
   (deffunction mrest (?arg)
   (bind ?rv (momento))
   (bind ?rv (+ (* (- (- ?arg 1) ?*hora*) 60) (- 60 ?*minutos*)))
   ?rv)
   

   
   (deffunction totalminutos (?h ?m)
   (bind ?rv (+ (* 60 ?h) ?m))
   ?rv)
   
   (deffunction hora2 (?hinicio ?minicio)
   (bind ?rv (+ (div (- (totalminutos (horasistema) (minutossistema)) (totalminutos  ?hinicio ?minicio)) 60) 8))
   ?rv)
   
   (deffunction minutos2 (?hinicio ?minicio)
   (bind ?rv (-  (- (totalminutos (horasistema) (minutossistema)) (totalminutos  ?hinicio ?minicio))   (* (- (hora2 ?hinicio ?minicio) 8) 60)))
   ?rv)
   
   (deffunction siguientehora (?h ?m ?s)
   (if (and (= ?s 59) (= ?m 59))
     then 
       (bind ?rv (+ ?h 1))
     else 
       (bind ?rv ?h) 	 
     )
   ?rv)
   
   (deffunction siguienteminuto (?h ?m ?s)
   (if (= ?s 59)
     then 
	   (if (= ?m 59) then (bind ?rv 0) else (bind ?rv (+ ?m 1)))
     else 
       (bind ?rv  ?m) 	 
     )
   ?rv)
   
   (deffunction siguientesegundo (?h ?m ?s)
   (if (= ?s 59)
     then 
	  (bind ?rv 0)
     else 
       (bind ?rv  (+ ?s 1)) 	 
     )
   ?rv)
   
  
   (deffunction esperando (?arg)
   (bind ?arg (str-cat "timeout " ?arg "> null"))
   (system ?arg)
   (bind ?rv "")
   ?rv)
   
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;; Para registrar la hora de comienzo de la ejecucion (si es simulada la fijamos nosotros) y fijar sumando en consecuencia
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (defrule LeerConfiguracion
   (declare (salience 10000))
   =>
   (load-facts SituacionInicial.txt)
   )
  
  (defrule simulado
  (declare (salience 10000))
  (simulado desde-las ?h ?m ?s segundosporciclo ?spc)
  =>
  (bind  ?*tiemporeal* 0)
  (bind ?*hora* ?h)
  (bind ?*minutos* ?m)
  (bind ?*segundos* ?s)
  (bind ?*segundosporciclo* ?spc)
  (printout t "Realizando el bucle en modo simulado, con comienzo  a las " ?h " " ?m " " ?s ", simulando " ?spc " segundos en cada ciclo" crlf)
  )
  
  (defrule SO_no_Windows
  (declare (salience 10000))
  (SistemaOperativo ~WINDOWS)
  =>
  (bind  ?*SO* 0)
  )
   
   (defrule RegistrarHoraInicio
   (declare (salience 9999))
   =>
   (bind ?*inicioejecucion* (round (time)))
   (if (= ?*tiemporeal* 1) 
    then
     (bind ?*hora* (horasistema))
     (bind ?*minutos* (minutossistema))
     (bind ?*segundos* (segundossistema)) 
    )
   (bind ?*sumando* (totalsegundos ?*hora* ?*minutos* ?*segundos*))
   (printout t "Hora simulada inicio " ?*hora* ":" ?*minutos* ":" ?*segundos* crlf)
   (assert (HoraActualizada (totalsegundos ?*hora* ?*minutos* ?*segundos*)))
   (assert (hora_actual ?*hora*))
   (assert (minutos_actual ?*minutos*))
   (assert (segundos_actual ?*segundos*))
   )
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Para preguntar al usuario ciclo a ciclo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(defrule  InicializarPreguntando
(Preguntando)
=>
(assert  (Seguir S))
(assert (ciclo 0))
(printout t "Se realiza el bucle preguntando en cada paso si se desea continuar" crlf) 
)
 
(defrule PreguntarSeguirPreguntando
(Preguntando)
?f <- (Preguntar)
=>
(printout t "Indique si desea ejecutar un nuevo ciclo? (S/N) ")
(assert (Seguir (read)))
(retract ?f)
)

(defrule guardarsituacionPreguntando
(declare (salience -20))
(Preguntando)
?f <- (Seguir N)
?g <- (ciclo ?n)
 =>
(retract ?f ?g)
(save-facts "Situacionfinal.txt")
(printout t "Guardamos los hechos del sistema en "Situacionfinal.txt crlf)
)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Para preguntar al usuario cuantos ciclos realizar 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule  InicializarNCiclos
(NCiclos)
=>
(assert  (Seguir S))
(printout t "Escriba el numero de ciclos a realizar: ")
(assert (NumeroCiclos (read))) 
(assert (ciclo 0))
)

(defrule PreguntarSeguirNCiclos
(NCiclos)
?f <- (Preguntar)
(ciclo ?n)
(NumeroCiclos ?m)
(test (< ?n ?m))
=>
(assert (Seguir S))
(retract ?f)
)

(defrule guardarsituacionNCiclos
(declare (salience -20))
(NCiclos)
?f <- (Preguntar)
?g <- (ciclo ?n)
?h <- (NumeroCiclos ?m)
(test (= ?n ?m))
 =>
(retract ?f ?g ?h)
(save-facts "Situacionfinal.txt")
(printout t "Guardamos los hechos del sistema en "Situacionfinal.txt crlf)
 )

 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Para preguntar al usuario cuanto tiempo se va hacer el bucle 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule  InicializarTiempo
(Tiempo)
=>
(assert  (Seguir S))
(printout t "Indica los segundos que quieres que haga el bucle?: ")
(assert (NumeroSegundos (read)))
(printout t crlf)
(assert (ciclo 0))
)

(defrule PreguntarSeguirTiempo
(Tiempo)
?f <- (Preguntar)
(ciclo ?n)
(NumeroSegundos ?s)
(test (<= ?*transcurrido* ?s))
=>
(assert (Seguir S))
(retract ?f)
)

(defrule guardarsituacionNumeroCiclos
(declare (salience -20))
(Tiempo)
?f <- (Preguntar)
?g <- (ciclo ?n)
?h <- (NumeroSegundos ?s)
(test (> ?*transcurrido* ?s))
 =>
(retract ?f ?g ?h)
(save-facts "Situacionfinal.txt")
(printout t "Guardamos los hechos del sistema en "Situacionfinal.txt crlf)
 )

 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;Generar ciclo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule Generaciclo
?f <- (Seguir S)
?g <- (ciclo ?n)
=> 
(assert (ciclo (+ ?n 1)))
(assert (ActualizarHora))
(retract ?f ?g)
)


(defrule Actualizar-Hora
   (declare (salience 10000))
   ?f <- (ActualizarHora)
   ?g <- (HoraActualizada ?t)
   ?k <- (hora_actual ?h)
   ?i <- (minutos_actual ?m)
   ?j <- (segundos_actual ?s)   
   =>
   (retract ?f ?g ?k ?i ?j)
   (assert (HoraActualizada (momento)))
   ;(printout t "Hora actualizada" crlf)
   (assert (hora_actual ?*hora*))
   (assert (minutos_actual ?*minutos*))
   (assert (segundos_actual ?*segundos*))
 )
 
(defrule  Siguiente_ciclo
(declare (salience -10000))
(ciclo ?n) 
=>
(assert (Preguntar))
)

;(defrule ImprimirCiclo
;(ciclo ?n)
;=>
;(printout t "Transcurrido "  ?*transcurrido* "  " ?*hora* ":" ?*minutos* ":" ?*segundos* " Paso por el ciclo " ?n  crlf)
;)