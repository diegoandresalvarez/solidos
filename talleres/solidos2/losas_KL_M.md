# Taller de vigas: modelado de una losa maciza utilizando software profesional. Teorías de Kirchhoff-Love y Mindlin.

# NOTA ESTO ES UN BORRADOR. FALTA DEFINIR CONDICIONES DE EVALUACION

Fecha de entrega: POR DEFINIR  a las 23:59. Por cada día de retraso se descontarán 0.3 unidades en la nota final.

La idea de este trabajo es modelar mediante un programa profesional dos losas:
1. La losa analizada en el archivo https://github.com/diegoandresalvarez/solidos/blob/master/archivos/losa_Kirchhoff_Love/ejemplo_losa_borde_libre.xlsm
2. La losa maciza que se encuentra en el archivo [proyecto_lucas.dwg](fig/proyecto_lucas.dwg) en particular se debe modelar la losa del piso 4.
<!--- (Nota: la vez pasada que enseñé sólidos 2 se modeló el piso 2).--->

Serán tres grupos de trabajo: cada uno con máximo cuatro integrantes (reportar los grupos en la WIKI). Los miembros de un mismo grupo no pueden utilizar programas de la misma casa. Por ejemplo en un mismo grupo no pueden estar quien maneja el SAP2000 y el ETABS, ya que ambos programas son de la casa Computers & Structures. En cada grupo debe haber al menos una persona que haya visto o que esté actualmente cursando la materia DISEÑO ESTRUCTURAL AVANZADO. Los estudiantes que ya hayan cursado Aplicaciones de Elementos Finitos deben estar en grupos separados. Solicitar al profesor que balancee los grupos en caso que queden grupos con muy pocos estudiantes.

## Trabajo individual
Se solicita realizar para cada losa:
* Explicar detalladamente como se modelaron las condiciones de frontera.
* Hacer el cálculo de los diagramas de momentos de flexión Mx y My y torsores Mxy al interior de la losa. 
* Hacer el cálculo de las fuerzas cortantes al interior de la losa.
* Hacer el cálculo de los momentos de flexión y torsión máximos y mínimos al interior de la losa con sus respectivas direcciones.
* Hacer el cálculo de las fuerzas cortantes máximas al interior de la losa con sus respectivas direcciones.
* Hacer el cálculo de los momentos de diseño Mx^* y My^*.
* Calcular las reacciones en los apoyos de la losa.
* Para el caso de la Losa 1, hacer un cálculo de los porcentajes de error relativos que se encuentra al comparar los resultados obtenidos con su software y con la solución obtenida utilizando MS EXCEL: https://github.com/diegoandresalvarez/solidos/blob/master/archivos/losa_Kirchhoff_Love/ejemplo_losa_borde_libre.xlsm para 10 puntos representativos de la losa (todos los compañeros del grupo deben escoger exactamente los mismos puntos). Adicionalmente, se deben hacer unos cortes en x=1.25m y y=1.5m donde se grafiquen todos los gráficos Mx, My, ..., Vx, Vy, M1, M2, etc.
* Para cada losa hacer dos videos de máximo 30 minutos cada uno:
  * VIDEO 1: en este video se debe explicar en detalle el modelado, análisis y diseño de cada losa utilizando el programa escogido; se mostrar aquí pantallazos con los resultados obtenidos.
  * VIDEO 2: en este video se deben explicar las presentar las capacidades del software para el análisis de losas. Se requiere un pantallazo de los reglones con las hipótesis, capacidades y limitaciones del programa, extraídas del manual del usuario.
* Hacer presentación de máximo 25 minutos, intentando convencer a los compañeros porqué su programa es el mejor del mercado (imagínense que ustedes son los representantes para Colombia del producto).

## Trabajo grupal análisis
Se solicita realizar para cada losa:
* Presentar un informe escrito que presente la comparación de los resultados del análisis estructural obtenidos por los miembros de cada grupo.
* Presentar una calificación general realizada a los programas, justificando en una tabla, los pro y los contra de cada software.
* Cada grupo debe utilizar las mismas suposiciones en el modelado, en caso que las deban hacer y deben justificar el porqué las hicieron.

## Trabajo grupal diseño
Se solicita realizar para cada losa:
* Hacer el diseño de la losa con los métodos aprendidos en la materia DISEÑO ESTRUCTURAL AVANZADO. A partir de los momentos de diseño, calcular el área de acero por metro que se requiere en la losa para el análisis tradicional y el análisis con los métodos vistos en clase.
* Realizar el despiece del refuerzo de la losa.
* Hacer la revisión de la resistencia a cortante de la losa.
* Aprender a manejar las funcionalidades de diseño de la losa con cada unos de los programas escogidos y comparar los resultados obtenidos con el método de diseño tradicional y el método de momentos de diseño equivalentes.
* Presentar un informe escrito que presente la comparación del diseño estructural: el método de diseño de losas tradicional vs. funcionalidades de diseño de losas de su programa de cálculo. Comparar en porcentajes.

Recuerden que la finalidad de los grupos de trabajo es que comparen los programas que utilizaron en cuanto a facilidad de uso, forma de entrar los datos, hipótesis que utilizan los programas, etc. Obviamente, deben comparar los resultados obtenidos. La idea es que si les dan resultados diferentes (que seguramente les darán), intenten explicar el porqué les dio diferente. No los pienso penalizar por resultados diferentes, siempre y cuando me muestren en el video que todo se modeló utilizando unas hipótesis correctas.

Espero que cada uno lea a fondo el manual del usuario del software. No se queden con los videos de YouTube. En el manual del usuario generalmente existe importante información sobre las hipótesis de modelado que hace cada software.

## Nota final
```
Nota final = 0.75*Trabajo_Individual_Análisis + 0.25*Trabajo_Grupal_Análisis + 0.35*Trabajo_Grupal_Diseño
```

NOTA: me encantaría si en la WIKI se especifican las suposiciones hechas y se hace “cooperación” o comunicación entre los grupos de trabajo de las suposiciones que tengan que hacer, de modo tal que todo el curso maneje los mismos parámetros en el modelado.
