--Apartado 1
CREATE OR REPLACE TYPE MiembroEscolar AS OBJECT(
    codigo INTEGER, 
    dni VARCHAR2(10),
    nombre VARCHAR2(30),
    apellidos VARCHAR2(30),
    sexo VARCHAR2(1),
    fecha_nac DATE
)NOT FINAL;
/
CREATE OR REPLACE TYPE Profesor UNDER MiembroEscolar(
    especialidad VARCHAR2(20),
    antiguedad INTEGER,
    
    CONSTRUCTOR FUNCTION Profesor(codigo INTEGER, nombre VARCHAR2, apellido1 VARCHAR2,
    apellido2 VARCHAR2, especialidad VARCHAR2)
    RETURN SELF AS RESULT,
    
    MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2

);
/
--Apartado 2
CREATE OR REPLACE TYPE BODY Profesor AS
CONSTRUCTOR FUNCTION Profesor(codigo INTEGER, nombre VARCHAR2, apellido1 VARCHAR2,
    apellido2 VARCHAR2, especialidad VARCHAR2)
    RETURN SELF AS RESULT IS
        BEGIN
            self.codigo := codigo;
            self.nombre := nombre;
            --Unión de apellidos con un espacio entre ellos
            self.apellidos := apellido1 || ' ' || apellido2;
            self.especialidad := especialidad;
            RETURN;
            END;
            --Apartado 3
        MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2 IS
        BEGIN
            RETURN self.nombre || ' ' || self.apellidos;
            END;
        
        END;
/        

CREATE OR REPLACE TYPE Cursos AS OBJECT(
    codigo INTEGER,
    nombre VARCHAR2(20),
    refProfe REF Profesor,
    max_Alumn INTEGER,
    fecha_Inic DATE,
    fecha_Fin DATE,
    num_Horas INTEGER,
    
    --apartado 8
    MAP MEMBER FUNCTION OrdenarCursos RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY Cursos AS
    MAP MEMBER FUNCTION OrdenarCursos RETURN VARCHAR2 IS
    profe Profesor;
    BEGIN
        SELECT DEREF (refProfe) INTO profe FROM DUAL;
        RETURN profe.getNombreCompleto();
        END;
    END;
/


CREATE OR REPLACE TYPE Alumno UNDER MiembroEscolar(
    cursoAlumno Cursos
);    
/
CREATE TABLE Profesorado OF Profesor; --Apartado 4 parte 1
/
CREATE TYPE ListaCursos AS VARRAY(10) OF Cursos; --Apartado5 parte1
/
CREATE TABLE alumnado OF Alumno; --Apartado6
/
DECLARE ListaCursos1 ListaCursos;

    Curso1 Cursos;
    Curso2 Cursos;
    
    profe REF Profesor;
    
    unAlumno Alumno;
BEGIN  --Apartado4 Parte2
    INSERT INTO Profesorado VALUES (Profesor(2,'51083099F','MARIA LUISA','FABRE BERDUN','F','31-03-1975','TECNOLOGIA',4));
    INSERT INTO Profesorado VALUES (NEW Profesor(3,'JAVIER','JIMENEZ','HERNANDO','LENGUA'));
    --Apartado5
    SELECT REF(p) INTO profe FROM profesorado p WHERE p.codigo = 3;
    Curso1 := new Cursos(1,'Curso1',profe,20,'01-06-2011','30-06-2011',30);
    
    SELECT REF(p) INTO profe FROM profesorado p WHERE p.dni = '51083099F';
    Curso2 := new Cursos(2,'Curso2',profe,20,'01-06-2011','30-06-2011',30);
   
    listacursos1 := ListaCursos(Curso1,Curso2);
    --Apartado6
    INSERT INTO alumnado VALUES (alumno(100,'76401092Z','MANUEL','SUAREZ IBAÑEZ','M','30-06-1990',listacursos1(1)));
    INSERT INTO alumnado VALUES (alumno(102,'6915588V','MILAGROSA','DIAZ PEREZ','F','28/10/1984',listacursos1(2)));
--Obtener el alumno del apartado 7
SELECT VALUE (a) INTO unAlumno FROM alumnado a WHERE a.codigo = 100;

unAlumno.codigo := 101;
unAlumno.cursoAlumno := listacursos1(2);
--Modificar alumno apartado 7
INSERT INTO alumnado VALUES (unAlumno);


END;    
/
--Realiza una consulta de la tabla "Alumnado" ordenada por "cursoAlumno" para comprobar el funcionamiento del método MAP.
SELECT * FROM alumnado ORDER BY cursoAlumno;