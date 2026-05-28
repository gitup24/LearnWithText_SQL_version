# Documentation CRUD - Traductions FR/RU

## Vue d'ensemble

Ce projet contient 4 procédures stockées MySQL pour gérer un système de traduction français-russe :

1. **creer_traduction.sql** - CREATE (Créer une nouvelle traduction)
2. **modifier_traduction.sql** - UPDATE (Modifier une traduction existante)
3. **modifier_mot.sql** - UPDATE (Renommer un mot dans la table mots_francais ou mots_russes)
4. **supprimer_traduction.sql** - DELETE (Supprimer une traduction)

## Structure des tables

```sql
mots_francais (id_francais, mot_francais)
mots_russes (id_russe, mot_russe)
traductions (id_traduction, id_francais, id_russe)
```

---

## 1. CRÉER UNE TRADUCTION - `creer_traduction()`

### Syntaxe
```sql
CALL creer_traduction(p_mot_francais VARCHAR(255), p_mot_russe VARCHAR(255));
```

### Description
- Crée une nouvelle traduction entre un mot français et un mot russe
- Si le mot français n'existe pas, il est créé automatiquement
- Si le mot russe n'existe pas, il est créé automatiquement
- Si la traduction existe déjà, elle n'est pas dupliquée (message d'information)
- Retourne : `id_traduction`, `id_francais`, `id_russe`, `message`

### Exemples

**Créer une nouvelle traduction :**
```sql
CALL creer_traduction('beau', 'красивый');
-- Résultat : 
-- | message | id_traduction | id_francais | id_russe |
-- | Traduction créée | 1 | 1 | 1 |
```

**Ajouter une traduction qui existe déjà :**
```sql
CALL creer_traduction('beau', 'красивый');
-- Résultat :
-- | message | id_traduction | id_francais | id_russe |
-- | Traduction déjà existante | 1 | 1 | 1 |
```

**Utiliser un mot français existant avec un nouveau mot russe :**
```sql
CALL creer_traduction('beau', 'прекрасный');
-- Crée une nouvelle traduction : beau → прекрасный
```

---

## 2. MODIFIER UNE TRADUCTION - `modifier_traduction()`

### Syntaxe
```sql
CALL modifier_traduction(
    p_id_traduction INT,
    p_mot_francais VARCHAR(255),
    p_mot_russe VARCHAR(255)
);
```

### Description
- Modifie une traduction existante (soit le mot français, soit le mot russe)
- **RÈGLES IMPORTANTE** :
  - Exactement UN des deux paramètres (`p_mot_francais` ou `p_mot_russe`) doit être non vide
  - L'autre doit être vide (`''`)
  - Les deux non-vides ou les deux vides génèrent une erreur
- Si le mot fourni n'existe pas, il est créé automatiquement
- Empêche la création de traductions dupliquées
- Retourne : `id_traduction`, `id_francais`, `id_russe`, `mot_francais`, `mot_russe`, `message`

### Exemples

**Modifier le mot français (garder le mot russe) :**
```sql
CALL modifier_traduction(1, 'joli', '');
-- Change la traduction 1 : ancien mot français → 'joli'
-- Résultat : joli → красивый
```

**Modifier le mot russe (garder le mot français) :**
```sql
CALL modifier_traduction(1, '', 'прелестный');
-- Change la traduction 1 : красивый → 'прелестный'
-- Résultat : beau → прелестный
```

### Cas d'erreur

**ERREUR : Les deux paramètres sont vides**
```sql
CALL modifier_traduction(1, '', '');
-- ❌ ERROR 45000 (45000): Parametres invalides : fournir exactement un mot a modifier (francais ou russe)
```

**ERREUR : Les deux paramètres sont non vides**
```sql
CALL modifier_traduction(1, 'test', 'тест');
-- ❌ ERROR 45000 (45000): Parametres invalides : fournir exactement un mot a modifier (francais ou russe)
```

**ERREUR : id_traduction inexistant**
```sql
CALL modifier_traduction(999, 'inexistant', '');
-- ❌ ERROR 45000 (45000): Traduction introuvable pour l id_traduction fourni
```

**ERREUR : Traduction déjà existante**
```sql
-- Supposons que 'joli' → 'милый' existe
CALL modifier_traduction(2, '', 'милый');  -- si traduction 2 est 'beau'
-- ❌ ERROR 45000 (45000): Une traduction identique existe deja pour ce mot francais et ce mot russe
```

---

## 3. SUPPRIMER UNE TRADUCTION - `supprimer_traduction()`

### Syntaxe
```sql
CALL supprimer_traduction(p_id_traduction INT);
```

### Description
- Supprime une traduction par son ID
- Retourne les informations de la traduction supprimée
- Retourne : `id_traduction`, `id_francais`, `id_russe`, `mot_francais`, `mot_russe`, `message`

### Exemples

