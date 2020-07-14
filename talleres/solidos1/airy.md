# Taller 2 de mecánica de sólidos

* Taller de elaboración individual.

* El número del ejercicio a resolver se sorteará de acuerdo con la lotería de Medellín (juega el viernes en la noche), siguiendo el criterio que se explicará en clase y utilizando el programa de MATLAB [sorteo_ejercicios.m](sorteo_ejercicios.m).

## La misión a realizar
Utilizando el método de la diferencias finitas para resolver las ecuaciones diferenciales de Airy y con respecto a la estructura propuesta, se pide describir, calcular y graficar usando MAXIMA, MS EXCEL y MATLAB lo siguiente:
* Modelación de la carga en los apoyos. Se deben hacer todos los cálculos a mano o en MAXIMA/MATLAB y EXCEL; no se pueden calcular centros de gravedad y áreas con otro programa como AUTOCAD (aunque pueden ser herramientas útiles para verificar las respuestas).
* Diagramas de *x(s)*, *y(s)*, *(x(s),y(s))*, *ϕ(s)*, *∂ϕ/∂x* y *∂ϕ/∂y*.
* Diagrama de deformaciones y esfuerzos de la estructura resolviendo la ecuación de Airy. Incluir el desarrollo matemático en el informe.
* Diagrama de los esfuerzos principales, indicando las direcciones de los mismos.
* Análisis de resultados (esto es lo más importante).
* Analizar la estructura utilizando un programa de elementos finitos utilizando el programa que se escogió al principio de semestre y compararlo con los resultados obtenidos. Seguir los consejos de https://github.com/diegoandresalvarez/elementosfinitos/blob/master/diapositivas/05e_generando_una_buena_malla.pdf en cuanto a como generar una malla de elementos finitos adecuada.
* Tenga en cuenta que deberá adjuntar los gráficos hechos por usted con MAXIMA+MS EXCEL+MATLAB y los del software de elementos finitos.

## Los datos de la estructura
* Estructura modelada por tensión plana
* Espesor = 1 m
* *E* = 70 GPa
* *ν* = 0.30 (coeficiente de Poisson)
* peso propio material = 2700 kgf/m³
* *Δ*  = 5 cm (para las diferencias finitas), en caso que no lo indique en la figura misma.

## La estructura
Las estructuras a analizar se encuentran en las fotografías adjuntas. El número de la fotografía es el número del problema a resolver. Puede que la foto que le haya tocado esté rotada. Por favor **no rote la fotografía**. Observe el origen de coordenadas: asegúrese que el origen de coordenadas debe ser tal que el eje *x* apunte hacia la derecha y el eje *y* apunte hacia arriba. 

## Fecha y hora límite de entrega
Se tienen 48 horas a partir de la hora de enviado el correo con las figuras de los ejercicios, para entregar el informe. Se descontará 1 décima por cada 5 minutos de retraso en la entrega de este trabajo.

Eventualmente, el profesor llamará al estudiante a realizar la sustentación oral del trabajo.

## Lo que se debe subir a Google Classroom
* Archivos de MAXIMA, MATLAB y MS EXCEL con los códigos y procedimientos usados para calcular la estructura. 

* Presentar un informe escrito en formato PDF que contenga el análisis de los resultados, comentarios varios sobre la elaboración del trabajo y respuesta a las preguntas postuladas (no hay que describir el procedimiento usado para el cálculo). Recuerde explicar detalladamente como varían las cantidades en el espacio, donde están las cantidades máximas y mínimas, como se relacionan unas gráficas con otras, etc. No es solo ubicar donde están los colores, o los máximos y los mínimos, sino decir, **por qué razón se produce esa coloración**, entendiendo como la estructura está cargada, está apoyada, se deforma, etc. Se sugiere [**este (descargue archivo .PDF)**](ejemplo_analisis_graficos.pdf) formato para presentar los resultados . 

* Se solicita subir todos los archivos asociados al trabajo (.XLSX, .DOCX, etc) directamente a GOOGLE CLASSROOM. Por favor no los empaquete en un archivo .ZIP o .RAR.

## Criterios de calificación
NOTA MAXIMA = 6.0 (tenga en cuenta que usted podría sacar más nota, pero la nota máxima asignada a este taller será 6.0, después de todas las deducciones posibles)

* Parte A: Airy con MAXIMA, MS EXCEL y MATLAB (si la sumatoria de fuerzas y momentos no es igual a cero, la calificación en la parte A es 0.0) (se calificará sobre 3.0)
   * 1.0 si la sumatoria de fuerzas es y momentos da cero 
   * 1.0 si la hoja de EXCEL es correcta (se sabe a simple vista mirando las gráficas de los esfuerzos generadas)
   * 1.0 si realizó el cálculo de los esfuerzos y las deformaciones incluyendo la fuerza másica
