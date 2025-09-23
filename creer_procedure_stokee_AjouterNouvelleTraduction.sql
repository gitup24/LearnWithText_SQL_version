DELIMITER $$

CREATE PROCEDURE `AjouterNouvelleTraduction`(
    IN p_mot_francais VARCHAR(255),
    IN p_mot_russe VARCHAR(255)
)
BEGIN
    DECLARE v_id_francais INT;
    DECLARE v_id_russe INT;

    -- ÉTAPE 1: Gérer le mot français
    -- Cherche si le mot existe déjà pour récupérer son ID
    SELECT mots_francais.id_francais INTO v_id_francais FROM mots_francais WHERE mots_francais.mot_francais = p_mot_francais LIMIT 1;

    -- S'il n'existe pas (l'ID est NULL), on l'insère
    IF v_id_francais IS NULL THEN
        -- Calcule le prochain ID disponible et insère le mot
        INSERT INTO mots_francais (mots_francais.id_francais, mots_francais.mot_francais)
        SELECT (SELECT COALESCE(MAX(id_francais), 0) + 1 FROM mots_francais AS temp_mf), p_mot_francais;
        -- Récupère l'ID du mot que l'on vient d'insérer
        SELECT mots_francais.id_francais INTO v_id_francais FROM mots_francais WHERE mots_francais.mot_francais = p_mot_francais LIMIT 1;
    END IF;

    -- ÉTAPE 2: Gérer le mot russe (même logique)
    SELECT mots_russes.id_russe INTO v_id_russe FROM mots_russes WHERE mots_russes.mot_russe = p_mot_russe LIMIT 1;

    IF v_id_russe IS NULL THEN
        INSERT INTO mots_russes (mots_russes.id_russe, mots_russes.mot_russe)
        SELECT (SELECT COALESCE(MAX(id_russe), 0) + 1 FROM mots_russes AS temp_mr), p_mot_russe;
        SELECT mots_russes.id_russe INTO v_id_russe FROM mots_russes WHERE mots_russes.mot_russe = p_mot_russe LIMIT 1;
    END IF;

    -- ÉTAPE 3: Insérer le lien de traduction (s'il n'existe pas déjà)
    -- On vérifie que cette paire d'IDs n'est pas déjà dans la table des traductions
    IF NOT EXISTS (SELECT 1 FROM traductions WHERE id_francais = v_id_francais AND id_russe = v_id_russe) THEN
        INSERT INTO traductions (traductions.id_traduction, traductions.id_francais, traductions.id_russe)
        SELECT (SELECT COALESCE(MAX(id_traduction), 0) + 1 FROM traductions AS temp_t), v_id_francais, v_id_russe;
    END IF;

END$$

DELIMITER ;
