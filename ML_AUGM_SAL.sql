/* Programme de création de la base augmentaion salaire*/

--drop table ML_AUGM_SAL;
--commit;

create table ML_AUGM_SAL as
select *
from
(select to_char(d_deb_rem,'DD/MM/YYYY') as d_deb_rem,matricule,salannuel,MTT_AUGM_INDIV,L_TYP_AUGM_INDIV,C_TYP_AUGM_INDIV
from
(select distinct matricule,MTT_AUGM_INDIV,L_TYP_AUGM_INDIV,C_TYP_AUGM_INDIV,SALANNUEL,d_deb_rem
from REF_AUGMENTATIONS

))
where salannuel is not null and L_TYP_AUGM_INDIV='Augmentation Individuelle'
;

--commit;


select*
from ML_AUGM_SAL;



-------------------augmentation pour la deuxième étude ,meme code  que la première étude
select *
from
(select to_char(d_deb_rem,'DD/MM/YYYY') as d_deb_rem,matricule,salannuel,MTT_AUGM_INDIV,L_TYP_AUGM_INDIV,C_TYP_AUGM_INDIV
from
(select distinct matricule,MTT_AUGM_INDIV,L_TYP_AUGM_INDIV,C_TYP_AUGM_INDIV,SALANNUEL,d_deb_rem
from REF_AUGMENTATIONS


))
where salannuel is not null and L_TYP_AUGM_INDIV='Augmentation Individuelle'
;
