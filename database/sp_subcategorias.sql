CREATE VIEW v_subcategoria AS
	SELECT 
		SUB.idsubcategoria,
        CAT.categoria,
        SUB.subcategoria
        FROM subcategorias SUB RIGHT JOIN categorias CAT
        ON SUB.idcategoria = CAT.idcategoria
        ORDER BY SUB.idsubcategoria ASC;
        
-- SELECT * FROM v_subcategoria;