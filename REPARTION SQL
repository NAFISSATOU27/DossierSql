-- test sur filièrz_binaire pour voir les réseaux, et siège
select count (*),filière_binaire 
from ref_effectif_a_date_complete
group by filière_binaire
;

select *
from ref_effectif_a_date_complete;

select distinct Filière
from ref_effectif_a_date_complete
;

-- vues des départs et sorties
execute P_debut.debut := to_date('01/01/2019','DD/MM/YYYY');
execute P_fin.fin := to_date('15/09/2020','DD/MM/YYYY');

     

--select *
--from ref_effectif_a_date_complete



-- pour calculer l'ancienneté date d'entrée societé
round((to_date(to_char(sysdate,'DD/MM/YYYY'),'DD/MM/YYYY') - C.D_DEB_CTT)/365.25,1)-- Ancienneté_contrat exemple de calcul poue l'ancienneté contrat voir sql de table ref effectif

select *
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES ;


select matricule, (to_date(to_char(sysdate,'DD/MM/YYYY'),'DD/MM/YYYY') - D_ENTR_SOC)/365.25 --Ancienneté_societé
from ref_effectif_a_date_complete -- présent 

--pour arrondir il faut metre round voici un exemple
select matricule, round((to_date(to_char(sysdate,'DD/MM/YYYY'),'DD/MM/YYYY') - D_ENTR_SOC)/365.25,1) --Ancienneté_societé
from ref_effectif_a_date_complete -- présent 


select D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) -- calcule l'ancienneté contrat dans la table entrée-sortie
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES;


select D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)) -- calcule l'ancienneté contrat dans la table entrée-sortie
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES;

--requete 1 
-- démission par age en  2017,2018,2019
execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');



-- fonction pivot 
select * 
from
(select TR_AGE,count(*) as démissions, to_char(d_fin_ctt,'yyyy') as annee
from
(select tb.*,
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE  
from (
      select nom ,prenom ,matricule ,age_annee ,L_metier,C_NAT_CTT ,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
      L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté, to_char(d_fin_ctt,'yyyy') année
      from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
      where L_MOTF_SORT_SOC ='démission' AND C_NAT_CTT='CDI'and type_mvt='Sortie') tb) tb2
GROUP BY tr_age, to_char(d_fin_ctt,'yyyy'))
pivot
(  sum(démissions)
for annee IN (2017,2018,2019)
);






--démission par age en 2018
execute P_debut.debut := to_date('01/01/2018','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2018','DD/MM/YYYY');

