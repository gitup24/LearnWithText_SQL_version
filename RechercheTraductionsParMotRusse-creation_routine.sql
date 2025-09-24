DELIMITER //

CREATE PROCEDURE RechercherTraductionsParMotRusse(
    IN recherche_russe VARCHAR(255)
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
        mr.mot_russe REGEXP recherche_russe;
END //

DELIMITER ;
