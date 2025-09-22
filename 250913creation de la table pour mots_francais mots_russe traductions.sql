
-- Création de la table pour les mots français
CREATE TABLE mots_francais (
id_francais INT PRIMARY KEY AUTO_INCREMENT,
mot_francais VARCHAR(255) NOT NULL
);

-- Création de la table pour les mots russes
CREATE TABLE mots_russes (
id_russe INT PRIMARY KEY AUTO_INCREMENT,
mot_russe VARCHAR(255) NOT NULL
);

Création de la table d'association

La table d'association, nommée translate (ou une variation plus descriptive comme traductions), va lier les mots français et russes en utilisant des clés étrangères (FOREIGN KEY). Ces clés font référence aux clés primaires des tables mots_francais et mots_russes. Cela assure l'intégrité référentielle, empêchant l'ajout de traductions pour des mots qui n'existent pas.
SQL

-- Création de la table d'association
CREATE TABLE traductions (
id_traduction INT PRIMARY KEY AUTO_INCREMENT,
id_francais INT,
id_russe INT,
FOREIGN KEY (id_francais) REFERENCES mots_francais(id_francais),
FOREIGN KEY (id_russe) REFERENCES mots_russes(id_russe)
);
