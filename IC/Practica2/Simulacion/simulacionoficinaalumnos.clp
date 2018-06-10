(defglobal ?*nksg* = 0)  
(defglobal ?*nksh* = 0) 


  (deffacts ar24io
  (UUh0II UUhoIIIk Pasillo)
  (UUh0II UUhoIIIk Oficina1)
  (UUh0II UUhoIIIk Oficina2)
  (UUh0II UUhoIIIk Oficina3)
  (UUh0II UUhoIIIk Oficina4)
  (UUh0II UUhoIIIk Oficina5)
  (UUh0II UUhoIIIk Gerencia)
  (UUh0II UUhoIIIk OficinaDoble)
  (UUh0II UUhoIIIk Papeleria)
  (UUh0II UUh1kI Pasillo)
  (UUh0II UUh1kI AseoHombres)
  (UUh0II UUh1kI AseoMujeres)
  )

  (deffacts ar25io
  (UUh0II ER4 G1 Oficina1)
  (UUh0II ER4 G2 Oficina2)
  (UUh0II ER4 G3 Oficina3)
  (UUh0II ER4 G4 Oficina4)
  (UUh0II ER4 G5 Oficina5)
  (UUh0II ER4 E1 OficinaDoble)
  (UUh0II ER4 E2 OficinaDoble)
  (UUh0II ER4 Recepcionista Recepcion)
  (UUh0II ER4 Director Gerencia)
  )

(defrule cargardatosasimular
=>
(load-facts DatosSimulados.txt) 
)



(defrule x235
(declare (salience 8000))
?f <- (NuevoUsuario ?tipo ?h ?m ?s)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
(test (<= (totalsegundos ?h ?m ?s) (totalsegundos ?h1 ?m1 ?s1)))
(not (Solicitud ?))
=> 
(assert (Solicitud ?tipo))
(printout t "------------------> " ?*hora* ":" ?*minutos* ":" ?*segundos* " SOLICITUD " ?tipo crlf)
(if (eq ?tipo TE) 
   then 
     (bind ?*nksh* (+ ?*nksh* 1))
     (assert (URJ22 TE ?*nksh*))   
   else 
     (bind ?*nksg* (+ ?*nksg* 1))
     (assert (URJ22 TG ?*nksg*)))
(retract ?f)
)

(defrule ddyt67
(declare (salience 8000))
?f <- (BotonDisponible ?ed4 ?h ?m ?s)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
(test (<= (totalsegundos ?h ?m ?s) (totalsegundos ?h1 ?m1 ?s1)))
=> 
(assert (Disponible ?ed4))
(printout t "-----------------> " ?*hora* ":" ?*minutos* ":" ?*segundos* " DISPONIBLE " ?ed4 crlf)
(retract ?f)
)

(defrule kjl998
(declare (salience 8000))
?f <- (URJ23 ?ed4 ?ah67u)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
(test (<= ?ah67u (totalsegundos ?h1 ?m1 ?s1)))
=> 
(assert (Ficha ?ed4))
(printout t "-----------------> " ?*hora* ":" ?*minutos* ":" ?*segundos* " FICHA " ?ed4 crlf)
(retract ?f)
)



(defrule rrrrbv
(declare (salience 10000))
?f <- (URJ3 ?URJ4 ?URJ5 ?ah67u)
(hora_actual ?h)
(minutos_actual ?m)
(segundos_actual ?s)
(test (<=  ?ah67u (totalsegundos ?h ?m ?s)))
(URJ6 ?URJ4 Recepcion)
=>
(bind ?a (+ ?ah67u (random 1 3)))
(bind ?b (+ ?a (random 1 2)))
(bind ?c (+ ?b (random 1 3)))
(bind ?d (+ ?c (random 1 2)))
(assert (URJ7 Pasillo ?a))
(assert (URJ8 ?URJ4 Pasillo ?b))
(assert (URJ7 ?URJ5 ?c))
(assert (URJ8 ?URJ4 ?URJ5 ?c))
(retract ?f)
)

