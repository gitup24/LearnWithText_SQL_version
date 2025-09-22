DELIMITER $$

CREATE PROCEDURE inserer_traduction(
    IN p_mot_francais VARCHAR(255),
    IN p_mot_russe VARCHAR(255)
)
BEGIN
    DECLARE v_id_francais INT;
    DECLARE v_id_russe INT;

    START TRANSACTION;

    -- Insérer le mot français
    INSERT INTO mots_francais (mot_francais) VALUES (p_mot_francais);
    SET v_id_francais = LAST_INSERT_ID();

    -- Insérer le mot russe
    INSERT INTO mots_russes (mot_russe) VALUES (p_mot_russe);
    SET v_id_russe = LAST_INSERT_ID();

    -- Insérer la relation
    INSERT INTO traductions (id_francais, id_russe) VALUES (v_id_francais, v_id_russe);

    COMMIT;

    -- Afficher la vue pour vérifier la nouvelle entrée
    SELECT * FROM vue_traductions_fr_ru;
END$$

DELIMITER ;

