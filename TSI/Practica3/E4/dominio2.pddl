(define (domain zeno-travel)

(:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :universal-preconditions
  :disjuntive-preconditions
  :conditional-effects
  :htn-expansion

  ; Requisitos adicionales para el manejo del tiempo
  :durative-actions
  :metatags
 )

(:types aircraft person city - object)
(:constants slow fast - object)
(:predicates (at ?x - (either person aircraft) ?c - city)
             (in ?p - person ?a - aircraft)
             (different ?x ?y) (igual ?x ?y)
             (hay-fuel-viaje-lento ?a ?c1 ?c2)
             (hay-fuel-viaje-rapido ?a ?c1 ?c2)
)

(:functions (fuel ?a - aircraft)
            (distance ?c1 - city ?c2 - city)
            (slow-speed ?a - aircraft)
            (fast-speed ?a - aircraft)
            (slow-burn ?a - aircraft)
            (fast-burn ?a - aircraft)
            (capacity ?a - aircraft)
            (refuel-rate ?a - aircraft)
            (total-fuel-used ?a - aircraft)
            (boarding-time)
            (debarking-time)
            (fuel-limit)
            (tope-pasajeros ?a - aircraft)
            (pasajeros ?a - aircraft)
            (destination ?p - person ?c - city)
)

; El consecuente "vacio" se representa como "()" y significa "siempre verdad"
(:derived
  (igual ?x ?x) ()
)

(:derived
  (different ?x ?y) (not (igual ?x ?y))
)

; este literal derivado se utiliza para deducir, a partir de la información en el estado actual,
; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1.
; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
; restricción más copleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
; los siguientes ejercicios).

(:derived
  ;Calculamos el fuel que se va a consumir usando consumo*distancia y comparamos si tenemos suficiente.

  (hay-fuel-viaje-lento ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a)))
)

(:derived
  ;Calculamos el fuel que se va a consumir usando consumo*distancia y comparamos si tenemos suficiente.

  (hay-fuel-viaje-rapido ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a)))
)

(:task transport-person
	:parameters (?p - person ?c - city)

	(:method Case1 ; si la persona est� en la ciudad no se hace nada
		:precondition (at ?p ?c)

		:tasks ()
	)

	(:method Case2 ;si no esta en la ciudad destino, pero avion y persona estan en la misma ciudad
		:precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c1 - city))

		:tasks ((embarcar)(mover-avion ?a ?c1 ?c)(desembarcar)
            )
	)

	(:method Case3;si no esta en la ciudad destino, avion y persona no estan en la misma ciudad
		:precondition (and (at ?p - person ?c1 - city)
                  (at ?a - aircraft ?c2 - city)
					        (different ?c1 - city ?c2 - city))

		:tasks ((mover-avion ?a ?c2 ?c1)(embarcar)(mover-avion ?a ?c1 ?c)(desembarcar))
	)
)

(:task mover-avion
	:parameters (?a - aircraft ?c1 - city ?c2 -city)
 ;;Hay fuel suficiente para volar de forma lenta y que no hayamos sobrepasado el limite de fuel gastado
  (:method fuel-suficiente-viaje-lento
		:precondition (and (hay-fuel-viaje-lento ?a ?c1 ?c2)
                  (< (total-fuel-used ?a) (fuel-limit)))

		:tasks ((fly ?a ?c1 ?c2))
	)

  (:method fuel-no-suficiente-viaje-lento
    :precondition (and (not (hay-fuel-viaje-lento ?a ?c1 ?c2))
                       (< (total-fuel-used ?a) (fuel-limit)))

    :tasks ((refuel ?a ?c1) (fly ?a ?c1 ?c2))
  )

	(:method fuel-suficiente-viaje-rapido
		:precondition (and (hay-fuel-viaje-rapido ?a ?c1 ?c2)
                  (< (total-fuel-used ?a) (fuel-limit)))
		:tasks ((zoom ?a ?c1 ?c2))
	)

	(:method fuel-no-suficiente-viaje-rapido
		:precondition (and (not (hay-fuel-viaje-rapido ?a ?c1 ?c2))
                       (< (total-fuel-used ?a) (fuel-limit)))

		:tasks ((refuel ?a ?c1) (zoom ?a ?c1 ?c2))
	)
)

(:task embarcar
	:parameters ()
	(:method embarca-pasajero
		:precondition (and  (at ?p ?c)
                        (at ?a ?c)
                        (> (tope-pasajeros ?a) (pasajeros ?a))
                        (not (destination ?p ?c))
                        )
		:tasks  ((board-passanger ?p ?a ?c) (embarcar)
		)
	)
	(:method fin-recurrencia
	:precondition():tasks()
	)
)


(:task desembarcar
	:parameters ()
	(:method desembarca-pasajero
		:precondition (and (in ?p ?a)
                       (at ?a ?c)
                  )
		:tasks  ((debark-passanger ?p ?a ?c)
            (desembarcar))
	)
	(:method fin-recurrencia
	:precondition()
  :tasks())
)
(:import "Primitivas-Zenotravel4.pddl")
)
