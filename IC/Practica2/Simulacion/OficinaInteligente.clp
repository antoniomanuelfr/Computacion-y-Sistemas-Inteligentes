;;; Hechos estaticos;
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
  (Empleados 0)                   ;;; Inicialmente hay 0 empleados en las oficinas
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
  (assert (Usuario ?tipotramite (+ ?n 1))
          (Usuarios ?tipotramite (+ ?n 1))
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
  (test (< ?atendidos ?total))
  =>
  (bind ?a (+ ?atendidos 1))
  (assert (Asignado ?empl ?tipotramite ?a)
          (UltimoUsuarioAtendido ?tipotramite ?a))
  (printout t "Usuaro " ?tipotramite ?a ", por favor pase a " ?ofic crlf)
  (retract ?f ?g)
  )
  
  (defrule RegistrarCaso
  (declare (salience 10))
  (Disponible ?empl)
  ?f <- (Asignado ?empl ?tipotramite ?n)
  =>
  (assert (Tramitado ?empl ?tipotramite ?n))
  (retract ?f)
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
  