**Supprimer une traduction :**
```sql
CALL supprimer_traduction(1);
-- Résultat :
-- | id_traduction | id_francais | id_russe | mot_francais | mot_russe | message |
-- | 1 | 1 | 1 | beau | красивый | Traduction supprimee |
```

### Cas d'erreur

**ERREUR : id_traduction inexistant**
```sql
CALL supprimer_traduction(999);
-- ❌ ERROR 45000 (45000): Traduction introuvable pour l id_traduction fourni
```

---

## 2b. RENOMMER UN MOT - `modifier_mot()`

### Syntaxe
```sql
CALL modifier_mot(p_mot_origine VARCHAR(255), p_mot_nouveau VARCHAR(255));
```

### Description
- Détecte automatiquement la langue du mot d'origine : la procédure recherche `p_mot_origine` dans `mots_francais` puis dans `mots_russes`.
- Si le mot d'origine est trouvé dans `mots_francais`, la mise à jour s'effectue dans cette table ; si trouvé dans `mots_russes`, la mise à jour s'effectue dans cette table.
- Si le même mot existe dans les deux tables, la procédure renvoie une erreur d'ambiguïté (demandez la précision de la langue dans ce cas).
- La procédure vérifie aussi que le `p_mot_nouveau` n'existe pas déjà dans la table cible avant d'effectuer la modification.
- Retourne : `id_mot_origine`, `mot_origine` (valeur avant modification), `mot_nouveau` (valeur après modification).

### Exemples

```sql
-- Renommer un mot français
CALL modifier_mot('bonjour', 'salut');

-- Renommer un mot russe
CALL modifier_mot('привет', 'здравствуй');
```

### Cas d'erreur

```sql
-- Mot d'origine absent des deux tables => erreur
CALL modifier_mot('inexistant', 'nouveau');

-- Mot d'origine présent dans les deux tables => erreur d'ambiguïté
CALL modifier_mot('mot_commun', 'nouveau');

-- Nouveau mot déjà existant dans la table cible => erreur
CALL modifier_mot('bonjour', 'salut'); -- si 'salut' existe déjà
```

---

## Tests

Un fichier de tests complet est fourni : **`tests_procedures.sql`**

### Pour exécuter les tests : (ordre précis à respecter)

1. **Créer les tables et la vue** (si vous ne les avez pas déjà) :
   - soit exécuter `SCHEMA_DATABASE.sql`,
   - soit exécuter manuellement les blocs CREATE TABLE / CREATE VIEW présents dans le projet.

2. **Charger les procédures** (ordre recommandé) :
   ```sql
   -- charger la procédure de création
   SOURCE creer_traduction.sql;

   -- charger la procédure de modification de traduction
   SOURCE modifier_traduction.sql;

   -- charger la procédure de renommage de mots
   SOURCE modifier_mot.sql;

   -- charger la procédure de suppression
   SOURCE supprimer_traduction.sql;
   ```

3. **Exécuter la suite de tests** :
   ```sql
   SOURCE tests_procedures.sql;
   ```

3. **Les tests couvrent** :
   - ✅ Création de traductions (cas succès)
   - ✅ Modification de traductions (cas succès)
   - ✅ Suppression de traductions (cas succès)
   - ✅ Vérification des doublons
   - ✅ Utilisation de mots existants
   - ✅ Test d'intégration complet (CREATE → READ → UPDATE → DELETE)
   - ⚠️ Cas d'erreurs (documentés pour exécution manuelle)

---

## Vue pour lister les traductions

Une vue `vue_traductions_fr_ru` permet de lister facilement toutes les traductions :

```sql
CREATE VIEW vue_traductions_fr_ru AS
SELECT
    mf.mot_francais,
    mr.mot_russe
FROM
    traductions t
    JOIN mots_francais mf ON t.id_francais = mf.id_francais
    JOIN mots_russes mr ON t.id_russe = mr.id_russe;
```

### Utilisation :
```sql
SELECT * FROM vue_traductions_fr_ru;
-- Retourne toutes les traductions sous forme simple
```

---

## Résumé des commandes SQL les plus courantes

```sql
-- Créer une traduction
CALL creer_traduction('beau', 'красивый');

-- Modifier le mot français
CALL modifier_traduction(1, 'joli', '');

-- Modifier le mot russe
CALL modifier_traduction(1, '', 'прекрасный');

-- Supprimer une traduction
CALL supprimer_traduction(1);

-- Lister toutes les traductions
SELECT * FROM vue_traductions_fr_ru;

-- Compter les traductions
SELECT COUNT(*) FROM traductions;
```

---

## Notes importantes

1. **Clés de base** : Les procédures utilisent les IDs auto-incrémentés (`LAST_INSERT_ID()`)
2. **Intégrité** : Les clés étrangères garantissent l'intégrité des données
3. **Doublons** : Les traductions en doublon sont automatiquement détectées
4. **Mots réutilisés** : Les mots existants sont réutilisés au lieu de créer des doublons
5. **Transaction** : Chaque procédure est atomique (tout réussit ou rien n'est modifié)

