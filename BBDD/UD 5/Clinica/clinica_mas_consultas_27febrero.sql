/* =========================================================
   CLÍNICA CONSULTAS SENCILLAS
   ========================================================= */

-- 1) WHERE + ORDER BY: Mostrar las citas ordenadas por fecha descendente.
SELECT * FROM cita 
ORDER BY fecha DESC; 

-- 2) LIKE: Mostrar pacientes cuyo apellido contenga 'Pérez'.
SELECT * FROM `paciente`
WHERE apellidos like '%Pérez%';

-- 3) COUNT con GROUP BY: Mostrar cuántas citas tiene cada paciente.
SELECT count(*) AS citas, p.nombre FROM cita c
INNER JOIN paciente p
	ON c.id_paciente = p.id_paciente
GROUP BY p.nombre;

-- 4) INNER JOIN sencillo: Mostrar nombre del paciente y fecha de su cita.
SELECT p.nombre, c.fecha FROM cita c
INNER JOIN paciente p
   ON c.id_paciente = p.id_paciente;

-- 5) INNER JOIN con médico: Mostrar médicos y las citas que atienden.
SELECT m.nombre AS medico, c.id_cita FROM medico m
INNER JOIN atiende a
	ON m.id_medico = a.id_medico
INNER JOIN cita c
	ON a.id_cita = c.id_cita;

-- 6) LEFT JOIN: Mostrar todos los médicos aunque no tengan citas.
SELECT m.nombre as medico, c.id_cita FROM medico m

LEFT JOIN atiende a
	ON m.id_medico = a.id_medico
LEFT JOIN cita c
	ON a.id_cita = c.id_cita;

-- 7) RIGHT JOIN: Mostrar todas las citas aunque no tengan médico asignado.
SELECT m.nombre as medico, c.id_cita FROM medico m

RIGHT JOIN atiende a
	ON m.id_medico = a.id_medico
RIGHT JOIN cita c
	ON a.id_cita = c.id_cita;

-- 8) HAVING: Mostrar pacientes con más de una cita.
SELECT *, count(p.id_paciente) qty_Citas FROM paciente p 
inner join cita c
	On p.id_paciente = c.id_paciente
GROUP by p.nombre
having qty_Citas>1;

-- 9) MIN: Mostrar la cita más antigua.
SELECT * FROM `cita`
ORDER BY fecha ASC
limit 1;

-- 10) MAX: Mostrar la cita más reciente.
SELECT * FROM `cita`
ORDER BY fecha ASC
limit 1;

-- 11) AVG sencillo: Calcular promedio de citas por paciente.
-- esta es un poco más complicada 
SELECT AVG(qty_Citas)
FROM (
        SELECT count(p.id_paciente) qty_Citas FROM paciente p 
        inner join cita c
            On p.id_paciente = c.id_paciente
        GROUP by p.nombre
    ) t;

-- 12) JOIN con tratamiento: Mostrar id de cita y descripción del tratamiento.
SELECT c.id_cita, t.descripcion FROM cita c
INNER JOIN incluye i  
	ON c.id_cita = i.id_cita
INNER JOIN tratamiento t 
	ON i.id_tratamiento = t.id_tratamiento;


