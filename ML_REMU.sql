--- ---------------base remun�ration prem�re �tude 
select matricule,remu_annuelle
from ref_effectif_histo
where pr�sent_au in ('31/12/18','31/12/19','31/12/20') and 
c_nat_ctt='CDI'and  C_FILIERE not in ('RD','9');



-------------------base  remu pour deuxi�me �tude
select matricule,remu_annuelle,to_char(pr�sent_au,'DD/MM/YYYY') as present_au
from ref_effectif_histo
where c_nat_ctt='CDI'and  C_FILIERE not in ('RD','9') and pr�sent_au between '01/01/2017' and '31/07/2021';
