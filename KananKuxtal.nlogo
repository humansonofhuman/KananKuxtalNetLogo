;;Pedro Pablo Romero Martinez 201500120
;;Mateo Morales Garcia 201500108
breed [KananKuxtal person]
breed [arbol tree]
breed [flecha bullet]
breed [langosta bug]
breed [warmk warmks]
breed [resto restos]

globals[
  ;;Radio con respecto al arbol en el cual no pueden aparecer enemigos
  warmkSuelto
  cantidadRestos
  cantidadEnemigos
  vidaArbol
  municionActual
]

arbol-own[integridad]
flecha-own[closest]
warmk-own[municion-generada closest]
langosta-own[atacking? tickOfChange]

to setup
  ;;limite de flechas que puede guardar el warmk
  set limiteFlechasWarmk 6
  set warmkSuelto false
end

to start
  clear-all
  clear-output
  setup
  resize-world -18 18 -18 18
  create-KananKuxtal 1[set color one-of[blue] setxy 0 -3 set heading 90 set shape "person"]
  create-arbol 1[set color one-of[green] setxy 0 0 set heading 90 set shape "tree" set size 4 set integridad integridadArbol]
  ask patches[if pxcor = 0 and pycor = -1 [set pcolor gray]]
  set cantidadEnemigos NumLangostas
  create-langosta cantidadEnemigos [set color one-of[red] set shape "bug" move-to one-of patches with [
    pxcor < (-1 * RadioProteccion) or pxcor > RadioProteccion and pycor < (-1 * RadioProteccion) or pycor > RadioProteccion
  ] face one-of arbol   set tickOfChange -1]

  set MunicionActual Municion
  set vidaArbol IntegridadArbol
  set WarmkRecolectando false
  show "Bienvenido a KananKuxtal"
  show "Presiona 'M' para empezar"
  reset-ticks
end

to gameLoop
  moveshoot
  moverInsecto
  move-warmk
  crearMunicion
  if vidaArbol <= 0
  [show "Game Over"
    show "Presiona 'P' para empezar otra partida"
    set vidaArbol 0
    stop]
  if cantidadEnemigos = 0
  [show "Felicidades has ganado"
    show "Presiona 'P' para empezar otra partida"
  stop]
  tick
end


to crearMunicion
  if ticks mod 1000000 = 0 [
    create-resto 1[
          set color one-of[green]
          set cantidadRestos cantidadRestos + 1
          set shape "flower"
          move-to one-of patches with [pxcor > (-1 * RadioProteccion) and pxcor < RadioProteccion and pycor > (-1 * RadioProteccion) and pycor < RadioProteccion and (pxcor != 0 and pycor != 0)]
    ]
  ]
end

to move-warmk
  ifelse WarmkRecolectando [
    moverWarmk
  ][
    retornarWarmk
  ]
end

to moverInsecto
  ask langosta[
    ifelse pxcor < 3 and pxcor > -3 and pycor < 3 and pycor > -3 [
      if tickOfChange = -1
      [ set tickOfChange ticks]
      herirArbol self
    ][
      face one-of arbol
      fd 0.00005
    ]
  ]
end

to herirArbol [insecto]
  if (ticks - [tickOfChange] of insecto) mod 10000 = 0
  [set vidaArbol vidaArbol - 1]
end

to moveleft
  ask KananKuxtal[
    if heading != 270 [
      set heading 270
    ]
    if xcor > -18 [
      if [pcolor] of patch-ahead 1 != gray
        [fd 1]
    ]
  ]
end
to moveright
  ask KananKuxtal[
    if heading != 90 [
      set heading 90
    ]
    if xcor < 18 [
      if [pcolor] of patch-ahead 1 != gray
        [fd 1]
    ]
  ]
end
to moveup
  ask KananKuxtal[
    if heading != 0 [
      set heading 0
    ]
    if ycor < 18 [
      if [pcolor] of  patch-ahead 1 != gray
        [fd 1]
    ]
  ]
end
to movedown
  ask KananKuxtal[
    if heading != 180 [
      set heading 180
    ]
    if ycor > -18 [
      if [pcolor] of  patch-ahead 1 != gray
        [fd 1]
    ]
  ]
end
to createshoot
  if municionActual > 0 and not WarmkRecolectando [
    create-flecha 1[set color one-of[red] set heading first ([heading] of KananKuxtal) setxy first ([(pxcor)] of KananKuxtal) first ([(pycor)] of KananKuxtal) set shape "arrow" ]
    set municionActual municionActual - 1
  ]
end
to moveshoot
  let cmurio false
  ;;Guardan la posicion de la langosta
  let x 0
  let y 0
  ask flecha[
    ;;closest es la langosta mas cercana a la flecha

    set closest min-one-of langosta [distance myself]
    ;;Verifica que exista una alguna langosta cercana
    if closest != nobody [
      set x ([pxcor] of closest)
      set y ([pycor] of closest)
      ;; si el valor absoluto de las coordenadas de la flecha y closest son iguales
      if pxcor = x and pycor = y [
        set cmurio true
        ;;la flecha muere y closest tambien
        ask closest [die]
        die
      ]
    ]
    ifelse pycor > -18 and pycor < 18 and pxcor > -18 and pxcor < 18 [
      fd 1
    ][
      die
    ]
  ]
  if cmurio [
  create-resto 1[
          set color one-of[green]
          setxy x y
          set cantidadRestos cantidadRestos + 1
          set cantidadEnemigos cantidadEnemigos - 1
          set shape "flower" ]
  ]
