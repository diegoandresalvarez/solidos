# Taller de losas: modelado de losas macizas utilizando software profesional. Teorías de Kirchhoff-Love y Mindlin.

Con el objeto de contrastar la teoría aprendida y la práctica mediante el uso de un software profesional de análisis estructural, se requiere hacer el análisis de los desplazamientos, diagramas de momentos flectores y de torsión, de fuerza cortante en una losa maciza, utilizando las teorías de Kirchhoff-Love y de Mindlin. Se espera que el estudiante explore, comente, discuta los conceptos aprendidos en clase, los conceptos nuevos vistos en el software y que propongan soluciones a los problemas propuestos.

Fecha de entrega: se especificará en GOOGLE CLASSROOM. Por cada minuto de retraso se descontará 1 decima de la nota final.

Hay una parte del trabajo que se debe realizar individualmente y otra que debe hacerse grupalmente.

## El problema propuesto
La idea de este trabajo es modelar mediante un programa profesional dos losas:
1. La losa analizada en el archivo https://github.com/diegoandresalvarez/solidos/blob/master/archivos/losa_Kirchhoff_Love/ejemplo_losa_borde_libre.xlsm
2. La losa maciza que se encuentra en el archivo [proyecto_lucas.dwg](figs/proyecto_lucas.dwg) en particular se debe modelar la losa del piso 4.
<!--- (Nota: la vez pasada que enseñé sólidos 2 se modeló el piso 2).--->

Serán tres grupos de trabajo: cada uno con máximo cuatro integrantes (reportar los grupos en la WIKI). Los miembros de un mismo grupo no pueden utilizar programas de la misma casa. Por ejemplo en un mismo grupo no pueden estar quien maneja el SAP2000 y el ETABS, ya que ambos programas son de la casa Computers & Structures. Los estudiantes que ya hayan cursado Aplicaciones de Elementos Finitos deben estar en grupos separados. Solicitar al profesor que balancee los grupos en caso que queden grupos con muy pocos estudiantes.
<!--- En cada grupo debe haber al menos una persona que haya visto o que esté actualmente cursando la materia DISEÑO ESTRUCTURAL AVANZADO. ---> 

## Trabajo individual
Se solicita realizar para cada losa:
* Explicar detalladamente como se modelaron las condiciones de frontera.
* Hacer el cálculo de los diagramas de momentos de flexión *Mx* y *My* y torsores *Mxy* al interior de la losa. 
* Hacer el cálculo de las fuerzas cortantes al interior de la losa.
* Hacer el cálculo de los momentos de flexión y torsión máximos y mínimos al interior de la losa con sus respectivas direcciones.
* Hacer el cálculo de las fuerzas cortantes máximas al interior de la losa con sus respectivas direcciones.
* Hacer el cálculo de los momentos de diseño Mx^* y My^*. En su defecto aprender a manejar la funcionalidad de su programa para el diseño del refuerzo del cascarón.
* Hacer el cálculo de los esfuerzos de von Mises y de los esfuerzos máximos/mínimos en la superficie superior/inferior de la losa.
* Calcular las reacciones en los apoyos.
* Calcular con la teoría de losas gruesas y con la teoría de losas delgadas. 
* Para el caso de la Losa 1, hacer un cálculo de los porcentajes de error relativos que se encuentra al comparar los resultados obtenidos con su software y con la solución obtenida utilizando MS EXCEL: https://github.com/diegoandresalvarez/solidos/blob/master/archivos/losa_Kirchhoff_Love/ejemplo_losa_borde_libre.xlsm para 10 puntos representativos de la losa (todos los compañeros del grupo deben escoger exactamente los mismos puntos). ¿Con qué criterio seleccionarán esos puntos? Adicionalmente, se deben hacer unos cortes en x=1.25m y y=1.5m donde se grafiquen todos los gráficos Mx, My, ..., Vx, Vy, M1, M2, etc.

