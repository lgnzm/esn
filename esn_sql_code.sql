/*requetes simples*/
/* Liste des libellés de types de projets.*/
select 	libtype
from	type

/* Liste des libellés de clients, ainsi que leurs villes.*/
select 	design, ville
from	client

/* Contenu intégral de la table ing_pro_cpc.*/
Select *
From	ing_pro_cpc

/* Liste des villes des implantations de la société.*/
Select	distinct ville
From	dept

/* Liste des noms, prénoms, villes de clients triés par ville, nom.*/
select	design, ville
from	client
order by ville, design

/* Donner la liste des codes et libellés de projets du plus cher au moins cher.*/
select	codpro, libpro, cout
from	projet
order by cout desc

/*	Liste des codes et libellés de projets dont le coût est supérieur à 10 millions?*/
select	codpro, libpro, adresse
from	projet
where	cout > 10000000

/*	Quel est le projet dont le nom de voie dans ladresse fait référence à "Brokleen"?*/
select	codpro, libpro, adresse
from	projet
where	adresse like '%brokleen%'

/*	Quels sont les salariés dont le nom commence par "S"?*/
select	nom
from	ingenieur
where	nom like 'S%'
 
/*	Donner la liste des matricules et codpro de salariés, compris entre 501 et 1000, 
intervenant actuellement au moins sur l'un des projet suivants: 17, 22 ou 120*/
select	distinct mle, codpro
from	affect
where	codpro in (17, 22, 120)
and		mle between 501 and 1000
and		datdeb <= current_date
and		(datfin is null or datfin >= current_date)

/*	En admettant que le coût des projets est en hors-taxe, donner pour chaque projet compris entre 11 et 20 son coût TTC (19,6 %). 
Nommer la nouvelle colonne ainsi créée « COUT_TTC ».*/
select	codpro, cout as cout_HT, cout * 1.196 as cout_TTC
from	projet
where	codpro between 11 and 20


/*	Quel est le client dont le libellé de secteur n'est pas renseigné?*/
select	codcli, design
from	client 
where	libsect is null

/* 	Liste des ingénieurs de la société. (Mle, Nom, Prénom).*/
Select	mle, nom, prenom
From	ingenieur

/* 	Liste des couples (PDG,DG) de tous les départements avec élimination des doubles.*/
Select	distinct pdg, dg
From	dept

/* 	Liste des matricules des Ingénieurs actuellement dans le département 7, 
triée sur les matricules croissants.*/
SELECT  MLE
FROM	EMPLOI
WHERE	CODEPT = 7
AND		(DATSOR  IS NULL OR DATSOR >= current_date)
AND		DATENT < current_date
ORDER BY MLE

/* 	Liste des prénoms rangée par sexe et prénom.*/
Select	distinct sexe, prenom
From	ingenieur
 

/* 	Liste des départements (code departement, désignation, PDG) 
situés rue de Londres à Paris (chercher 'LONDRES' et 'PARIS' en majuscules).*/
SELECT  CODEPT, DESIGN, PDG
FROM	DEPT
WHERE	ADRESSE LIKE '%LONDRES%'
AND		VILLE = 'PARIS'


/*	Quels sont les salariés dont le nom ne contient pas la lettre 'E'?*/
select	nom
from	ingenieur
where	nom not like '%E%'

/* 	Quels sont les matricules supérieurs à 1000, d'ingénieurs ayant la compétence 'JAVA'?*/
select	mle, compet
from	ing_cpc
where	compet = 'JAVA'
and		mle > 1000

/* 	Quels sont les ingénieurs dont le nom contient la lettre "A" en deuxième position?*/
select	nom
from	ingenieur
where	nom like '_A%'
 
/* 	Liste des ingénieurs n' ayant pas le téléphone.*/
Select	mle, nom, prenom
From	ingenieur 
Where	notel is null

/* 	Matricules des ingénieurs qui ont déjà eu loccasion de quitter 
au moins une fois le projet 17 ?*/
select	mle
from	affect
where	codpro = 17
and		datfin is not null

/*---------------------------------------------*/
/* jointure */
/*---------------------------------------------*/
/*	Noms et prénoms des salariés ayant la compétence « JAVASCRIPT »?*/
select		nom,prenom
from		ingenieur i
inner join	ing_pro_cpc ipc
on			ipc.mle = i.mle
where		ipc.compet = 'JAVASCRIPT'

