
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
    Distance
    Ground
    )

    (:functions
    (Cost)
    (Distance ?Place1 ?Place2 - Place)
)

  (:predicates
    (PlayerLoc ?plyr - Player ?plc - Place)
    (ObjectLoc ?obj - Object ?plc - Place)
    (CharacterLoc ?chrctr - Character ?plc - Place)
    (Orientation ?comps - Compass)
    (NeighborPlace ?place1 - Place ?place2 - Place ?orientation - Compass)
    (HasObject ?obj - Object)
    (DeliveredObj ?charctr - Character ?obj - Object)
    (PlaceType ?place - Place ?type - Ground)
    (SavedObject ?obj - Object)
    (BagEmpty)
    (HandEmpty)

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

  (:action MOVE
    :parameters (?plyr - Player ?p1 - Place ?p2 - Place ?plyr_or - Compass )
    :precondition (and (PlayerLoc ?plyr ?p1) (not (PlayerLoc ?plyr ?p2)) (NeighborPlace ?p1 ?p2 ?plyr_or) (Orientation ?plyr_or))
    :effect (and (PlayerLoc ?plyr ?p2) (not (PlayerLoc ?plyr ?p1)) (increase (Cost) (Distance ?p1 ?p2)))
  )

  (:action PICK_UP
    :parameters (?plyr - Player ?loc - Place ?obj - Object)
    :precondition (and (PlayerLoc ?plyr ?loc) (ObjectLoc ?obj ?loc) (HandEmpty))
    :effect (and (not (ObjectLoc ?obj ?loc)) (not (HandEmpty)) (HasObject ?obj) )
  )


  (:action DROP
    :parameters (?plyr - Player ?loc - Place ?obj - Object)
    :precondition (and (PlayerLoc ?plyr ?loc) (HasObject ?obj))
    :effect (and (not (HasObject ?obj)) (ObjectLoc ?obj ?loc) (HandEmpty))
  )

  (:action GIVE
    :parameters (?plyr - Player  ?chrctr - Character ?loc - Place ?obj - Object)
    :precondition (and (PlayerLoc ?plyr ?loc) (CharacterLoc ?chrctr ?loc) (HasObject ?obj))
    :effect (and (not (HasObject ?obj)) (HandEmpty) (DeliveredObj ?chrctr ?obj))
  )


  (:action POP
    :parameters (?obj - Object)
    :precondition (and (SavedObject ?obj) (HandEmpty))
    :effect (and (not (SavedObject ?obj)) (not (HandEmpty)) (HasObject ?obj) (BagEmpty))
  )

  (:action PUSH
    :parameters (?obj - Object)
    :precondition (and (BagEmpty) (HasObject ?obj))
    :effect (and (not (HasObject ?obj)) (not (BagEmpty)) (SavedObject ?obj) (HandEmpty))
  )
)
