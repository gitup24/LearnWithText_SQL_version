-- Définition des variables
SET @id_traduction_a_modifier = 1; -- Remplacez par l'ID de la traduction à modifier
SET @nouveau_mot_russe = 'do svidania'; -- Remplacez par le nouveau mot russe

-- 1. Récupération de l'ID du mot russe associé à l'ID de la traduction
SET @id_russe_associe = (
    SELECT id_russe
    FROM traductions
    WHERE id_russe = @id_traduction_a_modifier
);

-- 2. Mise à jour du mot russe dans la table 'mots_russes'
UPDATE mots_russes
SET mot_russe = @nouveau_mot_russe
WHERE id_russe = @id_russe_associe;

-- 3. Vérification du résultat

