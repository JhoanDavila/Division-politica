-- 1. Crear la tabla Moneda si no existe
CREATE TABLE IF NOT EXISTS Moneda (
    Id SERIAL PRIMARY KEY,
    Moneda VARCHAR(50) NOT NULL,
    Sigla VARCHAR(10),
    Imagen TEXT
);

-- 2. Agregar columna IdMoneda a Pais si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'pais' AND column_name = 'idmoneda'
    ) THEN
        ALTER TABLE Pais ADD COLUMN IdMoneda INTEGER;
    END IF;
END $$;

-- 3. Insertar monedas distintas en Moneda desde Pais.Moneda (si la columna existe)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'pais' AND column_name = 'moneda'
    ) THEN
        INSERT INTO Moneda (Moneda)
        SELECT DISTINCT Moneda
        FROM Pais
        WHERE Moneda IS NOT NULL
          AND Moneda NOT IN (SELECT Moneda FROM Moneda);
    END IF;
END $$;

-- 4. Actualizar IdMoneda en Pais relacionándolo con Moneda
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'pais' AND column_name = 'moneda'
    ) THEN
        UPDATE Pais
        SET IdMoneda = M.Id
        FROM Moneda M
        WHERE Pais.Moneda = M.Moneda;
    END IF;
END $$;

-- 5. Agregar restricción FOREIGN KEY fkPais_IdMoneda (solo si no existe)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_name = 'pais' 
          AND constraint_type = 'FOREIGN KEY'
          AND constraint_name = 'fkpais_idmoneda'
    ) THEN
        ALTER TABLE Pais
        ADD CONSTRAINT fkPais_IdMoneda
        FOREIGN KEY (IdMoneda)
        REFERENCES Moneda(Id);
    END IF;
END $$;

-- 6. Eliminar la columna antigua Moneda de Pais (si existe)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'pais' AND column_name = 'moneda'
    ) THEN
        ALTER TABLE Pais DROP COLUMN Moneda;
    END IF;
END $$;

-- 7. Agregar columna Mapa a Pais si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'pais' AND column_name = 'mapa'
    ) THEN
        ALTER TABLE Pais ADD COLUMN Mapa TEXT;
    END IF;
END $$;

-- 8. Agregar columna Bandera a Pais si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'pais' AND column_name = 'bandera'
    ) THEN
        ALTER TABLE Pais ADD COLUMN Bandera TEXT;
    END IF;
END $$;