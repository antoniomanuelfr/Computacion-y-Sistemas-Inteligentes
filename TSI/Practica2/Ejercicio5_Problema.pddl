(define (problem Problema3)

(:domain Practica2)

(:OBJECTS
    P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P20 P21 P22 P23 P24 P25 - Place
    PLAYER - Player
    OSCAR APPLE ROSE ALG GOLD BIKINI SHOE  - Object
    PRINCESS PRINCE WITCH PROF DICAPRIO - Character
    NORTH SOUTH EAST WEST - Compass
    FOREST WATER EDGE SAND STONE - Ground
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

  (= (Distance P1 P2) 1)
  (= (Distance P1 P14) 1)
  (= (Distance P1 P6) 1)
  (= (Distance P1 P20) 1)

  (=  (Distance P2 P1) 1)
  (= (Distance P2 P3) 1)
  (= (Distance P2 P22) 1)

  (= (Distance P3 P2) 1)
  (= (Distance P3 P4) 1)
  (= (Distance P3 P6) 1)

  (= (Distance P4 P3) 1)
  (= (Distance P4 P5) 1)

  (= (Distance P5 P4) 1)
  (= (Distance P5 P6) 1)

  (= (Distance P6 P5) 1)
  (= (Distance P6 P1) 1)
  (= (Distance P6 P3) 1)
  (= (Distance P6 P8) 1)

  (= (Distance P7 P8) 1)
  (= (Distance P7 P9) 1)

  (= (Distance P8 P6) 1)
  (= (Distance P8 P7) 1)
  (= (Distance P8 P6) 1)

  (= (Distance P9 P10) 1)
  (= (Distance P9 P7) 1)
  (= (Distance P9 P11) 1)

  (= (Distance P10 P9) 1)
  (= (Distance P10 P8) 1)

  (= (Distance P11 P9) 1)

  (= (Distance P12 P18) 1)
  (= (Distance P12 P13) 1)

  (= (Distance P13 P12) 1)
  (= (Distance P13 P14) 1)

  (= (Distance P14 P1) 1)
  (= (Distance P14 P13) 1)

  (= (Distance P15 P19) 1)
  (= (Distance P15 P20) 1)
  (= (Distance P15 P16) 1)

  (= (Distance P16 P17) 1)
  (= (Distance P16 P15) 1)

  (= (Distance P17 P16) 1)
  (= (Distance P17 P19) 1)
  (= (Distance P17 P18) 1)

  (= (Distance P18 P12) 1)
  (= (Distance P18 P17) 1)

  (= (Distance P19 P15) 1)
  (= (Distance P19 P17) 1)

  (= (Distance P20 P22) 1)
  (= (Distance P20 P21) 1)
  (= (Distance P20 P1) 1)
  (= (Distance P20 P15) 1)

  (= (Distance P21 P23) 1)
  (= (Distance P21 P2) 1)
  (= (Distance P21 P20) 1)

  (= (Distance P22 P24) 1)
  (= (Distance P22 P20) 1)
  (= (Distance P22 P23) 1)

  (= (Distance P23 P25) 1)
  (= (Distance P23 P21) 1)
  (= (Distance P23 P22) 1)

  (= (Distance P24 P22) 1)
  (= (Distance P24 P25) 1)

  (= (Distance P25 P23) 1)
  (= (Distance P25 P24) 1)

  (PlaceType P1 SAND)
  (PlaceType P2 SAND)
  (PlaceType P3 STONE)
  (PlaceType P4 SAND)
  (PlaceType P5 SAND)
  (PlaceType P6 STONE)
  (PlaceType P7 WATER)
  (PlaceType P8 WATER)
  (PlaceType P9 STONE)
  (PlaceType P10 WATER)
  (PlaceType P11 STONE)
  (PlaceType P12 FOREST)
  (PlaceType P13 FOREST)
  (PlaceType P14 STONE)
  (PlaceType P15 STONE)
  (PlaceType P16 FOREST)
  (PlaceType P17 FOREST)
  (PlaceType P18 FOREST)
  (PlaceType P19 FOREST)
  (PlaceType P20 SAND)
  (PlaceType P21 SAND)
  (PlaceType P22 STONE)
  (PlaceType P23 STONE)
  (PlaceType P24 EDGE)
  (PlaceType P25 EDGE)


  ; Objects
  (ObjectLoc GOLD P5)
  (ObjectLoc GOLD P22)
  (ObjectLoc GOLD P17)

  (ObjectLoc APPLE P4)
  (ObjectLoc APPLE P7)
  (ObjectLoc APPLE P8)

  (ObjectLoc ROSE P19)
  (ObjectLoc ROSE P19)
  (ObjectLoc ROSE P19)

  (ObjectLoc ALG P12)
  (ObjectLoc OSCAR P22)

  (ObjectLoc SHOE P7)
  (ObjectLoc BIKINI P20)

  (= (Puntuation DICAPRIO OSCAR) 10)
  (= (Puntuation DICAPRIO GOLD) 5)
  (= (Puntuation DICAPRIO APPLE) 3)
  (= (Puntuation DICAPRIO ROSE) 1)
  (= (Puntuation DICAPRIO ALG) 4)

  (= (Puntuation PRINCESS OSCAR) 5)
  (= (Puntuation PRINCESS GOLD) 4)
  (= (Puntuation PRINCESS APPLE) 1)
  (= (Puntuation PRINCESS ROSE) 10)
  (= (Puntuation PRINCESS ALG) 3)

  (= (Puntuation PRINCE OSCAR) 1)
  (= (Puntuation PRINCE GOLD) 10)
  (= (Puntuation PRINCE APPLE) 4)
  (= (Puntuation PRINCE ROSE) 3)
  (= (Puntuation PRINCE ALG) 5)

  (= (Puntuation PROF OSCAR) 3)
  (= (Puntuation PROF GOLD) 1)
  (= (Puntuation PROF APPLE) 5)
  (= (Puntuation PROF ROSE) 4)
  (= (Puntuation PROF ALG) 10)

  (= (Puntuation WITCH OSCAR) 4)
  (= (Puntuation WITCH GOLD) 3)
  (= (Puntuation WITCH APPLE) 10)
  (= (Puntuation WITCH ROSE) 5)
  (= (Puntuation WITCH ALG) 1)

  (CharacterLoc PRINCE P15)
  (CharacterLoc DICAPRIO P2)
  (CharacterLoc WITCH P23)
  (CharacterLoc PRINCESS P9)
  (CharacterLoc PROF P3)

  (GroundObject FOREST SHOE)
  (GroundObject WATER BIKINI)
  (NoNeedObject SAND)
  (NoNeedObject STONE)

  (PlayerLoc PLAYER P1)
  (Orientation NORTH)
  (HandEmpty)
  (BagEmpty)
  (= (Points) 0)
  (= (Cost) 0)
  (= (NumberObjects) 2)
  (= (ObjectsDelivered PRINCE) 0)
  (= (ObjectsDelivered PRINCESS) 0)
  (= (ObjectsDelivered PROF) 0)
  (= (ObjectsDelivered DICAPRIO) 0)
  (= (ObjectsDelivered WITCH) 0)
)

(:goal
    (and (>= (Points) 50)))
    (:metric minimize (Cost))
)
