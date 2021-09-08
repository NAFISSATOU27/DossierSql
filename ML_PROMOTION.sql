/* Programme de création de la base promotion */

--drop table ML_PROMOTION;
--commit;

execute P_debut.debut := to_date('31/12/2016','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2020','DD/MM/YYYY');

create table ML_PROMOTION as

select  matricule,l_motf_perd,to_char(debut,'DD/MM/YYYY') as debut,
case when type_mvt_fonc ='Promotion' then 'OUI' end Promotion
from VP_REF_EFF_MVT_ENTRE_2_DATES 
where type_mvt_fonc in ('Promotion');

commit;

select *
from ML_PROMOTION;



--nouvelle étude 

select a.matricule,to_char(a.dat_nais,('DD/MM/YYYY')) as DATE_NAIS,a.sexe
,to_char(a.d_entr_grp,'DD/MM/YYYY') as D_ENTR_GPR,to_char(a.présent_au,'DD/MM/YYYY') AS PRESENT_AU,b.debut,b.Promotion
from ref_effectif_histo a

left join 
(select  matricule,l_motf_perd,to_char(debut,'DD/MM/YYYY') as debut,
case when type_mvt_fonc ='Promotion' then 'OUI' end Promotion
from VP_REF_EFF_MVT_ENTRE_2_DATES 
where type_mvt_fonc in ('Promotion')) b
on a.matricule=b.matricule
where c_nat_ctt='CDI'  and C_FILIERE not in ('RD','9') and présent_au between '01/01/2017' and '31/07/2021'
;
