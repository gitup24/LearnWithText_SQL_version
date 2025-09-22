-- Définition des variables
SET @id_francais_a_modifier = 1; -- Remplacez par l'ID du mot français que vous voulez modifier
SET @nouveau_mot_francais = 'poisson';
SET @nouveau_mot_russe = 'riba';

-- 1. Mise à jour du mot français
UPDATE mots_francais
SET mot_francais = @nouveau_mot_francais
WHERE id_francais = @id_francais_a_modifier;

-- 2. Récupération de l'ID du mot russe associé
SET @id_russe_associe = (
    SELECT id_russe
    FROM traductions
    WHERE id_francais = @id_francais_a_modifier
);

-- 3. Mise à jour du mot russe
UPDATE mots_russes
SET mot_russe = @nouveau_mot_russe
WHERE id_russe = @id_russe_associe;

-- 4. Vérification du résultat
SELECT * FROM traductions WHERE id_francais = @id_francais_a_modifier;
