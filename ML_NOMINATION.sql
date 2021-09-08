/* Programme de création de la base nomination */

--drop table ML_Nomination;
--commit;

execute P_debut.debut := to_date('01/01/2018','DD/MM/YYYY');
execute P_fin.fin := to_date('30/06/2021','DD/MM/YYYY');

--create table ML_Nomination as
select  matricule,to_char(debut,'DD/MM/YYYY') as debut,
case when type_mvt_fonc='Nomination ss chgt classif' then 'Oui' end Nomination
from VP_REF_EFF_MVT_ENTRE_2_DATES 
where type_mvt_fonc in ('Nomination ss chgt classif');

--commit;

-- pour les presents


select a.matricule,to_char(a.dat_nais,('DD/MM/YYYY')) as DATE_NAIS,a.sexe
,to_char(a.d_entr_grp,'DD/MM/YYYY') as D_ENTR_GPR,to_char(a.présent_au,'DD/MM/YYYY') AS PRESENT_AU,b.debut,b.Nomination
from ref_effectif_histo a

left join 
(select  matricule,to_char(debut,'DD/MM/YYYY') as debut,
case when type_mvt_fonc='Nomination ss chgt classif' then 'Oui' end Nomination
from VP_REF_EFF_MVT_ENTRE_2_DATES 
where type_mvt_fonc in ('Nomination ss chgt classif')) b
on a.matricule=b.matricule
where c_nat_ctt='CDI'  and C_FILIERE not in ('RD','9') and présent_au between '01/01/2017' and '31/07/2021';
 



