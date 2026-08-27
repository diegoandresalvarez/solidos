# Observaciones generales y temario del curso

## Citas para preguntas
Únicamente solicitándolas previamente, ya sea por correo electrónico o inmediatamente después de la clase.

## Exámenes
Ver tema de los exámenes [aquí](05e_-_Examenes_Sol1.md). Los exámenes se realizarán en las fechas que se indican a continuación:
* **Examen 1:** Porcentaje: 25%. Miércoles 9 de septiembre de 2026 (semana 3).
* **Examen 2:** Porcentaje: 25%
  * **Parte 1:** Miércoles 30 de septiembre de 2026 (semana 6).
  * **Parte 2:** Miércoles 14 de octubre de 2026 (semana 8).
* **Examen 3:** Porcentaje: 25%. Miércoles 11 de noviembre de 2026 (semana 12).
* **Examen 4:** Porcentaje: 25%. Viernes 11 de diciembre de 2026 (semana 16).

En los exámenes siempre se preguntará: teoría, demostraciones, ejercicios numéricos y ejercicios de programación.

NOTA: se prohíbe en estos exámenes el uso de calculadoras Hewlett-Packard, Texas Instrument y calculadoras programables Casio.

<!---
<code style="color: #ff0000;">Se permite para los exámenes, que el profesor indique, traer una hoja tamaño carta en la cual ustedes pueden escribir (POR UN SOLO LADO) todas las fórmulas y comandos de MATLAB/MAXIMA/PYTHON que deseen. En la hoja no se pueden ni escribir programas, ni textos explicativos, ni se pueden escribir demostraciones. Dicha hoja debe ser de elaboración personal (no se pueden traer las hojas hechas por compañeros de este o semestres pasados) y debe hacerse a mano (se prohíbe explícitamente traer fotocopias/impresiones/reducciones).</code>
--->

## Descripción de la asignatura mecánica de sólidos 1
Este curso de pregrado aborda la teoría de la elasticidad, que es fundamental para comprender con suficiencia el método de los elementos finitos y para establecer criterios para el manejo responsable de los diversos programas de análisis estructural, para ingeniería estructural, ingeniería geotécnica y de pavimentos, evitando que se usen como una "caja negra". Más allá de lo técnico, fortalece rigor analítico, pensamiento crítico frente a resultados numéricos.

Partiendo de los conocimientos previos sobre tensiones y deformaciones adquiridos en el curso de mecánica del medio continuo (mecánica tensorial), exploraremos en detalle las relaciones entre esfuerzos y deformaciones en materiales elásticos lineales. Además, abordaremos las ecuaciones fundamentales de la teoría de la elasticidad, las teorías de falla de materiales dúctiles y frágiles y culmina con el estudio de la torsión en barras de sección transversal no circular. El curso también incluye la formulación elástica en coordenadas cilíndricas.

Se espera que al final del curso, el estudiante esté en capacidad de:
* Relacionar esfuerzos y deformaciones en 2D y 3D, incluyendo efectos térmicos en materiales isótropos y ortótropos.
* Entender las diferentes suposiciones y limitaciones presentes en la teoría de la elasticidad.
* Interpretar los gráficos que arroja un programa de elementos finitos para el análisis estructural.
* Interpretar criterios de falla para dúctiles (von Mises, Tresca) y frágiles (Rankine, Mohr-Coulomb, Matsuoka-Nakai).
* Entender la deducción y rango de aplicación de ciertas formulaciones que se aplicarán más tarde en las líneas de mecánica de suelos y pavimentos.
* Formular problemas en coordenadas polares y cilíndricas, base de soluciones clásicas en cimentaciones (Boussinesq, Flamant, Kelvin, Mindlin).
* Resolver torsión en barras de sección no circular y de pared delgada, entendiendo alabeo y rigidez torsional.

Para su desarrollo, es indispensable dominar álgebra lineal, cálculo vectorial, física mecánica y estática.

La materia se desarrollará mediante clases magistrales y simulaciones con el computador.

## Contenido programático de mecánica de sólidos 1

### 0a. Repaso de diferentes temas de álgebra lineal y cálculo vectorial

Cada estudiante debe repasar por cuenta propia los siguientes temas:

