{\rtf1\ansi\ansicpg1252\deff0\deflang3082{\fonttbl{\f0\fswiss\fcharset0 Arial;}}
{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20 (deffunction system-string (?arg)\par
   (bind ?arg (str-cat ?arg " > temp.txt"))\par
   (system ?arg)\par
   (open "temp.txt" temp "r")\par
   (bind ?rv (readline temp))\par
   (close temp)\par
   ?rv)\par
   \par
   (deffunction hora ()\par
   (bind ?rv (integer (string-to-field (sub-string 1 2  (system-string "time /t")))))\par
   ?rv)\par
   \par
   (deffunction minutos ()\par
   (bind ?rv (integer (string-to-field (sub-string 4 5  (system-string "time /t")))))\par
   ?rv)\par
   \par
   (deffunction mrest (?arg)\par
   (bind ?rv (+ (* (- (- ?arg 1) (hora)) 60) (- 60 (minutos))))\par
   ?rv)\par
   \par
}
  
