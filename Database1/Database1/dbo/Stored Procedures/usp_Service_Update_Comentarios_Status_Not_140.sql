-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 05-12-2017
-- Description:	Actualiza comentarios y estatus de servicio xml
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Update_Comentarios_Status_Not_140]
	
	  @IdXml		bigint
	, @Status		bit
	, @Comentarios  nvarchar(max)
	, @FolioBanco	nvarchar(25)

AS
BEGIN
	SET NOCOUNT ON;

	if(@Status in ('true'))
		begin
			Update dbo.tblDataCREa set 
				[status] = cast(0 as bit)
			where 
				noCaso = @FolioBanco
		end

	Update dbo.tblDataCREa set 
		  [status]			= @Status
		, Comentarios		= @Comentarios
		, fechaValidacion	= current_timestamp
	where 
		id= @IdXml

END
