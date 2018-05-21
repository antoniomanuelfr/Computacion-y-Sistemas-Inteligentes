
;;Funciones auxiliares para calcular el tiempo restante
(deffunction system-string (?arg)
   (bind ?arg (str-cat ?arg " > temp.txt"))
   (system ?arg)
   (open "temp.txt" temp "r")
   (bind ?rv (readline temp))
   (close temp)
   ?rv)
   
 (deffunction hora ()
   (bind ?rv (integer (string-to-field (sub-string 1 2  (system-string "time /t")))))
   ?rv)
   
(deffunction minutos ()
   (bind ?rv (integer (string-to-field (sub-string 4 5  (system-string "time /t")))))
   ?rv)
   
(deffunction mrest (?arg)
   (bind ?rv (+ (* (- (- ?arg 1) (hora)) 60) (- 60 (minutos))))
   ?rv)
;;Puesto que no se puede poner un bind en el LHS de la regla, he declarado
;;esta funcion para poder estimar el tiempo restante en completar toda 
;;la cola de usuarios
(deffunction calcula_tiempo (?totales ?atendidos ?t_medio ?h_cierre ?solicitud)
        (bind ?restantes (- ?atendidos ?totales))
        (bind ?tiempo_finalizacion (* ?restantes ?t_medio))
        (bind ?tiempo_restante (- (mrest ?h_cierre) ?tiempo_finalizacion))
        (if (< ?tiempo_restante ?t_medio) then
                (printout t "Lo sentimos, no tenemos tiempo de atenderle. Venga otro dia "crlf)
        )
        ?tiempo_restante)

;; Declaracion de templates
(deftemplate Habitacion
        (field id)
        )

(deftemplate Trabajador
        (field empl)
        (field hab)
        (field mesa)
        )

(deftemplate Usuario
        (field cola)
        (field tramite)
        (field hab)
        )

(deftemplate Puerta
        (field hab1)
        (field hab2)
        )

(deftemplate Tarea
        (field empl)
        (field tipo)
        (field estado)
        )

(deftemplate Cola
        (field Tipo)
        (field numero))

(deftemplate Horas
        (field inicio)
        (field fin)
        (field medio))

(deftemplate Atendidos
        (field tipo)
        (field numero))

(deftemplate Pasillo)

(deftemplate Solicitud
        (field Tipo)
        )

;; Declaracion de hechos iniciales
(deffacts Habitaciones
        (Habitacion
                (id Oficina_1)

        )
        (Habitacion
                (id Oficina_2)
        )
        (Habitacion
                (id Oficina_3)
        )
        (Habitacion
                (id Oficina_5)
        )
        (Habitacion
                (id Oficina_6)
        )
        (Habitacion 
                (id Recepcion)
        )
        (Habitacion 
                (id Servicio_hombres1)
        )
        (Habitacion 
                (id Servicio_hombres2)
        )
        (Habitacion 
                (id Servicio_hombres3)
        )
        (Habitacion 
                (id Servicio_mujeres1)
        )
        (Habitacion 
                (id Servicio_mujeres2)
        )
        (Habitacion 
                (id Servicio_mujeres3)
        )
        (Habitacion
                (id Gerencia)
        )

        (Habitacion 
                (id Papeleria)
        )
        )

(deffacts Empleados
        (Trabajador
                (empl 1)
                (hab Oficina_1)
                (mesa 1)
        )
        (Trabajador
                (empl 2)
                (hab Oficina_2)
                (mesa 1)
        )        
        (Trabajador
                (empl 3)
                (hab Oficina_3)
                (mesa 1)
        )        
        (Trabajador
                (empl 4)
                (hab Oficina_4)
                (mesa 1)
        )        
        (Trabajador
                (empl 5)
                (hab Oficina_5)
                (mesa 1)
        )        
        (Trabajador
                (empl 6)
                (hab Oficina_6)
                (mesa 1)
        )
        (Trabajador
                (empl 7)
                (hab Oficina_6)
                (mesa 2)
        )
        )

(deffacts Puertas

        (Puerta 
                (hab1 Oficina_1)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Oficina_2)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Oficina_3)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Oficina_4)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Oficina_5)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Oficina_6)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Recepcion)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Gerencia)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Papeleria)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 gerencia)
                (hab2 Pasillo)
        )

        (Puerta 
                (hab1 Servicio_mujeres1)
                (hab2 Pasillo)
        )
        
        (Puerta 
                (hab1 Servicio_mujeres2)
                (hab2 Pasillo)
        )
        
        (Puerta
                (hab1 Servicio_mujeres3)
                (hab2 Pasillo)
        )
        
        (Puerta 
                (hab1 Servicio_hombres1)
                (hab2 Pasillo)
        )
        
        (Puerta 
                (hab1 Servicio_hombres2)
                (hab2 Pasillo)
        )
        
        (Puerta 
                (hab1 Servicio_hombres3)
                (hab2 Pasillo)
        )
        )
