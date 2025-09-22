CREATE TABLE traductions (
                             id_traduction INT PRIMARY KEY AUTO_INCREMENT,
                             id_francais INT,
                             id_russe INT,
                             FOREIGN KEY (id_francais) REFERENCES mots_francais(id_francais),
                             FOREIGN KEY (id_russe) REFERENCES mots_russes(id_russe)
