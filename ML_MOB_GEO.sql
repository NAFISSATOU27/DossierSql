/* Programme de cr�ation de la base mobilit� g�ographique  */

execute P_debut.debut := to_date('31/12/2015','DD/MM/YYYY');
execute P_fin.fin := to_date('31/12/2020','DD/MM/YYYY');


--mobilit� g�o
--create table ML_MOBI_GEO as 
select matricule,to_char(debut,'DD/MM/YYYY') as debut,
case when mobilite_geo ='Mobilit� g�ographique' then 'Oui'ELSE 'Non' end Mob_geo
from VP_REF_EFF_MVT_ENTRE_2_DATES 
where mobilite_geo= 'Mobilit� g�ographique';
--commit;

--drop table ML_MOBI_GEO;
--commit;

select *
from ML_MOBI_GEO;



-- nouvelle �tude

select a.matricule,to_char(a.dat_nais,('DD/MM/YYYY')) as DATE_NAIS,a.sexe
,to_char(a.d_entr_grp,'DD/MM/YYYY') as D_ENTR_GPR,to_char(a.pr�sent_au,'DD/MM/YYYY') AS PRESENT_AU,b.debut,b.Mob_geo
from ref_effectif_histo a
left join 
(select matricule,to_char(debut,'DD/MM/YYYY') as debut,
case when mobilite_geo ='Mobilit� g�ographique' then 'Oui'ELSE 'Non' end Mob_geo
from VP_REF_EFF_MVT_ENTRE_2_DATES 
where mobilite_geo= 'Mobilit� g�ographique') b
on a.matricule=b.matricule
where c_nat_ctt='CDI'  and C_FILIERE not in ('RD','9') and pr�sent_au between '01/01/2017' and '31/07/2021'
;