* Para hacer tres videos:
  * VIDEO 1 (máximo 15 minutos): en este video se debe explicar en detalle el modelado, análisis y diseño de la losa 1 utilizando el programa escogido; se mostrar aquí pantallazos con los resultados obtenidos y su comparación con la respuesta teórica (si esta no está disponible, use la calculada con MS EXCEL). Entregar, adicionalmente, el archivo PDF utilizado en la presentación de este video (este PDF deberá contener las tablas con la comparación de los resultados).
  * VIDEO 2 (máximo 20 minutos): en este video se debe explicar en detalle el modelado, análisis y diseño de la losa 2 utilizando el programa escogido. Entregar, adicionalmente, el archivo PDF utilizado en la presentación de este video (este PDF deberá contener las tablas con resultados). 
  * VIDEO 3 (máximo 30 minutos): en este video se debe hacer una revisión crítica de las capacidades teóricas y las hipótesis fundamentales que hace el programa en cuanto al **ANÁLISIS Y DISEÑO DE LOSAS**. OJO: no es mostrar como se utiliza el software, sino más mirar los manuales de referencia del mismo y mostrar que teorías, hipótesis, suposiciones, capacidades y limitaciones que tiene el programa escogido y que se utilizaron para calcular losas. Con respecto a la parte de diseño se debe explicar como el software diseña el refuerzo en las losas (teorías empleadas, fórmulas, hipótesis empleadas, etc.). Entregar, adicionalmente, el archivo PDF utilizado en la presentación de este video. Se sugiere para la presentación tomar capturas de pantalla de los manuales de referencia del programa en cuestión. OJO: no confunda esto con la información comercial. Lo que se está solicitando está dentro de los manuales de referencia. 

* Se solicita subir todos los archivos asociados al trabajo (.XLSX, .DOCX, .MP4, .MKV, archivo de MAXIMA, etc) directamente a GOOGLE CLASSROOM. Por favor no los empaquete en un archivo .ZIP o .RAR.

* Active en el software de captura de pantalla la opción para ver el ratón.

Se espera que cada uno lea a fondo el manual del usuario del software. No se queden con los videos de YouTube. En el manual del usuario generalmente existe información importante sobre las hipótesis de modelado que hace cada software.

En el trabajo individual lo que se está básicamente solicitando son los videos. No hay que entregar como tal un trabajo escrito. Sin embargo, se sugiere hacer para los videos unas diapositivas que les ayuden en ciertos aspectos y en la presentación de los resultados.

Se sugiere aprender a manejar un programa de edición de videos. Esto les facilitará grandemente la realización del mismo.

## Trabajo grupal: análisis
Se solicita realizar para cada losa:
* Presentar un informe escrito que presente la comparación de los resultados del análisis estructural obtenidos por los miembros de cada grupo.
* Presentar una calificación general realizada a los programas, justificando en una tabla, los pro y los contra de cada software.
* Cada grupo debe utilizar las mismas suposiciones en el modelado, en caso que las deban hacer y deben justificar el porqué las hicieron.

<!---
## Trabajo grupal: diseño
Se solicita realizar para cada losa:
* Hacer el diseño de la losa con los métodos aprendidos en la materia DISEÑO ESTRUCTURAL AVANZADO. A partir de los momentos de diseño, calcular el área de acero por metro que se requiere en la losa para el análisis tradicional y el análisis con los métodos vistos en clase.
* Realizar el despiece del refuerzo de la losa.
* Hacer la revisión de la resistencia a cortante de la losa.
* Aprender a manejar las funcionalidades de diseño de la losa con cada unos de los programas escogidos y comparar los resultados obtenidos con el método de diseño tradicional y el método de momentos de diseño equivalentes.
* Presentar un informe escrito que presente la comparación del diseño estructural: el método de diseño de losas tradicional vs. funcionalidades de diseño de losas de su programa de cálculo. Comparar en porcentajes.
--->

