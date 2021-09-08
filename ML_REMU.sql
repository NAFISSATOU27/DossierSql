--- ---------------base remunération premère étude 
select matricule,remu_annuelle
from ref_effectif_histo
where présent_au in ('31/12/18','31/12/19','31/12/20') and 
c_nat_ctt='CDI'and  C_FILIERE not in ('RD','9');



-------------------base  remu pour deuxième étude
select matricule,remu_annuelle,to_char(présent_au,'DD/MM/YYYY') as present_au
from ref_effectif_histo
where c_nat_ctt='CDI'and  C_FILIERE not in ('RD','9') and présent_au between '01/01/2017' and '31/07/2021';
