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
            (total-fuel-used)
            (boarding-time)
            (debarking-time)
            (fuel-limit)
            )

;; el consecuente "vac�o" se representa como "()" y significa "siempre verdad"
(:derived
  (igual ?x ?x) ())

(:derived
  (different ?x ?y) (not (igual ?x ?y)))



;; este literal derivado se utiliza para deducir, a partir de la información en el estado actual,
;; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1.
;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
;; restricción más copleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
;; los siguientes ejercicios).
(:derived
  ;Calculamos el fuel que se va a consumir usando consumo*distancia y comparamos si tenemos suficiente.
  (hay-fuel-viaje-lento ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) (* (slow-burn ?a) (distance ?c1 ?c2))))
(:derived
    ;Calculamos el fuel que se va a consumir usando consumo*distancia y comparamos si tenemos suficiente.
    (hay-fuel-viaje-rapido ?a - aircraft ?c1 - city ?c2 - city)
    (> (fuel ?a) (* (fast-burn ?a) (distance ?c1 ?c2))))

(:task transport-person
	:parameters (?p - person ?c - city)

  (:method Case1 ; si la persona est� en la ciudad no se hace nada
	 :precondition (at ?p ?c)
	 :tasks ()
   )


   (:method Case2 ;si no est� en la ciudad destino, pero avion y persona est�n en la misma ciudad
	  :precondition (and (at ?p - person ?c1 - city)
			                 (at ?a - aircraft ?c1 - city))

	  :tasks (
	  	      (board ?p ?a ?c1)
		        (mover-avion ?a ?c1 ?c)
		        (debark ?p ?a ?c )))

    (:method Case3 ;si no esta en la ciudad destino, avion y persona no estan en la misma ciudad
 	  :precondition (and (at ?p - person ?cP - city)
 			                 (at ?a - aircraft ?cA - city)
                       (different ?cP - city ?cA - city))

 	  :tasks (
            (mover-avion ?a ?cA ?cP)
 	  	      (board ?p ?a ?c1)
 		        (mover-avion ?a ?c1 ?c)
 		        (debark ?p ?a ?c )))
	)

(:task mover-avion
 :parameters (?a - aircraft ?c1 - city ?c2 -city)
 ;;Hay fuel suficiente para volar de forma lenta y que no hayamos sobrepasado el limite de fuel gastado
  (:method fuel-suficiente-viaje-lento
   :precondition (and (hay-fuel-viaje-lento ?a ?c1 ?c2) (< (total-fuel-used) (fuel-limit)))
   :tasks ((fly ?a ?c1 ?c2))
  )

  (:method fuel-no-suficiente-viaje-lento
   :precondition (and (not (hay-fuel-viaje-lento ?a ?c1 ?c2)) (< (total-fuel-used) (fuel-limit)))
   :tasks ((refuel ?a ?c1) (fly ?a ?c1 ?c2))
  )

  (:method fuel-suficiente-viaje-rapido
   :precondition (and (hay-fuel-viaje-rapido ?a ?c1 ?c2) (< (total-fuel-used) (fuel-limit)))
   :tasks ((fly ?a ?c1 ?c2))
  )

  (:method fuel-no-suficiente-viaje-rapido
   :precondition (and (not (hay-fuel-viaje-rapido ?a ?c1 ?c2)) (< (total-fuel-used) (fuel-limit)))
   :tasks ((refuel ?a ?c1) (fly ?a ?c1 ?c2))
  )
)

(:import "Primitivas-Zenotravel.pddl")


)
