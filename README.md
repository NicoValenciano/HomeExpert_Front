# home_expert_front

### Proyecto base para construir un prototipo en Flutter

El repo cuenta con un drawer menu para agregar las distintas pantallas para cada integrante del grupo.

### Partes de cada integrante:

Paseadores - Camila Piergentili
Limpieza - Lucila Murano
Cuidadores - Bruno Dahua
Mantenimiento - Jonatan Diaz
Jardineria - Nicolas Valenciano

### screens

1.  Home screen con un listado de expertos con su respectiva foto y nombre, desde donde se puede acceder a a la lista de cada caterogía.
2.  Perfil de usuario para dar funcionalidad al switch del light/dark mode.(Accesible desde el drawer menu > Mi cuenta)
3.  Lista de categorías de expertos:
    - Paseadores: Se muestran los expertos con su respectiva foto, nombre, precio, disponibilidad y calificación. Se puede filtrar por disponibilidad (BottomNavigationBar). Cuentan con un buscador por ID en el searchArea().
    - Limpieza: Se muestran los expertos con su respectiva foto, nombre, especialidad, disponibilidad y calificación. Se puede filtrar por sexo. (SexoToggleButton). Cuentan con un buscador por nombre en el searchArea().
    - Cuidadores: Se muestran los expertos con su respectiva foto, nombre, disponibilidad y calificación. Se puede filtrar por el precio con el range filter. Cuentan con un buscador por ID en el searchArea().
    - Mantenimiento: Se muestran los expertos con su respectiva foto, nombre, oficio, disponibilidad y calificación. Se puede filtrar por oficio en el drawer menu de la categoria. Cuentan con un buscador por ID en el searchArea().
    - Jardineria: Se muestran los expertos con su respectiva foto, nombre, especialidad y precio. Cuentan con un buscador por nombre en el searchArea(). Mantieniendo el click en un experto se puede visualizar su calificación. Tambien se puede filtrar por el precio con el range filter.
4.  Pantalla de perfil del experto.

### mocks

En esta carpeta se almacenan los mocks con los que funcionan la listas de cada uno de los integrantes.

### widgets

Tenemos un widget para el drawer menu,un widget para las categorias de nuestros expertos y un widget para mostrar diferentes promociones.