#### Repaso de álgebra lineal (teoría y ejercicios de aplicación)
* Cosenos directores
* Proyección de vectores
* Producto punto, producto cruz (con todas las propiedades que aparecen en el apéndice de las notas)
* Norma de un vector
* Matrices
* Determinantes
* Valores y vectores propios
* Espacios vectoriales
* Vectores linealmente dependientes/independientes
* Bases
* Planos y líneas rectas

#### Repaso de cálculo vectorial (teoría y ejercicios de aplicación)
* Gradiente
* Matriz jacobiana y jacobiano
* Divergencia
* Rotacional
* Curvas paramétricas
* Diferenciales (se estudió en cálculo vectorial)
* Optimización de funciones multivariadas sin restricciones
* Optimización de funciones multivariadas con restricciones de igualdad (multiplicadores de Lagrange)
* Expansión en series de Taylor (univariada y multivariada)
* Regla de la cadena (se estudió en cálculo univariado y en cálculo vectorial)
* Campo vectorial (definición y ejemplos sencillos)

### 0b. Repaso breve de esfuerzos y deformaciones infinitesimales (estos temas se aprendieron en el curso *Mecánica Tensorial*)

#### Esfuerzos o tensiones
* Fuerzas másicas y fuerzas superficiales
* Esfuerzos cortantes y normales
* Tensor de tensiones
* Cambio de base

#### Desplazamientos y pequeñas deformaciones
* Desplazamientos
* Deformaciones longitudinales y angulares
* Especificación de la deformación en otras direcciones
* Rotación
* Deformaciones principales

#### Círculo de Mohr en 2D y 3D para los tensores de esfuerzos y deformaciones

#### Relación entre esfuerzos y deformaciones
* Materiales frágiles y materiales dúctiles: comportamiento elastoplástico, curva esfuerzo deformación.
* La ley de Hooke para materiales isótropos, anisótropos y ortótropos:
  * Los módulos de Young y Poisson.
  * Deformación de un sólido sometido a esfuerzos normales en las direcciones $x$, $y$ y $z$.
  * Deformación de un sólido sometido a esfuerzos tangenciales.
* Relación entre las direcciones principales asociadas a los esfuerzos y a las deformaciones para materiales isótropos
* Cambios de volumen y dilatación cúbica
* Módulo de expansión volumétrica o módulo de compresibilidad.

### 1. Relación entre esfuerzos y deformaciones
* Particularizaciones de tres a dos dimensiones: 
  * Tensión plana
  * Deformación plana
  * Relación entre los esfuerzos principales obtenidos en el análisis bidimensional y tridimensional
* Interpretación de los gráficos de colores de esfuerzos y deformaciones
* Modificación de la ley de Hooke para tener en cuenta los efectos térmicos en el caso de materiales isótropos y ortótropos

### 2. Ecuaciones diferenciales fundamentales de la teoría de la elasticidad
* Ecuaciones diferenciales de equilibrio
* Ecuaciones de compatibilidad en 2D y 3D en términos de deformaciones y esfuerzos (las ecuaciones de Saint-Venant y de  Mitchell-Beltrami)
* Condiciones de frontera
* Condiciones de equilibrio en la frontera en 2D y 3D
* Cálculo de los desplazamientos a partir de las deformaciones
* Función de tensión de Airy
* Ecuaciones diferenciales de Navier
* Unicidad de la solución
* Principio de superposición
* Principio de Saint-Venant

### 3. Criterios de falla para materiales dúctiles y frágiles
* Esfuerzos medios, desviadores y octaédricos
* El espacio de esfuerzos principales, la superficie de fluencia y la región elástica
* El sistema de coordenadas cilíndricas de Haigh-Westergaard
  * Simetría del espacio de esfuerzos principales
  * Comportamiento de los materiales isótropos en el rango plástico cuando se les somete a una condición de esfuerzos tridimensional
* Energía de dilatación y energía de distorsión
* Criterios de fluencia y superficies de plastificación en materiales dúctiles: von Mises, Tresca
* Criterios de rotura y superficies de falla en materiales frágiles: Rankine, Mohr-Coulomb, Drucker-Prager, Matsuoka-Nakai

