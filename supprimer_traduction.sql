create
    definer = avnadmin@`%` procedure supprimer_traduction(IN p_id_traduction INT)
BEGIN
    DECLARE v_id_francais INT DEFAULT NULL;
    DECLARE v_id_russe INT DEFAULT NULL;
    DECLARE v_mot_francais VARCHAR(255) DEFAULT NULL;
    DECLARE v_mot_russe VARCHAR(255) DEFAULT NULL;

    -- 1) Récupérer la traduction existante
    SELECT t.id_francais, t.id_russe, mf.mot_francais, mr.mot_russe
    INTO v_id_francais, v_id_russe, v_mot_francais, v_mot_russe
    FROM traductions t
    JOIN mots_francais mf ON t.id_francais = mf.id_francais
    JOIN mots_russes mr ON t.id_russe = mr.id_russe
    WHERE t.id_traduction = p_id_traduction
    LIMIT 1;

    IF v_id_francais IS NULL OR v_id_russe IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Traduction introuvable pour l id_traduction fourni';
    END IF;

    -- 2) Supprimer la traduction
    DELETE FROM traductions
    WHERE id_traduction = p_id_traduction;

    -- 3) Retourner les informations de la traduction supprimée
    SELECT p_id_traduction AS id_traduction,
           v_id_francais AS id_francais,
           v_id_russe AS id_russe,
           v_mot_francais AS mot_francais,
           v_mot_russe AS mot_russe,
           'Traduction supprimee' AS message;

END;

