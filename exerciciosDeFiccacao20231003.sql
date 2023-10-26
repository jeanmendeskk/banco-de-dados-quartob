-- exercicio 1

DELIMITER //
CREATE FUNCTION total_livros_por_genero(genero_nome VARCHAR(255)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;
    DECLARE cur CURSOR FOR
    SELECT Livro.id
    FROM Livro
    INNER JOIN Genero ON Livro.id_genero = Genero.id
    WHERE Genero.nome_genero = genero_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO livro_id;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        SET total = total + 1;
    END LOOP;
    CLOSE cur;
    RETURN total;
END //
DELIMITER ;

-- exercicio 2

DELIMITER //
CREATE FUNCTION listar_livros_por_autor(first_name VARCHAR(255), last_name VARCHAR(255)) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE lista_livros TEXT DEFAULT '';
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;
    DECLARE livro_titulo VARCHAR(255);
    DECLARE cur CURSOR FOR
    SELECT Livro_Autor.id_livro
    FROM Livro_Autor
    INNER JOIN Autor ON Livro_Autor.id_autor = Autor.id
    WHERE Autor.primeiro_nome = first_name AND Autor.ultimo_nome = last_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO livro_id;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        SELECT titulo INTO livro_titulo FROM Livro WHERE id = livro_id;
        SET lista_livros = CONCAT(lista_livros, livro_titulo, ', ');
    END LOOP;
    CLOSE cur;
    IF LENGTH(lista_livros) > 0 THEN
        SET lista_livros = LEFT(lista_livros, LENGTH(lista_livros) - 2);
    END IF;
    RETURN lista_livros;
END //
DELIMITER ;

-- exercicio 3

DELIMITER //
CREATE FUNCTION listar_livros_por_autor(first_name VARCHAR(255), last_name VARCHAR(255)) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE lista_livros TEXT DEFAULT '';
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;
    DECLARE livro_titulo VARCHAR(255);
    DECLARE cur CURSOR FOR
    SELECT Livro_Autor.id_livro
    FROM Livro_Autor
    INNER JOIN Autor ON Livro_Autor.id_autor = Autor.id
    WHERE Autor.primeiro_nome = first_name AND Autor.ultimo_nome = last_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO livro_id;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        SELECT titulo INTO livro_titulo FROM Livro WHERE id = livro_id;
        SET lista_livros = CONCAT(lista_livros, livro_titulo, ', ');
    END LOOP;
    CLOSE cur;
    IF LENGTH(lista_livros) > 0 THEN
        SET lista_livros = LEFT(lista_livros, LENGTH(lista_livros) - 2);
    END IF;
    RETURN lista_livros;
END //
DELIMITER ;

-- exercicio 4

DELIMITER //
CREATE FUNCTION media_livros_por_editora() RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_editoras INT DEFAULT 0;
    DECLARE total_livros INT DEFAULT 0;
    DECLARE contador_editoras INT DEFAULT 0;
	DECLARE editora_id INT;
    DECLARE cur_editoras CURSOR FOR
    SELECT id, nome_editora
    FROM Editora;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET total_editoras = -1;
    OPEN cur_editoras;
    editoras_loop: LOOP
        FETCH cur_editoras INTO editora_id;
        IF total_editoras = -1 THEN
            LEAVE editoras_loop;
        END IF;
        SELECT COUNT(*) INTO total_livros FROM Livro WHERE id_editora = editora_id;
        SET total_editoras = total_editoras + total_livros;
        SET contador_editoras = contador_editoras + 1;
    END LOOP;
    CLOSE cur_editoras;
    IF contador_editoras > 0 THEN
        RETURN total_editoras / contador_editoras;
    ELSE
        RETURN 0;
    END IF;
END //
DELIMITER ;

-- exercicio 5

DELIMITER //
CREATE FUNCTION autores_sem_livros() RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE lista_autores TEXT DEFAULT '';
    DECLARE done INT DEFAULT 0;
    DECLARE autor_id INT;
    DECLARE autor_nome VARCHAR(255);
    DECLARE cur_autores CURSOR FOR
    SELECT id, CONCAT(primeiro_nome, ' ', ultimo_nome) AS nome_completo
    FROM Autor;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur_autores;
    autores_loop: LOOP
        FETCH cur_autores INTO autor_id, autor_nome;
        IF done = 1 THEN
            LEAVE autores_loop;
        END IF;
        IF NOT EXISTS (SELECT 1 FROM Livro_Autor WHERE id_autor = autor_id) THEN
            SET lista_autores = CONCAT(lista_autores, autor_nome, ', ');
        END IF;
    END LOOP;
    CLOSE cur_autores;
    IF LENGTH(lista_autores) > 0 THEN
        SET lista_autores = LEFT(lista_autores, LENGTH(lista_autores) - 2);
    END IF;
    RETURN lista_autores;
END //
DELIMITER ;