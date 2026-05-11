DELIMITER //

CREATE PROCEDURE creer_traduction(
    IN p_mot_francais VARCHAR(255),
    IN p_mot_russe VARCHAR(255)
)
BEGIN
    DECLARE v_id_francais INT DEFAULT NULL;
    DECLARE v_id_russe INT DEFAULT NULL;
    DECLARE v_id_traduction INT DEFAULT NULL;
    DECLARE v_traduction_existe INT DEFAULT 0;

    SELECT id_francais
    INTO v_id_francais
    FROM mots_francais
    WHERE mot_francais = p_mot_francais
    LIMIT 1;

    IF v_id_francais IS NULL THEN
        INSERT INTO mots_francais (mot_francais)
        VALUES (p_mot_francais);

        SET v_id_francais = LAST_INSERT_ID();
    END IF;

    SELECT id_russe
    INTO v_id_russe
    FROM mots_russes
    WHERE mot_russe = p_mot_russe
    LIMIT 1;

    IF v_id_russe IS NULL THEN
        INSERT INTO mots_russes (mot_russe)
        VALUES (p_mot_russe);

        SET v_id_russe = LAST_INSERT_ID();
    END IF;

    SELECT COUNT(*)
    INTO v_traduction_existe
    FROM traductions
    WHERE id_francais = v_id_francais
      AND id_russe = v_id_russe;

    IF v_traduction_existe = 0 THEN
        INSERT INTO traductions (id_francais, id_russe)
        VALUES (v_id_francais, v_id_russe);

        SET v_id_traduction = LAST_INSERT_ID();

        SELECT 'Traduction créée' AS message,
               v_id_traduction AS id_traduction,
               v_id_francais AS id_francais,
               v_id_russe AS id_russe;
    ELSE
        SELECT id_traduction
        INTO v_id_traduction
        FROM traductions
        WHERE id_francais = v_id_francais
          AND id_russe = v_id_russe
        LIMIT 1;

        SELECT 'Traduction déjà existante' AS message,
               v_id_traduction AS id_traduction,
               v_id_francais AS id_francais,
               v_id_russe AS id_russe;
    END IF;
END //

DELIMITER ;