select TR_AGE,count(*) as démissions
from
(select tb.*,
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE  
from 
(select nom ,prenom ,matricule ,age_annee ,L_metier,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté to_char(
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission' and type_mvt='Sortie'  ) tb) tb2
GROUP BY tr_age

-- démission par ancienneté en 2017,2018,2019
execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');
select*
from
(select TR_ancien_gpe,count(*) as démissions, to_char(D_FIN_CTT,'yyyy') annee
from
(select tb.*,
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE  
from (
select nom ,prenom ,matricule ,age_annee ,L_metier,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission' and type_mvt='Sortie') tb) tb2
GROUP BY TR_ancien_gpe,to_char(D_FIN_CTT,'yyyy'))
pivot (sum(démissions)
for annee in (2017,2018,2019)
);





-- démission par ancienneté en 2017,2018,2019 en utilisan order by 
execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');
select*
from
(select TR_ancien_gpe,count(*) as démissions, to_char(D_FIN_CTT,'yyyy') annee
from
(select tb.*,
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE  
from (
select nom ,prenom ,matricule ,age_annee ,L_metier,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission'and type_mvt='Sortie' ) tb) tb2
GROUP BY TR_ancien_gpe,to_char(D_FIN_CTT,'yyyy'))
pivot (sum(démissions)
for annee in (2017,2018,2019)
);










-- démission par ancienneté en 2018 
execute P_debut.debut := to_date('01/01/2018','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2018','DD/MM/YYYY');

select TR_ancien_gpe,count(*) as démissions
from
(select tb.*,
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE  
from (
select nom ,prenom ,matricule ,age_annee ,L_metier,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission' and type_mvt='Sortie') tb) tb2
GROUP BY TR_ancien_gpe;


-- démission par métier en 2017,2018,2019

execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');
select*
from
(select L_metier, count(*) as démission ,to_char(D_FIN_CTT,'yyyy' ) annee
from
(select nom ,prenom ,matricule ,age_annee ,L_metier,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission' and type_mvt='Sortie')
group by L_metier,to_char(D_FIN_CTT,'yyyy'))
pivot( sum(démission)
for annee in (2017,2018,2019)
);



--démission métier par 2018
execute P_debut.debut := to_date('01/01/2018','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2018','DD/MM/YYYY');

select L_metier, count(*)
from
(select nom ,prenom ,matricule ,age_annee ,L_metier,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission' and type_mvt='Sortie' )
group by L_metier



--requete 2	Répartition des démissions du réseau par Direction / Région Commerciale sur les 3 dernières années 


select *
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES ;

--démission par réseau en 2019

execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');

 

select L_AFFECT_2,count(*)as démission,L_filiere,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire
from
(select  nom,prenom,matricule ,L_AFFECT_2,L_MOTF_SORT_SOC,L_filiere
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission' )
group by  L_AFFECT_2,L_filiere
;

select*
from( 
    select L_AFFECT_2,count(*) as démission ,L_filiere,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire
    from
    (select  nom,prenom,matricule ,L_AFFECT_2,L_MOTF_SORT_SOC,L_filiere
      from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
      where L_MOTF_SORT_SOC ='démission' and type_mvt='Sortie')
      group by  L_AFFECT_2,L_filiere)
pivot
(sum(démission)
for filierebinaire in ( 'Réseau','Siège')
);

--démission par réseau en 2018

execute P_debut.debut := to_date('01/01/2018','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2018','DD/MM/YYYY');

select L_filiere,count(*)
from
(select  nom,prenom,matricule ,L_AFFECT_2,L_MOTF_SORT_SOC,L_filiere
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='démission' and  L_filiere='FORCE DE VENTE' and type_mvt='Sortie')
group by L_filiere
--démission par réseau en 2017


-- requete 3

--par rupture conventionnelle par age en 2017,2018,2019
execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2020','DD/MM/YYYY');

select *
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES ;

select*
from
(select TR_AGE, count(*) as ruptureconventionnelle,to_char(D_FIN_CTT,'yyyy')annee
from 
(select tb.*, 
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE 
        
from (
select nom, prenom,age_annee,L_MOTF_SORT_SOC,L_metier,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES 
where L_MOTF_SORT_SOC ='Rupt.Convent.sans droit retraite' and type_mvt='Sortie') tb) tb2
group by TR_AGE, to_char(D_FIN_CTT,'yyyy'))
pivot( sum(ruptureconventionnelle)
for annee in (2017,2018,2020)
);

--par trancge d'age en 2018
execute P_debut.debut := to_date('01/01/2018','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2018','DD/MM/YYYY');

select *
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES ;

select TR_AGE, count(*) as ruptureconventionnelle
from 
(select tb.*, 
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE 
        
from (
select nom, prenom,age_annee,L_MOTF_SORT_SOC,L_metier,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES 
where L_MOTF_SORT_SOC ='Rupt.Convent.sans droit retraite' and type_mvt='Sortie') tb) tb2
group by TR_AGE;


-- rupture conventionnelle par ancienneté 2017,2018,2019
execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');

select *
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES ;
select*
from
(select TR_ancien_gpe, count(*) as ruptureconventionnelle,to_char(D_FIN_CTT,'yyyy')annee
from 
(select tb.*, 
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE 
        
from (
select nom, prenom,age_annee,L_MOTF_SORT_SOC,L_metier,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES 
where L_MOTF_SORT_SOC ='Rupt.Convent.sans droit retraite' and type_mvt='Sortie') tb) tb2
group by TR_ancien_gpe,to_char(D_FIN_CTT,'yyyy'))
pivot(sum(ruptureconventionnelle)
for annee in(2017,2018,2019)
);


-- rupture conventionnelle par ancienneté 2017
execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2017','DD/MM/YYYY');

select *
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES ;

select TR_ancien_gpe, count(*) as ruptureconventionnelle
from 
(select tb.*, 
  case when ancienneté < 1 then '1.Moins de 1 ans'
             when ancienneté >= 1 and ancienneté < 5 then '2.De 1 à 4 ans'
             when ancienneté >= 5 and ancienneté < 10 then '3.De 5 à 9 ans'
             when ancienneté >= 10 and ancienneté < 20 then '4.De 10 à 19 ans'
             when ancienneté >= 20 and ancienneté < 30 then '5.De 20 à 29 ans'
        else '6.30 ans et plus' end TR_ancien_gpe,
        
case when age_annee < 25 then '1.Moins de 25 ans'
             when age_annee >= 25 and age_annee < 35 then '2.De 25 à 34 ans'
             when age_annee >= 35 and age_annee < 45 then '3.De 35 à 44 ans'
             when age_annee >= 45 and age_annee < 55 then '4.De 45 à 54 ans'
             when age_annee >= 55 and age_annee < 60 then '5.De 55 à 59 ans'
        else '6.60 ans et plus' end TR_AGE 
        
from (
select nom, prenom,age_annee,L_MOTF_SORT_SOC,L_metier,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES 
where L_MOTF_SORT_SOC ='Rupt.Convent.sans droit retraite' and type_mvt='Sortie') tb) tb2
group by TR_ancien_gpe;

--par rupture conventionnelle par métier

execute P_debut.debut := to_date('01/01/2017','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');
select*
from
(select L_metier, count(*) as ruptureconventionnelle ,to_char(D_FIN_CTT,'yyyy' ) annee
from
(select nom ,prenom ,matricule ,age_annee ,L_metier,(case when L_filiere ='FORCE DE VENTE' then 'Réseau' else 'Siège' end) as filierebinaire ,
L_MOTF_SORT_SOC,D_FIN_CTT , D_DEB_CTT, round((D_FIN_CTT - D_DEB_CTT)/365.25,1) as ancienneté 
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES
where L_MOTF_SORT_SOC ='Rupt.Convent.sans droit retraite'and type_mvt='Sortie' )
group by L_metier,to_char(D_FIN_CTT,'yyyy'))
pivot( sum(ruptureconventionnelle)
for annee in (2017 rupconv2017, 2018 rupconv2018 ,2019 rupconv2019)
);

--requete 4 Décomposition des départs en retraite par métier en 2019 
execute P_debut.debut := to_date('01/01/2019','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2019','DD/MM/YYYY');

select*
from
(select L_metier, count(*) départretraite,to_char (d_sort_soc,'yyyy') annee
from 
(select nom, prenom, matricule,type_mvt, det_motif_sortie,L_metier,d_sort_soc,c_nat_ctt, to_char (d_sort_soc,'yyyy') année
from sres11_rh.VP_REF_EFF_ENTREESORTIE_2DATES 
where det_motif_sortie ='Retraite initiative salarié' and type_mvt='Sortie' and c_nat_ctt='CDI')

group by L_metier,to_char (d_sort_soc,'yyyy') )
pivot(sum(départretraite)
for annee in(2019)
);





