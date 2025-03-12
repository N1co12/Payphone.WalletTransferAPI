
CREATE PROCEDURE [dbo].[uSP_CompletarActividad](@id BIGINT, @idUsuario BIGINT=0)
AS
BEGIN
	IF(@idUsuario not in (0))
		BEGIN
			Declare @idRol int = (select idRol from dbPrestoCibergestionBanorte.dbo.Usuarios where idUsuario = @idUsuario)
			
			if(@idRol not in (22)) -- Admin CG
				begin
					update dbPrestoCibergestionBanorte.dbo.Actividades set
						[status] = 'Completada'
						,fechaTermino = getdate()
						,idUsuario = @idUsuario
					where  id = @id
				end
			else
				begin
					update dbPrestoCibergestionBanorte.dbo.Actividades set
						[status] = 'Completada'
					   ,fechaTermino = getdate()
					where  id = @id	
				end
		END
	ELSE
		BEGIN
			update dbPrestoCibergestionBanorte.dbo.Actividades set
									[status] = 'Completada'
								   ,fechaTermino = getdate()
			where  id = @id	
		END	
END
