CREATE OR REPLACE PROCEDURE  ESCALA.PRC_GERAR_PROGRAMACAO_PREVISAO
/******************************************************************************
   NAME:    PRC_GERAR_PROGRAMACAO_PREVISAO
   Author: Jose Mauro da Silva
   Date:   25/10/2021
******************************************************************************/
AS
  Begin
    INSERT INTO ESCALA.PROGRAMACAO_FERIAS(PGFR_CODIGO_EMPRESA          
      ,PGFR_NOME_EMPRESA            
      ,PGFR_CODIGO_ESTABELECIMENTO  
      ,PGFR_NOME_ESTABELECIMENTO    
      ,PGFR_MATRICULA               
      ,PGFR_NOME                    
      ,PGFR_ESCALA_TURMA            
      ,PGFR_ADMISSAO                
      ,PGFR_SITUACAO                
      ,PGFR_periodo_aquisitivo
      ,PGFR_DATA_LIMITE             
      ,PGFR_QTDE_DIAS               
      ,PGFR_MESES                   
      ,PGFR_SALDO                   
      ,PGFR_DIAS_GOZADO             
      ,PGFR_PROGRAMACAO_1           
      ,PGFR_DIAS_1                  
      ,PGFR_PROGRAMACAO_2           
      ,PGFR_DIAS_2                  
      ,PGFR_ABONO                   
      ,TPPG_ID                      
      ,PGFR_13                      
      ,PGFR_CODIGO_CENTRO_RESULTADO 
      ,PGFR_NOME_RESULTADO          
      ,PGFR_MATRICULA_CHEFIA        
      ,PGFR_NOME_CHEFIA             
      ,PGFR_FERIAS_COMPULSORIAS     
      ,PGFR_DT_LEITURA              
      ,USUA_ID                      
      ,PGFR_ATIVO                   
      ,PGFR_ULT_LEITURA             
      ,PGFR_DT_LANC_PERIODO         
      ,PGFR_AUTORIZADO              
      ,PGFR_STATUS                  
      ,PGFR_MOTIVO_STATUS           
      ,PGFR_CAMPOS_ALTERADOS)
    SELECT                     
      PGFR_CODIGO_EMPRESA          
      ,PGFR_NOME_EMPRESA            
      ,PGFR_CODIGO_ESTABELECIMENTO  
      ,PGFR_NOME_ESTABELECIMENTO    
      ,PGFR_MATRICULA               
      ,PGFR_NOME                    
      ,PGFR_ESCALA_TURMA            
      ,PGFR_ADMISSAO                
      ,PGFR_SITUACAO                
      ,TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(PGFR_periodo_aquisitivo,1,10)), 12), 'DD/MM/YYYY') || ' a ' ||  TO_CHAR(ADD_MONTHS (TO_DATE(SUBSTR(PGFR_periodo_aquisitivo,14,10)), 12), 'DD/MM/YYYY') As PGFR_PERIODO_AQUISITIVO      
      ,Add_Months(pgfr_data_limite, 12) AS PGFR_DATA_LIMITE             
      ,0 PGFR_QTDE_DIAS               
      ,0 PGFR_MESES                   
      ,0 PGFR_SALDO                   
      ,0 PGFR_DIAS_GOZADO             
      ,TO_DATE('01-01-0001') PGFR_PROGRAMACAO_1           
      ,0 PGFR_DIAS_1                  
      , TO_DATE('01-01-0001') PGFR_PROGRAMACAO_2           
      ,0 PGFR_DIAS_2                  
      ,0 PGFR_ABONO                   
      ,null TPPG_ID                      
      ,0 PGFR_13                      
      ,PGFR_CODIGO_CENTRO_RESULTADO 
      ,PGFR_NOME_RESULTADO          
      ,PGFR_MATRICULA_CHEFIA        
      ,PGFR_NOME_CHEFIA             
      ,PGFR_FERIAS_COMPULSORIAS     
      ,sysdate as PGFR_DT_LEITURA              
      ,USUA_ID                      
      ,PGFR_ATIVO                   
      ,sysdate as PGFR_ULT_LEITURA             
      ,TO_DATE('01-01-0001') PGFR_DT_LANC_PERIODO         
      ,0 as PGFR_AUTORIZADO              
      ,'' as PGFR_STATUS                  
      ,'' as PGFR_MOTIVO_STATUS           
      ,'' as PGFR_CAMPOS_ALTERADOS      
    FROM
       Escala.Programacao_Ferias  
    WHERE
       TO_CHAR(PGFR_MATRICULA) || TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(PGFR_periodo_aquisitivo,1,10)), 12), 'DD/MM/YYYY') || ' a ' ||  TO_CHAR(ADD_MONTHS (TO_DATE(SUBSTR(PGFR_periodo_aquisitivo,14,10)), 12), 'DD/MM/YYYY')
       NOT IN (SELECT TO_CHAR(PGFR_MATRICULA) || TO_CHAR(TO_DATE(SUBSTR(PGFR_periodo_aquisitivo,1,10), 'DD/MM/YYYY')) || ' a ' ||  TO_CHAR(TO_DATE(SUBSTR(PGFR_periodo_aquisitivo,14,10), 'DD/MM/YYYY')) FROM Escala.Programacao_Ferias)
       AND   
       TO_DATE(SUBSTR(PGFR_periodo_aquisitivo,14,10)) < SYSDATE;
       
       --Gerando as previsões de férias
      INSERT INTO Escala.Distribuicao_Ferias_Oper 
           (DFOP_13                          
           ,DFOP_ABONO                           
           ,DFOP_ADMISSAO                      
           ,DFOP_ATIVO                       
           ,DFOP_CODIGO_CENTRO_RESULTADO     
           ,DFOP_CODIGO_EMPRESA              
           ,DFOP_CODIGO_ESTABELECIMENTO      
           ,DFOP_DATA_LIMITE                 
           ,DFOP_DIAS_GOZADO                 
           ,DFOP_DT_LANC_PERIODO             
           ,DFOP_DT_LEITURA                  
           ,DFOP_ESCALA_TURMA                
           ,DFOP_FERIAS_COMPULSORIAS         
           ,DFOP_MATRICULA                   
           ,DFOP_MATRICULA_CHEFIA            
           ,DFOP_MESES                       
           ,DFOP_NOME                        
           ,DFOP_NOME_CHEFIA                 
           ,DFOP_NOME_EMPRESA                
           ,DFOP_NOME_ESTABELECIMENTO        
           ,DFOP_NOME_RESULTADO              
           ,DFOP_PERIODO_AQUISITIVO          
           ,DFOP_PROGRAMACAO                 
           ,DFOP_QTDE_DIAS                   
           ,DFOP_SALDO                       
           ,DFOP_SITUACAO                    
           ,DFOP_ULT_LEITURA                 
           ,TPPG_ID                          
           ,USUA_ID)
      SELECT
            0 as PGFR_13 
            ,PGFR_ABONO
            ,PGFR_ADMISSAO
            ,PGFR_ATIVO
            ,PGFR_CODIGO_CENTRO_RESULTADO
            ,PGFR_CODIGO_EMPRESA
            ,PGFR_CODIGO_ESTABELECIMENTO
            ,PGFR_DATA_LIMITE
            ,PGFR_DIAS_GOZADO
            ,PGFR_DT_LANC_PERIODO
            ,PGFR_DT_LEITURA
            ,PGFR_ESCALA_TURMA
            ,PGFR_FERIAS_COMPULSORIAS
            ,PGFR_MATRICULA
            ,PGFR_MATRICULA_CHEFIA
            ,PGFR_MESES
            ,PGFR_NOME
            ,PGFR_NOME_CHEFIA
            ,PGFR_NOME_EMPRESA
            ,PGFR_NOME_ESTABELECIMENTO
            ,PGFR_NOME_RESULTADO
            ,PGFR_PERIODO_AQUISITIVO
            ,PGFR_PROGRAMACAO_1
            ,PGFR_QTDE_DIAS
            ,PGFR_SALDO
            ,PGFR_SITUACAO
            ,PGFR_ULT_LEITURA
            ,TPPG_ID
            ,USUA_ID
      FROM
            ESCALA.Programacao_Ferias
      WHERE
            TO_CHAR(PGFR_MATRICULA) || PGFR_periodo_aquisitivo
       NOT IN (SELECT TO_CHAR(DFOP_MATRICULA) || DFOP_periodo_aquisitivo FROM Escala.Distribuicao_Ferias_Oper);
Commit;                 
End;
/                    