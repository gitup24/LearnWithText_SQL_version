create
    definer = avnadmin@`%` procedure modifier_traduction(
        IN p_id_traduction INT,
        IN p_mot_francais VARCHAR(255),
        IN p_mot_russe VARCHAR(255)
)
BEGIN
    DECLARE v_id_francais INT DEFAULT NULL;
    DECLARE v_id_russe INT DEFAULT NULL;
    DECLARE v_new_id_francais INT DEFAULT NULL;
    DECLARE v_new_id_russe INT DEFAULT NULL;
    DECLARE v_traduction_existe INT DEFAULT 0;

    -- 1) Validation des paramètres : exactement un des deux mots doit être fourni
    IF (p_mot_francais = '' AND p_mot_russe = '') OR (p_mot_francais <> '' AND p_mot_russe <> '') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parametres invalides : fournir exactement un mot a modifier (francais ou russe)';
    END IF;

    -- 2) Récupérer la traduction existante
    SELECT id_francais, id_russe
    INTO v_id_francais, v_id_russe
    FROM traductions
    WHERE id_traduction = p_id_traduction
    LIMIT 1;

    IF v_id_francais IS NULL OR v_id_russe IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Traduction introuvable pour l id_traduction fourni';
    END IF;

    -- 3) Cas : modification du mot francais
    IF p_mot_francais <> '' THEN
        -- chercher si le mot francais existe déjà
        SELECT id_francais INTO v_new_id_francais FROM mots_francais WHERE mot_francais = p_mot_francais LIMIT 1;

        IF v_new_id_francais IS NULL THEN
            INSERT INTO mots_francais (mot_francais) VALUES (p_mot_francais);
            SET v_new_id_francais = LAST_INSERT_ID();
        END IF;

        -- Vérifier qu'il n'existe pas déjà une traduction avec (nouveau id_francais, id_russe courant)
        SELECT COUNT(*) INTO v_traduction_existe
        FROM traductions
        WHERE id_francais = v_new_id_francais
          AND id_russe = v_id_russe
          AND id_traduction <> p_id_traduction;

        IF v_traduction_existe > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Une traduction identique existe deja pour ce mot francais et ce mot russe';
        END IF;

        -- Mettre à jour la traduction
        UPDATE traductions
        SET id_francais = v_new_id_francais
        WHERE id_traduction = p_id_traduction;

    ELSE
        -- 4) Cas : modification du mot russe
        SELECT id_russe INTO v_new_id_russe FROM mots_russes WHERE mot_russe = p_mot_russe LIMIT 1;

        IF v_new_id_russe IS NULL THEN
            INSERT INTO mots_russes (mot_russe) VALUES (p_mot_russe);
            SET v_new_id_russe = LAST_INSERT_ID();
        END IF;

        -- Vérifier qu'il n'existe pas déjà une traduction avec (id_francais courant, nouveau id_russe)
        SELECT COUNT(*) INTO v_traduction_existe
        FROM traductions
        WHERE id_francais = v_id_francais
          AND id_russe = v_new_id_russe
          AND id_traduction <> p_id_traduction;

        IF v_traduction_existe > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Une traduction identique existe deja pour ce mot francais et ce mot russe';
        END IF;

        -- Mettre à jour la traduction
        UPDATE traductions
        SET id_russe = v_new_id_russe
        WHERE id_traduction = p_id_traduction;
    END IF;

    -- 5) Retourner la traduction modifiee (ids et mots)
    SELECT t.id_traduction,
           t.id_francais,
           t.id_russe,
           mf.mot_francais,
           mr.mot_russe,
           'Traduction modifiee' AS message
    FROM traductions t
    JOIN mots_francais mf ON t.id_francais = mf.id_francais
    JOIN mots_russes mr ON t.id_russe = mr.id_russe
    WHERE t.id_traduction = p_id_traduction;

END;

