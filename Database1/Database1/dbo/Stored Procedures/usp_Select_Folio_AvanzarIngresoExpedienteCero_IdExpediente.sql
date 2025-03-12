-- =============================================
-- Author:		igs
-- Create date: 26-01-2016
-- Description:	Obtener los folios a Avanzar Automaticamente
-- usp_Select_Folio_AvanzarIngresoExpedienteCero_IdExpediente 174
-- =============================================
create PROCEDURE [dbo].[usp_Select_Folio_AvanzarIngresoExpedienteCero_IdExpediente]
@idExpediente int
AS 
    BEGIN
        SET NOCOUNT ON;
	
        SELECT  dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales.idExpediente ,
                dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales.folioBanco ,
                dbPrestoCibergestionBanorte.dbo.Actividades.idWorkFlow ,
                dbPrestoCibergestionBanorte.dbo.Actividades.idActividad ,
                dbPrestoCibergestionBanorte.dbo.Actividades.idUsuario ,
                dbPrestoCibergestionBanorte.dbo.Actividades.id ,
                dbPrestoCibergestionBanorte.dbo.Actividades.status
        FROM    dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales
                INNER JOIN dbPrestoCibergestionBanorte.dbo.Actividades ON dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales.idExpediente =dbPrestoCibergestionBanorte. dbo.Actividades.idExpediente
        WHERE   ( dbPrestoCibergestionBanorte.dbo.Actividades.idActividad = '_4fBQVMPDEeWPlbcvKjZuiw' )
                AND ( dbPrestoCibergestionBanorte.dbo.Actividades.status NOT IN( 'Completada' ,'Cancelado','Cancelada')) AND dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales.folioBanco<>'000000000000000'
				AND dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales.idExpediente=@idExpediente
    END
