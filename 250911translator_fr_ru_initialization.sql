CREATE TABLE FR (
                    PRIMARY_KEY_id int NOT NULL AUTO_INCREMENT,
                    libelle VARCHAR(42),
                    PRIMARY KEY (PRIMARY_KEY_id)
);

CREATE TABLE RU (
                    PRIMARY_KEY_id int NOT NULL AUTO_INCREMENT,
                    libelle VARCHAR(42),
                    PRIMARY KEY (PRIMARY_KEY_id)
);

CREATE TABLE TRADUIRE (
                          PRIMARY KEY (PRIMARY_KEY_id_1, PRIMARY_KEY_id_2),
                          PRIMARY_KEY_id_1 INT NOT NULL,
                          PRIMARY_KEY_id_2 INT NOT NULL
);

ALTER TABLE TRADUIRE ADD FOREIGN KEY (PRIMARY_KEY_id_2) REFERENCES RU (PRIMARY_KEY_id);
ALTER TABLE TRADUIRE ADD FOREIGN KEY (PRIMARY_KEY_id_1) REFERENCES FR (PRIMARY_KEY_id);
