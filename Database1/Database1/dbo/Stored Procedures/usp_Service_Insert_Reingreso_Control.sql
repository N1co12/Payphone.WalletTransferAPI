-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 13-12-2017
-- Description:	Registro de reingreso
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Reingreso_Control]
	
	  @IdXml		bigint	
	, @FolioBanco	nvarchar(25)
	, @Status		bit
	, @Comentarios NVARCHAR(500)

AS
BEGIN
	SET NOCOUNT ON;

	declare @IdXmlPrevio int = (Select top 1 id from dbo.tblDataCREa where noCaso = @FolioBanco and id < @IdXml order by id desc)

	Update dbo.tblDataCREa set 
		  [status] = 0
		, Comentarios = Comentarios + ' | Ingreso un reproceso con el id ' + cast(@IdXml as nvarchar(10))
	where 
		noCaso = @FolioBanco 
		--and id = @IdXmlPrevio 
		and id not in (@IdXml)
		and [status] = cast(1 as bit)

	Select
		  [ResultadoPaso] = cast(1 as bit)
		, [Comentarios] = 'Caso registrado con éxito. Folio: ' + cast(@IdXml as nvarchar(15))
		, [FechaHrEnvio] = current_timestamp

END
