/* Programme de création de la base sortie*/

execute P_debut.debut := to_date('31/12/2017','DD/MM/YYYY'); 
execute P_fin.fin := to_date('08/09/2021','DD/MM/YYYY');



--create table ML_SORTIE_NG as
select  matricule,d_sort_soc as date_sortie, to_char(d_sort_soc,'DD/MM/YYYY') as d_sort_soc,l_motf_sort_soc
from VP_REF_EFF_ENTREESORTIE_2DATES
where type_mvt='Sortie' and c_aff_str_adm not in ('HL000000000000000','CE000000000000000')
and c_nat_ctt='CDI';
--commit;



--base sortie pour deuxième étude
execute P_debut.debut := to_date('01/01/2016','DD/MM/YYYY'); 
execute P_fin.fin := to_date('31/08/2021','DD/MM/YYYY');


select matricule,mois,d_sort_soc as date_sortie, to_char(d_sort_soc,'DD/MM/YYYY') as d_sort_soc,l_motf_sort_soc,sexe,dat_nais as date_nais,d_entr_grp
from VP_REF_EFFz_ENTREESORTIE_2DATES
where type_mvt='Sortie' and c_aff_str_adm not in ('HL000000000000000','CE000000000000000')
and c_nat_ctt='CDI' ;