* Parte B: Análisis de resultados y comparación con el método de los elementos finitos (se calificará sobre 4.0)
   * Modelación de la estructura (nota máxima 1.0)
     * 0.2 Calculó y graficó las reacciones en los apoyos y graficó dichas reacciones
     * 0.1 Calculó y graficó el diagrama de los desplazamientos y de la estructura deformada
     * 0.1 Calculó y graficó los diagramas de las deformaciones ex, ey, gxy *y* los esfuerzos sx, sy, txy.
     * 0.1 Calculó y graficó el diagrama de las rotaciones.
     * 0.2 Calculó y graficó el diagrama de esfuerzos s1, s2 *y* sus inclinaciones (los diagramas de s1 y s2 sin sus respectivas inclinaciones no otorgarán puntos)
     * 0.1 Calculó y graficó el diagrama de esfuerzos de von Mises y/o Tresca y/o tau_max 
     * 0.2 Usa el consejo de como hacer buenas mallas  
   * Análisis de resultados (nota máxima es 3.0). Tenga en cuenta que podría utilizar para esta parte los gráficos obtenidos con el programa de EFs en caso que no haya sido capaz de realizar el cálculo utilizando la función de tensión de Airy. Y en caso que haya sido capaz de hacer el cálculo utilizando la función de tensión de Airy, debe comparar los resultados. En este caso, debe interpretar gráficos, analizar como varían las cantidades en el espacio, ubicar máximos y mínimos, relaciona gráficos entre si de:
     * 0.5 Diagramas de los desplazamientos del sólido y las deformaciones ex, ey, gxy
     * 0.5 Diagramas de esfuerzos sx, sy, txy
     * 0.5 Diagramas de esfuerzos s1, s2 con sus inclinaciones (si no tiene las inclinaciones, se tendrá un 0.0 en este punto)
     * 0.5 Sugiere como se podría poner el refuerzo óptimo al interior de la estructura asumiendo que esta es de concreto reforzado?
     * 0.5 Diagramas de esfuerzos de von Mises, de Tresca y/o tau_max
     * 0.5 Reacciones en los apoyos   

* Se descontará 1 décima por cada 5 minutos de retraso en la entrega de este trabajo.

* Si modela la estructura como 3D a pesar que es una de tensión/deformación plana se tendrá menos 1.0 unidad. Se debe usar necesariamente la funcionalidad de tensión/deformación plana del programa de elementos finitos (excepto si puede demostrar que este software no tiene esa opción).

* Si se usa un software diferente al registrado, se tendrá menos 2.0 unidades.

* Si se modela una estructura diferente a la registrada, se tendrá menos 3.0 unidades.

* Si rota la fotografía, la nota es automáticamente cero; utilice la rotación de la fotografía asignada.

* Si su programa no puede graficar lo anteriormente pedido, debería cambiar de programa, ya que podría perder la oportunidad de contabilizar algunos puntos.

## Notas adicionales
* En ocasiones para que el algoritmo funcione hay que presionar F9 muchas veces, hasta lograr la convergencia.
* Si les aparece un *#NUM* o un error parecido, lo más probable es que cometieron un error con alguna de las fórmulas; en este caso toca borrar las fórmulas y entrarlas de nuevo.
* Para determinar la ecuación de la parábola pueden utilizar los llamados polinomios de Lagrange http://en.wikipedia.org/wiki/Lagrange_polynomial o utilizar matrices de Vandermonde tal y como se explica en http://en.wikipedia.org/wiki/Polynomial_interpolation. En la práctica uno utilizaría los comandos `polyfit` de MATLAB o `lagrange` de MAXIMA. Sin embargo, necesito que también lo hagan "a mano" con los métodos referidos.
* Cuando se realiza el análisis de cargas que se aplican a la estructura, si la suma de fuerzas y momentos no da cero (es decir un número del orden de *O*(10⁻³) o mayor), la nota en la parte A de la calificación es automáticamente cero.
* En las esquinas entrantes es donde generalmente los estudiantes cometen los errores. Mucho cuidado haciendo los cálculos en dichas esquinas.
* Los desarrollos matemáticos pueden incluirse como una foto de sus apuntes, la cual se incluirá en el informe final.
* En caso que requiera un programa de elementos finitos, la siguiente lista puede ser útil: http://feacompare.com/ Tenga en cuenta que muchos programas pagos tienen versiones de prueba que pueden ser de utilidad para el presente taller.
