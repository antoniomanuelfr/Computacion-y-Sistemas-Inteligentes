
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
    (Points)
    (PlayerPoints ?plye - Player)
    (Puntuation ?chrctr - Character ?obj - Obj)
    (NumberObjects)
    (ObjectsDelivered ?chrctr - Character)

)

  (:predicates
    (PlayerLoc ?plyr - Player ?plc - Place)
    (ObjectLoc ?obj - Obj ?plc - Place)
    (CharacterLoc ?chrctr - Character ?plc - Place)
    (Orientation ?plyr - Player ?comps - Compass)
    (NeighborPlace ?place1 - Place ?place2 - Place ?orientation - Compass)
    (HandObject ?plyr - Player ?obj - Obj)
    (DeliveredObj ?charctr - Character ?obj - Obj)
    (PlaceType ?place - Place ?type - Ground)
    (SavedObject ?plyr - Player ?obj - Obj)
    (GroundObject ?type - Ground ?obj - Obj)
    (NoNeedObject ?type - Ground)
    (BagEmpty ?plyr - Player )
    (HandEmpty ?plyr - Player )

  )

  (:action TURN_R
    :parameters (?plyr_or - Compass ?plyr - Player )
    :precondition (and(Orientation ?plyr ?plyr_or))
    :effect
    (and
      (when (and (Orientation ?plyr NORTH))
            (and (Orientation ?plyr  EAST) (not (Orientation ?plyr NORTH)))
      )
      (when (and (Orientation ?plyr EAST))
            (and (Orientation ?plyr SOUTH) (not (Orientation ?plyr EAST)))
      )
      (when (and (Orientation ?plyr SOUTH))
            (and (Orientation ?plyr WEST) (not (Orientation ?plyr SOUTH)))
      )
      (when (and (Orientation ?plyr WEST))
            (and (Orientation ?plyr NORTH) (not (Orientation ?plyr WEST)))
      )
    )
  )

  (:action TURN_L
    :parameters (?plyr - Player ?plyr_or - Compass)
    :precondition (and(Orientation ?plyr ?plyr_or))
    :effect
    (and
      (when (and (Orientation ?plyr NORTH))
            (and (Orientation ?plyr WEST) (not (Orientation ?plyr NORTH)))
      )
      (when (and (Orientation ?plyr EAST))
            (and (Orientation ?plyr NORTH) (not (Orientation ?plyr EAST)))
      )
      (when (and (Orientation ?plyr SOUTH))
            (and (Orientation ?plyr EAST) (not (Orientation ?plyr SOUTH)))
      )
      (when (and (Orientation ?plyr WEST))
            (and (Orientation ?plyr SOUTH) (not (Orientation ?plyr WEST)))
      )
    )
  )

  (:action MOVE
    :parameters (?plyr - Player ?p1 - Place ?p2 - Place ?plyr_or - Compass ?Ground - Ground ?obj - Obj )
    :precondition (and (PlayerLoc ?plyr ?p1) (not (PlayerLoc ?plyr ?p2)) (NeighborPlace ?p1 ?p2 ?plyr_or) (Orientation ?plyr ?plyr_or) (PlaceType ?p2 ?Ground)
                    (or (NoNeedObject ?Ground) (and (or (HandObject ?plyr ?obj) (SavedObject ?plyr ?obj)) (GroundObject ?Ground ?obj)  ))
                  )
    :effect (and (PlayerLoc ?plyr ?p2) (not (PlayerLoc ?plyr ?p1)) (increase (Cost) (Distance ?p1 ?p2)))
  )

  (:action PICK_UP
    :parameters (?plyr - Player ?loc - Place ?obj - Obj)
    :precondition (and (PlayerLoc ?plyr ?loc) (ObjectLoc ?obj ?loc) (HandEmpty ?plyr) )
    :effect (and (not (ObjectLoc ?obj ?loc)) (not (HandEmpty ?plyr)) (HandObject ?plyr ?obj) )
  )


  (:action DROP
    :parameters (?plyr - Player ?loc - Place ?obj - Obj)
    :precondition (and (PlayerLoc ?plyr ?loc) (HandObject ?plyr ?obj))
    :effect (and (not (HandObject ?plyr ?obj)) (ObjectLoc ?obj ?loc) (HandEmpty ?plyr))
  )

  (:action GIVE
    :parameters (?plyr - Player  ?chrctr - Character ?loc - Place ?obj - Obj)
    :precondition (and (PlayerLoc ?plyr ?loc) (CharacterLoc ?chrctr ?loc) (HandObject ?plyr ?obj)(< (ObjectsDelivered ?chrctr) (NumberObjects)))
    :effect (and (not (HandObject ?plyr ?obj)) (HandEmpty ?plyr) (DeliveredObj ?chrctr ?obj) (increase (Points) (Puntuation ?chrctr ?obj)) (increase (ObjectsDelivered ?chrctr) 1)
      (increase (PlayerPoints ?plyr) 1)
    )
  )


  (:action POP
    :parameters (?plyr - Player ?obj - Obj)
    :precondition (and (SavedObject ?plyr ?obj) (HandEmpty ?plyr))
    :effect (and (not (SavedObject ?plyr ?obj)) (not (HandEmpty ?plyr)) (HandObject ?plyr ?obj) (BagEmpty ?plyr))
  )

  (:action PUSH
    :parameters (?plyr - Player ?obj - Obj)
    :precondition (and (BagEmpty ?plyr) (HandObject ?plyr ?obj))
    :effect (and (not (HandObject ?plyr ?obj)) (not (BagEmpty ?plyr)) (SavedObject ?plyr ?obj) (HandEmpty ?plyr))
  )
)
