
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

(deffacts Personas
  (NumeroPersonas Recepcion 0)    ;;;;  Receptión es una habitación
  (NumeroPersonas Pasillo 0)
  (NumeroPersonas Oficina1 0)
  (NumeroPersonas Oficina2 0)
  (NumeroPersonas Oficina3 0)
  (NumeroPersonas Oficina4 0)
  (NumeroPersonas Oficina5 0)
  (NumeroPersonas OficinaDoble 0)
  (NumeroPersonas Gerencia 0)
  (NumeroPersonas Papeleria 0)
  (NumeroPersonas Aseos 0)
  (NumeroPersonas AseoHombres 0)
  (NumeroPersonas AseoMujeres 0)
  )

  (deffacts Luces
    (Luz Recepcion OFF)    ;;;;  Receptión es una habitación
    (Luz Pasillo OFF)
    (Luz Oficina1 OFF)
    (Luz Oficina2 OFF)
    (Luz Oficina3 OFF)
    (Luz Oficina4 OFF)
    (Luz Oficina5 OFF)
    (Luz OficinaDoble OFF)
    (Luz Gerencia OFF)
    (Luz Papeleria OFF)
    (Luz Aseos OFF)
    (Luz AseoHombres OFF)
    (Luz AseoMujeres OFF)
    )

   (deffacts Codificacion
   (Code TG "Tramites Generales")
   (Code TE "Tramites Especiales")
   (Code 0 "No fichado")
   (Code 1 "Fichado")
   (Code 2 "Disponible")
   (Code 3 "Atendiendo")
   (Code 4 "Descansando")
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
  (EmpleadosFichados TG 0)                   ;;; Inicialmente hay 0 empleados en las oficinas
  (EmpleadosFichados TE 0)
  (Ejecutar)
  (TiempoTramite TG 0)
  (TiempoTramite TE 0)
  ;0 para no fichado
  ; 1 para fichado
  ; 2 disponible
  ; 3 atendiendo
  ; 4 descansando
  (EstadoEmpleado Director 0)
  (EstadoEmpleado G1 0)
  (EstadoEmpleado G2 0)
  (EstadoEmpleado G3 0)
  (EstadoEmpleado G4 0)
  (EstadoEmpleado G5 0)
  (EstadoEmpleado E1 0)
  (EstadoEmpleado E2 0)

  (TramitesEmpleado G1 0)
  (TramitesEmpleado G2 0)
  (TramitesEmpleado G3 0)
  (TramitesEmpleado G4 0)
  (TramitesEmpleado G5 0)
  (TramitesEmpleado E1 0)
  (TramitesEmpleado E2 0)
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
  (open "DatosT.txt" datosT "a")
  (open "DatosE.txt" datosE "a")


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

  (HoraActualizada ?t)
  =>

  (assert (Usuario ?tipotramite (+ ?n 1))
          (Usuarios ?tipotramite (+ ?n 1))
          (TiempoInicialUsuario ?tipotramite (+ ?n 1) (momento))
          (NoComprobado ?tipotramite (+ ?n 1) 0)
  )
  (printout t "Su turno es " ?tipotramite " " (+ ?n 1)  crlf)
  (retract ?f ?g)
  )
  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1B ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule AsignarEmpleado
  ?g <- (Disponible ?empl)
  ?f <- (UltimoUsuarioAtendido ?tipotramite ?atendidos)
  ?q<-(EstadoEmpleado ?empl ?estado)
  (Empleado ?empl ?ofic)
  (Tarea ?empl ?tipotramite)
  (Usuarios ?tipotramite ?total)
  (HoraActualizada ?t)
  (test (< ?atendidos ?total))
  =>
  (bind ?a (+ ?atendidos 1))
  (assert (Asignado ?empl ?tipotramite ?a)
          (UltimoUsuarioAtendido ?tipotramite ?a)
          (TiempoInicialTramite ?tipotramite ?a ?t)
          (EstadoEmpleado ?empl 3)
          )
  (printout t "Usuaro " ?tipotramite ?a ", por favor pase a " ?ofic crlf)
  (retract ?f ?g ?q)
  )

  (defrule RegistrarCaso
  (declare (salience 10))
  (Disponible ?empl)
  ?f <- (Asignado ?empl ?tipotramite ?n)
  ?g <- (TiempoInicialTramite ?tipotramite ?n ?tinicialTramite)
  ?v <- (TiempoInicialUsuario ?tipotramite ?n ?tinicialCola)
  ?z <- (NoComprobado ?tipotramite ?n ?)
  ?y <- (EstadoEmpleado ?empleado ?estado)
  ?q <- (TramitesEmpleado ?empl ?totalTramites)
  (HoraActualizada ?t)
  =>
  (bind ?tTramite (- ?t ?tinicialTramite))
  (bind ?tEspera (- ?tinicialTramite ?tinicialCola))

    (assert (Tramitado ?empl ?tipotramite ?n)
            (TramitesEmpleado ?empl (+ ?totalTramites 1))
            (EstadoEmpleado ?empl 2))
    (retract ?f ?g ?v ?z ?q ?y)
    (printout t "El empleado " ?empl " ahora esta disponible." crlf )
    (printout datosT "Usuario: " ?tipotramite ?n " \\Tiempo: " ?tTramite crlf)
    (printout datosE "Usuario: " ?tipotramite ?n " \\Tiempo: " ?tEspera crlf)
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
    ?v <-(NoComprobado ?tipotramite ?n ?val)
    (MaximoEsperaParaSerAtendido ?tipotramite ?tiempoMax)
    (UltimoUsuarioAtendido ?tipotramite ?id)
    (HoraActualizada ?xc)
    (test (< ?id ?n))
    (test (> (- ?xc ?tiempo) (* ?tiempoMax 60)))
    (test (eq ?val 0))
    =>
    (printout t "El usuario " ?tipotramite " " ?n " lleva esperando mas tiempo tiempo del maximo" crlf)
    (assert (NoComprobado ?tipotramite ?n 1))
    (retract ?v)
  )

  (defrule Fichar
    (declare (salience 10))
    ?a<-(Ficha ?empl)
    (Tarea ?empl ?tipotramite)
    (HoraActualizada ?hora)
    ?b <- (EstadoEmpleado ?empl ?gs)
    ?c <- (EmpleadosFichados ?tipotramite ?totalFichados)
    (test (= ?gs 0))
    =>
    (assert (HoraFicha ?empl ?hora)
    (EstadoEmpleado ?empl 1)
    (EmpleadosFichados ?tipotramite (+ ?totalFichados 1))
    )
    (printout t "Ha fichado el empleado: " ?empl crlf)
    (retract ?b ?a ?c)

    )

  (defrule ComienzaTrabajar
    (Disponible ?empl)
    ?y <- (EstadoEmpleado ?empl ?estado)
    (test (= ?estado 1))
    =>
    (assert (EstadoEmpleado ?empl 2))
    (retract ?y)
    (printout t "El empleado " ?empl " comienza a trabajar." crlf)
    )

  (defrule EmpleadoSeVa
    ?b <-(Ficha ?empl)
    (HoraActualizada ?hora)
    (FinalJornada ?horaFin)
    (Tarea ?empl ?tipotramite)
    ?y <- (EstadoEmpleado ?empl ?estado)
    ?a <- (EmpleadosFichados ?tipotramite ?totalFichados)
    =>
    (assert (EmpleadosFichados ?tipotramite (- ?totalFichados 1)))
    (if (>= ?hora (totalsegundos ?horaFin 0 0)) then
        (assert(EstadoEmpleado ?empl 0))
        (printout t "El empleado " ?empl " se va" crlf)
    else
        (assert (EstadoEmpleado ?empl 4))
        (printout t "El empleado " ?empl "se va a descansar." crlf)

    )
    (retract ?a ?b ?y))


  (defrule Libres
    (declare (salience 1000))
    (EmpleadosFichados ?tipotramite ?tot)
    (MinimoEmpleadosActivos ?tipotramite ?min)
    (test (> ?min ?tot))
    (code ?tipotramite ?texto)
    =>
    (printout t "Hay menos de " ?min " trabajadores atendiento " ?texto crlf)
    )

  (defrule TiempoTramiteExcedido
      (ciclo ?n)
      (TiempoInicialTramite ?tipotramite ?n ?t)
      (MaximoTiempoGestion ?tipotramite ?tmax)
      (HoraActualizada ?hora)
      (test (> (- ?hora ?t) (* ?tmax 60)))
      =>
      (printout t "El tramite " ?tipotramite ?n " ha excedido el tiempo maximo" crlf)
    )


