-- On change le délimiteur pour pouvoir utiliser le point-virgule ';' à l'intérieur de la procédure.
DELIMITER $$

-- Création de la procédure qui va contenir la logique de la boucle
CREATE PROCEDURE InsererToutesLesTraductions()
BEGIN
    -- Déclaration des variables pour stocker les mots de la ligne en cours
    DECLARE v_mot_francais VARCHAR(255);
    DECLARE v_mot_russe VARCHAR(255);
    
    -- Variable pour détecter la fin du curseur
    DECLARE fin_curseur INT DEFAULT FALSE;

    -- Déclaration du curseur pour parcourir toutes les lignes de la table temp_traductions
    DECLARE curseur_traductions CURSOR FOR 
        SELECT mot_francais, mot_russe FROM temp_traductions;

    -- Déclaration d'un "gestionnaire" (handler) qui s'activera quand le curseur n'aura plus de lignes à lire
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin_curseur = TRUE;

    -- Ouverture du curseur pour commencer la lecture
    OPEN curseur_traductions;

    -- Début de la boucle qui va lire chaque ligne
    boucle_lecture: LOOP
        -- Récupération des données de la ligne actuelle dans les variables déclarées
        FETCH curseur_traductions INTO v_mot_francais, v_mot_russe;

        -- Si la variable fin_curseur est TRUE, cela signifie qu'on a lu toutes les lignes, donc on quitte la boucle
        IF fin_curseur THEN
            LEAVE boucle_lecture;
        END IF;

        -- Appel de la procédure stockée pour chaque paire de mots
        -- On ajoute une condition pour s'assurer que les mots ne sont pas vides avant de les insérer
        IF v_mot_francais IS NOT NULL AND v_mot_francais != '' AND v_mot_russe IS NOT NULL AND v_mot_russe != '' THEN
            CALL AjouterNouvelleTraduction(v_mot_francais, v_mot_russe);
        END IF;

    END LOOP;

    -- Fermeture du curseur
    CLOSE curseur_traductions;

END$$

-- On réinitialise le délimiteur par défaut
DELIMITER ;

-- Exécution de la procédure pour démarrer l'insertion de toutes les traductions
CALL InsererToutesLesTraductions();
