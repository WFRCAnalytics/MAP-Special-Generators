
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 03_Skim_auto.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=HIGHWAY  MSG='Mode Choice 3: perform highway skims'
FILEI  NETI     = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Summary.net'
       ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'

FILEO  MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_ff.mtx', 
           mo=1-4,100,120,
           name=ovt,
                permpark,
                temppark,
                xydist,
                ivt_GP,
                dist_GP
        
       MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Ok.mtx',
           mo=1-4, 200-205, 220-225, 241-245,253-255, 261-265,273-275, 281-285,293-295,
           name=ovt,
                permpark,
                temppark,
                xydist,
                ivt_GP,        ;total path - time
                ivt_HOV_S2,
                ivt_HOV_S3,
                ivt_Tol_DA,
                ivt_Tol_S2,
                ivt_Tol_S3,
                dist_GP,       ;total path - distance
                dist_HOV_S2,
                dist_HOV_S3,
                dist_Tol_DA,
                dist_Tol_S2,
                dist_Tol_S3,
                TO_HOV_S2,     ;trace of just managed lane - time (Time Only)
                TO_HOV_S3,
                TO_HOT_DA,
                TO_HOT_S2,
                TO_HOT_S3,
                TO_Tol_DA,
                TO_Tol_S2,
                TO_Tol_S3,
                DO_HOV_S2,     ;trace of just managed lane - distance (Distance Only)
                DO_HOV_S3,
                DO_HOT_DA,
                DO_HOT_S2,
                DO_HOT_S3,
                DO_Tol_DA,
                DO_Tol_S2,
                DO_Tol_S3,
                Fee_HOV_S2,    ;trace of just managed lane - toll cost
                Fee_HOV_S3,
                Fee_HOT_DA,
                Fee_HOT_S2,
                Fee_HOT_S3,
                Fee_Tol_DA,
                Fee_Tol_S2,
                Fee_Tol_S3
       
       MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_AM.tmp.mtx',
           mo=1-4, 300-305, 320-325, 341-345,353-355, 361-365,373-375, 381-385,393-395,
           name=ovt,
                permpark,
                temppark,
                xydist,
                ivt_GP,        ;total path - time
                ivt_HOV_S2,
                ivt_HOV_S3,
                ivt_Tol_DA,
                ivt_Tol_S2,
                ivt_Tol_S3,
                dist_GP,       ;total path - distance
                dist_HOV_S2,
                dist_HOV_S3,
                dist_Tol_DA,
                dist_Tol_S2,
                dist_Tol_S3,
                TO_HOV_S2,     ;trace of just managed lane - time (Time Only)
                TO_HOV_S3,
                TO_HOT_DA,
                TO_HOT_S2,
                TO_HOT_S3,
                TO_Tol_DA,
                TO_Tol_S2,
                TO_Tol_S3,
                DO_HOV_S2,     ;trace of just managed lane - distance (Distance Only)
                DO_HOV_S3,
                DO_HOT_DA,
                DO_HOT_S2,
                DO_HOT_S3,
                DO_Tol_DA,
                DO_Tol_S2,
                DO_Tol_S3,
                Fee_HOV_S2,    ;trace of just managed lane - toll cost
                Fee_HOV_S3,
                Fee_HOT_DA,
                Fee_HOT_S2,
                Fee_HOT_S3,
                Fee_Tol_DA,
                Fee_Tol_S2,
                Fee_Tol_S3
       
       MATO[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_PM.tmp.mtx',
           mo=1-4, 400-405, 420-425, 441-445,453-455, 461-465,473-475, 481-485,493-495,
           name=ovt,
                permpark,
                temppark,
                xydist,
                ivt_GP,        ;total path - time
                ivt_HOV_S2,
                ivt_HOV_S3,
                ivt_Tol_DA,
                ivt_Tol_S2,
                ivt_Tol_S3,
                dist_GP,       ;total path - distance
                dist_HOV_S2,
                dist_HOV_S3,
                dist_Tol_DA,
                dist_Tol_S2,
                dist_Tol_S3,
                TO_HOV_S2,     ;trace of just managed lane - time (Time Only)
                TO_HOV_S3,
                TO_HOT_DA,
                TO_HOT_S2,
                TO_HOT_S3,
                TO_Tol_DA,
                TO_Tol_S2,
                TO_Tol_S3,
                DO_HOV_S2,     ;trace of just managed lane - distance (Distance Only)
                DO_HOV_S3,
                DO_HOT_DA,
                DO_HOT_S2,
                DO_HOT_S3,
                DO_Tol_DA,
                DO_Tol_S2,
                DO_Tol_S3,
                Fee_HOV_S2,    ;trace of just managed lane - toll cost
                Fee_HOV_S3,
                Fee_HOT_DA,
                Fee_HOT_S2,
                Fee_HOT_S3,
                Fee_Tol_DA,
                Fee_Tol_S2,
                Fee_Tol_S3
        
        
    
    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
    ZONES   = @UsedZones@
    ZONEMSG = 5
    
    
    PHASE=LINKREAD
        ;initialize in vehicle time values
        lw.ivt_GP_FF = li.FF_TIME
        lw.ivt_GP_OK = li.MD_TIME
        lw.ivt_GP_AM = li.AM_TIME
        lw.ivt_GP_PM = li.PM_TIME
        
        lw.ivt_HOV_S2_OK = li.MD_TIME
        lw.ivt_HOV_S2_AM = li.AM_TIME
        lw.ivt_HOV_S2_PM = li.PM_TIME
        
        lw.ivt_HOV_S3_OK = li.MD_TIME
        lw.ivt_HOV_S3_AM = li.AM_TIME
        lw.ivt_HOV_S3_PM = li.PM_TIME
        
        lw.ivt_Tol_DA_OK = li.MD_TIME
        lw.ivt_Tol_DA_AM = li.AM_TIME
        lw.ivt_Tol_DA_PM = li.PM_TIME
        
        lw.ivt_Tol_S2_OK = li.MD_TIME
        lw.ivt_Tol_S2_AM = li.AM_TIME
        lw.ivt_Tol_S2_PM = li.PM_TIME
        
        lw.ivt_Tol_S3_OK = li.MD_TIME
        lw.ivt_Tol_S3_AM = li.AM_TIME
        lw.ivt_Tol_S3_PM = li.PM_TIME
        
        ;initialize HOV path cost
        lw.Cost_HOV_S2_OK = li.MD_TIME  
        lw.Cost_HOV_S2_AM = li.AM_TIME
        lw.Cost_HOV_S2_PM = li.PM_TIME
        
        lw.Cost_HOV_S3_OK = li.MD_TIME  
        lw.Cost_HOV_S3_AM = li.AM_TIME
        lw.Cost_HOV_S3_PM = li.PM_TIME
        
        ;initialize HOT and Toll path cost
        lw.Cost_Tol_DA_OK = li.MD_TIME
        lw.Cost_Tol_DA_AM = li.AM_TIME
        lw.Cost_Tol_DA_PM = li.PM_TIME
        
        lw.Cost_Tol_S2_OK = li.MD_TIME
        lw.Cost_Tol_S2_AM = li.AM_TIME
        lw.Cost_Tol_S2_PM = li.PM_TIME
        
        lw.Cost_Tol_S3_OK = li.MD_TIME
        lw.Cost_Tol_S3_AM = li.AM_TIME
        lw.Cost_Tol_S3_PM = li.PM_TIME
        
        
        ;Reliability lanes on arterials
        if (li.Rel_LN>0 & li.FT<20)
            ;estimated congested time for managed lane
            lw.ivt_MngLn_OK = li.DISTANCE / (li.FF_SPD * 0.98) * 60    ;assume managed lanes on arterials in off-peak are 98% of free flow speed
            lw.ivt_MngLn_AM = li.DISTANCE / (li.FF_SPD * 0.85) * 60    ;assume managed lanes on arterials at LOS C are traveling at 85% of free flow speed in AM
            lw.ivt_MngLn_PM = li.DISTANCE / (li.FF_SPD * 0.85) * 60    ;assume managed lanes on arterials at LOS C are traveling at 85% of free flow speed in PM
            
            ;for relibility lane 11-19, add managed lane time to peak direction only
            ;(inbound peak direction = AM, outbound peak direction = MD & PM)
            if (li.Rel_LN=10-19)
                if (li.IB_OB='IB')
                    lw.ivt_MngLn_OK = 9999
                    lw.ivt_MngLn_AM = lw.ivt_MngLn_AM
                    lw.ivt_MngLn_PM = 9999
                else
                    lw.ivt_MngLn_OK = lw.ivt_MngLn_OK
                    lw.ivt_MngLn_AM = 9999
                    lw.ivt_MngLn_PM = lw.ivt_MngLn_PM
                endif
            endif
            
            
            ;reset speeds based on estimated congested time for managed lane
            lw.ivt_HOV_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_HOV_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_DA_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_DA_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_DA_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            
            ;if HOT2 and HOT3 cost are zero then include as HOV
            ;off-peak - S2
            if (@Cost_2HOT_Ok@=0)
                Pen_HOV_S2_OK = 0
                Pen_Tol_S2_OK = 9999
            else
                Pen_HOV_S2_OK = 9999
                Pen_Tol_S2_OK = 0
            endif
            
            ;peak - S2
            if (@Cost_2HOT_AM@=0)
                Pen_HOV_S2_PK = 0
                Pen_Tol_S2_PK = 9999
            else
                Pen_HOV_S2_PK = 9999
                Pen_Tol_S2_PK = 0
            endif
            
            ;off-peak - S3
            if (@Cost_3HOT_Ok@=0)
                Pen_HOV_S3_OK = 0
                Pen_Tol_S3_OK = 9999
            else
                Pen_HOV_S3_OK = 9999
                Pen_Tol_S3_OK = 0
            endif
            
            ;peak - S3
            if (@Cost_3HOT_AM@=0)
                Pen_HOV_S3_PK = 0
                Pen_Tol_S3_PK = 9999
            else
                Pen_HOV_S3_PK = 9999
                Pen_Tol_S3_PK = 0
            endif
            
            
            ;calc toll cost 
            
            lw.Fee_HOT_DA_OK = li.DISTANCE * @Cost_REL_Ok@     ;Drive alone HOT costs
            lw.Fee_HOT_DA_PK = li.DISTANCE * @Cost_REL_Pk@
            
            lw.Fee_HOT_S2_OK = li.DISTANCE * @Cost_2REL_Ok@    ;Shared Ride 2 HOT costs
            lw.Fee_HOT_S2_PK = li.DISTANCE * @Cost_2REL_Pk@
            
            lw.Fee_HOT_S3_OK = li.DISTANCE * @Cost_3REL_Ok@    ;Shared Ride 3+ HOT costs
            lw.Fee_HOT_S3_PK = li.DISTANCE * @Cost_3REL_Pk@ 
            

            
            
            ;generalized time values for skimming best paths
            ;HOV
            lw.Cost_HOV_S2_OK = lw.ivt_HOV_S2_OK  +  Pen_HOV_S2_OK
            lw.Cost_HOV_S2_AM = lw.ivt_HOV_S2_AM  +  Pen_HOV_S2_PK
            lw.Cost_HOV_S2_PM = lw.ivt_HOV_S2_PM  +  Pen_HOV_S2_PK
            
            lw.Cost_HOV_S3_OK = lw.ivt_HOV_S3_OK  +  Pen_HOV_S3_OK
            lw.Cost_HOV_S3_AM = lw.ivt_HOV_S3_AM  +  Pen_HOV_S3_PK
            lw.Cost_HOV_S3_PM = lw.ivt_HOV_S3_PM  +  Pen_HOV_S3_PK
            
            ;Toll (HOT)
            lw.Cost_Tol_DA_OK = lw.ivt_Tol_DA_OK  +  lw.Fee_HOT_DA_OK / @VOT_Auto_Per@
            lw.Cost_Tol_DA_AM = lw.ivt_Tol_DA_AM  +  lw.Fee_HOT_DA_PK / @VOT_Auto_Wrk@
            lw.Cost_Tol_DA_PM = lw.ivt_Tol_DA_PM  +  lw.Fee_HOT_DA_PK / @VOT_Auto_Wrk@
            
            lw.Cost_Tol_S2_OK = lw.ivt_Tol_S2_OK  +  lw.Fee_HOT_S2_OK / @VOT_Auto_Per@  +  Pen_Tol_S2_OK
            lw.Cost_Tol_S2_AM = lw.ivt_Tol_S2_AM  +  lw.Fee_HOT_S2_PK / @VOT_Auto_Wrk@  +  Pen_Tol_S2_PK
            lw.Cost_Tol_S2_PM = lw.ivt_Tol_S2_PM  +  lw.Fee_HOT_S2_PK / @VOT_Auto_Wrk@  +  Pen_Tol_S2_PK
            
            lw.Cost_Tol_S3_OK = lw.ivt_Tol_S3_OK  +  lw.Fee_HOT_S3_OK / @VOT_Auto_Per@  +  Pen_Tol_S3_OK
            lw.Cost_Tol_S3_AM = lw.ivt_Tol_S3_AM  +  lw.Fee_HOT_S3_PK / @VOT_Auto_Wrk@  +  Pen_Tol_S3_PK
            lw.Cost_Tol_S3_PM = lw.ivt_Tol_S3_PM  +  lw.Fee_HOT_S3_PK / @VOT_Auto_Wrk@  +  Pen_Tol_S3_PK
            
            ;create variables for tracing time & distance on only HOV links
            lw.TO_HOV_S2_OK = lw.ivt_HOV_S2_OK  
            lw.TO_HOV_S2_AM = lw.ivt_HOV_S2_AM
            lw.TO_HOV_S2_PM = lw.ivt_HOV_S2_PM
            
            lw.TO_HOV_S3_OK = lw.ivt_HOV_S3_OK  
            lw.TO_HOV_S3_AM = lw.ivt_HOV_S3_AM
            lw.TO_HOV_S3_PM = lw.ivt_HOV_S3_PM
            
            lw.DO_HOV = li.DISTANCE
            
            ;create HOT only variables for skimming time & distance on only HOT links
            lw.TO_HOT_DA_OK = lw.ivt_Tol_DA_OK
            lw.TO_HOT_DA_AM = lw.ivt_Tol_DA_AM
            lw.TO_HOT_DA_PM = lw.ivt_Tol_DA_PM
            
            lw.TO_HOT_S2_OK = lw.ivt_Tol_S2_OK
            lw.TO_HOT_S2_AM = lw.ivt_Tol_S2_AM
            lw.TO_HOT_S2_PM = lw.ivt_Tol_S2_PM
            
            lw.TO_HOT_S3_OK = lw.ivt_Tol_S3_OK
            lw.TO_HOT_S3_AM = lw.ivt_Tol_S3_AM
            lw.TO_HOT_S3_PM = lw.ivt_Tol_S3_PM
            
            lw.DO_HOT = li.DISTANCE
        
        endif
        
        
        ;HOV links
        if (li.FT=37)
            ADDTOGROUP = 2
            
            ;estimated congested time for managed lane
            lw.ivt_MngLn_OK = li.DISTANCE / (li.FF_SPD * 0.98) * 60    ;assume managed freeway lanes in off-peak are 98% of free flow speed
            lw.ivt_MngLn_AM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in AM
            lw.ivt_MngLn_PM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in PM
            
            ;reset speeds based on estimated congested time for managed lane
            lw.ivt_HOV_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_HOV_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            ;if HOV policy is 3+, discourage HOV 2 from using link
            if (@HOV_Policy@=3)
                Pen_HOVPolicy_OK = 9999
                Pen_HOVPolicy_PK = 9999
            else
                Pen_HOVPolicy_OK = 0
                Pen_HOVPolicy_PK = 0
            endif
            
            ;generalized time values for skimming best paths
            lw.Cost_HOV_S2_OK = lw.ivt_HOV_S2_OK  +  Pen_HOVPolicy_OK
            lw.Cost_HOV_S2_AM = lw.ivt_HOV_S2_AM  +  Pen_HOVPolicy_PK
            lw.Cost_HOV_S2_PM = lw.ivt_HOV_S2_PM  +  Pen_HOVPolicy_PK
            
            lw.Cost_HOV_S3_OK = lw.ivt_HOV_S3_OK  
            lw.Cost_HOV_S3_AM = lw.ivt_HOV_S3_AM
            lw.Cost_HOV_S3_PM = lw.ivt_HOV_S3_PM
            
            ;create variables for tracing time & distance on only HOV links
            lw.TO_HOV_S2_OK = lw.ivt_HOV_S2_OK  
            lw.TO_HOV_S2_AM = lw.ivt_HOV_S2_AM
            lw.TO_HOV_S2_PM = lw.ivt_HOV_S2_PM
            
            lw.TO_HOV_S3_OK = lw.ivt_HOV_S3_OK  
            lw.TO_HOV_S3_AM = lw.ivt_HOV_S3_AM
            lw.TO_HOV_S3_PM = lw.ivt_HOV_S3_PM
            
            lw.DO_HOV = li.DISTANCE
            
        
        ;HOT links
        elseif (li.FT=38)
            ADDTOGROUP = 3
            
            ;estimated congested time for managed lane
            lw.ivt_MngLn_OK = li.DISTANCE / (li.FF_SPD * 0.98) * 60    ;assume managed freeway lanes in off-peak are 98% of free flow speed
            lw.ivt_MngLn_AM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in AM
            lw.ivt_MngLn_PM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in PM
            
            ;reset speeds based on estimated congested time for managed lane
            lw.ivt_HOV_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_HOV_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_DA_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_DA_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_DA_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            ;if HOT2 and HOT3 cost are zero then include as HOV
            ;off-peak - S2
            if (@Cost_2HOT_Ok@=0)
                Pen_HOV_S2_OK = 0
                Pen_Tol_S2_OK = 9999
            else
                Pen_HOV_S2_OK = 9999
                Pen_Tol_S2_OK = 0
            endif
            
            ;peak - S2
            if (@Cost_2HOT_AM@=0)
                Pen_HOV_S2_PK = 0
                Pen_Tol_S2_PK = 9999
            else
                Pen_HOV_S2_PK = 9999
                Pen_Tol_S2_PK = 0
            endif
            
            ;off-peak - S3
            if (@Cost_3HOT_Ok@=0)
                Pen_HOV_S3_OK = 0
                Pen_Tol_S3_OK = 9999
            else
                Pen_HOV_S3_OK = 9999
                Pen_Tol_S3_OK = 0
            endif
            
            ;peak - S3
            if (@Cost_3HOT_AM@=0)
                Pen_HOV_S3_PK = 0
                Pen_Tol_S3_PK = 9999
            else
                Pen_HOV_S3_PK = 9999
                Pen_Tol_S3_PK = 0
            endif
            
            ;calc toll cost
            lw.Fee_HOT_DA_OK = li.HOT_CHRGMD * @Cost_HOT_Ok@     ;Drive alone HOT costs
            lw.Fee_HOT_DA_AM = li.HOT_CHRGAM * @Cost_HOT_AM@
            lw.Fee_HOT_DA_PM = li.HOT_CHRGPM * @Cost_HOT_PM@            
            
            lw.Fee_HOT_S2_OK = li.HOT_CHRGMD * @Cost_2HOT_Ok@    ;Shared Ride 2 HOT costs
            lw.Fee_HOT_S2_AM = li.HOT_CHRGAM * @Cost_2HOT_AM@
            lw.Fee_HOT_S2_PM = li.HOT_CHRGPM * @Cost_2HOT_PM@            
            
            lw.Fee_HOT_S3_OK = li.HOT_CHRGMD * @Cost_3HOT_Ok@    ;Shared Ride 3+ HOT costs
            lw.Fee_HOT_S3_AM = li.HOT_CHRGAM * @Cost_3HOT_AM@
            lw.Fee_HOT_S3_PM = li.HOT_CHRGPM * @Cost_3HOT_PM@
            
            ;generalized time values for skimming best paths
            ;HOV
            lw.Cost_HOV_S2_OK = lw.ivt_HOV_S2_OK  +  Pen_HOV_S2_OK
            lw.Cost_HOV_S2_AM = lw.ivt_HOV_S2_AM  +  Pen_HOV_S2_PK
            lw.Cost_HOV_S2_PM = lw.ivt_HOV_S2_PM  +  Pen_HOV_S2_PK
            
            lw.Cost_HOV_S3_OK = lw.ivt_HOV_S3_OK  +  Pen_HOV_S3_OK
            lw.Cost_HOV_S3_AM = lw.ivt_HOV_S3_AM  +  Pen_HOV_S3_PK
            lw.Cost_HOV_S3_PM = lw.ivt_HOV_S3_PM  +  Pen_HOV_S3_PK
            
            ;Toll (HOT)
            lw.Cost_Tol_DA_OK = lw.ivt_Tol_DA_OK  +  lw.Fee_HOT_DA_OK / @VOT_Auto_Per@
            lw.Cost_Tol_DA_AM = lw.ivt_Tol_DA_AM  +  lw.Fee_HOT_DA_AM / @VOT_Auto_Wrk@
            lw.Cost_Tol_DA_PM = lw.ivt_Tol_DA_PM  +  lw.Fee_HOT_DA_PM / @VOT_Auto_Wrk@
            
            lw.Cost_Tol_S2_OK = lw.ivt_Tol_S2_OK  +  lw.Fee_HOT_S2_OK / @VOT_Auto_Per@  +  Pen_Tol_S2_OK
            lw.Cost_Tol_S2_AM = lw.ivt_Tol_S2_AM  +  lw.Fee_HOT_S2_AM / @VOT_Auto_Wrk@  +  Pen_Tol_S2_PK
            lw.Cost_Tol_S2_PM = lw.ivt_Tol_S2_PM  +  lw.Fee_HOT_S2_PM / @VOT_Auto_Wrk@  +  Pen_Tol_S2_PK
            
            lw.Cost_Tol_S3_OK = lw.ivt_Tol_S3_OK  +  lw.Fee_HOT_S3_OK / @VOT_Auto_Per@  +  Pen_Tol_S3_OK
            lw.Cost_Tol_S3_AM = lw.ivt_Tol_S3_AM  +  lw.Fee_HOT_S3_AM / @VOT_Auto_Wrk@  +  Pen_Tol_S3_PK
            lw.Cost_Tol_S3_PM = lw.ivt_Tol_S3_PM  +  lw.Fee_HOT_S3_PM / @VOT_Auto_Wrk@  +  Pen_Tol_S3_PK
            
            ;create variables for tracing time & distance on only HOV links
            lw.TO_HOV_S2_OK = lw.ivt_HOV_S2_OK  
            lw.TO_HOV_S2_AM = lw.ivt_HOV_S2_AM
            lw.TO_HOV_S2_PM = lw.ivt_HOV_S2_PM
            
            lw.TO_HOV_S3_OK = lw.ivt_HOV_S3_OK  
            lw.TO_HOV_S3_AM = lw.ivt_HOV_S3_AM
            lw.TO_HOV_S3_PM = lw.ivt_HOV_S3_PM
            
            lw.DO_HOV = li.DISTANCE
            
            ;create HOT only variables for skimming time & distance on only HOT links
            lw.TO_HOT_DA_OK = lw.ivt_Tol_DA_OK  
            lw.TO_HOT_DA_AM = lw.ivt_Tol_DA_AM
            lw.TO_HOT_DA_PM = lw.ivt_Tol_DA_PM
            
            lw.TO_HOT_S2_OK = lw.ivt_Tol_S2_OK  
            lw.TO_HOT_S2_AM = lw.ivt_Tol_S2_AM
            lw.TO_HOT_S2_PM = lw.ivt_Tol_S2_PM
            
            lw.TO_HOT_S3_OK = lw.ivt_Tol_S3_OK  
            lw.TO_HOT_S3_AM = lw.ivt_Tol_S3_AM
            lw.TO_HOT_S3_PM = lw.ivt_Tol_S3_PM
            
            lw.DO_HOT = li.DISTANCE
        
        
        ;HOV/HOT access links
        elseif (li.FT=39)
            ADDTOGROUP = 1
            
            ;estimated congested time for managed lane
            lw.ivt_MngLn_OK = li.DISTANCE / (li.FF_SPD * 0.98) * 60    ;assume managed freeway lanes in off-peak are 98% of free flow speed
            lw.ivt_MngLn_AM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in AM
            lw.ivt_MngLn_PM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in PM
            
            ;reset speeds based on estimated congested time for managed lane
            lw.ivt_HOV_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_HOV_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_HOV_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_HOV_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_DA_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_DA_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_DA_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
        
            lw.Fee_HOT_DA_OK = li.HOT_CHRGMD * @Cost_HOT_Ok@     ;Drive alone HOT costs
            lw.Fee_HOT_DA_AM = li.HOT_CHRGAM * @Cost_HOT_AM@
            lw.Fee_HOT_DA_PM = li.HOT_CHRGPM * @Cost_HOT_PM@            
            
            lw.Fee_HOT_S2_OK = li.HOT_CHRGMD * @Cost_2HOT_Ok@    ;Shared Ride 2 HOT costs
            lw.Fee_HOT_S2_AM = li.HOT_CHRGAM * @Cost_2HOT_AM@
            lw.Fee_HOT_S2_PM = li.HOT_CHRGPM * @Cost_2HOT_PM@            
            
            lw.Fee_HOT_S3_OK = li.HOT_CHRGMD * @Cost_3HOT_Ok@    ;Shared Ride 3+ HOT costs
            lw.Fee_HOT_S3_AM = li.HOT_CHRGAM * @Cost_3HOT_AM@
            lw.Fee_HOT_S3_PM = li.HOT_CHRGPM * @Cost_3HOT_PM@
            
            ;generalized time values for skimming best paths
            ;HOV
            lw.Cost_HOV_S2_OK = lw.ivt_HOV_S2_OK 
            lw.Cost_HOV_S2_AM = lw.ivt_HOV_S2_AM
            lw.Cost_HOV_S2_PM = lw.ivt_HOV_S2_PM
            
            lw.Cost_HOV_S3_OK = lw.ivt_HOV_S3_OK
            lw.Cost_HOV_S3_AM = lw.ivt_HOV_S3_AM
            lw.Cost_HOV_S3_PM = lw.ivt_HOV_S3_PM
            
            ;Toll (HOT)
            lw.Cost_Tol_DA_OK = lw.ivt_Tol_DA_OK  +  lw.Fee_HOT_DA_OK / @VOT_Auto_Per@
            lw.Cost_Tol_DA_AM = lw.ivt_Tol_DA_AM  +  lw.Fee_HOT_DA_AM / @VOT_Auto_Wrk@
            lw.Cost_Tol_DA_PM = lw.ivt_Tol_DA_PM  +  lw.Fee_HOT_DA_PM / @VOT_Auto_Wrk@
            
            lw.Cost_Tol_S2_OK = lw.ivt_Tol_S2_OK  +  lw.Fee_HOT_S2_OK / @VOT_Auto_Per@
            lw.Cost_Tol_S2_AM = lw.ivt_Tol_S2_AM  +  lw.Fee_HOT_S2_AM / @VOT_Auto_Wrk@
            lw.Cost_Tol_S2_PM = lw.ivt_Tol_S2_PM  +  lw.Fee_HOT_S2_PM / @VOT_Auto_Wrk@
            
            lw.Cost_Tol_S3_OK = lw.ivt_Tol_S3_OK  +  lw.Fee_HOT_S3_OK / @VOT_Auto_Per@
            lw.Cost_Tol_S3_AM = lw.ivt_Tol_S3_AM  +  lw.Fee_HOT_S3_AM / @VOT_Auto_Wrk@
            lw.Cost_Tol_S3_PM = lw.ivt_Tol_S3_PM  +  lw.Fee_HOT_S3_PM / @VOT_Auto_Wrk@
            
        ;toll links
        elseif (li.FT=40)
            ADDTOGROUP = 4 
            
            ;estimated congested time for managed lane
            lw.ivt_MngLn_OK = li.DISTANCE / (li.FF_SPD * 0.98) * 60    ;assume managed freeway lanes in off-peak are 98% of free flow speed
            lw.ivt_MngLn_AM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in AM
            lw.ivt_MngLn_PM = li.DISTANCE / (li.FF_SPD * 0.95) * 60    ;assume managed freeway lanes at LOS C are traveling at 95% of free flow speed in PM
            
            ;reset speeds based on estimated congested time for managed lane
            lw.ivt_Tol_DA_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_DA_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_DA_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S2_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S2_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S2_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            lw.ivt_Tol_S3_OK =  MIN(lw.ivt_MngLn_OK, li.MD_TIME)
            lw.ivt_Tol_S3_AM =  MIN(lw.ivt_MngLn_AM, li.AM_TIME)
            lw.ivt_Tol_S3_PM =  MIN(lw.ivt_MngLn_PM, li.PM_TIME)
            
            ;calc toll cost
            lw.Fee_Tol_OK = li.DISTANCE * @Cost_Toll_Ok@
            lw.Fee_Tol_PK = li.DISTANCE * @Cost_Toll_Pk@
            
            ;generalized time values for skimming best paths
            lw.Cost_Tol_DA_OK = lw.ivt_Tol_DA_OK  +  lw.Fee_Tol_OK / @VOT_Auto_Per@
            lw.Cost_Tol_DA_AM = lw.ivt_Tol_DA_AM  +  lw.Fee_Tol_PK / @VOT_Auto_Wrk@
            lw.Cost_Tol_DA_PM = lw.ivt_Tol_DA_PM  +  lw.Fee_Tol_PK / @VOT_Auto_Wrk@
            
            lw.Cost_Tol_S2_OK = lw.ivt_Tol_S2_OK  +  lw.Fee_Tol_OK / @VOT_Auto_Per@
            lw.Cost_Tol_S2_AM = lw.ivt_Tol_S2_AM  +  lw.Fee_Tol_PK / @VOT_Auto_Wrk@
            lw.Cost_Tol_S2_PM = lw.ivt_Tol_S2_PM  +  lw.Fee_Tol_PK / @VOT_Auto_Wrk@
            
            lw.Cost_Tol_S3_OK = lw.ivt_Tol_S3_OK  +  lw.Fee_Tol_OK / @VOT_Auto_Per@
            lw.Cost_Tol_S3_AM = lw.ivt_Tol_S3_AM  +  lw.Fee_Tol_PK / @VOT_Auto_Wrk@
            lw.Cost_Tol_S3_PM = lw.ivt_Tol_S3_PM  +  lw.Fee_Tol_PK / @VOT_Auto_Wrk@
            
            ;create HOT only variables for skimming time & distance on only Toll links
            lw.TO_Tol_DA_OK = lw.ivt_Tol_DA_OK  
            lw.TO_Tol_DA_AM = lw.ivt_Tol_DA_AM
            lw.TO_Tol_DA_PM = lw.ivt_Tol_DA_PM
            
            lw.TO_Tol_S2_OK = lw.ivt_Tol_S2_OK  
            lw.TO_Tol_S2_AM = lw.ivt_Tol_S2_AM
            lw.TO_Tol_S2_PM = lw.ivt_Tol_S2_PM
            
            lw.TO_Tol_S3_OK = lw.ivt_Tol_S3_OK  
            lw.TO_Tol_S3_AM = lw.ivt_Tol_S3_AM
            lw.TO_Tol_S3_PM = lw.ivt_Tol_S3_PM
            
            lw.DO_Tol = li.DISTANCE
            
        endif
        
    ENDPHASE
    
    
    PHASE=ILOOP
        
        ;General Purpose Lane Skims -------------------------------------------------------
        ;free flow skim
        PATHLOAD PATH=lw.ivt_GP_FF,   ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=1-4,
            mw[100]=PATHTRACE(lw.ivt_GP_FF), NOACCESS=0,
            mw[120]=PATHTRACE(li.DISTANCE),  NOACCESS=0
        
        ;off-peak skims
        PATHLOAD PATH=lw.ivt_GP_OK,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=1-4,
            mw[200]=PATHTRACE(lw.ivt_GP_OK), NOACCESS=0,
            mw[220]=PATHTRACE(li.DISTANCE),  NOACCESS=0
        
        ;AM peak skim
        PATHLOAD PATH=lw.ivt_GP_AM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=1-4,
            mw[300]=PATHTRACE(lw.ivt_GP_AM), NOACCESS=0,
            mw[320]=PATHTRACE(li.DISTANCE),  NOACCESS=0
        
        ;PM peak skim
        PATHLOAD PATH=lw.ivt_GP_PM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=1-4,
            mw[400]=PATHTRACE(lw.ivt_GP_PM), NOACCESS=0,
            mw[420]=PATHTRACE(li.DISTANCE),  NOACCESS=0
        
        
        ;HOV Lane Skims (exclude toll) ----------------------------------------------------
        ;off-peak skims
        PATHLOAD PATH=lw.Cost_HOV_S2_OK,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=4,    ;include HOV & HOT lanes (exclude toll)
            mw[201]=PATHTRACE(lw.ivt_HOV_S2_OK), NOACCESS=0,
            mw[221]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[241]=PATHTRACE(lw.TO_HOV_S2_OK),  NOACCESS=0,
            mw[261]=PATHTRACE(lw.DO_HOV),        NOACCESS=0,
            mw[281]=PATHTRACE(lw.Fee_HOT_S2_OK), NOACCESS=0      ;note: fee for HOV skim should equal 0, this statement included for checking
            
        PATHLOAD PATH=lw.Cost_HOV_S3_OK,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=4,    ;include HOV & HOT lanes (exclude toll)
            mw[202]=PATHTRACE(lw.ivt_HOV_S3_OK), NOACCESS=0,
            mw[222]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[242]=PATHTRACE(lw.TO_HOV_S3_OK),  NOACCESS=0,
            mw[262]=PATHTRACE(lw.DO_HOV),        NOACCESS=0,
            mw[282]=PATHTRACE(lw.Fee_HOT_S3_OK), NOACCESS=0
        
        ;AM peak skim
        PATHLOAD PATH=lw.Cost_HOV_S2_AM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=4,    ;include HOV & HOT lanes (exclude toll)
            mw[301]=PATHTRACE(lw.ivt_HOV_S2_AM), NOACCESS=0,
            mw[321]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[341]=PATHTRACE(lw.TO_HOV_S2_AM),  NOACCESS=0,
            mw[361]=PATHTRACE(lw.DO_HOV),        NOACCESS=0,
            mw[381]=PATHTRACE(lw.Fee_HOT_S2_AM), NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_HOV_S3_AM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=4,    ;include HOV & HOT lanes (exclude toll)
            mw[302]=PATHTRACE(lw.ivt_HOV_S3_AM), NOACCESS=0,
            mw[322]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[342]=PATHTRACE(lw.TO_HOV_S3_AM),  NOACCESS=0,
            mw[362]=PATHTRACE(lw.DO_HOV),        NOACCESS=0,
            mw[382]=PATHTRACE(lw.Fee_HOT_S3_AM), NOACCESS=0
            
        ;PM peak skim
        PATHLOAD PATH=lw.Cost_HOV_S2_PM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=4,    ;include HOV & HOT lanes (exclude toll)
            mw[401]=PATHTRACE(lw.ivt_HOV_S2_PM), NOACCESS=0,
            mw[421]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[441]=PATHTRACE(lw.TO_HOV_S2_PM),  NOACCESS=0,
            mw[461]=PATHTRACE(lw.DO_HOV),        NOACCESS=0,
            mw[481]=PATHTRACE(lw.Fee_HOT_S2_PM), NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_HOV_S3_PM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=4,    ;include HOV & HOT lanes (exclude toll)
            mw[402]=PATHTRACE(lw.ivt_HOV_S3_PM), NOACCESS=0,
            mw[422]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[442]=PATHTRACE(lw.TO_HOV_S3_PM),  NOACCESS=0,
            mw[462]=PATHTRACE(lw.DO_HOV),        NOACCESS=0,
            mw[482]=PATHTRACE(lw.Fee_HOT_S3_PM), NOACCESS=0
            
            
        ;Toll Lane Skims (HOT & Toll) ----------------------------------------------------
        ;off-peak skims
        PATHLOAD PATH=lw.Cost_Tol_DA_OK,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[203]=PATHTRACE(lw.ivt_Tol_DA_OK), NOACCESS=0,
            mw[223]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[243]=PATHTRACE(lw.TO_HOT_DA_OK),  NOACCESS=0,
            mw[253]=PATHTRACE(lw.TO_Tol_DA_OK),  NOACCESS=0,
            mw[263]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[273]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[283]=PATHTRACE(lw.Fee_HOT_DA_OK), NOACCESS=0,
            mw[293]=PATHTRACE(lw.Fee_Tol_OK),    NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_Tol_S2_OK,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[204]=PATHTRACE(lw.ivt_Tol_S2_OK), NOACCESS=0,
            mw[224]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[244]=PATHTRACE(lw.TO_HOT_S2_OK),  NOACCESS=0,
            mw[254]=PATHTRACE(lw.TO_Tol_S2_OK),  NOACCESS=0,
            mw[264]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[274]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[284]=PATHTRACE(lw.Fee_HOT_S2_OK), NOACCESS=0,
            mw[294]=PATHTRACE(lw.Fee_Tol_OK),    NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_Tol_S3_OK,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[205]=PATHTRACE(lw.ivt_Tol_S3_OK), NOACCESS=0,
            mw[225]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[245]=PATHTRACE(lw.TO_HOT_S3_OK),  NOACCESS=0,
            mw[255]=PATHTRACE(lw.TO_Tol_S3_OK),  NOACCESS=0,
            mw[265]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[275]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[285]=PATHTRACE(lw.Fee_HOT_S3_OK), NOACCESS=0,
            mw[295]=PATHTRACE(lw.Fee_Tol_OK),    NOACCESS=0
        
        ;AM peak skim
        PATHLOAD PATH=lw.Cost_Tol_DA_AM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[303]=PATHTRACE(lw.ivt_Tol_DA_AM), NOACCESS=0,
            mw[323]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[343]=PATHTRACE(lw.TO_HOT_DA_AM),  NOACCESS=0,
            mw[353]=PATHTRACE(lw.TO_Tol_DA_AM),  NOACCESS=0,
            mw[363]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[373]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[383]=PATHTRACE(lw.Fee_HOT_DA_AM), NOACCESS=0,
            mw[393]=PATHTRACE(lw.Fee_Tol_AM),    NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_Tol_S2_AM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[304]=PATHTRACE(lw.ivt_Tol_S2_AM), NOACCESS=0,
            mw[324]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[344]=PATHTRACE(lw.TO_HOT_S2_AM),  NOACCESS=0,
            mw[354]=PATHTRACE(lw.TO_Tol_S2_AM),  NOACCESS=0,
            mw[364]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[374]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[384]=PATHTRACE(lw.Fee_HOT_S2_AM), NOACCESS=0,
            mw[394]=PATHTRACE(lw.Fee_Tol_AM),    NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_Tol_S3_AM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[305]=PATHTRACE(lw.ivt_Tol_S3_AM), NOACCESS=0,
            mw[325]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[345]=PATHTRACE(lw.TO_HOT_S3_AM),  NOACCESS=0,
            mw[355]=PATHTRACE(lw.TO_Tol_S3_AM),  NOACCESS=0,
            mw[365]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[375]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[385]=PATHTRACE(lw.Fee_HOT_S3_AM), NOACCESS=0,
            mw[395]=PATHTRACE(lw.Fee_Tol_AM),    NOACCESS=0
        
        ;PM peak skim
        PATHLOAD PATH=lw.Cost_Tol_DA_PM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[403]=PATHTRACE(lw.ivt_Tol_DA_PM), NOACCESS=0,
            mw[423]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[443]=PATHTRACE(lw.TO_HOT_DA_PM),  NOACCESS=0,
            mw[453]=PATHTRACE(lw.TO_Tol_DA_PM),  NOACCESS=0,
            mw[463]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[473]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[483]=PATHTRACE(lw.Fee_HOT_DA_PM), NOACCESS=0,
            mw[493]=PATHTRACE(lw.Fee_Tol_PM),    NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_Tol_S2_PM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[404]=PATHTRACE(lw.ivt_Tol_S2_PM), NOACCESS=0,
            mw[424]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[444]=PATHTRACE(lw.TO_HOT_S2_PM),  NOACCESS=0,
            mw[454]=PATHTRACE(lw.TO_Tol_S2_PM),  NOACCESS=0,
            mw[464]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[474]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[484]=PATHTRACE(lw.Fee_HOT_S2_PM), NOACCESS=0,
            mw[494]=PATHTRACE(lw.Fee_Tol_PM),    NOACCESS=0
            
        PATHLOAD PATH=lw.Cost_Tol_S3_PM,  ;DEC=F2,
            CONSOLIDATE=T,
            EXCLUDEGROUP=2,    ;include HOT & toll lanes (exclude HOV)
            mw[405]=PATHTRACE(lw.ivt_Tol_S3_PM), NOACCESS=0,
            mw[425]=PATHTRACE(li.DISTANCE),      NOACCESS=0,
            mw[445]=PATHTRACE(lw.TO_HOT_S3_PM),  NOACCESS=0,
            mw[455]=PATHTRACE(lw.TO_Tol_S3_PM),  NOACCESS=0,
            mw[465]=PATHTRACE(lw.DO_HOT),        NOACCESS=0,
            mw[475]=PATHTRACE(lw.DO_Tol),        NOACCESS=0,
            mw[485]=PATHTRACE(lw.Fee_HOT_S3_PM), NOACCESS=0,
            mw[495]=PATHTRACE(lw.Fee_Tol_PM),    NOACCESS=0
        
        
        ;calculate intrazonal times & distances, terminal times
        JLOOP
            ;1 Acre = 0.0015625 square miles)
            SQMILETOT = zi.1.ACRES[J] * 0.0015625
            
            ;xy distance in miles
            mw[4][j] = SQRT((zi.1.X[I]-zi.1.X[J])^2 + (zi.1.Y[I]-zi.1.Y[J])^2) / 1609.344
            
            ;calculate intrazonal time & distance
            if (i=j)
                intrazonal_dist = 0.5 * SQMILETOT^0.5
                intrazonal_time = intrazonal_dist / 20 * 60    ;assume intrazonal speed is 20mph
                
                ;intrazonal times
                ;free flow
                mw[100][j] = intrazonal_time    ;general purpose
                
                ;off-peak
                mw[200][j] = intrazonal_time    ;general purpose
                mw[201][j] = intrazonal_time    ;HOV SR 2
                mw[202][j] = intrazonal_time    ;HOV SR 3
                mw[203][j] = intrazonal_time    ;Toll DA
                mw[204][j] = intrazonal_time    ;Toll SR 2
                mw[205][j] = intrazonal_time    ;Toll SR 3
                
                ;AM
                mw[300][j] = intrazonal_time    ;general purpose
                mw[301][j] = intrazonal_time    ;HOV SR 2
                mw[302][j] = intrazonal_time    ;HOV SR 3
                mw[303][j] = intrazonal_time    ;Toll DA
                mw[304][j] = intrazonal_time    ;Toll SR 2
                mw[305][j] = intrazonal_time    ;Toll SR 3
                
                ;PM
                mw[400][j] = intrazonal_time    ;general purpose
                mw[401][j] = intrazonal_time    ;HOV SR 2
                mw[402][j] = intrazonal_time    ;HOV SR 3
                mw[403][j] = intrazonal_time    ;Toll DA
                mw[404][j] = intrazonal_time    ;Toll SR 2
                mw[405][j] = intrazonal_time    ;Toll SR 3
                
                ;intrazonal distance
                ;xy distance
                mw[4][j] = intrazonal_dist
                
                ;free flow
                mw[120][j] = intrazonal_dist    ;general purpose
                
                ;off-peak
                mw[220][j] = intrazonal_dist    ;general purpose
                mw[221][j] = intrazonal_dist    ;HOV SR 2
                mw[222][j] = intrazonal_dist    ;HOV SR 3
                mw[223][j] = intrazonal_dist    ;Toll DA
                mw[224][j] = intrazonal_dist    ;Toll SR 2
                mw[225][j] = intrazonal_dist    ;Toll SR 3
                
                ;AM
                mw[320][j] = intrazonal_dist    ;general purpose
                mw[321][j] = intrazonal_dist    ;HOV SR 2
                mw[322][j] = intrazonal_dist    ;HOV SR 3
                mw[323][j] = intrazonal_dist    ;Toll DA
                mw[324][j] = intrazonal_dist    ;Toll SR 2
                mw[325][j] = intrazonal_dist    ;Toll SR 3
                
                ;PM
                mw[420][j] = intrazonal_dist    ;general purpose
                mw[421][j] = intrazonal_dist    ;HOV SR 2
                mw[422][j] = intrazonal_dist    ;HOV SR 3
                mw[423][j] = intrazonal_dist    ;Toll DA
                mw[424][j] = intrazonal_dist    ;Toll SR 2
                mw[425][j] = intrazonal_dist    ;Toll SR 3
            endif
            
            
            ;out of vehicle time (ovt)
            mw[1][j] = zi.1.TERMTIME[i]+zi.1.TERMTIME[j]
            
            ;permanent parking costs (expressed as dollars in input files, convert to cents)
            mw[2][j] = zi.1.PRKCSTPERM[J]*100
            
            ;temporary parking costs (expressed as dollars in input files, convert to cents)
            mw[3][j] = zi.1.PRKCSTTEMP[J]*100
            
            
            ;ensure no 0 distances if time>0
            ;free flow
            if (mw[120][j]=0)  mw[120][j] = 1    ;general purpose
            
            ;off-peak
            if (mw[220][j]=0)  mw[220][j] = 1    ;general purpose
            if (mw[221][j]=0)  mw[221][j] = 1    ;HOV SR 2
            if (mw[222][j]=0)  mw[222][j] = 1    ;HOV SR 3
            if (mw[223][j]=0)  mw[223][j] = 1    ;Toll DA
            if (mw[224][j]=0)  mw[224][j] = 1    ;Toll SR 2
            if (mw[225][j]=0)  mw[225][j] = 1    ;Toll SR 3
            
            ;AM
            if (mw[320][j]=0)  mw[320][j] = 1    ;general purpose
            if (mw[321][j]=0)  mw[321][j] = 1    ;HOV SR 2
            if (mw[322][j]=0)  mw[322][j] = 1    ;HOV SR 3
            if (mw[323][j]=0)  mw[323][j] = 1    ;Toll DA
            if (mw[324][j]=0)  mw[324][j] = 1    ;Toll SR 2
            if (mw[325][j]=0)  mw[325][j] = 1    ;Toll SR 3
            
            ;PM
            if (mw[420][j]=0)  mw[420][j] = 1    ;general purpose
            if (mw[421][j]=0)  mw[421][j] = 1    ;HOV SR 2
            if (mw[422][j]=0)  mw[422][j] = 1    ;HOV SR 3
            if (mw[423][j]=0)  mw[423][j] = 1    ;Toll DA
            if (mw[424][j]=0)  mw[424][j] = 1    ;Toll SR 2
            if (mw[425][j]=0)  mw[425][j] = 1    ;Toll SR 3
        
        ENDJLOOP
    
    ENDPHASE
    
