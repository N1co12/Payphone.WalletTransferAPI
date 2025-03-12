
CREATE PROCEDURE [dbo].[uSP_EncontrarActividad](@idExpediente bigint, @idActividad varchar(100))
AS
BEGIN
	select *
	from  dbPrestoCibergestionBanorte.dbo.Actividades
	where  idExpediente =  @idExpediente
	and    idActividad  = @idActividad 
	--and    status in ('Nueva','En Progreso','Suspendida A','Suspendida B','En Aclaración')
	and    status not in ('Completada','Cancelada')
END
