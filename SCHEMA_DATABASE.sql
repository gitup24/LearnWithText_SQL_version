-- ===========================================================================================
-- STRUCTURE DE LA BASE DE DONNÉES - TRADUCTIONS FR/RU
-- ===========================================================================================

-- ===========================================================================================
-- TABLE : mots_francais
-- ===========================================================================================
-- Stocke tous les mots français uniques
-- Clé primaire : id_francais (auto-incrémentée)
-- Contrainte : mot_francais doit être UNIQUE

CREATE TABLE mots_francais (
    id_francais INT PRIMARY KEY AUTO_INCREMENT,
    mot_francais VARCHAR(255) NOT NULL UNIQUE
);

-- Exemple de données :
-- | id_francais | mot_francais |
-- | 1           | beau         |
-- | 2           | joli         |
-- | 3           | merci        |


-- ===========================================================================================
-- TABLE : mots_russes
-- ===========================================================================================
-- Stocke tous les mots russes uniques
-- Clé primaire : id_russe (auto-incrémentée)
-- Contrainte : mot_russe doit être UNIQUE

CREATE TABLE mots_russes (
    id_russe INT PRIMARY KEY AUTO_INCREMENT,
    mot_russe VARCHAR(255) NOT NULL UNIQUE
);

-- Exemple de données :
-- | id_russe | mot_russe     |
-- | 1        | красивый      |
-- | 2        | прекрасный    |
-- | 3        | спасибо       |


-- ===========================================================================================
-- TABLE : traductions
-- ===========================================================================================
-- Associe les mots français aux mots russes
-- Clé primaire : id_traduction (auto-incrémentée)
-- Clés étrangères : id_francais, id_russe
-- Contrainte UNIQUE : (id_francais, id_russe) ne peut pas être dupliquée

CREATE TABLE traductions (
    id_traduction INT PRIMARY KEY AUTO_INCREMENT,
    id_francais INT NOT NULL,
    id_russe INT NOT NULL,
    FOREIGN KEY (id_francais) REFERENCES mots_francais(id_francais),
    FOREIGN KEY (id_russe) REFERENCES mots_russes(id_russe),
    UNIQUE KEY unique_traduction (id_francais, id_russe)
);

-- Exemple de données :
-- | id_traduction | id_francais | id_russe |
-- | 1             | 1           | 1        |  -> "beau" → "красивый"
-- | 2             | 1           | 2        |  -> "beau" → "прекрасный"
-- | 3             | 2           | 3        |  -> "joli" → "спасибо"


-- ===========================================================================================
-- VUE : vue_traductions_fr_ru
-- ===========================================================================================
-- Vue simplifiée pour afficher les traductions
-- Joins les trois tables pour retourner directement les mots français et russes

CREATE VIEW vue_traductions_fr_ru AS
SELECT
    mf.mot_francais,
    mr.mot_russe
FROM
    traductions t
    JOIN mots_francais mf ON t.id_francais = mf.id_francais
    JOIN mots_russes mr ON t.id_russe = mr.id_russe;

-- Résultat quand on fait SELECT * FROM vue_traductions_fr_ru;
-- | mot_francais | mot_russe     |
-- | beau         | красивый      |
-- | beau         | прекрасный    |
-- | joli         | спасибо       |


-- ===========================================================================================
-- RELATIONS ET INTÉGRITÉ DES DONNÉES
-- ===========================================================================================

/*
DIAGRAMME ENTITÉ-RELATION :

┌──────────────────┐
│   mots_francais  │
├──────────────────┤
│ id_francais (PK) │◄───┐
│ mot_francais (U) │    │ FK
└──────────────────┘    │
                        │
                    ┌───┴──────────────┐
                    │   traductions    │
                    ├──────────────────┤
                    │ id_traduction(PK)│
                    │ id_francais (FK) │───────────┐
                    │ id_russe (FK)    │───┐       │
                    │ UNIQUE (FK, FK)  │   │       │
                    └──────────────────┘   │       │
                                           │       │
                        ┌──────────────────┘       │
                        │                          │
┌──────────────────┐    │                          │
│   mots_russes    │    │                          │
├──────────────────┤    │                          │
│ id_russe (PK)    │◄───┘                          │
│ mot_russe (U)    │◄────────────────────────────┘
└──────────────────┘
*/

-- ===========================================================================================
-- CAS D'USAGE
-- ===========================================================================================

-- L'un mot "beau" peut avoir plusieurs traductions russes :
-- beau → красивый
-- beau → прекрасный
-- beau → миленький

-- Un mot russe peut avoir plusieurs traductions françaises :
-- красивый → beau
-- красивый → joli
-- красивый → joli fille (si on le souhaite)

-- Mais un couple (id_francais, id_russe) ne peut exister qu'une seule fois
-- (impossible de créer deux fois "beau" → "красивый")


-- ===========================================================================================
-- REQUÊTES UTILES
-- ===========================================================================================

-- Afficher toutes les traductions avec leurs IDs
SELECT
    t.id_traduction,
    mf.mot_francais,
    mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe;

-- Afficher toutes les traductions d'un mot français
SELECT t.id_traduction, mr.mot_russe
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
WHERE mf.mot_francais = 'beau';

-- Afficher toutes les traductions pour un mot russe
SELECT t.id_traduction, mf.mot_francais
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
JOIN mots_russes mr ON t.id_russe = mr.id_russe
WHERE mr.mot_russe = 'красивый';

-- Compter les traductions par mot français
SELECT
    mf.mot_francais,
    COUNT(*) AS nombre_traductions
FROM traductions t
JOIN mots_francais mf ON t.id_francais = mf.id_francais
GROUP BY mf.mot_francais
ORDER BY nombre_traductions DESC;

-- Trouver les mots français sans traductions (orphelins - ne devrait pas se produire)
SELECT mf.mot_francais
FROM mots_francais mf
LEFT JOIN traductions t ON mf.id_francais = t.id_francais
WHERE t.id_traduction IS NULL;

-- Trouver les mots russes sans traductions (orphelins - ne devrait pas se produire)
SELECT mr.mot_russe
FROM mots_russes mr
LEFT JOIN traductions t ON mr.id_russe = t.id_russe
WHERE t.id_traduction IS NULL;

