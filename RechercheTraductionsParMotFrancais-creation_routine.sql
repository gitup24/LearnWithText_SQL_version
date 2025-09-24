DELIMITER //

CREATE PROCEDURE RechercherTraductionsParMotFrancais(
    IN recherche_francais VARCHAR(255)
)
BEGIN
    SELECT
        mf.mot_francais,
        mr.mot_russe
    FROM
        traductions t
            JOIN
        mots_francais mf ON t.id_francais = mf.id_francais
            JOIN
        mots_russes mr ON t.id_russe = mr.id_russe
    WHERE
        mf.mot_francais REGEXP recherche_francais;
END //

DELIMITER ;
