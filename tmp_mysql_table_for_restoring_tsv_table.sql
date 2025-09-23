CREATE TABLE `lwt_tsv_export_ru` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `word_ru` VARCHAR(255),
    `word_fr` VARCHAR(255),
    `context` TEXT,
    -- Add other columns here based on your file's structure.
    PRIMARY KEY (`id`)
);
