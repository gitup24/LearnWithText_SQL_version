-- 3. MODIFIER UNE TRADUCTION (UPDATE)
-- ===========================================================================================

-- Renommer globalement un mot français
-- Remplacer "bonjour" par "salut" dans toutes les traductions
-- Renommer le mot français "bonjour" en "salut"
CALL modifier_mot('F', 'bonjour', 'salut');

-- Renommer globalement un mot russe
-- Remplacer "спасибо" par "благодарю" dans toutes les traductions
-- Renommer le mot russe "спасибо" en "благодарю"
CALL modifier_mot('R', 'спасибо', 'благодарю');

-- Vérifier les modifications
=======
-- ===========================================================================================
-- 3. MODIFIER UNE TRADUCTION OU UN MOT (UPDATE)
-- ===========================================================================================

-- A. Modifier une association spécifique par son ID
-- Modifier uniquement le mot russe de la traduction N°2 (merci -> спасибо) pour (merci -> признательность)
-- Note: On passe '' pour le mot qu'on ne souhaite pas modifier.
CALL modifier_traduction(2, '', 'признательность');

-- B. Renommer globalement un mot (impacte toutes les traductions utilisant ce mot)
-- Remplacer "salut" par "bonjour_modifie" dans toutes les traductions existantes
CALL modifier_mot('F', 'salut', 'bonjour_modifie');

-- Remplacer "благодарю" par "спасибо_v2"
CALL modifier_mot('R', 'благодарю', 'спасибо_v2');

-- Vérifier les modifications
=======
-- EXEMPLES D'UTILISATION RAPIDE - PROCÉDURES CRUD TRADUCTIONS
-- ===========================================================================================

-- IMPORTANT : Avant d'exécuter ce script d'exemples, chargez les tables et les procédures
-- 1) Créer les tables (si nécessaire) :
--    SOURCE SCHEMA_DATABASE.sql;    -- ou exécuter manuellement les CREATE TABLE dans le projet
-- 2) Charger les procédures dans l'ordre suivant :
--    SOURCE creer_traduction.sql;
--    SOURCE modifier_traduction.sql;
--    SOURCE modifier_mot.sql;
--    SOURCE supprimer_traduction.sql;
-- 3) Ensuite, exécuter ce fichier d'exemples :
--    SOURCE exemples_utilisation.sql;

-- ===========================================================================================
-- 1. CRÉER DES TRADUCTIONS (CREATE)
-- ===========================================================================================

-- Créer une première traduction
CALL creer_traduction('bonjour', 'привет');

-- Créer une deuxième traduction
CALL creer_traduction('merci', 'спасибо');

-- Créer une troisième traduction
CALL creer_traduction('au revoir', 'до свидания');

-- Ajouter une autre traduction pour le mot "bonjour"
CALL creer_traduction('bonjour', 'здравствуй');

-- ===========================================================================================
-- 2. LIRE LES TRADUCTIONS (READ)
-- ===========================================================================================

-- Afficher toutes les traductions
SELECT * FROM vue_traductions_fr_ru;

-- Afficher les détails des traductions (avec les IDs)
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe;

-- ===========================================================================================
-- 3. MODIFIER UNE TRADUCTION (UPDATE)
-- ===========================================================================================

-- Renommer globalement un mot français
-- Remplacer "bonjour" par "salut" dans toutes les traductions
-- Renommer le mot français "bonjour" en "salut"
CALL modifier_mot('F', 'bonjour', 'salut');

-- Renommer globalement un mot russe
-- Remplacer "спасибо" par "благодарю" dans toutes les traductions
-- Renommer le mot russe "спасибо" en "благодарю"
CALL modifier_mot('R', 'спасибо', 'благодарю');

-- Vérifier les modifications
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe;

-- ===========================================================================================
-- 4. SUPPRIMER UNE TRADUCTION (DELETE)
-- ===========================================================================================

-- Supprimer la traduction 3
CALL supprimer_traduction(3);

-- Vérifier que la traduction a été supprimée
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe;

-- ===========================================================================================
-- ANALYSE DES DONNÉES RESTANTES
-- ===========================================================================================

-- Compter les traductions restantes
SELECT COUNT(*) AS nombre_traductions FROM traductions;

-- Compter les mots français créés
SELECT COUNT(*) AS nombre_mots_francais FROM mots_francais;

-- Compter les mots russes créés
SELECT COUNT(*) AS nombre_mots_russes FROM mots_russes;

-- Afficher toutes les traductions restantes
SELECT t.id_traduction, mf.mot_francais, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
ORDER BY t.id_traduction;