end
to lefttop
  ask KananKuxtal[set heading 315]
end
to righttop
  ask KananKuxtal[set heading 45]
end
to leftdown
  ask KananKuxtal[set heading 225]
end
to rightdown
  ask KananKuxtal[set heading 135]
end

;;WARMK-START
;;Se suelta al warmk para que consuma los restos y genere más munición
to soltarWarmk
  crearWarmk
  moverWarmk
end
to crearWarmk
  ;;Si se quiere ver en el futuro como seria el juego con mas de un warmk a la vez
  let maxNumWarmks 1
  if count warmk < maxNumWarmks [
    create-warmk 1[
      set color one-of[cyan]
      set heading first ([heading] of KananKuxtal) setxy first ([(pxcor)] of KananKuxtal) first ([(pycor)] of KananKuxtal) - 1
      set shape "pentagon"
      set municion-generada 0
    ]
    ifelse cantidadRestos > 0 [set WarmkRecolectando true] [set WarmkRecolectando false]
  ]
end
to moverWarmk
  ask warmk [
    ;;Se identifica el resto mas cercano
    set closest min-one-of resto [distance myself]
    ;;Se verifica que exita alguno
    ifelse closest != nobody and municion-generada < limiteFlechasWarmk [
      ;; si el valor de las coordenadas del warmk y el resto son iguales
      ifelse pxcor = ([pxcor] of closest) and pycor = ([pycor] of closest) [
        ;;con los restos genera mas municion
        set municion-generada municion-generada + 1
        show "municion obtenida"
        ;;el resto muere (desaparece)
        ask closest [die]
        set cantidadRestos cantidadRestos - 1
        if cantidadRestos = 0 [set WarmkRecolectando false]
      ][
        face closest
        fd 0.0005
      ]
    ][
      ;;Si el warmk no puede generar mas flechas regresa con el KK
      if municion-generada = limiteFlechasWarmk or not WarmkRecolectando [
        retornarWarmk
      ]
    ]
  ]

end
;;Regresa el Warmk con el KK
to retornarWarmk
  ask warmk [
    ;; si el valor de las coordenadas del warmk y de KK son iguales
    ifelse pxcor = first ([pxcor] of KananKuxtal) and pycor = first ([pycor] of KananKuxtal) [
      ;;entrega la municion obtenida
      show "antes"
      show municion
      set municionActual municionActual + municion-generada

      ;;el Warmk muere (se sube al KK)
      die
    ][
      face one-of KananKuxtal
      fd 0.0005
    ]
  ]
end
;;WARMK-END
@#$#@#$#@
GRAPHICS-WINDOW
210
10
699
500
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-18
18
-18
18
0
0
1
ticks
30.0

BUTTON
62
66
127
99
Iniciar
start
NIL
1
T
OBSERVER
NIL
P
NIL
NIL
1

BUTTON
983
151
1064
184
izquierda
moveleft
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
1075
151
1162
184
derecha
moveright
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
1040
111
1104
144
arriba
moveup
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
1040
189
1103
222
abajo
movedown
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
1030
263
1107
296
disparar
createshoot
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

BUTTON
976
69
1045
102
NIL
lefttop
NIL
1
T
OBSERVER
NIL
Y
NIL
NIL
1

BUTTON
1087
68
1166
102
NIL
righttop
NIL
1
T
OBSERVER
NIL
I
NIL
NIL
1

BUTTON
972
226
1042
259
NIL
leftdown
NIL
1
T
OBSERVER
NIL
N
NIL
NIL
1

BUTTON
1093
227
1169
260
NIL
rightdown
NIL
1
T
OBSERVER
NIL
M
NIL
NIL
1

INPUTBOX
85
245
177
305
integridadArbol
25.0
1
0
Number

SLIDER
17
415
189
448
RadioProteccion
RadioProteccion
1
17
11.0
1
1
NIL
HORIZONTAL

MONITOR
763
63
886
108
Vida Che U Ka Uxtal
vidaArbol
17
1
11

INPUTBOX
22
245
84
305
Municion
200.0
1
0
Number

BUTTON
41
123
150
156
NIL
gameLoop
T
1
T
OBSERVER
NIL
M
NIL
NIL
0

SWITCH
733
312
914
345
WarmkRecolectando
WarmkRecolectando
1
1
-1000

SLIDER
9
375
199
408
NumLangostas
NumLangostas
0
100
100.0
1
1
Langostas
HORIZONTAL

BUTTON
1009
314
1121
347
Soltar Warmk
crearWarmk
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

MONITOR
765
124
886
169
Cantidad de Restos
cantidadRestos
17
1
11

INPUTBOX
15
308
185
368
limiteFlechasWarmk
6.0
1
0
Number

MONITOR
765
186
885
231
Municion
municionActual
17
1
11

TEXTBOX
780
23
876
48
Monitores\n
20
26.0
1

TEXTBOX
1024
25
1112
50
Controles
20
26.0
1

TEXTBOX
59
208
142
233
Entradas
20
26.0
1

TEXTBOX
68
25
135
50
Jugar
20
26.0
1

MONITOR
767
246
887
291
Enemigos
cantidadEnemigos
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
