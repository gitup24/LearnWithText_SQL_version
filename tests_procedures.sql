-- ===========================================================================================
-- FICHIER DE TESTS POUR LES PROCÉDURES CRUD
-- Tests pour creer_traduction, modifier_traduction, supprimer_traduction
-- ===========================================================================================

-- ===========================================================================================
-- SECTION 1 : PRÉPARATION ET NETTOYAGE DES DONNÉES
-- ===========================================================================================

-- Créer les tables si elles n'existent pas
CREATE TABLE IF NOT EXISTS mots_francais (
    id_francais INT PRIMARY KEY AUTO_INCREMENT,
    mot_francais VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS mots_russes (
    id_russe INT PRIMARY KEY AUTO_INCREMENT,
    mot_russe VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS traductions (
    id_traduction INT PRIMARY KEY AUTO_INCREMENT,
    id_francais INT NOT NULL,
    id_russe INT NOT NULL,
    FOREIGN KEY (id_francais) REFERENCES mots_francais(id_francais),
    FOREIGN KEY (id_russe) REFERENCES mots_russes(id_russe),
    UNIQUE KEY unique_traduction (id_francais, id_russe)
);

-- Nettoyer les données existantes pour les tests
DELETE FROM traductions;
DELETE FROM mots_francais;
DELETE FROM mots_russes;
ALTER TABLE mots_francais AUTO_INCREMENT = 1;
ALTER TABLE mots_russes AUTO_INCREMENT = 1;
ALTER TABLE traductions AUTO_INCREMENT = 1;

-- ===========================================================================================
-- SECTION 2 : TESTS POUR CREER_TRADUCTION
-- ===========================================================================================

SELECT '=== TEST 1 : creer_traduction - Créer une nouvelle traduction ===' AS test_description;
CALL creer_traduction('beau', 'красивый');

SELECT '=== TEST 2 : creer_traduction - Créer une autre nouvelle traduction ===' AS test_description;
CALL creer_traduction('joli', 'миленький');

SELECT '=== TEST 3 : creer_traduction - Ajouter une traduction déjà existante (pas de doublon) ===' AS test_description;
CALL creer_traduction('beau', 'красивый');

SELECT '=== TEST 4 : creer_traduction - Utiliser un mot français existant avec un nouveau mot russe ===' AS test_description;
CALL creer_traduction('beau', 'прекрасный');

SELECT '=== TEST 5 : creer_traduction - Afficher toutes les traductions créées ===' AS test_description;
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe;

-- ===========================================================================================
-- SECTION 3 : TESTS POUR MODIFIER_TRADUCTION
-- ===========================================================================================

SELECT '=== TEST 6 : modifier_traduction - Modifier le mot français (cas succès) ===' AS test_description;
-- On modifie la traduction 1 : remplacer "beau" par "joli_modifie"
CALL modifier_traduction(1, 'beau_modifie', '');

SELECT '=== TEST 7 : modifier_traduction - Vérifier la modification ===' AS test_description;
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
WHERE t.id_traduction = 1;

SELECT '=== TEST 8 : modifier_traduction - Modifier le mot russe (cas succès) ===' AS test_description;
-- On modifie la traduction 2 : remplacer "миленький" par "милаya"
CALL modifier_traduction(2, '', 'милая');

SELECT '=== TEST 9 : modifier_traduction - Vérifier la modification du mot russe ===' AS test_description;
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
WHERE t.id_traduction = 2;

-- ===========================================================================================
-- SECTION 3B : TESTS POUR MODIFIER_MOT
-- ===========================================================================================

SELECT '=== TEST M1 : modifier_mot - Renommer un mot francais (cas succès) ===' AS test_description;
-- Renommer 'joli' en 'joli_mod'
CALL modifier_mot('F', 'joli', 'joli_mod');

SELECT '=== VERIF M1 : vérifier renommage mot français ===' AS test_description;
SELECT id_francais, mot_francais FROM mots_francais WHERE mot_francais IN ('joli_mod', 'joli');

SELECT '=== TEST M2 : modifier_mot - Renommer un mot russe (cas succès) ===' AS test_description;
-- Renommer 'миленький' en 'милая'
CALL modifier_mot('R', 'миленький', 'милая');

SELECT '=== VERIF M2 : vérifier renommage mot russe ===' AS test_description;
SELECT id_russe, mot_russe FROM mots_russes WHERE mot_russe IN ('милая', 'миленький');

SELECT '=== TEST M3 : modifier_mot - CAS D''ERREUR : origine inexistante ===' AS test_description;
SELECT 'ERREUR ATTENDUE si cette requête était exécutée : mot origine introuvable' AS note_erreur;
-- CALL modifier_mot('F', 'inexistant', 'nouveau'); -- COMMENTÉ : génère une erreur SQL

SELECT '=== TEST M4 : modifier_mot - CAS D''ERREUR : nouveau mot existe deja ===' AS test_description;
SELECT 'ERREUR ATTENDUE si cette requête était exécutée : nouveau mot existe deja' AS note_erreur;
-- CALL modifier_mot('R', 'миленький', 'милая'); -- COMMENTÉ : génère une erreur SQL si déjà renommé

SELECT '=== TEST 10 : modifier_traduction - CAS D''ERREUR : les deux paramètres vides ===' AS test_description;
SELECT 'ERREUR ATTENDUE si cette requête était exécutée : parametres invalides (les deux mots sont vides)' AS note_erreur;
-- CALL modifier_traduction(1, '', '');  -- COMMENTÉ : génère une erreur SQL

SELECT '=== TEST 11 : modifier_traduction - CAS D''ERREUR : les deux paramètres non vides ===' AS test_description;
SELECT 'ERREUR ATTENDUE si cette requête était exécutée : parametres invalides (les deux mots sont non vides)' AS note_erreur;
-- CALL modifier_traduction(1, 'test', 'тест');  -- COMMENTÉ : génère une erreur SQL

SELECT '=== TEST 12 : modifier_traduction - CAS D''ERREUR : id_traduction inexistant ===' AS test_description;
SELECT 'ERREUR ATTENDUE si cette requête était exécutée : traduction introuvable (id_traduction inexistant)' AS note_erreur;
-- CALL modifier_traduction(999, 'inexistant', '');  -- COMMENTÉ : génère une erreur SQL

-- ===========================================================================================
-- SECTION 4 : TESTS POUR SUPPRIMER_TRADUCTION
-- ===========================================================================================

SELECT '=== TEST 13 : supprimer_traduction - Afficher les traductions avant suppression ===' AS test_description;
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
ORDER BY t.id_traduction;

SELECT '=== TEST 14 : supprimer_traduction - Supprimer la traduction 1 (cas succès) ===' AS test_description;
CALL supprimer_traduction(1);

SELECT '=== TEST 15 : supprimer_traduction - Afficher les traductions après suppression ===' AS test_description;
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
ORDER BY t.id_traduction;

SELECT '=== TEST 16 : supprimer_traduction - CAS D''ERREUR : id_traduction inexistant ===' AS test_description;
SELECT 'ERREUR ATTENDUE si cette requête était exécutée : traduction inexistante (id_traduction introuvable)' AS note_erreur;
-- CALL supprimer_traduction(999);  -- COMMENTÉ : génère une erreur SQL

-- ===========================================================================================
-- SECTION 5 : TEST D'INTÉGRATION COMPLET
-- ===========================================================================================

SELECT '=== TEST 17 : Test d''intégration complet (CREATE, READ, UPDATE, DELETE) ===' AS test_description;

-- 1. Créer une nouvelle traduction
SELECT 'ÉTAPE 1 : Création d''une nouvelle traduction' AS etape;
CALL creer_traduction('intelligent', 'умный');

-- 2. Lire la traduction créée
SELECT 'ÉTAPE 2 : Vérification de la traduction créée' AS etape;
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
WHERE mf.mot_francais = 'intelligent';

-- 3. Modifier la traduction
SELECT 'ÉTAPE 3 : Modification du mot russe' AS etape;
-- On suppose que l'id_traduction est 5 (adapter selon le nombre de traductions existantes)
-- Pour ce test, on utilise une sous-requête
SET @id_traduction_test = (SELECT id_traduction FROM traductions WHERE id_francais = (SELECT id_francais FROM mots_francais WHERE mot_francais = 'intelligent') LIMIT 1);
CALL modifier_traduction(@id_traduction_test, '', 'интеллигентный');

-- 4. Vérifier la modification
SELECT 'ÉTAPE 4 : Vérification de la modification' AS etape;
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
WHERE mf.mot_francais = 'intelligent';

-- 5. Supprimer la traduction
SELECT 'ÉTAPE 5 : Suppression de la traduction' AS etape;
CALL supprimer_traduction(@id_traduction_test);

-- 6. Vérifier la suppression
SELECT 'ÉTAPE 6 : Vérification de la suppression' AS etape;
SELECT COUNT(*) AS nombre_traductions_restantes
FROM traductions t
WHERE t.id_traduction = @id_traduction_test;

-- ===========================================================================================
-- SECTION 6 : RÉSUMÉ FINAL
-- ===========================================================================================

SELECT '=== RÉSUMÉ FINAL ===' AS resume;
SELECT 'Nombre total de mots français :' AS description, COUNT(*) AS nombre FROM mots_francais;
SELECT 'Nombre total de mots russes :' AS description, COUNT(*) AS nombre FROM mots_russes;
SELECT 'Nombre total de traductions :' AS description, COUNT(*) AS nombre FROM traductions;

-- ===========================================================================================
-- SECTION 7 : INSTRUCTIONS POUR TESTER LES CAS D'ERREUR MANUELLEMENT
-- ===========================================================================================

SELECT '=== INSTRUCTIONS POUR LES ERREURS ===' AS section;
SELECT 'Pour tester les cas d''erreur, décommentez les lignes suivantes et les exécuter individuellement :' AS instruction;

SELECT '
Test 1 : Modifier avec les deux paramètres vides
CALL modifier_traduction(1, \'\', \'\');
Erreur attendue : Parametres invalides : fournir exactement un mot a modifier (francais ou russe)

Test 2 : Modifier avec les deux paramètres non vides
CALL modifier_traduction(1, \'test\', \'тест\');
Erreur attendue : Parametres invalides : fournir exactement un mot a modifier (francais ou russe)

Test 3 : Modifier avec id_traduction inexistant
CALL modifier_traduction(999, \'inexistant\', \'\');
Erreur attendue : Traduction introuvable pour l id_traduction fourni

Test 4 : Supprimer avec id_traduction inexistant
CALL supprimer_traduction(999);
Erreur attendue : Traduction introuvable pour l id_traduction fourni
' AS instructions_detaillees;

SELECT '=== FIN DES TESTS ===' AS fin;

