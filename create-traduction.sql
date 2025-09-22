-- Démarre une transaction pour s'assurer que toutes les opérations réussissent ou échouent ensemble
START TRANSACTION;

-- Insérer le mot français et stocker son ID
INSERT INTO mots_francais (mot_francais) VALUES ('rat');
SET @id_francais = LAST_INSERT_ID();

-- Insérer le mot russe et stocker son ID
INSERT INTO mots_russes (mot_russe) VALUES ('cris');
SET @id_russe = LAST_INSERT_ID();

-- Insérer la relation dans la table de traductions
INSERT INTO traductions (id_francais, id_russe) VALUES (@id_francais, @id_russe);

-- Valider la transaction si tout s'est bien passé
COMMIT;

-- Afficher la vue pour vérifier la nouvelle entrée
SELECT * FROM vue_traductions_fr_ru;

-- Afficher la vue avec les deux entrées
SELECT * FROM vue_traductions_fr_ru;
