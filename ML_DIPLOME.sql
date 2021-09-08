/* Programme de création de la base diplome max */ -- base utilisée pour faire la deuxième étude 

--create table ML_DIPLOME as
--select matricule,count(*)
--from

--(
select matricule,NIVEAU_DIPL_MAX,
case when NIVEAU_DIPL_MAX in (' Sans diplôme', '< au bac',' Bac',' Autre',' Bac + 1') then '<= Bac +1'
when  NIVEAU_DIPL_MAX =' Bac + 2' then 'Bac+2'
when NIVEAU_DIPL_MAX=' Bac + 3' then 'Bac+3'
when  NIVEAU_DIPL_MAX=' Bac + 4' then 'Bac+4'
when NIVEAU_DIPL_MAX in (' Bac + 5',' Bac + 6') then '+Bac +5' end diplome
from
(select distinct  max (RANG_DIPLOME_MAX) over (partition by MATRICULE) Max_diplome_max,MATRICULE, max(NIVEAU_DIPLOME_MAX) over (partition by MATRICULE) as niveau_dipl_max --,RANG_DIPLOME_MAX,D_MAJ_DIPL
                       from (select distinct
                                  MATRICULE,D_MAJ_DIPL
                                  ,case when C_NIV_DIPL is null then -4
                                        when C_NIV_DIPL = 'A' then -3
                                        when C_NIV_DIPL = '0' then -2
                                        when C_NIV_DIPL = 'AB' then -1
                                        when C_NIV_DIPL = 'B0' then 0
                                        when C_NIV_DIPL = 'B1' then 1
                                        when C_NIV_DIPL = 'B2' then 2
                                        when C_NIV_DIPL = 'B3' then 3
                                        when C_NIV_DIPL = 'B4' then 4     
                                        when C_NIV_DIPL = 'B5' then 5
                                        when C_NIV_DIPL = 'B6' then 6
                                        else null end Rang_diplome_max
                                  ,case when C_NIV_DIPL is null then ' Sans diplôme'
                                        when C_NIV_DIPL = 'A' then ' Sans diplôme'
                                        when C_NIV_DIPL = '0' then ' Autre'
                                        when C_NIV_DIPL = 'AB' then ' < au bac'
                                        when C_NIV_DIPL = 'B0' then ' Bac'
                                        when C_NIV_DIPL = 'B1' then ' Bac + 1'
                                        when C_NIV_DIPL = 'B2' then ' Bac + 2'
                                        when C_NIV_DIPL = 'B3' then ' Bac + 3'
                                        when C_NIV_DIPL = 'B4' then ' Bac + 4'      
                                        when C_NIV_DIPL = 'B5' then ' Bac + 5'
                                        when C_NIV_DIPL = 'B6' then ' Bac + 6'
                                        else '' end Niveau_diplome_max
                                from HYP_DIPLOME
                                where DIPL_MAX ='O') )
                                --)
                                --group by matricule
                                --having count(*) > 1;
commit;                 
--40203394

select distinct niveau_dipl_max
FROM ML_DIPLOME;
