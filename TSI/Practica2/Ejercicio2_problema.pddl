(define (problem Problema2)

(:domain Practica2)

(:OBJECTS
    P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P20 P21 P22 P23 P24 P25 - Place
    PLAYER - Player
    OSCAR APPLE ROSA ALG GOLD - Obj
    PRINCESS PRINCIPE WITCH PROF DICAPRIO - Character
    NORTH SOUTH EAST WEST - Compass
)

(:INIT

    (NeighborPlace P1 P2 SOUTH)
    (NeighborPlace P1 P14 NORTH)
    (NeighborPlace P1 P6 WEST)
    (NeighborPlace P1 P20 EAST)

    (NeighborPlace P2 P1 NORTH)
    (NeighborPlace P2 P3 WEST)
    (NeighborPlace P2 P22 EAST)

    (NeighborPlace P3 P2 EAST)
    (NeighborPlace P3 P4 WEST)
    (NeighborPlace P3 P6 NORTH)

    (NeighborPlace P4 P3 EAST)
    (NeighborPlace P4 P5 NORTH)

    (NeighborPlace P5 P4 SOUTH)
    (NeighborPlace P5 P6 EAST)

    (NeighborPlace P6 P5 WEST)
    (NeighborPlace P6 P1 EAST)
    (NeighborPlace P6 P3 SOUTH)
    (NeighborPlace P6 P8 NORTH)

    (NeighborPlace P7 P8 EAST)
    (NeighborPlace P7 P9 NORTH)

    (NeighborPlace P8 P6 SOUTH)
    (NeighborPlace P8 P7 WEST)
    (NeighborPlace P8 P6 SOUTH)

    (NeighborPlace P9 P10 EAST)
    (NeighborPlace P9 P7 SOUTH)
    (NeighborPlace P9 P11 NORTH)

    (NeighborPlace P10 P9 WEST)
    (NeighborPlace P10 P8 SOUTH)

    (NeighborPlace P11 P9 SOUTH)

    (NeighborPlace P12 P18 EAST)
    (NeighborPlace P12 P13 SOUTH)

    (NeighborPlace P13 P12 NORTH)
    (NeighborPlace P13 P14 SOUTH)

    (NeighborPlace P14 P1 SOUTH)
    (NeighborPlace P14 P13 NORTH)

    (NeighborPlace P15 P19 EAST)
    (NeighborPlace P15 P20 SOUTH)
    (NeighborPlace P15 P16 NORTH)

    (NeighborPlace P16 P17 EAST)
    (NeighborPlace P16 P15 SOUTH)

    (NeighborPlace P17 P16 WEST)
    (NeighborPlace P17 P19 SOUTH)
    (NeighborPlace P17 P18 NORTH)

    (NeighborPlace P18 P12 WEST)
    (NeighborPlace P18 P17 SOUTH)

    (NeighborPlace P19 P15 WEST)
    (NeighborPlace P19 P17 NORTH)

    (NeighborPlace P20 P22 EAST)
    (NeighborPlace P20 P21 SOUTH)
    (NeighborPlace P20 P1 WEST)
    (NeighborPlace P20 P15 NORTH)

    (NeighborPlace P21 P23 EAST)
    (NeighborPlace P21 P2 WEST)
    (NeighborPlace P21 P20 NORTH)

    (NeighborPlace P22 P24 EAST)
    (NeighborPlace P22 P20 WEST)
    (NeighborPlace P22 P23 SOUTH)

    (NeighborPlace P23 P25 EAST)
    (NeighborPlace P23 P21 WEST)
    (NeighborPlace P23 P22 NORTH)

    (NeighborPlace P24 P22 WEST)
    (NeighborPlace P24 P25 SOUTH)

    (NeighborPlace P25 P23 WEST)
    (NeighborPlace P25 P24 NORTH)

    ;=(Distances

    (= (Distance P1 P2) 5)
    (= (Distance P1 P14) 5)
    (= (Distance P1 P6) 5)
    (= (Distance P1 P20) 5)

    (=  (Distance P2 P1) 5)
    (= (Distance P2 P3) 5)
    (= (Distance P2 P22) 5)

    (= (Distance P3 P2) 5)
    (= (Distance P3 P4) 5)
    (= (Distance P3 P6) 5)

    (= (Distance P4 P3) 5)
    (= (Distance P4 P5) 5)

    (= (Distance P5 P4) 5)
    (= (Distance P5 P6) 5)

    (= (Distance P6 P5) 5)
    (= (Distance P6 P1) 5)
    (= (Distance P6 P3) 5)
    (= (Distance P6 P8) 5)

    (= (Distance P7 P8) 5)
    (= (Distance P7 P9) 5)

    (= (Distance P8 P6) 5)
    (= (Distance P8 P7) 5)
    (= (Distance P8 P6) 5)

    (= (Distance P9 P10) 5)
    (= (Distance P9 P7) 5)
    (= (Distance P9 P11) 5)

    (= (Distance P10 P9) 5)
    (= (Distance P10 P8) 5)

    (= (Distance P11 P9) 5)

    (= (Distance P12 P18) 5)
    (= (Distance P12 P13) 5)

    (= (Distance P13 P12) 5)
    (= (Distance P13 P14) 5)

    (= (Distance P14 P1) 5)
    (= (Distance P14 P13) 5)

    (= (Distance P15 P19) 5)
    (= (Distance P15 P20) 5)
    (= (Distance P15 P16) 5)

    (= (Distance P16 P17) 5)
    (= (Distance P16 P15) 5)

    (= (Distance P17 P16) 5)
    (= (Distance P17 P19) 5)
    (= (Distance P17 P18) 5)

    (= (Distance P18 P12) 5)
    (= (Distance P18 P17) 5)

    (= (Distance P19 P15) 5)
    (= (Distance P19 P17) 5)

    (= (Distance P20 P22) 5)
    (= (Distance P20 P21) 5)
    (= (Distance P20 P1) 5)
    (= (Distance P20 P15) 5)

    (= (Distance P21 P23) 5)
    (= (Distance P21 P2) 5)
    (= (Distance P21 P20) 5)

    (= (Distance P22 P24) 5)
    (= (Distance P22 P20) 5)
    (= (Distance P22 P23) 5)

    (= (Distance P23 P25) 5)
    (= (Distance P23 P21) 5)
    (= (Distance P23 P22) 5)

    (= (Distance P24 P22) 5)
    (= (Distance P24 P25) 5)

    (= (Distance P25 P23) 5)
    (= (Distance P25 P24) 5)

    ; Objects
    (ObjectLoc GOLD P5)
    (ObjectLoc OSCAR P22)
    (ObjectLoc APPLE P4)
    (ObjectLoc ROSA P19)
    (ObjectLoc ALG P12)

    (CharacterLoc PRINCIPE P15)
    (CharacterLoc DICAPRIO P2)
    (CharacterLoc WITCH P23)
    (CharacterLoc PRINCESS P9)
    (CharacterLoc PROF P3)

    (PlayerLoc PLAYER P1)
    (Orientation NORTH)
    (HandEmpty)
    (= (Cost) 0)
)

; El objetivo va a ser entregar los objetos a los personajes
(:goal
    (and (DeliveredObj DICAPRIO OSCAR) (DeliveredObj PRINCESS ROSA) (DeliveredObj WITCH APPLE) (DeliveredObj PROF ALG) (DeliveredObj PRINCIPE GOLD)))
    (:metric minimize (Cost))
)
