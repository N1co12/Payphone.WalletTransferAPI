create procedure [dbo].[usp_ws_select_usuarios_by_usuario]
	@usuario varchar(max)
as begin

	select 
		*
	from UsuariosWS
	WHERE activo = 1
	and  Usuario = @usuario
end