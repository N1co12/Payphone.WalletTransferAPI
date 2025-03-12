-- =============================================
-- Author:		Eduardo
-- Create date: 13Oct2015
-- Description:	Store que almacena los datos enviado por el banco en formato XML sin Procesarlo a Presto
-- 
-- =============================================
CREATE PROCEDURE [dbo].[uSP_RegistraDataCREaEnPresto]
	-- Add the parameters for the stored procedure here
    @xmlDataCREa XML ,
    @codigo NVARCHAR(5) ,
    @noCaso NVARCHAR(30)
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
		if(@codigo not in (100, 140)) 
			begin
				DECLARE @idExpediente BIGINT

  
				IF ( EXISTS ( SELECT    1
							  FROM      dbPrestoCibergestionBanorte.dbo.tblDataCREa
							  WHERE     status = 1
										AND noCaso = @noCaso ) ) 
					BEGIN 

					SET @idExpediente=( SELECT    TOP 1 idExpediente
							  FROM      dbPrestoCibergestionBanorte.dbo.tblDataCREa
							  WHERE     status = 1
										AND noCaso = @noCaso )
						UPDATE  dbPrestoCibergestionBanorte.dbo.tblDataCREa
						SET     status = 0
						WHERE   noCaso = @noCaso
								AND status = 1

						INSERT  INTO dbPrestoCibergestionBanorte.[dbo].[tblDataCREa]
								( [xmlDataCREa] ,
								  codigo ,
								  idExpediente,
								  noCaso ,
								  fechaRegistro,
								  status
								)
						VALUES  ( @xmlDataCREa ,
								  @codigo ,
								  @idExpediente,
								  @noCaso ,
								  GETDATE(),
								  1
								);

						if(@codigo in (180))
							begin
								if exists(select 1 from dbPrestoCibergestionBanorte.dbo.tblCierreCifras where idExpediente = @idExpediente)
									begin
										Update dbPrestoCibergestionBanorte.dbo.tblCierreCifras set
											cat = isNull(ACOCAperturaCREa.value('(cat/text())[1]', 'decimal(18, 2)'), 0)
										from @xmlDataCrea.nodes('//DataCREa//ACOCAperturaCREa') as nodo01(ACOCAperturaCREa)
										where idExpediente = @idExpediente
									end
							end
					END
				ELSE 
					BEGIN
						SET @idExpediente=( SELECT    TOP 1 idExpediente
							  FROM      dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales
							  WHERE     folioBanco = @noCaso )
            
						INSERT  INTO dbPrestoCibergestionBanorte.[dbo].[tblDataCREa]
								( [xmlDataCREa] ,
								  codigo ,
								  idExpediente,
								  noCaso ,
								  fechaRegistro,
								  status
								)
						VALUES  ( @xmlDataCREa ,
								  @codigo ,
								  @idExpediente,
								  @noCaso ,
								  GETDATE(),
								  1
								);
					END
			end

    END
