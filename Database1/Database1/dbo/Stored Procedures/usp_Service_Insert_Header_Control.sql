-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 05-12-2017
-- Description:	Registro Header como método de control (existencia de servicio 100)
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Header_Control]

	  @IdXml		bigint	
	, @FolioBanco	nvarchar(25)
	, @XmlHeader	xml

AS
BEGIN
	SET NOCOUNT ON;

    if exists (Select 1 from dbo.tblHeader where noCaso = @FolioBanco)
		begin
			Declare @comentario nvarchar(300) = 'El número de caso existe en el flujo, codigo 100 no puede ser procesado.'

			update dbo.tblDataCREa 
				set 
					  [status]			= 0
					, [Comentarios]		= @comentario
					, fechaValidacion	= current_timestamp
				where 
					id = @IdXml
			  
			Select
				  [ResultadoPaso]	= cast(0 as bit)
				, [Comentarios]		= @comentario
				, [FechaHrEnvio]	= current_timestamp
		end
	else
		begin
			Insert into dbo.tblHeader (nombre, idPrograma, destino, banco, rfc, crSucursal, noCaso, bancoCte, noCliente, usrAsignado, tipoCredito, fechaRegistro)
				Select
					  Header.value('nombre[1]','nvarchar(80)')
					, Header.value('idPrograma[1]','nvarchar(50)')
					, Header.value('destino[1]','nvarchar(50)')
					, Header.value('banco[1]','nvarchar(50)')
					, Header.value('rfc[1]','varchar(20)')
					, Header.value('crSucursal[1]','nvarchar(80)')
					, Header.value('noCaso[1]','nvarchar(50)')
					, Header.value('bancoCte[1]','varchar(20)')
					, Header.value('noCliente[1]','nvarchar(30)')
					, Header.value('usrAsignado[1]','nvarchar(50)')
					, Header.value('tipoCredito[1]','varchar(20)')
					, current_timestamp
				from @XmlHeader.nodes('/Header')Catalog(Header)
			
			Select
				  [ResultadoPaso] = cast(1 as bit)
				, [Comentarios] = 'Caso registrado con éxito. Folio: ' + cast(@IdXml as nvarchar(15))
				, [FechaHrEnvio] = current_timestamp
		end

END