/*	Quel est le client (code client) ayant au moins un projet sur Lille?*/

select		c.codcli, c.design, p.ville
from		client c 
inner join	cli_pro cp 
on			c.codcli = cp.codcli
inner join	projet p   
on			cp.codpro = p.codpro
where		p.ville = 'LILLE'
 

/*	Liste les noms, prénoms, date dentrée des ingénieurs appartenant au département 7.*/
SELECT  NOM,PRENOM,DATENT
FROM	INGENIEUR I, EMPLOI E
WHERE	I.MLE = E.MLE
AND		E.CODEPT = 7 
AND		E.DATENT <= current_date
AND		(E.DATSOR IS NULL OR E.DATSOR >= current_date)

/*	Même liste, mais triée par date d'entrée croissante.*/
SELECT  NOM,PRENOM,DATENT
FROM	INGENIEUR I, EMPLOI E
WHERE	I.MLE = E.MLE
AND		E.CODEPT = 7 
AND		E.DATENT <= current_date
AND		(E.DATSOR IS NULL OR E.DATSOR >= current_date)
ORDER BY DATENT


/*	Liste des noms de salariés actuellement dans le département 7, 
avec les libellés de leurs projets en cours. 
Préciser également leur prix de vente à chaque fois sur ces projets.*/
SELECT  NOM,LIBPRO,PVENTE
FROM  INGENIEUR I, AFFECT A, EMPLOI E, PROJET P
WHERE  I.MLE = E.MLE
AND		I.MLE = A.MLE
AND		A.CODPRO = P.CODPRO 
AND		E.CODEPT = 7
AND		E.DATENT <= current_date
AND		A.DATDEB <= current_date
AND		(E.DATSOR IS NULL OR E.DATSOR >= current_date)
AND		( A.DATFIN IS NULL OR A.DATFIN >= current_date)

/* 	Même liste, mais triée par code projet décroissant.*/
/*Idem +
ORDER BY CODPRO DESC*/

/*	Quels sont les ingénieurs ayant participé à des projets situés à Paris ?*/
SELECT  A.MLE
FROM	AFFECT A , PROJET P
WHERE	A.CODPRO = P.CODPRO
AND		A.DATFIN < current_date
AND		VILLE  =  'PARIS'

/*	Liste des ingénieurs participant actuellement au projet : 22.	(Nom, Prénom, Fonction, Libellé du projet).*/
SELECT  I.NOM , I.PRENOM , A.FONCTION , P.LIBPRO
FROM	INGENIEUR I , PROJET P , AFFECT A
WHERE	I.MLE      =  A.MLE
AND		A.CODPRO   =  P.CODPRO
AND		P.CODPRO   =  22
AND		(A.DATFIN  >=  current_date OR	A.DATFIN  IS NULL)
AND		A.DATDEB <= current_date

/*	Noms et prénoms des ingenieurs mettant en oeuvre leur compétence JAVA sur projet au 1er janvier 2000?*/
SET DATEFORMAT ymd;
select distinct i.nom, i.prenom
from	ingenieur i, ing_pro_cpc ipc, affect a
where	i.mle = ipc.mle
and		i.mle = a.mle
and		a.codpro = ipc.codpro
and		a.datdeb <= '2000-01-01'
and		(datfin >= '2000-01-01' or datfin is null)
and		ipc.compet = 'JAVA'

/*	Liste des départements ayant le même PDG (code dept, code dept, pdg), 
avec élimination des lignes où le PDG nest pas valorisé.*/
SELECT  *
FROM	DEPT A , DEPT B
WHERE	A.PDG    =  B.PDG
AND		A.CODEPT < B.CODEPT

/*	Liste des ingénieurs participant actuellement à un projet 
dont l'un au moins des clients habite la même ville que l'ingénieur.*/
SELECT  DISTINCT I.NOM , C.CODCLI
FROM	INGENIEUR I , AFFECT A , CLIENT C , CLI_PRO CP
WHERE	I.MLE      =  A.MLE
AND		 A.CODPRO   =  CP.CODPRO
AND		CP.CODCLI  =  C.CODCLI
AND		I.VILLE    =  C.VILLE
AND		(A.DATFIN  >=  current_date OR	A.DATFIN  IS NULL)
AND		A.DATDEB < current_date

