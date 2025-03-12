create PROCEDURE [dbo].[SP_GetActividadById] 

	@id bigint

AS
BEGIN
	
	Declare @status nvarchar(100) = 'En progreso'
	set @status = (Select rtrim(ltrim([status])) from dbPrestoCibergestionBanorte.dbo.Actividades where id = @id)
	
	if(@status not in ('Suspendido proceso juridico', 'Suspendido proceso avaluos', 'Reproceso', 'Suspendida', 'Completada', 'Cancelado'))
		begin
			set @status = 'En progreso'
		end

	Update dbPrestoCibergestionBanorte.dbo.actividades set [status] = @status where id = @id

	Select * from dbPrestoCibergestionBanorte.dbo.Actividades where id = @id

END