import csv

nom_fichier_csv = 'traductions_a_inserer.csv'
nom_fichier_sql = 'insertion_traductions.sql'

# Ouvre le fichier CSV en mode lecture et le fichier SQL en mode écriture
with open(nom_fichier_csv, 'r', encoding='utf-8') as fichier_csv, \
     open(nom_fichier_sql, 'w', encoding='utf-8') as fichier_sql:

    # Écrit l'en-tête du script SQL
    fichier_sql.write("-- Script SQL généré pour insérer les traductions\n")
    fichier_sql.write("USE dictionnaire_db;\n\n")

    # Crée un lecteur de fichier CSV et ignore la première ligne (en-tête)
    lecteur_csv = csv.reader(fichier_csv)
    next(lecteur_csv)

    # Parcourt chaque ligne du fichier CSV
    for ligne in lecteur_csv:
        mot_francais = ligne[0]
        mot_russe = ligne[1]
        
        # Écrit l'instruction CALL dans le fichier SQL
        fichier_sql.write(f"CALL AjouterNouvelleTraduction('{mot_francais}', '{mot_russe}');\n")

print(f"Le script SQL a été généré avec succès dans le fichier {nom_fichier_sql}.")
