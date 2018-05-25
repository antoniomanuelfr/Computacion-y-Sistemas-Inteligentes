
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
  (EmpleadosFichados TG 0)                   ;;; Inicialmente hay 0 empleados en las oficinas
  (EmpleadosFichados TE 0)
  (Ejecutar)
  (TiempoTramite TG 0)
  (TiempoTramite TE 0)
  (NoFichado Director)
  (NoFichado G1)
  (NoFichado G2)
  (NoFichado G3)
  (NoFichado G4)
  (NoFichado G5)
  (NoFichado E1)
  (NoFichado E2)
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
  (Empleado ?empl ?ofic)
  (Tarea ?empl ?tipotramite)
  (Usuarios ?tipotramite ?total)
  (HoraActualizada ?t)
  (test (< ?atendidos ?total))
  =>
  (bind ?a (+ ?atendidos 1))
  (assert (Asignado ?empl ?tipotramite ?a)
          (UltimoUsuarioAtendido ?tipotramite ?a)
          (TiempoInicialTramite ?tipotramite ?a ?t))
  (printout t "Usuaro " ?tipotramite ?a ", por favor pase a " ?ofic crlf)
  (retract ?f ?g)
  )

  (defrule RegistrarCaso
  (declare (salience 10))
  (Disponible ?empl)
  ?f <- (Asignado ?empl ?tipotramite ?n)
  ?g <- (TiempoInicialTramite ?tipotramite ?n ?tinicialTramite)
  ?v <- (TiempoInicialUsuario ?tipotramite ?n ?tinicialCola)
  ?z <- (NoComprobado ?tipotramite ?n)
  (HoraActualizada ?t)
  =>
  (bind ?tTramite (- ?t ?tinicialTramite) )
  (bind ?tEspera (- ?tinicialTramite ?tinicialCola) )

  (assert (Tramitado ?empl ?tipotramite ?n))
  (retract ?f ?g ?v ?z)

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
    (Ficha ?empl)
    (HoraActualizada ?hora)
    ?b <- (NoFichado ?empl)

    =>
    (assert (HoraFicha ?empl ?hora))
    (printout t "Ha fichado el empleado: " ?empl crlf)
    (retract ?b)

    )

  (defrule ComienzaTrabajar
    ?b <- (Ficha ?empl)
    (Tarea ?empl ?tipotramite)
    (Disponible ?empl)
    ?a <- (EmpleadosFichados ?tipotramite ?totalFichados)
    =>
    (assert (EmpleadosFichados ?tipotramite (+ ?totalFichados 1)))
    (retract ?a ?b)
    (printout t "Hay " (+ ?totalFichados 1) " empleados atendiendo " ?tipotramite crlf)
    )

  (defrule EmpleadoSeVa
    ?b <-(SeVa ?empl)
    (Tarea ?empl ?tipotramite)
    ?a <- (EmpleadosFichados ?tipotramite ?totalFichados)
    =>
    (assert (EmpleadosFichados ?tipotramite (- ?totalFichados 1)))
    (printout t "El empleado " ?empl " se va" crlf)
    (retract ?a ?b)
    )

  (defrule Libres
    (declare (salience 10))
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
        (test (> ?hora 0))
        (test (> (- ?hora ?t) (* ?tmax 60)))
        =>
        (printout t "El empleado " ?empleado " ha excedido el tiempo maximo de retraso" crlf)
        (assert (HoraFicha ?empleado -1))
        (retract ?a)
      )
