-- =============================================
-- Author:		igs
-- Create date: 26-01-2016
-- Description:	borrar la actividad ingresoExpedienteCero de los folios que Avanzaron Automaticamente
-- =============================================
create PROCEDURE [dbo].[usp_Delete_Folio_AvanzarIngresoExpedienteCero]
AS 
    BEGIN
        SET NOCOUNT ON;

	DELETE  dbPrestoCibergestionBanorte.dbo.Actividades WHERE idActividad='_4fBQVMPDEeWPlbcvKjZuiw' AND status='Completada'

    END