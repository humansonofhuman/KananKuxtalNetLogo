# KananKuxtalNetLogo
A prototype of a game made with NetLogo

Proyect description in spanish:

El proyecto consiste en utilizar NetLogo para crear un videojuego, aprovechando los
conocimientos aprendidos durante el cuatrimestre en clase y por nuestra cuenta. El juego
consiste en que el jugador debe defender un árbol del ataque una plaga de insectos. 

Para defender al árbol el jugador dispone de una cantidad limitada de flechas, para obtener
más flechas debe soltar a una tortuga llamada Warmk que creará más munición con los
restos de las langostas, también con el paso del tiempo se crea munición en una zona
aleatoria cercana al árbol.

El mundo se ve desde una perspectiva aérea, y el jugador puede moverse con las
siguientes teclas:

- ‘w’ para ir hacia arriba
- ‘a’ para ir a la izquierda
- ‘s’ para ir hacia abajo
- ‘d’ para ir a la derecha

Se dispara con la tecla j
La dirección del disparo dependerá de la dirección del movimiento del jugador previo al
disparo. Si el jugador se mueve a la derecha la bala irá a la derecha, si se mueve a la
izquierda la bala irá a la izquierda, etc.

Al soltar al Warmk este recolectarán las municiones que están esparcidas por el mapa
resultado de la muerte de los enemigos o la munición aleatoria que aparece cada cierto
tiempo, si el warmk recolecta el máximo que esté en los datos de entrada regresará a el
jugador y le aumentará la munición. Si no hay restos disponibles para ser recogidos en el
terreno el warmk vuelve al jugador y le aumenta la munición dependiendo de la cantidad de
restos que haya recogido. Mientras el Warmk esté recolectando municion no se podrá
disparar. 

El árbol tiene un nivel de integridad inicial de 25 que puede ser modificado en los datos de
entrada, al llegar un insecto al árbol le hace daño cambia su estado a atacando y cada
10000 ticks realiza 1 de daño a la integridad del árbol.
Si la integridad del árbol llega a 0 aparece un mensaje de juego terminado y se detiene el
juego.

Si el jugador mata a todas los insectos, gana el juego. La cantidad de insectos puede ser
modificada desde un deslizador en el programa, la cantidad inicial es 11

Made by:

- [Mateo Morales Garcia](https://github.com/humansonofhuman)
- [Pedro Pablo Romero Martinez](https://github.com/KabutoYamato)

in the year 2018