;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; EJ3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule TiempoRetrasoExcedido
      ?a <- (HoraFicha ?empleado ?t)
      (MaximoTiempoRetraso ?tipotramite ?tmax)
      (HoraActualizada ?hora)
      (test (> ?t 0))
      (test (> (- ?hora ?t) (* ?tmax 60)))
      =>
      (printout t "El empleado " ?empleado " ha excedido el tiempo maximo de retraso" crlf)
      (assert (HoraFicha ?empleado -1))
      (retract ?a)
    )


  (defrule ComprobarTiempoDescanso
      ?a <- (HoraDescanso ?empleado ?t)
      (TiempoMaximoDescanso ?tmax)
      (HoraActualizada ?hora)
      (test (> ?t 0))
      (test (> (- ?hora ?t) (* ?tmax 60)))
      =>
      (printout t "El empleado " ?empleado " ha excedido el tiempo maximo de descanso." crlf)
      (assert (HoraDescanso ?empleado -1))
      (retract ?a)
    )

  (defrule ComprobarTotalTramites
    ?a <- (TramitesEmpleado ?empl ?total)
    (Tarea ?empl ?tipotramite)
    (MinimoTramitesPorDia ?tipotramite ?minimo)
    (fin)
    (test (< ?total ?minimo))
    =>
    (printout t "El empleado " ?empl " ha atendido menos de " ?minimo " tramites. " crlf)
    )

  (defrule Consulta
    ?a <- (Consulta ?empl)
    (EstadoEmpleado ?empl ?estado)
    (Code ?estado ?txt)
    =>
    (printout t "El empleado "  ?empl " esta: " ?txt crlf)
    (retract ?a)
    )


