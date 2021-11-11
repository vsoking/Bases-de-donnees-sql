.shell echo "3. Création des tables";
PRAGMA foreign_keys = ON;
CREATE TABLE EMPLOYE(Nom text, Salaire real, PRIMARY KEY(Nom));
CREATE TABLE RAYON(Numero int, Nom text, PRIMARY KEY(Numero));
ALTER TABLE EMPLOYE ADD COLUMN Rayon int REFERENCES RAYON(Numero) ON DELETE CASCADE;
ALTER TABLE RAYON ADD COLUMN Chef text REFERENCES EMPLOYE(Nom) ON DELETE CASCADE;
CREATE TABLE PRODUIT(Ref int PRIMARY KEY, Nom text, Prix real, Rayon int, FOREIGN KEY (Rayon) REFERENCES RAYON(Numero) ON DELETE CASCADE);
CREATE TABLE FOURNISSEUR(Nom text, Adresse text, PRIMARY KEY(Nom));
CREATE TABLE CLIENT(Nom text, Adresse text, Solde real, PRIMARY KEY(Nom));
CREATE TABLE COMMANDE(Num int, Date date, Nom_client REFERENCES CLIENT(Nom) ON DELETE CASCADE, PRIMARY KEY(Num));
CREATE TABLE FOURNIR(Nom_four text REFERENCES FOURNISSEUR(Nom) ON DELETE CASCADE, Ref_prod int REFERENCES PRODUIT(Ref) ON DELETE CASCADE, Prix real);
CREATE TABLE LIGNE_COM(Num_com int REFERENCES COMMANDE(Num) ON DELETE CASCADE, Ref_prod int REFERENCES PRODUIT(Ref) ON DELETE CASCADE, Quantite int);
.shell echo "\n4. Schema de la base de données"; 
SELECT * FROM sqlite_master;
.shell echo "\n5. Insertion des données";
INSERT INTO RAYON(Nom, Numero) VALUES ("jouet",1),("vetement",2),("jardin",3);
INSERT INTO EMPLOYE(Nom, Salaire, Rayon) VALUES ("durand",1000,1),("dubois",1500,1),("dupont",2000,1),("dumoulin",1200,2),("dutilleul",1000,2),("duchene",2000,2),("duguesclin",1500,3),("duduche",2000,3);
UPDATE RAYON SET Chef="dupont" WHERE Numero=1; UPDATE RAYON SET Chef="duchene" WHERE Numero=2; UPDATE RAYON SET Chef="duduche" WHERE Numero=3;
INSERT INTO PRODUIT(Nom, Ref, Rayon, Prix) VALUES ("train",1,1,100),("avion",2,1,75),("bateau",3,1,70),("pantalon",4,2,30),("veste",5,2,38),("robe",6,2,50),("rateau",7,3,5),("pioche",8,3,7),("brouette",9,3,38);
INSERT INTO FOURNISSEUR(Nom, Adresse) VALUES ("f1","paris"),("f2","lyon"),("f3","marseille");
INSERT INTO CLIENT(Nom, Adresse, Solde) VALUES ("dumont","paris",500),("dupont","lyon",-200),("dupond","marseille",-300),("dulac","paris",800),("dumas","lyon",-300);
INSERT INTO COMMANDE(Num, Date, Nom_client) VALUES (1,"2013-01-01","dupont"),(2,"2014-01-05","dupond"),(3,"2014-01-18","dupont"),(4,"2014-01-25","dumas"),(5,"2015-01-31","dumas");
INSERT INTO FOURNIR(Nom_four, Ref_prod, Prix) VALUES ("f1",1,90),("f1",4,25),("f1",5,30),("f1",7,4),("f2",2,70),("f2",3,60),("f2",6,45),("f3",8,5),("f3",9,32);
INSERT INTO LIGNE_COM(Num_com, Ref_prod, Quantite) VALUES (1,1,1),(1,4,2),(1,5,5),(2,1,3),(2,2,3),(2,8,4),(3,2,2),(3,5,1),(3,6,1),(3,7,1),(3,8,5),(4,8,10),(4,9,4),(5,1,2),(5,9,3);
.shell echo "Table EMPLOYE";
SELECT * FROM EMPLOYE;
.shell echo "\nTABLE RAYON";
SELECT * FROM RAYON;
.shell echo "\nLa commande de 2013";
SELECT * FROM COMMANDE WHERE strftime("%Y", Date)="2013";
.shell echo "\n6. Mise à jour des données de table"
.shell echo "Augmentation du solde du client dumas;";
UPDATE CLIENT SET Solde=Solde+1000 WHERE Nom="dumas";
SELECT * FROM CLIENT WHERE Nom="dumas";
.shell echo "\nSuppression des clients n'ayant jamais passé de commande.";
DELETE FROM CLIENT WHERE Nom NOT IN (SELECT Nom_client FROM COMMANDE);
.shell echo "\nContenu de la table après suppression";
SELECT * FROM CLIENT;
.shell echo "\nSuppression des informations liées au client dupont";
DELETE FROM CLIENT WHERE Nom="dupont";
.shell echo "\nContenu de la table CLIENT après la suppression";
SELECT * FROM CLIENT;
.shell echo "\nContenu de la table COMMANDE après la suppression";
SELECT * FROM COMMANDE;
.shell echo "\n7. Notion de Trigger\nUn trigger est une fonction qui est exécutée lorsque un événement spécifié se produit sur la database";
.shell echo "\n8. Trigger pour supprimer toutes les lignes d'une commande";
CREATE TRIGGER delete_line_command AFTER DELETE ON COMMANDE
BEGIN
DELETE FROM LIGNE_COM WHERE Num_com=old.Num;
END;
.shell echo "\n9. Trigger empechant insertion d'un produit avec prix négatif";
CREATE TRIGGER before_insert_prod BEFORE INSERT ON PRODUIT
BEGIN
SELECT CASE WHEN new.Prix<0 THEN RAISE(ABORT, 'Prix invalide') END;
END;