;;Tarea tiene tres campos: Empleado que realiza la tarea, que tipo de tramite
;;y si esta ocupado (1) o libre (0)
(deffacts Tareas
        (Tarea 
                (empl 1)
                (tipo TG)
                (estado 0)
        )
        (Tarea
                (empl 2)
                (tipo TG)
                (estado 0)

        )
        (Tarea 
                (empl 3)
                (tipo TG)
                (estado 0)

        )
        (Tarea 
                (empl 4)
                (tipo TG)
                (estado 0)

        )
        (Tarea
                (empl 5)
                (tipo TG)
                (estado 0)

        )
        (Tarea
                (empl 6)
                (tipo TE)
                (estado 0)

        )
        (Tarea
                (empl 7)
                (tipo TE)
                (estado 0)

        )

        )

(deffacts Cola
        (Cola 
                (Tipo TG)
                (numero 0)
        )
        (Cola 
                (Tipo TE)
                (numero 0)
        )
        )

(deffacts Atendidos
        (Atendidos
                (tipo TG)
                (numero 0)
        )
        (Atendidos 
                (tipo TE)
                (numero 0))
)
(deffacts Horas
        (Horas
                (inicio 9)
                (fin 20)
                (medio 15)
        )
)
;;Reglas
;;Regla para cuando un empleado pulsa el boton indicando que esta libre. 
;;Se encarga de anotar que ese usuario ha sido atendido y de eliminarlo del
;;sistema.
(defrule empleado_libre
        ?i<-(Disponible ?empleado)
        ?ident<-(Tarea
                (empl ?empleado)
                (tipo ?tipo)
                (estado 1))
        (Trabajador
                (empl ?empleado)
                (hab ?habitacion))
        
        ?usuario<-(Usuario
                (hab ?habitacion))

        ?atendidos<-(Atendidos
                (tipo ?tipo)
                (numero ?n))
        =>
        (modify ?ident
                (estado 0))
        
        (bind ?inc (+ ?n 1))
        (modify ?atendidos
                (numero ?inc))

        (retract ?usuario)
        (retract ?i)
        (printout t "El empleado " ?empleado" esta libre. " crlf)
        (printout t "Se ha registrado el tramite anterior. "crlf)

)
;;Regla para cuando hay un empleado libre y un usuario dentro del sistema sin habitacion asignada(en la cola)
;;Tiene un salience mas alto, puesto que le doy mas importancia a que un usario que este en la cola se le asigne
;;una oficina
(defrule empleado_atiende
        (declare (salience 10)) 

        ?id_tarea<-(Tarea 
                (empl ?empleado)
                (tipo ?tipo)
                (estado 0))

        (Trabajador 
                (empl ?empleado)
                (hab ?habitacion)
                (mesa ?mesa))
        
        ?id_user<-(Usuario 
                (cola ?id)
                (tramite ?tipo)
                (hab no))

        => 
        (modify ?id_tarea
                (estado 1))
        (modify ?id_user
                (hab ?habitacion))

        (printout t "Usuario "?tipo"_"?id " pase a la habitacion: " ?habitacion " en la mesa: "?mesa crlf)
        )

;;Regla que procesa la llegada de una solicitud (ya sea TG o TE) y asigna un codigo al usuario en la cola
(defrule Solicitud
        ?sol<-(Solicitud 
                (Tipo ?Tramite))

        ?cola<-(Cola
                (Tipo ?Tramite)
                (numero ?n_cola))

        (Atendidos
                (tipo ?Tramite)
                (numero ?at))
        
        (Horas
                (inicio ?ini)
                (fin ?final)
                (medio ?t_medio))
        
        (test(> (calcula_tiempo ?n_cola ?at ?t_medio ?final ?sol) ?t_medio))


        =>
        (retract ?sol) 
        (bind ?n (+ ?n_cola 1))

        (assert (Usuario 
                (cola ?n)
                (tramite ?Tramite)
                (hab no)
                )
        )
        (modify ?cola
                (numero ?n))

        (retract ?sol)
        (printout t "Se le ha asignado el codigo: "?Tramite "_" ?n crlf)
        )
