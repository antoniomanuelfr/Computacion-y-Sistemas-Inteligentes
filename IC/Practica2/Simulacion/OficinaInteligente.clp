
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

  (TiempoTramitesEmpleado G1 0)
  (TiempoTramitesEmpleado G2 0)
  (TiempoTramitesEmpleado G3 0)
  (TiempoTramitesEmpleado G4 0)
  (TiempoTramitesEmpleado G5 0)
  (TiempoTramitesEmpleado E1 0)
  (TiempoTramitesEmpleado E2 0)

  (ComprobacionMinEmpleados TG 0)
  (ComprobacionMinEmpleados TE 0)

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
  (open "DatosEmpleados.txt" datosEmpl "a")


  )


  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; PASO1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;respuestas ante los hechos (Solicitud ?tipotramite) y (Disponible ?empl);;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule EncolarUsuario
    ?g <- (Solicitud ?tipotramite)
    ?f <- (Usuarios ?tipotramite ?n)
    (HoraActualizada ?t)
    =>

    (assert (Usuario ?tipotramite (+ ?n 1))
          (Usuarios ?tipotramite (+ ?n 1))
          (TiempoInicialUsuario ?tipotramite (+ ?n 1) ?t)
          (NoComprobado ?tipotramite (+ ?n 1) 0)
    )
    (printout t "Su turno es " ?tipotramite " " (+ ?n 1)  crlf)
    (retract ?f ?g))
  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1B ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule AsignarEmpleado
    ?g <- (Disponible ?empl)
    (Tarea ?empl ?tipotramite)
    (Empleado ?empl ?ofic)
    ?f <- (UltimoUsuarioAtendido ?tipotramite ?atendidos)
    (Usuarios ?tipotramite ?total)
    ?q<-(EstadoEmpleado ?empl ?estado)
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
    (retract ?f ?g ?q))

  (defrule RegistrarCaso
    (declare (salience 10))
    (Disponible ?empl)
    ?f <- (Asignado ?empl ?tipotramite ?n)
    ?g <- (TiempoInicialTramite ?tipotramite ?n ?tinicialTramite)
    ?v <- (TiempoInicialUsuario ?tipotramite ?n ?tinicialCola)
    ?z <- (NoComprobado ?tipotramite ?n ?)
    ?c <- (TiempoTramitesEmpleado ?empl ?tiempoTotalTramite)
    ?q <- (TramitesEmpleado ?empl ?totalTramites)
    (HoraActualizada ?t)
    =>
    (bind ?tTramite (- ?t ?tinicialTramite))
    (bind ?tEspera (- ?tinicialTramite ?tinicialCola))
    (bind ?tiempoTramite (- ?t ?tinicialTramite))
    (assert (Tramitado ?empl ?tipotramite ?n)
            (TramitesEmpleado ?empl (+ ?totalTramites 1))
            (TiempoTramitesEmpleado ?empl (+ ?tiempoTotalTramite ?tiempoTramite))
            )
    (retract ?f ?g ?v ?z ?q ?c)
    (printout datosT "@Usuario: " ?tipotramite ?n " \\Tiempo: " crlf ?tTramite crlf)
    (printout datosE "@Usuario: " ?tipotramite ?n " \\Tiempo: " crlf ?tEspera crlf))

  (defrule PulsaDisponible
    (declare (salience 9))
    (Disponible ?empl)
    ?a<-(EstadoEmpleado ?empl ?estado)
    (test (neq ?estado 2))
    =>
    (printout t "El empleado " ?empl " ahora esta disponible." crlf )
    (assert(EstadoEmpleado ?empl 2))
    (retract ?a))
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
    (retract ?g))

