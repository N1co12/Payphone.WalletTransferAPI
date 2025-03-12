-- =============================================
-- Create date: 05/08/2021
-- Description:	Registra información para servicio de postfima (ENTRADA)

-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_EntradaPostFirma]
		@FolioBanco		varchar(50)
	,	@idExpediente	bigint
	,	@Estatus		bit
	,	@Mensaje		nvarchar(max)
	,	@Comentario		nvarchar(max)
AS
BEGIN
	set nocount on;
	Set transaction isolation level read uncommitted;

	declare @fechaActual datetime = getdate()

	if exists(select top 1 idExpediente from [dbPrestoCibergestionBanorte].[dbo].[tblHistorial_Entrada_WsPostFirma] where idExpediente=@idExpediente)
		begin
				update  [dbPrestoCibergestionBanorte].[dbo].[tblHistorial_Entrada_WsPostFirma] set
						estatus				=	@Estatus
					,	msg					=	@Mensaje
					,	comentarios			=	@Comentario
					,	fechaActualizacion	=	@fechaActual
					,	fechaReEnvio		=	iif(@Estatus = cast(1 as bit), @fechaActual, null)
				where 
					idExpediente=@idExpediente
		end
	else
		begin
				insert into  [dbPrestoCibergestionBanorte].[dbo].[tblHistorial_Entrada_WsPostFirma] 
					( folioBanco, idExpediente, estatus, msg,comentarios, fechaAlta, fechaActualizacion, fechaReEnvio)
				VALUES(
						@FolioBanco
					,	@idExpediente
					,	@Estatus
					,	@Mensaje
					,	@Comentario
					,	@fechaActual
					,	null
					,	iif(@Estatus = cast(1 as bit), @fechaActual, null)
				)

		end

	select exito = cast(1 as bit)
END