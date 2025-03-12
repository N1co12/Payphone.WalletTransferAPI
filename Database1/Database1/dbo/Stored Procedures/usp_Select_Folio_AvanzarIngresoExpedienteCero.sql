
CREATE PROCEDURE [dbo].[usp_Select_Folio_AvanzarIngresoExpedienteCero]
AS 
    BEGIN
        SET NOCOUNT ON;
	
 select 
    DG.idExpediente,
    DG.folioBanco,
    A.idWorkFlow  ,
    A.idActividad ,
    A.idUsuario ,
    A.id ,
    A.status
    from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales DG
    INNER JOIN dbPrestoCibergestionBanorte.dbo.Actividades A ON DG.idExpediente = A.idExpediente
      WHERE   ( A.idActividad = '_4fBQVMPDEeWPlbcvKjZuiw' )
                AND ( A.status NOT IN( 'Completada' ,'Cancelado','Cancelada')) AND DG.folioBanco<>'000000000000000'

 END


   