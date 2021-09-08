--création de table ABS
create table ML_ABS2 as
SELECT a.matricule,d_arrt_info as date_abs,
          to_char(d_arrt_info,'DD/MM/YYYY') AS d_arr_info
            ,sum (b.absent) as sum_abs   
            ,sum (b.absent_maladie_acc) as sum_maladie_acc
            ,sum (b.absent_mater) as sum_mater
            ,sum (b.absent_abs_autre) as sum_abs_autre
           
            FROM
                (SELECT distinct 
                 matricule 
                 ,nvl(d_deb,lag(d_deb) over(partition by matricule order by d_arrt_info)) d_deb 
                 ,nvl(d_fin,lead(d_fin) over(partition by matricule order by d_arrt_info)) d_fin 
                FROM 
                     (SELECT  
                      a.* 
                      ,case when ( absent <> 0 and absent<>nvl(lag(absent,1) over(partition by a.matricule order by d_arrt_info),0 ) ) 
                      or ( absent <> 0 and absent<>nvl(lead(absent,1) over(partition by a.matricule order by d_arrt_info),0) )  
                      then 'Abs' end top 
                      ,case when absent <> 0 and (lag(absent,1) over(partition by a.matricule order by d_arrt_info) = 0 or lag (absent,1) 
                      over(partition by a.matricule order by d_arrt_info) is null or absent<>lag(absent,1) over(partition by a.matricule order by d_arrt_info) )  
                      then d_arrt_info end d_deb 
                      ,case when absent <> 0 and (lead(absent,1) over(partition by a.matricule order by d_arrt_info) = 0 or lead(absent,1) 
                      over(partition by a.matricule order by d_arrt_info) is null  or absent<>lead(absent,1) over(partition by a.matricule order by d_arrt_info) )  
                      then d_arrt_info end d_fin 
                  
                      FROM
                           (SELECT matricule, d_arrt_info, absent 
                            FROM 
                                (SELECT a_bis.matricule, a_bis.d_arrt_info , a_bis.tps_theo 
                                      ,nvl(b.dur_abs,0) dur_abs 
                                      ,nvl(b.dur_abs,0)/a_bis.tps_theo as tx 
                                      ,case when (nvl(b.dur_abs,0)/a_bis.tps_theo>=0.4 and nvl(b.dur_abs,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.dur_abs,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent  
                                FROM 
                                      (SELECT a.matricule,a.d_arrt_info,
                                      case when tps_theo = 0 then 7.6 else tps_theo end as tps_theo, count(*) nb 
                                       FROM GTA_ABSENCES a 
                                       WHERE  a.d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and a.d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       GROUP BY a.matricule,a.d_arrt_info,a.tps_theo) a_bis 
                                       
                                LEFT JOIN 
                                      (SELECT matricule,d_arrt_info,sum(
                                      case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end 
                                      ) dur_abs
                                       FROM GTA_ABSENCES 
                                       WHERE  d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       AND (( code_ip in                 ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN',
                                       'EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB','SE','SF','SS','XY','AL','B1','BB','GP','P1','P2','P3','P6','PA','MS',
                                       'MA','MN','MP','TH','M1','LA','AJ','AT')   
                                                          AND (typ_nat='A'  or (typ_nat='I' and code_ip='AJU')) )
                                        )
                                       GROUP BY matricule,d_arrt_info
                                    ) b 
                                ON a_bis.matricule=b.matricule and a_bis.d_arrt_info=b.d_arrt_info 
                                order by a_bis.matricule,a_bis.d_arrt_info )
                              )a
                          ) 
                        WHERE top = 'Abs' 
                        AND absent = 1 ) a 
 
              LEFT JOIN  
                      (SELECT matricule, d_arrt_info, absent ,  absent_maladie_acc ,absent_mater,
                                       absent_abs_autre
                            FROM 
                                (SELECT a_bis.matricule, a_bis.d_arrt_info , a_bis.tps_theo 
                                      ,nvl(b.dur_abs,0) dur_abs 
                                      ,nvl(b.dur_abs,0)/a_bis.tps_theo as tx 
                                      ,case when (nvl(b.dur_abs,0)/a_bis.tps_theo>=0.4 and nvl(b.dur_abs,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.dur_abs,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent
                                       ,case when (nvl(b.sum_maladie_acc,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_maladie_acc,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_maladie_acc,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_maladie_acc
                                       ,case when (nvl(b.sum_mater,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_mater,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_mater,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_mater
                                       ,case when (nvl(b.sum_abs_autre,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_abs_autre,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_abs_autre,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_abs_autre
                                FROM 
                                      (SELECT a.matricule,a.d_arrt_info, case when tps_theo = 0 then 7.6 else tps_theo end as tps_theo,count(*) nb 
                                       FROM GTA_ABSENCES a 
                                       WHERE  a.d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and a.d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       GROUP BY a.matricule,a.d_arrt_info,a.tps_theo) a_bis 
                                       
                                LEFT JOIN 
                                      (
                                      SELECT matricule,d_arrt_info, 
                                      case 
                                      when code_ip in ('MA','MN','MP','TH','M1','LA','AJ','AT')then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_maladie_acc,
                                      case 
                                      when code_ip in ('AL','B1','BB','GP','P1','P2','P3','P6','PA','MS') then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_mater,
                                      case 
                                      when code_ip  in ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN','EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB',
                                      'SE','SF','SS','XY') then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_abs_autre,
                                      sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) dur_abs
                                       FROM GTA_ABSENCES    
                                       WHERE  d_arrt_info >= to_date('31/12/2015','DD/MM/YYYY') and d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       AND (( code_ip in                 ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN',
                                       'EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB','SE','SF','SS','XY','AL','B1','BB','GP','P1','P2','P3','P6','PA','MS',
                                       'MA','MN','MP','TH','M1','LA','AJ','AT' )   
                                                          AND (typ_nat='A'  or (typ_nat='I' and code_ip='AJU')) )
                                        )
                                       GROUP BY matricule,d_arrt_info, code_ip
                                    ) b 
                                ON a_bis.matricule=b.matricule and a_bis.d_arrt_info=b.d_arrt_info 
                                order by a_bis.matricule,a_bis.d_arrt_info )
                        ) b on a.matricule = b.matricule and b.d_arrt_info >= a.d_deb and b.d_arrt_info <= a.d_fin        
              GROUP BY a.matricule,d_arrt_info;
commit;



----------------------------------nbre d'abscence ()
create table ML_ABS2 as
SELECT a.matricule,d_arrt_info as date_abs,
          to_char(d_arrt_info,'DD/MM/YYYY') AS d_arr_info
            ,sum (b.absent) as sum_abs   
            ,sum (b.absent_maladie_acc) as sum_maladie_acc
            ,sum (b.absent_mater) as sum_mater
            ,sum (b.absent_abs_autre) as sum_abs_autre
           
            FROM
                (SELECT distinct 
                 matricule 
                 ,nvl(d_deb,lag(d_deb) over(partition by matricule order by d_arrt_info)) d_deb 
                 ,nvl(d_fin,lead(d_fin) over(partition by matricule order by d_arrt_info)) d_fin 
                FROM 
                     (SELECT  
                      a.* 
                      ,case when ( absent <> 0 and absent<>nvl(lag(absent,1) over(partition by a.matricule order by d_arrt_info),0 ) ) 
                      or ( absent <> 0 and absent<>nvl(lead(absent,1) over(partition by a.matricule order by d_arrt_info),0) )  
                      then 'Abs' end top 
                      ,case when absent <> 0 and (lag(absent,1) over(partition by a.matricule order by d_arrt_info) = 0 or lag (absent,1) 
                      over(partition by a.matricule order by d_arrt_info) is null or absent<>lag(absent,1) over(partition by a.matricule order by d_arrt_info) )  
                      then d_arrt_info end d_deb 
                      ,case when absent <> 0 and (lead(absent,1) over(partition by a.matricule order by d_arrt_info) = 0 or lead(absent,1) 
                      over(partition by a.matricule order by d_arrt_info) is null  or absent<>lead(absent,1) over(partition by a.matricule order by d_arrt_info) )  
                      then d_arrt_info end d_fin 
                  
                      FROM
                           (SELECT matricule, d_arrt_info, absent 
                            FROM 
                                (SELECT a_bis.matricule, a_bis.d_arrt_info , a_bis.tps_theo 
                                      ,nvl(b.dur_abs,0) dur_abs 
                                      ,nvl(b.dur_abs,0)/a_bis.tps_theo as tx 
                                      ,case when (nvl(b.dur_abs,0)/a_bis.tps_theo>=0.4 and nvl(b.dur_abs,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.dur_abs,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent  
                                FROM 
                                      (SELECT a.matricule,a.d_arrt_info,
                                      case when tps_theo = 0 then 7.6 else tps_theo end as tps_theo, count(*) nb 
                                       FROM GTA_ABSENCES a 
                                       WHERE  a.d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and a.d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       GROUP BY a.matricule,a.d_arrt_info,a.tps_theo) a_bis 
                                       
                                LEFT JOIN 
                                      (SELECT matricule,d_arrt_info,sum(
                                      case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end 
                                      ) dur_abs
                                       FROM GTA_ABSENCES 
                                       WHERE  d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       AND (( code_ip in                 ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN',
                                       'EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB','SE','SF','SS','XY','AL','B1','BB','GP','P1','P2','P3','P6','PA','MS',
                                       'MA','MN','MP','TH','M1','LA','AJ','AT')   
                                                          AND (typ_nat='A'  or (typ_nat='I' and code_ip='AJU')) )
                                        )
                                       GROUP BY matricule,d_arrt_info
                                    ) b 
                                ON a_bis.matricule=b.matricule and a_bis.d_arrt_info=b.d_arrt_info 
                                order by a_bis.matricule,a_bis.d_arrt_info )
                              )a
                          ) 
                        WHERE top = 'Abs' 
                        AND absent = 1 ) a 
 
              LEFT JOIN  
                      (SELECT matricule, d_arrt_info, absent ,  absent_maladie_acc ,absent_mater,
                                       absent_abs_autre
                            FROM 
                                (SELECT a_bis.matricule, a_bis.d_arrt_info , a_bis.tps_theo 
                                      ,nvl(b.dur_abs,0) dur_abs 
                                      ,nvl(b.dur_abs,0)/a_bis.tps_theo as tx 
                                      ,case when (nvl(b.dur_abs,0)/a_bis.tps_theo>=0.4 and nvl(b.dur_abs,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.dur_abs,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent
                                       ,case when (nvl(b.sum_maladie_acc,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_maladie_acc,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_maladie_acc,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_maladie_acc
                                       ,case when (nvl(b.sum_mater,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_mater,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_mater,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_mater
                                       ,case when (nvl(b.sum_abs_autre,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_abs_autre,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_abs_autre,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_abs_autre
                                FROM 
                                      (SELECT a.matricule,a.d_arrt_info, case when tps_theo = 0 then 7.6 else tps_theo end as tps_theo,count(*) nb 
                                       FROM GTA_ABSENCES a 
                                       WHERE  a.d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and a.d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       GROUP BY a.matricule,a.d_arrt_info,a.tps_theo) a_bis 
                                       
                                LEFT JOIN 
                                      (
                                      SELECT matricule,d_arrt_info, 
                                      case 
                                      when code_ip in ('MA','MN','MP','TH','M1','LA','AJ','AT')then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_maladie_acc,
                                      case 
                                      when code_ip in ('AL','B1','BB','GP','P1','P2','P3','P6','PA','MS') then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_mater,
                                      case 
                                      when code_ip  in ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN','EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB',
                                      'SE','SF','SS','XY') then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_abs_autre,
                                      sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) dur_abs
                                       FROM GTA_ABSENCES    
                                       WHERE  d_arrt_info >= to_date('31/12/2015','DD/MM/YYYY') and d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       AND (( code_ip in                 ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN',
                                       'EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB','SE','SF','SS','XY','AL','B1','BB','GP','P1','P2','P3','P6','PA','MS',
                                       'MA','MN','MP','TH','M1','LA','AJ','AT' )   
                                                          AND (typ_nat='A'  or (typ_nat='I' and code_ip='AJU')) )
                                        )
                                       GROUP BY matricule,d_arrt_info, code_ip
                                    ) b 
                                ON a_bis.matricule=b.matricule and a_bis.d_arrt_info=b.d_arrt_info 
                                order by a_bis.matricule,a_bis.d_arrt_info )
                        ) b on a.matricule = b.matricule and b.d_arrt_info >= a.d_deb and b.d_arrt_info <= a.d_fin        
              GROUP BY a.matricule,d_arrt_info;
commit;

select*
from ML_ABS;

--drop table ML_ABS;
--commit;



-- nouvelle étude 
select *
from 
(select ng.matricule,to_char(ng.dat_nais,('DD/MM/YYYY')) as DATE_NAIS,ng.sexe
,to_char(ng.d_entr_grp,'DD/MM/YYYY') as D_ENTR_GPR,to_char(ng.présent_au,'DD/MM/YYYY') AS PRESENT_AU,kg.d_arr_info,kg.sum_maladie_acc,kg.sum_abs_autre,kg.sum_mater
from ref_effectif_histo ng

left join 

(
SELECT a.matricule,d_arrt_info as date_abs,
          to_char(d_arrt_info,'DD/MM/YYYY') AS d_arr_info
            ,sum (b.absent) as sum_abs   
            ,sum (b.absent_maladie_acc) as sum_maladie_acc
            ,sum (b.absent_mater) as sum_mater
            ,sum (b.absent_abs_autre) as sum_abs_autre
           
            FROM
                (SELECT distinct 
                 matricule 
                 ,nvl(d_deb,lag(d_deb) over(partition by matricule order by d_arrt_info)) d_deb 
                 ,nvl(d_fin,lead(d_fin) over(partition by matricule order by d_arrt_info)) d_fin 
                FROM 
                     (SELECT  
                      a.* 
                      ,case when ( absent <> 0 and absent<>nvl(lag(absent,1) over(partition by a.matricule order by d_arrt_info),0 ) ) 
                      or ( absent <> 0 and absent<>nvl(lead(absent,1) over(partition by a.matricule order by d_arrt_info),0) )  
                      then 'Abs' end top 
                      ,case when absent <> 0 and (lag(absent,1) over(partition by a.matricule order by d_arrt_info) = 0 or lag (absent,1) 
                      over(partition by a.matricule order by d_arrt_info) is null or absent<>lag(absent,1) over(partition by a.matricule order by d_arrt_info) )  
                      then d_arrt_info end d_deb 
                      ,case when absent <> 0 and (lead(absent,1) over(partition by a.matricule order by d_arrt_info) = 0 or lead(absent,1) 
                      over(partition by a.matricule order by d_arrt_info) is null  or absent<>lead(absent,1) over(partition by a.matricule order by d_arrt_info) )  
                      then d_arrt_info end d_fin 
                  
                      FROM
                           (SELECT matricule, d_arrt_info, absent 
                            FROM 
                                (SELECT a_bis.matricule, a_bis.d_arrt_info , a_bis.tps_theo 
                                      ,nvl(b.dur_abs,0) dur_abs 
                                      ,nvl(b.dur_abs,0)/a_bis.tps_theo as tx 
                                      ,case when (nvl(b.dur_abs,0)/a_bis.tps_theo>=0.4 and nvl(b.dur_abs,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.dur_abs,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent  
                                FROM 
                                      (SELECT a.matricule,a.d_arrt_info,
                                      case when tps_theo = 0 then 7.6 else tps_theo end as tps_theo, count(*) nb 
                                       FROM GTA_ABSENCES a 
                                       WHERE  a.d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and a.d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       GROUP BY a.matricule,a.d_arrt_info,a.tps_theo) a_bis 
                                       
                                LEFT JOIN 
                                      (SELECT matricule,d_arrt_info,sum(
                                      case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end 
                                      ) dur_abs
                                       FROM GTA_ABSENCES 
                                       WHERE  d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       AND (( code_ip in                 ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN',
                                       'EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB','SE','SF','SS','XY','AL','B1','BB','GP','P1','P2','P3','P6','PA','MS',
                                       'MA','MN','MP','TH','M1','LA','AJ','AT')   
                                                          AND (typ_nat='A'  or (typ_nat='I' and code_ip='AJU')) )
                                        )
                                       GROUP BY matricule,d_arrt_info
                                    ) b 
                                ON a_bis.matricule=b.matricule and a_bis.d_arrt_info=b.d_arrt_info 
                                order by a_bis.matricule,a_bis.d_arrt_info )
                              )a
                          ) 
                        WHERE top = 'Abs' 
                        AND absent = 1 ) a 
 
              LEFT JOIN  
                      (SELECT matricule, d_arrt_info, absent ,  absent_maladie_acc ,absent_mater,
                                       absent_abs_autre
                            FROM 
                                (SELECT a_bis.matricule, a_bis.d_arrt_info , a_bis.tps_theo 
                                      ,nvl(b.dur_abs,0) dur_abs 
                                      ,nvl(b.dur_abs,0)/a_bis.tps_theo as tx 
                                      ,case when (nvl(b.dur_abs,0)/a_bis.tps_theo>=0.4 and nvl(b.dur_abs,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.dur_abs,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent
                                       ,case when (nvl(b.sum_maladie_acc,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_maladie_acc,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_maladie_acc,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_maladie_acc
                                       ,case when (nvl(b.sum_mater,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_mater,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_mater,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_mater
                                       ,case when (nvl(b.sum_abs_autre,0)/a_bis.tps_theo>=0.4 and nvl(b.sum_abs_autre,0)/a_bis.tps_theo<=0.6) then 0.5 
                                            when nvl(b.sum_abs_autre,0)/a_bis.tps_theo>0.6 then 1 
                                       else 0 end as absent_abs_autre
                                FROM 
                                      (SELECT a.matricule,a.d_arrt_info, case when tps_theo = 0 then 7.6 else tps_theo end as tps_theo,count(*) nb 
                                       FROM GTA_ABSENCES a 
                                       WHERE  a.d_arrt_info>= to_date('31/12/2015','DD/MM/YYYY') and a.d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       GROUP BY a.matricule,a.d_arrt_info,a.tps_theo) a_bis 
                                       
                                LEFT JOIN 
                                      (
                                      SELECT matricule,d_arrt_info, 
                                      case 
                                      when code_ip in ('MA','MN','MP','TH','M1','LA','AJ','AT')then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_maladie_acc,
                                      case 
                                      when code_ip in ('AL','B1','BB','GP','P1','P2','P3','P6','PA','MS') then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_mater,
                                      case 
                                      when code_ip  in ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN','EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB',
                                      'SE','SF','SS','XY') then sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) else 0 end as sum_abs_autre,
                                      sum( case 
                                      when (dur_abs is null or dur_abs = 0) and TPS_THEO = 0 then 7.6 
                                      when code_ip = 'JCE' and dur_abs = 0 then TPS_THEO
                                      else dur_abs end ) dur_abs
                                       FROM GTA_ABSENCES    
                                       WHERE  d_arrt_info >= to_date('31/12/2015','DD/MM/YYYY') and d_arrt_info <= to_date('31/12/2020','DD/MM/YYYY')
                                       AND (( code_ip in                 ('AB','AC','AI','AN','BA','CC','CF','CP','CR','CS','CT','CTFC','DE','EC','ED','EE','EF','EG','EM','EN',
                                       'EP','EQ','ES','HU','HY','IC','IN','MD','PC','PR','SB','SE','SF','SS','XY','AL','B1','BB','GP','P1','P2','P3','P6','PA','MS',
                                       'MA','MN','MP','TH','M1','LA','AJ','AT' )   
                                                          AND (typ_nat='A'  or (typ_nat='I' and code_ip='AJU')) )
                                        )
                                       GROUP BY matricule,d_arrt_info, code_ip
                                    ) b 
                                ON a_bis.matricule=b.matricule and a_bis.d_arrt_info=b.d_arrt_info 
                                order by a_bis.matricule,a_bis.d_arrt_info )
                        ) b on a.matricule = b.matricule and b.d_arrt_info >= a.d_deb and b.d_arrt_info <= a.d_fin        
              GROUP BY a.matricule,d_arrt_info) kg
on ng.matricule=kg.matricule
where c_nat_ctt='CDI'  and C_FILIERE not in ('RD','9') and présent_au= '30/06/2020')
where d_arr_info between add_months(present_au ,-12) and present_au or d_arr_info is null or d_arr_info is not null  ;