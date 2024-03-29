# Taller de vigas: comparación de las teorías de Euler-Bernoulli y Timoshenko-Ehrenfest

Con el objeto de contrastar la teoría aprendida y la práctica mediante el uso de un software profesional de análisis estructural, se requiere hacer el análisis de los desplazamientos, diagramas de momento flector y de fuerza cortante en una viga, utilizando las teorías de Euler-Bernoulli y de Timoshenko-Ehrenfest. Se espera que el estudiante explore, comente, discuta los conceptos aprendidos en clase, los conceptos nuevos vistos en el software y que proponga soluciones a los problemas propuestos.

Trabajo de elaboración individual.

Fecha de entrega: se especificará en GOOGLE CLASSROOM. Por cada 8 horas de retraso se tendrán 1 décima menos en la nota final.


## El problema propuesto
Cada estudiante debe proponer una viga, que sea diferente a la del resto de sus compañeros, con:

* Sección rectangular constante en toda su longitud.
* Con dos resortes intermedios y dos rodillos intermedios. Uno de los rodillos intermedios debe tener un asentamiento de 3 cm.
* Empotramiento a la izquierda.
* Dos momentos puntuales: uno sobre un apoyo, otro en medio de una luz.
* Dos cargas puntuales: una sobre un apoyo, otra en medio de una luz.
* Relación *h/L* = 0.20 en el tramo entre dos apoyos más corto de la viga.

Discutir la viga propuesta con el profesor.

Dicha viga tiene una sección rectangular de 5 cm de ancho y 25 de alto y está hecha de un material con un módulo de Young *E* = 20 GPa y un coeficiente de Poisson *ν* = 0.30. Asuma *k₁* = *k₂*/2 = 1000 kN/m.

Se solicita calcular y graficar los diagramas de:

* Fuerza cortante *V(x)*.
* Momento flector *M(x)*.
* Ángulo de giro de la viga *θ(x)*.
* Desplazamiento vertical *v(x)*.

Utilizando los siguientes métodos:

* Diferencias finitas por el método de Euler-Bernoulli.
* Funciones de discontinuidad con las teorías de Euler-Bernoulli y de Timoshenko-Ehrenfest.
* Programa de análisis estructural que usted registró en https://mecanicadesolidos.shoutwiki.com/wiki/Software_para_análisis_estructural_por_elementos_finitos utilizando las teorías de Euler-Bernoulli y Timoshenko-Ehrenfest. NOTA: no usar como software el FTOOL.

## Se solicita

* Un informe, presentado como un archivo PDF, donde:
  * Se presente la solución utilizando la teoría de Euler-Bernoulli con:
    * Método de las funciones de singularidad.
    * Método de las diferencias finitas.
    * Software profesional.
    * Compare estas tres respuestas entre sí.

  * Se presente la solución utilizando la teoría de Timoshenko-Ehrenfest (analice empotramiento suave y rígido) con:
    * Método de las funciones de singularidad.
    * Software profesional.
    * Compare ambas respuestas entre sí.

  La solución obtenida con el método de las funciones de discontinuidad se considerará como la matemáticamente exacta, por lo que la usaremos como el valor de referencia en las comparaciones; recuerde hacer cálculos de los porcentajes de error para mirar las diferencias entre las respuestas.

  * Estime el porcentaje de diferencia estimada por las teoría de Euler-Bernoulli y Timoshenko-Ehrenfest estimada con el método de las funciones de discontinuidad. En este punto el valor de referencia será el de Timoshenko-Ehrenfest.

  * Haga diagramas que comparen los resultados obtenidos entre ambas teorías de vigas. ¿Cuál método calculó las reacciones, momentos flectores, fuerzas cortantes y desplazamientos más altos y más pequeños? 
  * Enumere en el informe las hipótesis empleadas en la simulación y sus observaciones.
  * Configure su software de modo que se emplee la misma convención para mostrar los diagramas de fuerzas cortantes y momentos flectores empleados en clase. Los momentos son positivos cuando la fibra superior esté a compresión. El eje dependiente *M(x)* se grafica hacia arriba.
  * Explique qué es lo que observa en los gráficos.
  * No es necesario escribir una introducción o un marco teórico que contenga la metodología vista en clase.

