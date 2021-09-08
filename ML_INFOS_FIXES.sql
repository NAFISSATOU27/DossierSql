/* Programme de création de la base fixe */



--create table ML_INFOS_FIXES as
select matricule,to_char(dat_nais,('DD/MM/YYYY')) as DATE_NAIS,sexe,to_char(d_entr_grp,'DD/MM/YYYY') as D_ENTR_GPR,to_char(présent_au,'DD/MM/YYYY') AS PRESENT_AU
from ref_effectif_histo
where présent_au in ('31/12/2018','31/12/2019','31/12/2020') and 
c_nat_ctt='CDI'  and C_FILIERE not in ('RD','9'); --J' AI ENLEVe LES RESPONSABLES DE DIRECTION ET LE PR2SIDENT CAR IL SONT AU NBRE DE 5? ET C'EST N'EST PAS REPR2SENTATIF DE LA POPULATION
--COMMIT;

select*
from ML_INFOS_FIXES ;


--drop table ML_INFOS_FIXES;
--commit;




-- nouvelle étude 

select matricule,to_char(dat_nais,('DD/MM/YYYY')) as DATE_NAIS,sexe
,to_char(d_entr_grp,'DD/MM/YYYY') as D_ENTR_GPR,to_char(présent_au,'DD/MM/YYYY') AS PRESENT_AU
from ref_effectif_histo 
where c_nat_ctt='CDI'  and C_FILIERE not in ('RD','9') and présent_au between '01/01/2017' and '31/07/2021';