/*	Liste des ingénieurs (Mle, Nom, Prénom) présents dans le département 7
au moins 1 jour en 2000.*/
SET DATEFORMAT ymd;
SELECT  I.MLE, I.NOM, I.PRENOM
FROM	INGENIEUR I, EMPLOI E
WHERE	I.MLE    = E.MLE
AND		E.CODEPT  = 7
AND		E.DATENT <=  '2000-12-31'
AND		(E.DATSOR  >=  '2000-01-01' OR  E.DATSOR  IS NULL)

/* Liste des projets (codpro, libpro, type) nayant pas de compétences requises */
SELECT		a.codpro, libpro, type 
FROM		projet a 
LEFT  JOIN	pro_cpc  b 
ON			a.codpro = b.codpro 
WHERE		b.codpro is null 
 
/* Liste des départements (Codept, design, datent, pdg, dg) dont l emploi a débuté 
avant le 1 er  janvier 1991 ou pour lesquels il n y a que le PDG/DG (sans employé), 
triée par désignation */
SELECT		a.codept, design, datent, pdg, dg 
FROM		dept a 
LEFT JOIN	emploi b ON a.codept = b.codept 
WHERE		( datent is null or  datent < '1991-01-01') 
and			dg is not null 
ORDER BY	a.design

/*---------------------------------------------*/
/* requetes */
/*---------------------------------------------*/

/* Quels sont les ingénieurs (nom) de sexe masculin domiciliés dans une ville où ne se trouve
aucun projet ?*/


-- sous-requête en NOT IN
SELECT I.nom, I.VILLE, I.SEXE
FROM	ingenieur I
WHERE sexe = 'M'
AND ville NOT IN (
	SELECT	ville
	FROM	projet)

-- sous-requête en NOT EXISTS
SELECT	nom
FROM	ingenieur I
WHERE	sexe = 'M'
AND		NOT EXISTS (
	SELECT	'x'
	FROM	projet p
	WHERE	P.ville = I.ville)

/* Nom du dernier salarié embauché dans la société (sans fonction d'agrégation).*/

SELECT	I.nom, E.DATENT
FROM	ingenieur I 
JOIN	emploi E 
ON		E.mle = I.mle
WHERE	E.DATENT <= ALL ( 
	select	E1.DATENT
	from	EMPLOI E1
	where 	E1.MLE = I.MLE
)
AND		E.datent >= all ( 
	SELECT	datent 
	FROM	emploi
	WHERE	datent < current_date) 
AND	datent < current_date

/* Noms des ingénieurs ayant toujours travaillé dans leur ville de résidence actuelle.*/
SELECT	nom,I.ville
FROM	ingenieur I, affect A1
WHERE	I.mle = A1.mle
AND		I.ville = all (
	SELECT ville
	FROM projet p, affect A2
	WHERE A2.codpro = p.codpro
	AND A2.mle = I.mle)

/*Remarque :
Dans la requête principale la jointure entre INGENIEUR et AFFECTATION est
nécessaire afin de ne sélectionner que des ingénieurs affectés.
*/

/* Liste triée (codept, nom) des doyens de chaque département (sans fonction d'agrégation)*/

SELECT	DISTINCT E.codept, I.nom
FROM	emploi E 
JOIN	ingenieur I 
ON		I.mle = E.mle
WHERE	I.datnais <= all ( 
	SELECT	I2.datnais
	FROM	ingenieur I2 
	JOIN	emploi E2
	ON		I2.mle = E2.mle
	WHERE	E.codept = E.codept)
ORDER BY E.codept

/* Liste des matricules et noms d ingénieurs mettant systématiquement en oeuvre leur
compétence « Z/OS » dans tous leurs projets. (Travailler uniquement sur les tables
INGENIEUR et ING_PRO_CPC sans fonction d'agrégation).
Même question pour « MERISE », à titre de vérification */
SELECT	DISTINCT I.mle,nom
FROM	ingenieur I,ing_pro_cpc ipc1
WHERE	I.mle=ipc1.mle
AND		NOT EXISTS (
	SELECT	'BIDON'
	FROM	ing_pro_cpc ipc2
	WHERE ipc2.mle = ipc1.mle
	AND codpro NOT IN (
		SELECT codpro
		FROM	ing_pro_cpc ipc3
		WHERE compet = 'Z/OS'
		AND ipc3.mle = ipc1.mle
	)
)