;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; EJ2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defrule FichaDirector
    ?a<-(Ficha Director)
    ?b<-(Luz Gerencia ?estado)
    =>
    (if (eq ?estado ON)then
      (assert (Luz Gerencia OFF ))
      (retract ?b ?a)
      (printout t "Apagamos la luz de: "Gerencia crlf)
      (printout t "El director se va de la oficina." crlf)
    else
      (printout t "Ha fichado: " Director crlf)
      (retract ?a)
    ))

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
    (retract ?v))

  (defrule Fichar
    (declare (salience 20))
    ?a<-(Ficha ?empl)
    (Tarea ?empl ?tipotramite)
    (ComienzoJornada ?horaJornada)
    (TiempoMaximoRetraso ?tmax)
    (HoraActualizada ?hora)
    ?b <- (EstadoEmpleado ?empl ?gs)
    ?c <- (EmpleadosFichados ?tipotramite ?totalFichados)
    (test (= ?gs 0))
    =>
    (if (< ?tmax (- ?hora (totalsegundos ?horaJornada 0 0))) then
      (printout t "El empleado " ?empl " llega tarde. "crlf)
    )
    (assert (HoraFicha ?empl ?hora)
    (EstadoEmpleado ?empl 1)
    (EmpleadosFichados ?tipotramite (+ ?totalFichados 1))
    )
    (printout t "Ha fichado el empleado: " ?empl crlf)
    (retract ?b ?a ?c)
    )

  (defrule VuelveDescanso
    (declare (salience 5))
    ?a<-(Ficha ?empl)
    (Tarea ?empl ?tipotramite)
    (HoraActualizada ?hora)
    ?b <- (EstadoEmpleado ?empl ?gs)
    ?c <- (EmpleadosFichados ?tipotramite ?totalFichados)
    ?d <- (HoraDescanso ?empleado ?horaDescnso)
    (TiempoMaximoDescanso ?tmax)
    (test (= ?gs 4))
    =>
    (if (> (- ?hora ?horaDescnso) (totalsegundos 0 ?tmax 0))then
      (printout t "El empleado " ?empl " ha superado el tiempo maximo de descanso." crlf)
    else
      (printout t "El empleado " ?empl " no ha superado el tiempo maximo de descanso." crlf)
    )
    (assert (HoraFicha ?empl ?hora)
    (EstadoEmpleado ?empl 1)
    (EmpleadosFichados ?tipotramite (+ ?totalFichados 1)))
    (printout t "Ha fichado el empleado: " ?empl crlf)
    (retract ?b ?a ?c ?d)
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
    (declare (salience 5))
    ?b <-(Ficha ?empl)
    (HoraActualizada ?hora)
    ?c<-(ComprobacionMinEmpleados ?tipotramite ?)
    (FinalJornada ?horaFin)
    (Tarea ?empl ?tipotramite)
    ?y <- (EstadoEmpleado ?empl ?estado)
    ?a <- (EmpleadosFichados ?tipotramite ?totalFichados)

    =>
    (assert (EmpleadosFichados ?tipotramite (- ?totalFichados 1))
            (ComprobacionMinEmpleados ?tipotramite 0))
    (if (>= ?hora (totalsegundos ?horaFin 0 0)) then
        (assert(EstadoEmpleado ?empl 0))
        (printout t "El empleado " ?empl " se va" crlf)
    else
        (assert (EstadoEmpleado ?empl 4) (HoraDescanso ?empl ?hora))
        (printout t "El empleado " ?empl " se va a descansar." crlf)

    )
    (retract ?a ?b ?c ?y))

  (defrule Libres
    (declare (salience -1))
    (HoraActualizada ?t)
    (EmpleadosFichados ?tipotramite ?tot)
    (MinimoEmpleadosActivos ?tipotramite ?min)
    ?a <- (ComprobacionMinEmpleados ?tipotramite ?val)
    (test (> ?min ?tot))
    (test (= ?val 0))
    =>
    (retract ?a)
    (assert (ComprobacionMinEmpleados ?tipotramite 1))
    (printout t "Hay menos de " ?min " trabajadores atendiento " ?tipotramite crlf)
    )

  (defrule TiempoTramiteExcedido
      (HoraActualizada ?hora)
      (TiempoInicialTramite ?tipotramite ?n ?t)
      (MaximoTiempoGestion ?tipotramite ?tmax)
      (test (> (- ?hora ?t) (* ?tmax 60)))
      (not (Comprobado ?tipotramite ?n))
      =>
      (assert (Comprobado ?tipotramite ?n))
      (printout t "El tramite " ?tipotramite ?n " ha excedido el tiempo maximo" crlf)
    )

;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; EJ3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule ComprobarTotalTramites
    ?a <- (TramitesEmpleado ?empl ?totalTramites)
    (Tarea ?empl ?tipotramite)
    (MinimoTramitesPorDia ?tipotramite ?minimo)
    (fin)
    (test (< ?totalTramites ?minimo))
    =>
    (printout t "El empleado " ?empl " ha atendido menos de " ?minimo " tramites. " crlf)
    )

  (defrule ResultadoEmpleados
    ?a <- (TramitesEmpleado ?empl ?totalTramites)
    ?b <- (TiempoTramitesEmpleado ?empl ?totalTiempo)
    (fin)
    =>
    (if (neq ?totalTramites 0)then
      (printout t "El empleado " ?empl " ha atendido " ?totalTramites crlf)
      (printout t "El empleado " ?empl " ha atendido durante: " ?totalTiempo crlf)
      (printout t "El empleado " ?empl " ha tardado en media: " (/ ?totalTiempo ?totalTramites ) crlf)

      (printout datosEmpl "El empleado " ?empl " ha atendido " ?totalTramites crlf)
      (printout datosEmpl "El empleado " ?empl " ha atendido durante: " ?totalTiempo crlf)
      (printout datosEmpl "El empleado " ?empl " ha tardado en media: " (/ ?totalTiempo ?totalTramites ) crlf)
    else
      (printout t "El empleado " ?empl " no ha realizado ningun tramite. "crlf )
      (printout datosEmpl "El empleado " ?empl " no ha realizado ningun tramite. "crlf )

    )
    (retract ?a ?b)
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
    (or (Sensor_puerta Pasillo) (Sensor_presencia Pasillo))
    ?a <- (Luz Pasillo OFF)
    ?b <- (NumeroPersonas Pasillo ?t)
    (HoraActualizada ?hora)
    =>
    (printout t "Encendemos la luz de: " Pasillo crlf)
    (retract ?a ?b)
    (assert (Luz Pasillo ON)
            (NumeroPersonas Pasillo (+ ?t 1))
            (HoraPuertaPasillo ?hora)))

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
    (printout t "Apagamos la luz del pasillo" crlf))

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
      (Empleado ?empl ?hab)
      (test (neq ?empl E1))
      (test (neq ?empl E2))
      ?a <- (Luz ?hab ON)
      ?b <- (NumeroPersonas ?hab ?t)
      (and (test (neq ?hab Pasillo)) (test (neq ?hab Gerencia)))
      =>
      (printout t "Apagamos la luz de: " ?hab  crlf)
      (retract ?a)
       (assert (Luz ?hab OFF)
               (NumeroPersonas ?hab 0))
      )
