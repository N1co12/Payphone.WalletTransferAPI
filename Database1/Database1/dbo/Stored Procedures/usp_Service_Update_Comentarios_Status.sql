-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 05-12-2017
-- Description:	Actualiza comentarios y estatus de servicio xml
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Update_Comentarios_Status]
	
	  @IdXml		bigint
	, @Status		bit
	, @Comentarios  nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;

	Update dbo.tblDataCREa set 
		  [status]			= @Status
		, Comentarios		= @Comentarios
		, fechaValidacion	= current_timestamp
	where 
		id= @IdXml

END
