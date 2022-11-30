- Primero ingresare a postgres
psql -U postgres
- Creamos la base de datos:
CREATE DATABASE prueba_yarenla_cordero_378;

- conectamos la base de dato:

\c prueba_yarenla_cordero_378;

Comencemos con el desafío:

1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
claves primarias, foráneas y tipos de datos. 


CREATE TABLE pelicula(
  id SERIAL PRIMARY key,
  nombre VARCHAR(255) NOT NULL,
  anno INTEGER NOT NULL
);

CREATE TABLE tag(
  id SERIAL primary key,
  tag VARCHAR(32) NOT NULL
);


CREATE TABLE pelicula_tag (
  pelicula_id INT,
  tag_id INT,
  PRIMARY KEY (pelicula_id, tag_id),
  CONSTRAINT fk_pelicula FOREIGN KEY(pelicula_id) REFERENCES pelicula(id),
  CONSTRAINT fk_tag FOREIGN KEY(tag_id) REFERENCES tag(id)
);

2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
segunda película debe tener dos tags asociados. 


-Peliculas
INSERT INTO pelicula (nombre, anno) VALUES
('Harry Potter', 2012),
('Encantada', 2007),
('Grinch', 2018),
('RED', 2022),
('Sinsajo', 2015);

-Tags
INSERT INTO tag (tag) VALUES
('Comedia'),
 ('Drama'),
 ('Aventura'),
 ('Fantasía'),
 ('Ciencia Ficción');

Tabla intermedia
INSERT INTO pelicula_tag (pelicula_id, tag_id) VALUES 
(1,1),
 (1,2),
 (1,4),
 (2,1),
 (2,2);

3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0. 

SELECT
  pelicula.nombre,
  COUNT(pelicula_tag.tag_id)
FROM
  pelicula
  LEFT JOIN pelicula_tag ON pelicula.id = pelicula_tag.pelicula_id
GROUP BY
  pelicula.nombre;



  4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
datos.

  CREATE TABLE preguntas (
  id SERIAL PRIMARY KEY,
  pregunta VARCHAR(255),
  respuesta_correcta VARCHAR
);


CREATE TABLE usuarios(
  id SERIAL PRIMARY key,
  nombre VARCHAR(255),
  edad INTEGER
);

CREATE TABLE respuestas (
  id SERIAL PRIMARY KEY,
  respuesta VARCHAR(255),
  usuario_id BIGINT,
  pregunta_id BIGINT,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
  FOREIGN KEY (pregunta_id) REFERENCES preguntas (id)
);

5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.

INSERT INTO usuarios(nombre, edad) VALUES 
('Lita', 23),
('Juan', 33),
('Valeria', 30),
('Matias', 23),
('Romina', 25);

INSERT INTO preguntas(pregunta, respuesta_correcta) VALUES 
('¿Quien es el villano en Harry Potter?', 'Lord Voldemort'),
('¿Quien es el personaje principal de Sinsajo?', 'Katniss Everdeen'),
('¿Cua es la última película de One Piece?', 'RED'),
('¿Que significa usagi en español?', 'conejo '),
('¿Que personaje de plaza sesamo come galletas?', 'Lucas El monstruo come galletas');


INSERT INTO respuestas(respuesta, usuario_id, pregunta_id) VALUES 
('Lord Voldemort', 1, 1),
('Lord Voldemort', 3, 1),
('gold', 2, 2),
('conejo', 5, 2),
('Katniss Everdeen', 4, 2);

6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta).

SELECT
  usuarios.nombre,
  count(preguntas.respuesta_correcta) as Respuestas_correctas
FROM
  preguntas
  RIGHT JOIN respuestas ON respuestas.respuesta = preguntas.respuesta_correcta
  JOIN usuarios ON usuarios.id = respuestas.usuario_id
GROUP BY
  usuario_id,
  usuarios.nombre;


7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta.

SELECT
  preguntas.pregunta,
  COUNT(respuestas.usuario_id) AS Respuesta_correctas
FROM
  respuestas
  RIGHT JOIN preguntas ON respuestas.pregunta_id = preguntas.id
GROUP BY
  preguntas.pregunta;


8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación. 

8.1 Implementacion 
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, 
ADD FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;
8.2 Eliminacion Usuario 
DELETE FROM usuarios WHERE id = 1;

9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos

ALTER TABLE usuarios ADD CHECK (edad > 18); 

10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
único.
ALTER TABLE usuarios ADD email VARCHAR(50) UNIQUE;