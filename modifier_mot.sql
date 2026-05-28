-- modifier_mot.sql
-- Détecte automatiquement la langue du mot d'origine (francais ou russe)
-- et remplace la valeur trouvée par la nouvelle valeur fournie.
-- Si le même mot d'origine existe dans les deux tables, la procédure signale une erreur d'ambiguïté.
-- Usage : CALL modifier_mot('mot_origine', 'mot_nouveau');

create
    definer = avnadmin@`%` procedure modifier_mot(
        IN p_mot_origine VARCHAR(255),
        IN p_mot_nouveau VARCHAR(255)
)
BEGIN
    DECLARE v_id_fr INT DEFAULT NULL;
    DECLARE v_old_fr VARCHAR(255) DEFAULT NULL;
    DECLARE v_id_ru INT DEFAULT NULL;
    DECLARE v_old_ru VARCHAR(255) DEFAULT NULL;
    DECLARE v_count INT DEFAULT 0;

    -- Bloc principal (labelisé) pour permettre LEAVE en sortie sans utiliser RETURN
    main_block: BEGIN

    -- Validation des paramètres
    IF p_mot_origine = '' OR p_mot_nouveau = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parametres invalides : p_mot_origine et p_mot_nouveau doivent etre non vides';
    END IF;

    -- Vérifier existence dans mots_francais (comparaison entière, insensible à la casse)
    SELECT id_francais, mot_francais
    INTO v_id_fr, v_old_fr
    FROM mots_francais
    WHERE TRIM(mot_francais) COLLATE utf8mb4_unicode_ci = TRIM(p_mot_origine) COLLATE utf8mb4_unicode_ci
    LIMIT 1;

    -- Vérifier existence dans mots_russes (comparaison entière, insensible à la casse)
    SELECT id_russe, mot_russe
    INTO v_id_ru, v_old_ru
    FROM mots_russes
    WHERE TRIM(mot_russe) COLLATE utf8mb4_unicode_ci = TRIM(p_mot_origine) COLLATE utf8mb4_unicode_ci
    LIMIT 1;

    -- Cas : mot trouvé dans les deux tables -> ambiguïté
    IF v_id_fr IS NOT NULL AND v_id_ru IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mot present dans les deux tables, veuillez preciser la langue';
    END IF;

    -- Cas : mot français
    IF v_id_fr IS NOT NULL THEN
        -- Vérifier que le nouveau mot n'existe pas déjà en français (comparaison entière, insensible à la casse)
        SELECT COUNT(*) INTO v_count FROM mots_francais WHERE TRIM(mot_francais) COLLATE utf8mb4_unicode_ci = TRIM(p_mot_nouveau) COLLATE utf8mb4_unicode_ci;
        IF v_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Le nouveau mot francais existe deja';
        END IF;

        -- Mettre à jour
        UPDATE mots_francais
        SET mot_francais = p_mot_nouveau
        WHERE id_francais = v_id_fr;

        -- Retourner le résultat puis quitter la procédure
        SELECT v_id_fr AS id_mot_origine,
               v_old_fr AS mot_origine,
               p_mot_nouveau AS mot_nouveau;

        LEAVE main_block;
    END IF;

    -- Cas : mot russe
    IF v_id_ru IS NOT NULL THEN
        -- Vérifier que le nouveau mot n'existe pas déjà en russe (comparaison entière, insensible à la casse)
        SELECT COUNT(*) INTO v_count FROM mots_russes WHERE TRIM(mot_russe) COLLATE utf8mb4_unicode_ci = TRIM(p_mot_nouveau) COLLATE utf8mb4_unicode_ci;
        IF v_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Le nouveau mot russe existe deja';
        END IF;

        -- Mettre à jour
        UPDATE mots_russes
        SET mot_russe = p_mot_nouveau
        WHERE id_russe = v_id_ru;

        -- Retourner le résultat puis quitter la procédure
        SELECT v_id_ru AS id_mot_origine,
               v_old_ru AS mot_origine,
               p_mot_nouveau AS mot_nouveau;

        LEAVE main_block;
    END IF;

    -- Si le mot n'existe dans aucune table
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mot d origine introuvable dans mots_francais ni dans mots_russes';

    END main_block;

END;