(defrule hp34v5
(declare (salience 10000))
?f <- (URJ3 ?URJ4 ?URJ5 ?ah67u)
(hora_actual ?h)
(minutos_actual ?m)
(segundos_actual ?s)
(test (<=  ?ah67u (totalsegundos ?h ?m ?s)))
(URJ6 ?URJ4 ?x)
(test (neq ?x Recepcion))
=>
(bind ?a (+ ?ah67u (random 1 3)))
(bind ?b (+ ?a (random 1 2)))
(bind ?c (+ ?b (random 1 3)))
(bind ?d (+ ?c (random 1 2)))
(assert (URJ9 ?x ?a))
(assert (URJ8 ?URJ4 Pasillo ?b))
(assert (URJ7 ?URJ5 ?c))
(assert (URJ8 ?URJ4 ?URJ5 ?c))
(retract ?f)
)

(defrule pzxd3
(declare (salience 10000))
?f <- (Se_desplaza ?URJ4 ?URJ5 ?h ?m ?s)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
(test (<= (totalsegundos ?h1 ?m1 ?s1) (totalsegundos ?h1 ?m1 ?s1)))
=>
(assert (URJ3 ?URJ4 ?URJ5 (totalsegundos ?h ?m ?s)))
(retract ?f)
)


(defrule rmbb
(declare (salience 10000))
?f <- (URJ11 ?URJ4 ?URJ5 ?ah67u)
(hora_actual ?h)
(minutos_actual ?m)
(segundos_actual ?s)
(test (<=  ?ah67u (totalsegundos ?h ?m ?s)))
=> 
(bind ?a (+ ?ah67u (random 1 3)))
(bind ?b (+ ?a (random 1 2)))
(bind ?c (+ ?b (random 1 3)))
(bind ?d (+ ?c (random 1 3)))
(bind ?e (+ ?d (random 1 3)))
(assert (URJ9 ?URJ5 ?a))
(assert (URJ8 ?URJ4 Pasillo  ?b))
(assert (URJ9 Pasillo ?c))
(assert (URJ8 ?URJ4 Recepcion ?d))
(assert (URJ8 ?URJ4 Fuera ?e))
(retract ?f)
)

(defrule ekm4p
(declare (salience 10000))
?f <- (URJ12 ?ed4 ?URJ5 ?ah67u)
(hora_actual ?h)
(minutos_actual ?m)
(segundos_actual ?s)
(test (<=  ?ah67u (totalsegundos ?h ?m ?s)))
=> 
(bind ?a (+ ?ah67u (random 1 3)))
(bind ?b (+ ?a (random 1 2)))
(bind ?c (+ ?b (random 1 3)))
(bind ?d (+ ?c (random 1 3)))
(bind ?e (+ ?d (random 1 3)))
(assert (URJ9 ?URJ5 ?a))
(assert (URJ8 ?ed4 Pasillo  ?b))
(assert (URJ9 Pasillo ?c))
(assert (URJ8 ?ed4 Recepcion ?d))
(assert (URJ23 ?ed4 ?d))
(assert (URJ8 ?ed4 Fuera ?e))
(retract ?f)
)



(defrule p4km
(declare (salience 10000))
?f <- (llega ?ed4 ?h ?m ?s)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
(test (<= (totalsegundos ?h ?m ?s) (totalsegundos ?h1 ?m1 ?s1)))
(UUh0II ER4 ?ed4 ?URJ14)
=> 
(assert (URJ6 ?ed4 Recepcion))
(assert (URJ23 ?ed4 (totalsegundos ?h1 ?m1 ?s1)))
(assert (URJ3 ?ed4 ?URJ14 (totalsegundos ?h1 ?m1 ?s1)))
(retract ?f)
)

(defrule rrrrrr
(declare (salience 9999))
?f <- (seva ?ed4 ?h ?m ?s)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
(test (<= (totalsegundos ?h ?m ?s) (totalsegundos ?h1 ?m1 ?s1)))
(UUh0II ER4 ?ed4 ?URJ14)
=> 
(assert (URJ12 ?ed4 ?URJ14 (totalsegundos ?h1 ?m1 ?s1)))
(retract ?f)
)

