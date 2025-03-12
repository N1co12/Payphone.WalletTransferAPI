-- =============================================
-- Author:		Mexicano
-- Create date: 07/06/2022
-- Description:	Inserta xml de entrada
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Xml_Presto]
		@XmlRequest		xml
	,	@XmlResponse	xml
	,	@Codigo			char(3)
	,	@ApiId			int
	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @FolioBanco as varchar(25)=''

	SELECT  
		@FolioBanco = Header.value('noCaso[1]', 'varchar(25)')
	FROM @XmlRequest.nodes('//IngresoPrestovm/Header')Catalog(Header)

	Insert into dbo.tblDataCREa (xmlDataCREa, fechaRegistro, status, codigo, noCaso, enviadoPresto, XMLRespuestaPrestoBanco, ApiId)
	values (@XmlRequest, current_timestamp, 0, @Codigo, @FolioBanco,0, @XmlResponse, @ApiId)

	Select [Id] = cast(scope_identity() as bigint), [Estatus]=CAST(1 as bit)

END
