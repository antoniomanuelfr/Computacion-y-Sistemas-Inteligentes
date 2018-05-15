(define (problem Problema1)

(:domain Practica2)

(:OBJECTS
    P1 P2 P3 P4 P5 P6 P7 P8 P9 - Place
    PLAYER - Player
    OSCAR MANZANA ROSA ALGORITMO ORO - Object
    PRINCESA PRINCIPE BRUJA PROFESOR LEONARDO - Character
    NORTH SOUTH EAST WEST - Compass
)

(:INIT
    ; Extremos
    (NeighborPlace P1 P2 EAST)
    (NeighborPlace P2 P1 WEST)
    (NeighborPlace P2 P3 EAST)
    (NeighborPlace P3 P2 WEST)

    (NeighborPlace P4 P5 EAST)
    (NeighborPlace P5 P4 WEST)
    (NeighborPlace P5 P6 EAST)
    (NeighborPlace P6 P5 WEST)

    (NeighborPlace P7 P8 EAST)
    (NeighborPlace P8 P7 WEST)
    (NeighborPlace P8 P9 EAST)
    (NeighborPlace P9 P8 WEST)

    (NeighborPlace P1 P4 SOUTH)
    (NeighborPlace P4 P1 NORTH)
    (NeighborPlace P4 P7 SOUTH)
    (NeighborPlace P7 P4 NORTH)

    (NeighborPlace P3 P6 SOUTH)
    (NeighborPlace P6 P3 NORTH)
    (NeighborPlace P6 P9 SOUTH)
    (NeighborPlace P9 P6 NORTH)

    (NeighborPlace P2 P5 SOUTH)
    (NeighborPlace P5 P2 NORTH)

    ; Objetos en el mapa
    (ObjectLoc ORO P4)
    (ObjectLoc OSCAR P5)
    (ObjectLoc MANZANA P6)
    (ObjectLoc ROSA P7)
    (ObjectLoc ALGORITMO P8)

    (CharacterLoc PRINCIPE P2)
    (CharacterLoc LEONARDO P3)
    (CharacterLoc BRUJA P9)
    (CharacterLoc PRINCESA P4)
    (CharacterLoc PROFESOR P8)

    (PlayerLoc PLAYER P7)
    (Orientation NORTH)
    (HandEmpty)
)

; El objetivo va a ser entregar los objetos a los personajes
(:goal
    (and (DeliveredObj LEONARDO OSCAR) (DeliveredObj PRINCESA ROSA) (DeliveredObj BRUJA MANZANA) (DeliveredObj PROFESOR ALGORITMO) (DeliveredObj PRINCIPE ORO)))
)
