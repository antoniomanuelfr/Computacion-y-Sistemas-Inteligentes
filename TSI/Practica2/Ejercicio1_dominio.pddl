
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
    (PlayerLoc ?plyr - Player ?plc - Place)
    (ObjectLoc ?obj - Object ?plc - Place)
    (CharacterLoc ?chrctr - Character ?plc - Place)
    (Orientation ?comps - Compass)
    (NeighborPlace ?clace1 - Place ?place2 - Place ?orientation - Compass)
    (HasObject ?obj - Object)
    (DeliveredObj ?charctr - Character ?obj - Object)
  )

  (:action TURN_R
    :parameters (?plyr_or - Compass)
    :precondition (and(Orientation ?plyr_or))
    :effect
    (and
      (when (and (Orientation NORTH))
            (and (Orientation EAST) (not (Orientation NORTH)))
      )
      (when (and (Orientation EAST))
            (and (Orientation SOUTH) (not (Orientation EAST)))
      )
      (when (and (Orientation SOUTH))
            (and (Orientation WEST) (not (Orientation SOUTH)))
      )
      (when (and (Orientation WEST))
            (and (Orientation NORTH) (not (Orientation WEST)))
      )
    )
  )
  (:action TURN_L
    :parameters (?plyr_or - Compass)
    :precondition (and(Orientation ?plyr_or))
    :effect
    (and
      (when (and (Orientation NORTH))
            (and (Orientation WEST) (not (Orientation NORTH)))
      )
      (when (and (Orientation EAST))
            (and (Orientation NORTH) (not (Orientation EAST)))
      )
      (when (and (Orientation SOUTH))
            (and (Orientation EAST) (not (Orientation SOUTH)))
      )
      (when (and (Orientation WEST))
            (and (Orientation SOUTH) (not (Orientation WEST)))
      )
    )
  )
  (:action action-name
    :parameters (?x - object)
    :precondition (and ())
    :effect (and ())
  )

)
