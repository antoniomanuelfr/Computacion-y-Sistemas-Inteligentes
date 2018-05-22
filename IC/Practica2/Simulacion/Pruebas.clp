;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(deffacts Habitaciones
  (Habitacion Recepcion)    ;;;;  Receptión es una habitación
  (Habitacion Pasillo)
  (Habitacion Oficina1)
  (Habitacion Oficina2)
  (Habitacion Oficina3)
  (Habitacion Oficina4)
  (Habitacion Oficina5)
  (Habitacion OficinaDoble)
  (Habitacion Gerencia)
  (Habitacion Papeleria)
  (Habitacion Aseos)
  (Habitacion AseoHombres)
  (Habitacion AseoMujeres)
  )
  (deffacts Puertas
  (Puerta Recepcion Pasillo)    ;;;; Hay una puerta que comunica Recepción con Pasillo
  (Puerta Pasillo Oficina1)
  (Puerta Pasillo Oficina2)
  (Puerta Pasillo Oficina3)
  (Puerta Pasillo Oficina4)
  (Puerta Pasillo Oficina5)
  (Puerta Pasillo Gerencia)
  (Puerta Pasillo OficinaDoble)
  (Puerta Pasillo Papeleria)
  )
  (deffacts Empleados
  (Empleado G1 Oficina1)          ;;;;; El empleado G1 atiende en la Oficina 1
  (Empleado G2 Oficina2)
  (Empleado G3 Oficina3)
  (Empleado G4 Oficina4)
  (Empleado G5 Oficina5)
  (Empleado E1 OficinaDoble-1)
  (Empleado E2 OficinaDoble-2)
  (Empleado Recepcionista Recepcion)
  (Empleado Director Gerencia)
  )

   (deffacts Codificacion
   (Code TG "Tramites Generales")
   (Code TE "Tramites Especiales")
   )
  (deffacts Tareas
  (Tarea G1 TG)                   ;;;;; El empleado G1 atiende Trámites Generales
  (Tarea G2 TG)
  (Tarea G3 TG)
  (Tarea G4 TG)
  (Tarea G5 TG)
  (Tarea E1 TE)                   ;;;;; El empleado E1 atiende Trámites Especiales
  (Tarea E2 TE)
  )
  (deffacts Inicializacion
  (Personas 0)                    ;;; Inicialmente hay 0 personas en las oficinas
  (Usuarios TG 0)                 ;;; Inicialmente hay 0 Usuarios de trámites generales
  (UltimoUsuarioAtendido TG 0)    ;;; Inicialmente se han atendido 0 usuarios de tramites generales
  (Usuarios TE 0)
  (UltimoUsuarioAtendido TE 0)
  (EmpleadosLibres TG 0)                   ;;; Inicialmente hay 0 empleados en las oficinas
  (EmpleadosLibres TE 0)
  (Ejecutar)
  )
  ;(deffacts Constantes
  ;(ComienzoJornada 8)
  ;(FinalJornada 14)
  ;(ComienzoAtencion 9)
  ;(MinimoEmpleadosActivos TG 3)
  ;(MinimoEmpleadosActivos TE 1)
  ;(MaximoEsperaParaSerAtendido TG 30)
  ;(MaximoEsperaParaSerAtendido TE 20)
  ;(MaximoTiempoGestion TG 10)
  ;(TiempoMedioGestion TG 5)
  ;(MaximoTiempoGestion TE 15)
  ;(TiempoMedioGestion TE 8)
  ;(TiempoMaximoRetraso 15)
  ;(TiempoMaximoDescanso 5)
  ;(MinimoTramitesPorDia TG 20)
  ;(MinimoTramitesPorDia TE 15)
  ;)


  (defrule cargarconstantes
  (declare (salience 10000))
  =>
  (load-facts Constantes.txt)
  )


  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; PASO1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;respuestas ante los hechos (Solicitud ?tipotramite) y (Disponible ?empl);;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1A ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule EncolarUsuario
  ?g <- (Solicitud ?tipotramite)
  ?f <- (Usuarios ?tipotramite ?n)
  =>
  (bind ?t (+ (hora-segundos (horasistema)) (minuto-segundos (minutossistema)) (segundo-segundos (segundossistema))))
  (assert (Usuario ?tipotramite (+ ?n 1))
          (Usuarios ?tipotramite (+ ?n 1))
          (TiempoInicialUsuario ?tipotramite (+ ?n 1) ?t)
  )
  (printout t "Su turno es " ?tipotramite " " (+ ?n 1)  crlf)
  (retract ?f ?g)
  )

  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1B ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule AsignarEmpleado
  ?g <- (Disponible ?empl)
  (Tarea ?empl ?tipotramite)
  (Empleado ?empl ?ofic)
  ?f <- (UltimoUsuarioAtendido ?tipotramite ?atendidos)
  (Usuarios ?tipotramite ?total)
  ?tot <- (EmpleadosLibres ?tipotramite ?totalLibres)
  (test (< ?atendidos ?total))
  =>
  (bind ?a (+ ?atendidos 1))

  (assert (Asignado ?empl ?tipotramite ?a)
          (UltimoUsuarioAtendido ?tipotramite ?a)
          (EmpleadosLibres ?tipotramite (- ?totalLibres 1)))
  (printout t "Usuaro " ?tipotramite ?a ", por favor pase a " ?ofic crlf)
  (retract ?f ?g ?tot)
  )

  (defrule RegistrarCaso
  (declare (salience 10))
  (Disponible ?empl)
  ?f <- (Asignado ?empl ?tipotramite ?n)
  ?g <- (EmpleadosLibres ?tipotramite ?totalEmpl)
  =>
  (assert (Tramitado ?empl ?tipotramite ?n)
          (EmpleadosLibres ?tipotramite (+ ?totalEmpl 1))
  )

  (retract ?f ?g)
  )

  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1C ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  (defrule NoposibleEncolarUsuario
  (declare (salience 20))
  ?g <- (Solicitud ?tipotramite)
  (Usuarios ?tipotramite ?n)
  (UltimoUsuarioAtendido ?tipotramite ?atendidos)
  (TiempoMedioGestion ?tipotramite ?m)
  (FinalJornada ?h)
  (test (> (* (- ?n ?atendidos) ?m) (mrest ?h)))
  (Code  ?tipotramite ?texto)
  =>
  (printout t "Lo siento pero por hoy no podremos atender mas " ?texto crlf)
  (bind ?a (- ?n ?atendidos))
  (printout t "Hay ya  " ?a " personas esperando y se cierra a las " ?h "h. No nos dara tiempo a atenderle." crlf)
  (retract ?g)
  )


  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; EJ2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule ComprobarTiempo
    ?e <-(TiempoInicialUsuario ?tipotramite ?n ?tiempo)
    (MaximoEsperaParaSerAtendido ?tipotramite ?tiempoMax)
    (EmpleadosLibres ?tipotramite ?tot)
    (test (!= ?tot 0))
    =>
    (if (> (- (+ (hora-segundos (horasistema)) (minuto-segundos (minutossistema)) (segundo-segundos (segundossistema))) ?tiempo) ?tiempoMax)
      then
      (printout t "El usuario " ?tipotramite " " ?n " " lleva esperando mas tiempo tiempo del maximo)
    )
  )

  (defrule Libres
    (EmpleadosLibres ?tipotramite ?tot)
    (MinimoEmpleadosActivos ?tipotramite ?min)
    (test (> ?min ?tot))
    (code ?tipotramite ?texto)
    =>
    (printout t "Hay menos de " ?min " trabajadores atendiento " ?texto crlf)
    )