### 4. Formulación en coordenadas polares y cilíndricas
* Los sistemas de coordenadas polares y cilíndricas
* El gradiente, el laplaciano, la divergencia y el rotacional en coordenadas cilíndricas
* Esfuerzos
* Deformaciones
* Ecuaciones diferenciales de equilibrio
* Desplazamiento y deformación en el caso de simetría axial
* Ley de Hooke
* Ecuaciones diferenciales de compatibilidad en coordenadas polares y cilíndricas
* Funciones de tensión de Airy y de Love
* Ecuaciones diferenciales de Navier
* Aplicaciones
  * Cálculo de los discos y cilindros de sección constante sujetos a un estado de tensiones axisimétrico
  * Concentración de esfuerzos alrededor de huecos circulares (el problema de Kirsch)
  * Concentración de esfuerzos alrededor de grietas
  * Concentración de esfuerzos en el ensayo brasileño
  * Aplicación en ingeniería de cimentaciones: problemas de Boussinesq, Flamant, Kelvin, Cerruti y Mindlin

### 5. Torsión
  * Hipótesis fundamentales de la teoría de Saint-Venant y Prandtl
  * Desplazamientos, deformaciones y esfuerzos en barras de sección circular y no circular
  * Función de tensión de Prandtl, analogía de la membrana
  * Alabeo
  * Cálculo de la rigidez a la torsión
  * Localización del centro de torsión
  * Uso de chaflanes en barras sometidas a torsión
  * Torsión de secciones de pared delgada

## Bibliografía básica
* Alvarez-Marín, Diego A. (2026). *Notas de clase del curso mecánica de sólidos*. En preparación.
* Álvarez-Marín, D. A. (2023a). Teoría de la Elasticidad usando Matlab y Maxima (volumen 1: fundamentos). Departamento de Ingeniería Civil, Facultad de Ingeniería y Arquitectura, Universidad Nacional de Colombia - Sede Manizales. ISBN 978-958-505-376-2. https://repositorio.unal.edu.co/handle/unal/84682
* Alvarez, Diego A. Video tutoriales en YouTube sobre teoría de la elasticidad https://www.youtube.com/channel/UCV0FtSuauv5WbcY-lLRMZ4g
* Ameen, M. (2005) - *Computational elasticity*. Alpha Science.
* Ortiz-Berrocal, L. (1998) - *Elasticidad*. McGraw Hill, 3rd edition.
* Saad, M. (2005) - *Elasticity: theory, applications and numerics*. Elsevier.
* Solecki, R. and Conant, R. (2003) - *Advanced mechanics of materials*. Oxford University Press.
* Timoshenko, S. P. and Goodier, J. (1970) - *Theory of Elasticity*. McGraw Hill, 3rd edition.
* Wang, C.-T. (1953) - *Applied Elasticity*. McGraw Hill.

## Otras observaciones que se quieren dejar por escrito:

### Falta a los exámenes
Siempre que usted falte a un examen, debe haber algún documento que lo exonere de dicha inasistencia. Cuando usted por algún motivo de fuerza mayor no pueda asistir al examen, usted debe avisarle al profesor con anterioridad ya sea personalmente o por correo. En esos casos en lo posible, debe demostrarlo. Por ejemplo: si le tocó viajar a su pueblo esa semana porque algo sucedió un evento familiar de trascendencia, entonces una forma de certificar que usted viajó son los tiquetes de ida y vuelta a su pueblo. Sin una excusa o una notificación previa no se repetirán los exámenes y usted tendrá como nota un cero.

### Dispositivos electrónicos durante los exámenes
Durante los exámenes, los celulares, relojes inteligentes, gafas inteligentes, y en general cualquier dispositivo electrónico debe permanecer apagado y guardado en el morral. Si el estudiante porta alguno de estos dispositivos electrónicos en sus manos, bolsillos o en cualquier lugar diferente del morral, independientemente de si está apagado o encendido, esto resultará en la anulación del examen. Esta medida se aplica como parte de las normas contra el fraude académico, ante la proliferación del fraude con la tecnología.

### Fraude en los exámenes o trabajos
Estos se penalizarán así:
* Nota cero en el trabajo/examen en cuestión.
* Carta al Consejo de Facultad reportando el suceso.
<!---
* Se pierden adicionalmente todos los privilegios que se tienen de una calificación con notas mayores a 5.0 en todas las notas obtenidas en el semestre y cualquier bonificación adicional de notas que el profesor decida otorgar al grupo.
--->

### "Minuciosamente" en los exámenes
En todos los exámenes se debe relacionar con palabras las fórmulas y motivar físicamente el por qué de un procedimiento o fórmula (es decir, se debe escribir la explicación suponiendo que usted está escribiendo un libro). Si no se hace esto, se le rebajará en ese punto en particular el 50% de la nota.
