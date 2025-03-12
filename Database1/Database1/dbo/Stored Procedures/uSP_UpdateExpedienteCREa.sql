-- =============================================
-- Author:		igs
-- Create date: 07Sep2015
-- Description:	Store que almacena los datos enviado por el banco en distintas tablas
--  exec [uSP_UpdateExpedienteCREa] true, '', '07/09/2015',16,''
-- =============================================
CREATE PROCEDURE [dbo].[uSP_UpdateExpedienteCREa]
	-- Add the parameters for the stored procedure here
    @status BIT ,
    @Comentarios NVARCHAR(500) ,
    @idTblDataCREa INT ,
    @xmlDataCREa XML ,
    @noCaso NVARCHAR(30)
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @resultadopaso INT
        DECLARE @idPresto INT
        DECLARE @idTblDataCREaAnterior INT
        BEGIN TRY
            BEGIN TRANSACTION
  
  SELECT TOP 1 @idTblDataCREaAnterior=id FROM tblDataCREa WHERE noCaso=@noCaso 
  and id=(@idTblDataCREa-1)
      


	--Actualiza el estatus del xml enviado por el banco.
            UPDATE  dbo.tblDataCREa
            SET     status = 0 ,
                    Comentarios = Comentarios
                    + '| Ingreso un reproceso con el id '
                    + CAST(@idTblDataCREa AS VARCHAR(10))
            WHERE   status = 1
                    AND id = @idTblDataCREaAnterior
                    AND noCaso = @noCaso;

            UPDATE  tblDataCREa
            SET     status = @status ,
                    Comentarios = @Comentarios ,
                    fechaValidacion = GETDATE()
            WHERE   id = @idTblDataCREa


			     
            SELECT  1 AS ResultadoPaso ,
                    'Caso Registrado Con Éxito, folio:'
                    + CAST(@idTblDataCREa AS NVARCHAR(20)) AS Comentarios ,
                    GETDATE() AS FechaHrEnvio
                  
            COMMIT
        END TRY
        BEGIN CATCH
            IF ( @@trancount > 0 ) 
                BEGIN    
                    ROLLBACK  TRANSACTION
                    INSERT  INTO tblError
                            SELECT  ERROR_NUMBER() AS ErrorNumber ,
                                    ERROR_SEVERITY() AS ErrorSeverity ,
                                    ERROR_STATE() AS ErrorState ,
                                    ERROR_PROCEDURE() AS ErrorProcedure ,
                                    ERROR_LINE() AS ErrorLine ,
                                    ERROR_MESSAGE() AS ErrorMessage ,
                                    GETDATE() AS Fecha_Error ,
                                    0 AS USUARIO;
		
                    DECLARE @ErrMsg NVARCHAR(4000) ,
                        @ErrSeverity INT
                    SELECT  @ErrMsg = ERROR_MESSAGE() ,
                            @ErrSeverity = ERROR_SEVERITY()
                    RAISERROR(@ErrMsg, @ErrSeverity, 1)
                END
        END CATCH

    END
