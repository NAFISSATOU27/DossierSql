/* Programme de création de la base candidature  */

--create table ML_CAND as 
select*
from
(select matricule,d_depot_cand,candidature_selectionnee
from
(select a.*,b.email,b.d_depot_cand,b.candidature_selectionnee
from
(select h.*,c.eml_prof
from
(select matricule,présent_au,NOM|| ' '|| PRENOM as nom_prenom
from ref_effectif_histo 
where c_nat_ctt='CDI'

)h
left join
(select matricule,eml_prof
from myl_per )c on h.matricule=c.matricule
) a 

left join
--données candidatures
(SELECT to_char(date_depot_candidature,'DD/MM/YYYY') as d_depot_cand,candidature_selectionnee,email,upper(nom_cand),upper(prenom_cand),
upper(nom_cand)|| ' '|| upper(prenom_cand)as nom_prenom
from APR_CANDIDATURE ) b on (b.nom_prenom = a.nom_prenom) or (b.email=a.eml_prof)))
where d_depot_cand is not null;
--commit;



------------------------------------- nouvelle----------------
--select min(d_depot_cand)
--from
--(
select*
from
(select distinct matricule,d_depot_cand,statut_candidature
from
(select a.*,b.email,b.d_depot_cand,b.statut_candidature
from
(select h.*,c.eml_prof
from
(select matricule,présent_au,NOM|| ' '|| PRENOM as nom_prenom
from ref_effectif_histo 
where c_nat_ctt='CDI'

)h
left join
(select matricule,eml_prof
from myl_per )c on h.matricule=c.matricule
) a 

left join
--données candidatures
(SELECT to_char(date_depot_candidature,'DD/MM/YYYY') as d_depot_cand,statut_candidature,email,upper(nom_cand),upper(prenom_cand),
upper(nom_cand)|| ' '|| upper(prenom_cand)as nom_prenom
from APR_CANDIDATURE 
where statut_candidature in ('Rejeté','Embauché')) b on (b.nom_prenom = a.nom_prenom) or (b.email=a.eml_prof)));
--where d_depot_cand is not null);

-- il n' a pas de candidature en 2018,que faire ? 
-- à bosser sur email perso , l'ajouter à la clé de jointure pour avoir plus de données