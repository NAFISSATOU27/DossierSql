/* Programme de création de la base emploi */



--anciennté emploi à prende dans la vue que Sandra à créer
execute P_debut.debut := to_date('01/12/2013','DD/MM/YYYY'); 
execute P_fin.fin := to_date('31/12/2020','DD/MM/YYYY');





select *
from
(select matricule,to_char(présent_au,'DD/MM/YYYY') as present_au,to_char(deb,'DD/MM/YYYY') as deb,to_char(fin,'DD/MM/YYYY') as fin,
DENSE_RANK() OVER (PARTITION BY matricule ORDER BY matricule,deb DESC) AS ID_RANK 
from
(select b.matricule,b.mat_comm_info,b.présent_au,a.DEB,a.FIN,a.c_empl
from
(SELECT distinct matricule,mat_comm_info,présent_au
FROM ref_effectif_histo 
where présent_au in ('31/12/2018','31/12/2019','31/12/2020') and c_nat_ctt='CDI' AND c_filiere not in ('9','RD')) b
left join 
(select*-- mat_comm_info,deb,fin,c_empl
from V_ANC_EMPL_OCC 
)a
on a.mat_comm_info=b.mat_comm_info))
--where deb <='31/12/2020')
where id_rank =1;

--group by matricule
--having count(*) > 1;
--40200312

--nouvelle approche -- les presents
select *
from
(select matricule,to_char(présent_au,'DD/MM/YYYY') as present_au,to_char(deb,'DD/MM/YYYY') as deb,to_char(fin,'DD/MM/YYYY') as fin,
DENSE_RANK() OVER (PARTITION BY matricule ORDER BY matricule,deb DESC) AS ID_RANK ,c_empl
from
(select b.matricule,b.mat_comm_info,b.présent_au,a.DEB,a.FIN,a.c_empl
from
(SELECT distinct matricule,mat_comm_info,présent_au
FROM ref_effectif_histo 
where présent_au between '01/01/2017' and '31/07/2021' and c_nat_ctt='CDI' AND c_filiere not in ('9','RD')) b
left join 
(select*-- mat_comm_info,deb,fin,c_empl
from V_ANC_EMPL_OCC 
)a
on a.mat_comm_info=b.mat_comm_info))
--where deb <='31/12/2020')
where id_rank =1;