Recuerden que la finalidad de los grupos de trabajo es que comparen los programas que utilizaron en cuanto a facilidad de uso, forma de entrar los datos, hipótesis que utilizan los programas, etc. Obviamente, deben comparar los resultados obtenidos. La idea es que si les dan resultados diferentes (que seguramente les darán), intenten explicar el porqué les dió diferente. No los pienso penalizar por resultados diferentes, siempre y cuando me muestren en el video que todo se modeló utilizando unas hipótesis correctas. Ya hemos tenido la experiencia que ciertos programas dan resultados incorrectos y que toca hacer unos procedimientos para nada intuitivos para que funcionen bien.

## Nota final
```
Nota final = 0.8*Trabajo_Individual_Análisis + 0.2*Trabajo_Grupal_Análisis
```
 <!--- + 0.35*Trabajo_Grupal_Diseño--->

NOTA: me encantaría si en la WIKI se especifican las suposiciones hechas y se hace “cooperación” o comunicación entre los grupos de trabajo de las suposiciones que tengan que hacer, de modo tal que todo el curso maneje los mismos parámetros en el modelado.

## Criterios de evaluación (del trabajo individual)
* NOTA MAXIMA 6.0

* 1.5 unidades por cada video de modelación de la losa:
  - 0.1 Modela adecuadamente los apoyos? la estructura? el material?
  - 0.2 Refina adecuadamente la malla de elementos finitos? No de forma arbitraria sino utilizando los criterios escritos en: https://github.com/diegoandresalvarez/elementosfinitos/blob/master/diapositivas/05e_generando_una_buena_malla.pdf
  - 0.3 Grafica e interpreta adecuadamente los gráficos resultantes? Ubicó los momentos máximos y mínimos con sus respectivas inclinaciones? Las fuerzas cortantes máximas? Los puntos críticos de la estructura? Explica el por qué de los resultados obtenidos?
  - 0.2 Compara los resultados entre las teorías de Kirchhoff-Love y Mindlin
  - 0.3 Explora todas las capacidades de visualización de resultados que ofrece el software
  - VIDEO 1: 0.4 Compara los resultados con la respuesta teórica (si está disponible) y la de MS EXCEL. Hace los cortes solicitados en *x*=1.25m y *y*=1.5m. Los grafica? Explica el por qué de los resultados obtenidos?
  - VIDEO 2: 0.4 Muestra las funcionalidades para el cálculo de los momentos de diseño (ej. Wood y Armer -- tenga en cuenta que su programa podría utilizar otros métodos)

* 3.0 unidades por el video de la revisión crítica de cada programa.
  - 0.5 Lista las hipótesis/suposiciones que hace el software
  - 0.5 Lista las capacidades y limitaciones que tiene el software
  - 0.5 Lista las advertencias o consejos que hace el software en cuento a la modelación?
  - 0.5 Hace una revisión general del software y dió su opinión acerca del mismo? Intuitividad, facilidad de uso, claridad de los manuales, ayudas disponibles en internet y en YouTube.
  - 1.0 Explica el modelo matemático que hace el software para la diseño del refuerzo

* Si el video tiene mala calidad en el sonido se tendrá se rebajará 0.5 unidades en dicho video. Por lo tanto, se sugiere utilizar un micrófono diferente al del portátil para grabar el video (por ejemplo usar un manos libres).

* Si se sube un video de mala calidad (por ejemplo 360p de calidad o inferior) se rebajará 1.0 unidad. Mínimo 720p y preferiblemente 1080p. Recuerde que no tenemos limitación en el almacenamiento en GOOGLE CLASSROOM.

* Si se usa un software diferente al registrado, se tendrá menos 2.0 unidades.

* Por cada minuto de retrazo se descontarán 1 décima de la nota final.

NOTA: no los voy a penalizar en caso que ustedes obtengan desplazamientos diferentes a los que deberían dar. La experiencia nos ha demostrado que hay programas que simplemente no funcionan adecuadamente (aunque son pocos). Sin embargo, el estudiante debe demostrar en el video que modeló correctamente la estructura.
