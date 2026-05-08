DELIMITER $$

CREATE PROCEDURE creer_traduction(
    IN p_mot_francais VARCHAR(255),
    IN p_mot_russe VARCHAR(255)
)
BEGIN
    DECLARE v_id_francais INT;
    DECLARE v_id_russe INT;
    DECLARE v_id_traduction INT;

    START TRANSACTION;

    -- Insérer le mot français
    INSERT INTO mots_francais (mot_francais) VALUES (p_mot_francais);
    SET v_id_francais = LAST_INSERT_ID();

    -- Insérer le mot russe
    INSERT INTO mots_russes (mot_russe) VALUES (p_mot_russe);
    SET v_id_russe = LAST_INSERT_ID();

    -- Créer la relation
    INSERT INTO traductions (id_francais, id_russe) VALUES (v_id_francais, v_id_russe);
    SET v_id_traduction = LAST_INSERT_ID();

    COMMIT;

    -- Afficher les résultats avec l'id_traduction
    SELECT v_id_traduction AS id_traduction,
           v_id_francais AS id_francais,
           v_id_russe AS id_russe,
           'Traduction créée avec succès' AS message;
END$$

DELIMITER ;
