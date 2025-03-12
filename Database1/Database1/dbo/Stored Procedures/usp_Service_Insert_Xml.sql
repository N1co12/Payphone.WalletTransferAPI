-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 04-12-2017
-- Description:	Inserta xml de entrada
-- PREVIO: uSP_RegistraDataCREa
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Xml]
	
	  @FolioBanco	nvarchar(25)
	, @Codigo		int
	, @XmlData		xml
	
	

AS
BEGIN
	SET NOCOUNT ON;

	Insert into dbo.tblDataCREa (xmlDataCREa, fechaRegistro, codigo, noCaso)
		values (@XmlData, current_timestamp, @Codigo, @FolioBanco)

	Select [Id] = cast(scope_identity() as bigint)

END
