
(define (domain Practica2)

  (:requirements
    :strips
    :typing
  )

  (:types
    Player
    Object
    Character
    Place
    Compass
    )

  (:predicates
    (PlayerLoc ?Plyr - Player ?Plc - Place)
    (ObjectLoc ?Obj - Object ?Plc - Place)
  )

  (:action action-name
    :parameters ()
    :precondition ()
    :effect ())

)

))
