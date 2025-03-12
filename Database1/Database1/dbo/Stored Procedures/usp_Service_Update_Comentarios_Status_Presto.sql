-- =============================================
-- Author:		Mexicano
-- Create date: 08/06/2022
-- Description:	Actualiza comentarios y estatus de servicio xml
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Update_Comentarios_Status_Presto]
	
			@XmlResponse	xml
		,	@IdXml			bigint
		,	@Comentarios	nvarchar(max)

AS
BEGIN
	SET NOCOUNT ON;

	Update dbo.tblDataCREa	 set 
		 Comentarios				= @Comentarios
		, fechaValidacion			= current_timestamp
		, XMLRespuestaPrestoBanco	= @XmlResponse
	where 
		id= @IdXml

END