ENDRUN




;Must do this because above HIGHWAY couldn't handle two ZDATI's correctly
RUN PGM=MATRIX  MSG='Mode Choice 3: process Peak skims and prepare matrices for utility calculaitons'
; Factor distributed person trips to vehicle trips

FILEI  MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_AM.tmp.mtx'
       MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_PM.tmp.mtx'

FILEO  MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx',
           mo=1-4, 300-305, 120-125, 141-145,153-155, 161-165,173-175, 181-185,193-195,
           name=ovt,
                permpark,
                temppark,
                xydist,
                ivt_GP,        ;total path - time
                ivt_HOV_S2,
                ivt_HOV_S3,
                ivt_Tol_DA,
                ivt_Tol_S2,
                ivt_Tol_S3,
                dist_GP,       ;total path - distance
                dist_HOV_S2,
                dist_HOV_S3,
                dist_Tol_DA,
                dist_Tol_S2,
                dist_Tol_S3,
                TO_HOV_S2,     ;trace of just managed lane - time (Time Only)
                TO_HOV_S3,
                TO_HOT_DA,
                TO_HOT_S2,
                TO_HOT_S3,
                TO_Tol_DA,
                TO_Tol_S2,
                TO_Tol_S3,
                DO_HOV_S2,     ;trace of just managed lane - distance (Distance Only)
                DO_HOV_S3,
                DO_HOT_DA,
                DO_HOT_S2,
                DO_HOT_S3,
                DO_Tol_DA,
                DO_Tol_S2,
                DO_Tol_S3,
                Fee_HOV_S2,    ;trace of just managed lane - toll cost
                Fee_HOV_S3,
                Fee_HOT_DA,
                Fee_HOT_S2,
                Fee_HOT_S3,
                Fee_Tol_DA,
                Fee_Tol_S2,
                Fee_Tol_S3


    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
    ZONEMSG = 10
    
    
    mw[1]   = mi.1.ovt
    mw[2]   = mi.1.permpark
    mw[3]   = mi.1.temppark
    mw[4]   = mi.1.xydist
    
    mw[100] = mi.1.ivt_GP        ;total path - time
    mw[101] = mi.1.ivt_HOV_S2
    mw[102] = mi.1.ivt_HOV_S3 
    mw[103] = mi.1.ivt_Tol_DA
    mw[104] = mi.1.ivt_Tol_S2
    mw[105] = mi.1.ivt_Tol_S3
    
    mw[120] = mi.1.dist_GP       ;total path - distance
    mw[121] = mi.1.dist_HOV_S2
    mw[122] = mi.1.dist_HOV_S3
    mw[123] = mi.1.dist_Tol_DA
    mw[124] = mi.1.dist_Tol_S2
    mw[125] = mi.1.dist_Tol_S3
    
    mw[141] = mi.1.TO_HOV_S2     ;trace of just managed lane - time (Time Only)
    mw[142] = mi.1.TO_HOV_S3
    mw[143] = mi.1.TO_HOT_DA
    mw[144] = mi.1.TO_HOT_S2
    mw[145] = mi.1.TO_HOT_S3
    mw[153] = mi.1.TO_Tol_DA
    mw[154] = mi.1.TO_Tol_S2
    mw[155] = mi.1.TO_Tol_S3
    
    mw[161] = mi.1.DO_HOV_S2     ;trace of just managed lane - distance (Distance Only)
    mw[162] = mi.1.DO_HOV_S3
    mw[163] = mi.1.DO_HOT_DA
    mw[164] = mi.1.DO_HOT_S2
    mw[165] = mi.1.DO_HOT_S3
    mw[173] = mi.1.DO_Tol_DA
    mw[174] = mi.1.DO_Tol_S2
    mw[175] = mi.1.DO_Tol_S3
    
    mw[181] = mi.1.Fee_HOV_S2    ;trace of just managed lane - toll cost
    mw[182] = mi.1.Fee_HOV_S3
    mw[183] = mi.1.Fee_HOT_DA
    mw[184] = mi.1.Fee_HOT_S2
    mw[185] = mi.1.Fee_HOT_S3
    mw[193] = mi.1.Fee_Tol_DA
    mw[194] = mi.1.Fee_Tol_S2
    mw[195] = mi.1.Fee_Tol_S3
    
    
    ;transpose PM ivt
    mw[200] = mi.2.ivt_GP.T      ;total path - time
    
    
    ;initialize ivt output matrices
    mw[301] = mw[101]
    mw[302] = mw[102]
    mw[303] = mw[103]
    mw[304] = mw[104]
    mw[305] = mw[105]
    
    ;use ratio of average/AM peak from GP skim to weight total ivt time path for HOV and toll skims
    JLOOP
        ;peak general purpose IVT is an average of AM and PM Peak IVT
        mw[300] = (mw[100] + mw[200]) / 2
        
        if (mw[100]>0)  mw[301] = mw[101] * mw[300] / mw[100]
        if (mw[100]>0)  mw[302] = mw[102] * mw[300] / mw[100]
        if (mw[100]>0)  mw[303] = mw[103] * mw[300] / mw[100]
        if (mw[100]>0)  mw[304] = mw[104] * mw[300] / mw[100]
        if (mw[100]>0)  mw[305] = mw[105] * mw[300] / mw[100]
    ENDJLOOP
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Skim Auto                          ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 03_Skim_auto.txt)