;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; EJ4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule LuzPasillo
  (Sensor_puerta Pasillo)
  ?a <- (Luz Pasillo OFF)
  ?b <- (NumeroPersonas Pasillo ?t)
  (HoraActualizada ?hora)
  =>
  (printout t "Encendemos la luz de: " Pasillo crlf)
  (retract ?a ?b)
  (assert (Luz Pasillo ON)
          (NumeroPersonas Pasillo (+ ?t 1))
          (HoraPuertaPasillo ?hora))
)

(defrule ApagarLuzPasillo
  ?a<-(Luz Pasillo ON)
  (HoraActualizada ?hora)
  (not (Sensor_puerta Pasillo))
  (not (Sensor_presencia Pasillo))
  ?b <- (HoraPuertaPasillo ?horaP)
  (test (< 10 (- ?hora ?horaP)))
  =>
  (assert
    (Luz Pasillo OFF))
  (retract ?a ?b)
  (printout t "Apagamos la luz del pasillo" crlf)
)

(defrule LuzHab
  (Sensor_puerta ?hab)
  ?a <- (Luz ?hab OFF)
  ?b <- (NumeroPersonas ?hab ?t)
  (HoraActualizada ?hora)
  (test (neq ?hab Pasillo))
  =>
  (printout t "Encendemos la luz de: " ?hab crlf)
  (retract ?a ?b)
  (assert (Luz ?hab ON)
          (NumeroPersonas ?hab (+ ?t 1)))
  )

  (defrule ApagarLuzHab
    (declare (salience 10))
    (Ficha ?empl)
    (Empleados ?empl ?hab)
    (test (neq ?empl E1))
    (test (neq ?empl E2))

    ?a <- (Luz ?hab ON)
    ?b <- (NumeroPersonas ?hab ?t)
    (test (neq ?hab Pasillo))
    =>
    (printout t "Apagamos la luz de:" ?hab  crlf)
    (retract ?a ?b)
    (assert (Luz ?hab OFF)
            (NumeroPersonas ?hab 0))
    )