(defrule rrrrrr2
(declare (salience 10000))
(seva ?ed4 ?h ?m ?s)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
(test (<= (totalsegundos ?h ?m ?s) (totalsegundos ?h1 ?m1 ?s1)))
(UUh0II ER4 ?ed4 ?URJ14)
(URJ6 ?x ?URJ14)
(Asignado ?ed4 ?tipotramite ?n) 
(test (eq ?x (str-cat "usuario_" ?tipotramite ?n)))
=> 
(assert (URJ20 ?x ?URJ14))
)

(defrule u8956
(declare (salience 10000))
(URJ22 ?tipotramite ?n)
=> 
(assert (URJ6 (str-cat "usuario_" ?tipotramite ?n)  Recepcion))
)


(defrule Mkjo
(declare (salience 10000))
(Asignado ?ed4 ?tipotramite ?n) 
(UUh0II ER4 ?ed4 ?URJ14)
=>
(assert (URJ21  (str-cat "usuario_" ?tipotramite ?n) ?URJ14))
)

(defrule opkobk
(declare (salience 10000))
?f <- (URJ21  ?URJ4 ?URJ14)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
=>
(assert (URJ3 ?URJ4 ?URJ14 (+ (random 0 6) (totalsegundos ?h1 ?m1 ?s1))))
(retract ?f)
)
 
(defrule llllls5
(declare (salience 10000))
(Tramitado ?ed4 ?tipotramite ?n) 
(UUh0II ER4 ?ed4 ?URJ14)
=>
(assert (URJ20  (str-cat "usuario_" ?tipotramite ?n) ?URJ14))
)

(defrule lls56l
(declare (salience 10000))
?f <- (URJ20  ?URJ4 ?URJ14)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
=>
(assert (URJ11 ?URJ4 ?URJ14 (+ (random 0 3) (totalsegundos ?h1 ?m1 ?s1))))
(retract ?f)
)

(defrule ty9045
(declare (salience 9900))
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
?g <- (URJ8 ?x ?URJ5  ?n)
(test (<= ?n (totalsegundos ?h1 ?m1 ?s1)))
?f <- (URJ6 ?x ?URJ52)
(test (neq ?URJ5 ?URJ52))
=> 
(retract ?f ?g)
(assert (URJ6 ?x ?URJ5))
)


(defrule ds690p
(declare (salience 8000))
(UUh0II UUh1kI ?URJ5)
(URJ6 ?x ?URJ5)
=>
(assert (Sensor_presencia ?URJ5))
(printout t "-----------------> " ?*hora* ":" ?*minutos* ":" ?*segundos* "  SENSOR PRESENCIA " ?URJ5 crlf)
)

(defrule sa32p
(declare (salience 8000))
?f <- (Sensor_presencia ?URJ5)
(not (URJ6 ?x ?URJ5))
=>
(retract ?f)
)

(defrule dd7spe
(declare (salience 8000))
(UUh0II UUhoIIIk ?URJ5)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
?f <- (URJ7 ?URJ5 ?ah67u)
(test (<= ?ah67u (totalsegundos ?h1 ?m1 ?s1)))
=>
(assert (Sensor_puerta ?URJ5))
(printout t "-----------------> " ?*hora* ":" ?*minutos* ":" ?*segundos* " SENSOR PUERTA " ?URJ5 crlf)
(assert (URJ13 (+ (totalsegundos ?h1 ?m1 ?s1) 1)))
(retract ?f)
)

(defrule ddfss
(declare (salience 8000))
(UUh0II UUhoIIIk ?URJ5)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
?f <- (URJ9 ?URJ5 ?ah67u)
(test (<= ?ah67u (totalsegundos ?h1 ?m1 ?s1)))
=>
(assert (Sensor_puerta ?URJ5))
(printout t "-----------------> " ?*hora* ":" ?*minutos* ":" ?*segundos* " SENSOR PUERTA " ?URJ5 crlf)
(assert (URJ13 (+ (totalsegundos ?h1 ?m1 ?s1) 1)))
(retract ?f)
)

(defrule rmmmps1
(declare (salience 8000))
?f <- (Sensor_puerta ?URJ5)
(hora_actual ?h1)
(minutos_actual ?m1)
(segundos_actual ?s1)
?g <- (URJ13 ?ah67u)
(test (<= ?ah67u (totalsegundos ?h1 ?m1 ?s1)))
=>
(retract ?f ?g)
)