* Dos videos:
  * VIDEO 1 (máximo 20 minutos): hacer un video que ilustre como resolvió la viga utilizando el programa seleccionado. En el mismo video mostrar la comparación de los resultados obtenidos en PYTHON y EXCEL.

  * VIDEO 2 (máximo 20 minutos): en este video se debe hacer una reseña crítica de las capacidades teóricas y las hipótesis fundamentales que hace el programa en cuanto al **ANALISIS DE VIGAS Y PÓRTICOS** (es decir, en cuanto a la matemática interna para el cálculo de desplazamientos, diagramas de momento flector, fuerza cortante, etc). NOTA: no es mostrar como se utiliza el software, sino estudiar a fondo los manuales de referencia y mostrar que teorías, hipótesis, suposiciones, capacidades y limitaciones que tiene el programa escogido y que se utilizaron para calcular la viga. Entregar, adicionalmente, el archivo PDF utilizado en la presentación de este video. Se sugiere para la presentación tomar capturas de pantalla de los manuales de referencia del programa en cuestión. OJO: no confunda esto con la información comercial. Lo que se está solicitando está dentro de los manuales de referencia. Algunos ejemplos de buenos análisis son:
     * MIDAS GEN (análisis de vigas): https://www.youtube.com/watch?v=p06pnzg2ZPg
     * STRUSOFT FEM-DESIGN (análisis de losas): https://www.youtube.com/watch?v=xxPzgIl-mEg

* Se solicita subir todos los archivos asociados al trabajo (.XLSX, .DOCX, .MP4, .MKV, archivo de MAXIMA, etc) directamente a GOOGLE CLASSROOM. Por favor no los empaquete en un archivo .ZIP o .RAR.

* Active en el software de captura de pantalla la opción para ver el ratón.

Se espera que cada uno lea a fondo el manual del usuario del software. No se queden con los videos de YouTube. En el manual del usuario generalmente existe información importante sobre las hipótesis de modelado que hace cada software.

Se sugiere aprender a manejar un programa de edición de videos. Esto les facilitará bastante su elaboración.


## Criterios de evaluación
* NOTA MAXIMA 6.0

* Análisis y comparación de los resultados con diferencias finitas, funciones de singularidad y el software de EFs (60% = 3.6)
  * 0.5 Calculo de reacciones, *V*, *M*, *θ*, *v* con MS EXCEL + diferencias finitas + EB.
  * 0.4 Calculo de reacciones, *V*, *M*, *θ*, *v* con PYTHON + funciones de singularidad + EB.
  * 0.4 Calculo de reacciones, *V*, *M*, *θ*, *v* con PYTHON + funciones de singularidad + TE (empotramientos suave y duro).
  * 0.3 VIDEO 1: Calculo de reacciones, *V*, *M*, *θ*, *v* con el software profesional haciendo un ingreso adecuado de datos + EB.
  * 0.3 VIDEO 1: Calculo de reacciones, *V*, *M*, *θ*, *v* con el software profesional haciendo un ingreso adecuado de datos + TE.
  * Si no se realiza el video 1, se tendrán -2.0 unidades.
  * 0.6 Compara, analiza, hace tablas y/o gráficas comparativas de los resultados entre los diferentes métodos que usan la teoría de Euler-Bernoulli. ¿Explica el por qué de las diferencias? El método de las funciones de singularidad es el método de referencia.
  * 0.6 Compara, analiza, hace tablas y/o gráficas comparativas de los resultados entre los diferentes métodos que usan la teoría de Timoshenko-Ehrenfest y calcula el porcentaje de diferencia entre los resultados para los diferentes tipos de empotramientos. ¿Compara respuestas entre los diferentes empotramientos de Timoshenko (rígido/suave) y el software? ¿Explica el por qué de las diferencias? El método de las funciones de singularidad es el método de referencia.
  * 0.5 Compara, analiza, hace tablas y/o gráficas comparativas de los resultados entre el método de EB y el de TE estimados por el método de las funciones de singularidad? ¿Explica el por qué de las diferencias?

* VIDEO 2: reseña crítica de las capacidades teóricas y las hipótesis fundamentales que hace el programa en cuanto al análisis de vigas (40% = 2.4)
  * 0.8 Hace un recuento de las teorías que soporta el programa, haciendo recortes del manual de referencia. Explica las capacidades de cálculo y las teorías que utiliza el software. 
  * 0.8 Explica las hipótesis fundamentales y consejos en el modelado según se detalla en el manual del programa; hace una reseña crítica de las capacidades teóricas, las limitaciones y las hipótesis fundamentales que hace el programa en cuanto al análisis de viga.
  * 0.8 Hace una reseña crítica de las ventajas/capacidades y limitaciones/suposiciones que hace el programa en cuanto al análisis de vigas y pórticos

* Por mala calidad en el sonido se rebajarán 0.5 unidades. Por favor use un micrófono auxiliar (por ejemplo, un manos libres) y evite usar el micrófono del portátil para hacer el video.

* Si se sube un video de mala calidad (por ejemplo 720p de calidad o inferior) se rebajará 1.0 unidad. Mínimo 1080p. Recuerde que no tenemos limitación en el almacenamiento en GOOGLE CLASSROOM.

* Si se usa un software diferente al registrado, se tendrá -2.0 unidades.
