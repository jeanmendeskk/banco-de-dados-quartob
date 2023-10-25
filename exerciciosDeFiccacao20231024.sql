-- exercicio 1

CREATE TRIGGER inserirCliente AFTER INSERT ON Clientes
FOR EACH ROW INSERT INTO Auditoria VALUES (null, 'Novo cliente Registrado', NOW());

-- exercicio 2 

CREATE TRIGGER tentativaExclusao BEFORE DELETE ON Clientes
FOR EACH ROW INSERT INTO Auditoria VALUES (null, 'Tentaram excluir um cliente', NOW());

-- exercicio 3 

CREATE TRIGGER updateCliente AFTER UPDATE ON Clientes
FOR EACH ROW INSERT INTO Auditoria VALUES (null, 'Atualizaram os dados de um cliente', NOW());

-- exercicio 4

select * from Auditoria;

DELIMITER //
CREATE TRIGGER updateInvalido BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        INSERT INTO Auditoria VALUES (null, 'Update de cliente invalido', NOW());
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O Nome não será atualizado, pois é invalido';
    END IF;
END;
//
DELIMITER ;

-- exercicio 5

DELIMITER //
CREATE TRIGGER pedidosEEstoque AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE novo_estoque INT;
    SELECT estoque - NEW.quantidade INTO novo_estoque
    FROM Produtos
    WHERE id = NEW.produto_id;
    UPDATE Produtos
    SET estoque = novo_estoque
    WHERE id = NEW.produto_id;
    IF novo_estoque < 5 THEN
        INSERT INTO Auditoria VALUES (null, 'Estoque de um produto abaixo de 5', NOW());
    END IF;
END;
//
DELIMITER;