/* Programme de création de la base formation */

--formation
--create table ML_FORMATION as
select distinct matricule,code_form,to_char(date_debut,'DD/MM/YYYY') as date_debut
from

(select   matricule,code as CODE_FORM,nom_form,date_debut,date_fin
from ess_elearning
where etat_prog='Terminé' and succes <> 'Non'
union
select matricule,code_form ,lib_form as nom_form,date_debut_session as date_debut,date_fin_session as date_debut
from HRT_SUIVI_DES_HEURES
where tot_h_real>0
--and etat_inscription='Inscrit'
AND statut_session IN ( 'Terminée')
AND etat_inscription IN ( 'Inscrit', 'Ré-inscrit'));

commit;

select*
from  ML_FORMATION;
--where code_form is null;




--nouvelle étude
SELECT*
from
(select a.matricule,to_char(a.dat_nais,('DD/MM/YYYY')) as DATE_NAIS,a.sexe
,to_char(a.d_entr_grp,'DD/MM/YYYY') as D_ENTR_GPR,to_char(a.présent_au,'DD/MM/YYYY') AS PRESENT_AU,b.date_debut,b.code_form
from ref_effectif_histo a

left join 
(select distinct matricule,code_form,to_char(date_debut,'DD/MM/YYYY') as date_debut
from

(select   matricule,code as CODE_FORM,nom_form,date_debut,date_fin
from ess_elearning
where etat_prog='Terminé' and succes <> 'Non'
union
select matricule,code_form ,lib_form as nom_form,date_debut_session as date_debut,date_fin_session as date_debut
from HRT_SUIVI_DES_HEURES
where tot_h_real>0
--and etat_inscription='Inscrit'
AND statut_session IN ( 'Terminée')
AND etat_inscription IN ( 'Inscrit', 'Ré-inscrit'))) b
on a.matricule=b.matricule
where c_nat_ctt='CDI'  and C_FILIERE not in ('RD','9') and présent_au between '01/01/2017' and '31/07/2021')

;

