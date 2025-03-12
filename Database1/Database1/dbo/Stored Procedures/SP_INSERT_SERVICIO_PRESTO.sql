CREATE PROCEDURE SP_INSERT_SERVICIO_PRESTO
(
	@XmlDatos XML,
	@XmlResponse XML,
	@Codigo VARCHAR(10),
	@ApiId INT --1: CREA, 2: PRESTO, 3: OTROS
)
AS
BEGIN 
	SET NOCOUNT ON;

	DECLARE @noCaso VARCHAR(25) = '';
	DECLARE @StatusResponse INT = 0;
	DECLARE @Comentarios VARCHAR(MAX) = '';
	DECLARE @ID BIGINT = 0;
	DECLARE @Estatus BIT = IIF(@StatusResponse = 422, 0, 1);

	--select top 10 * from tblDataCREa order by 1 desc--where noCaso = '202204016191139'
	--select top 10 * from tblHeader order by 1 desc
	

	SELECT  
		@noCaso = Header.value('noCaso[1]', 'varchar(25)')
	FROM @XmlDatos.nodes('//IngresoPrestovm/Header')Catalog(Header)

	SELECT 
		@StatusResponse = Response.value('Status[1]', 'INT'),
		@Comentarios = Response.value('Comentarios[1]', 'VARCHAR(MAX)')
	FROM @XmlResponse.nodes('//Response')Catalog(Response)

	INSERT INTO tblDataCREa(xmlDataCREa, fechaRegistro, status, Comentarios, fechaValidacion, codigo, noCaso, enviadoPresto, XMLRespuestaPrestoBanco, ApiId)
	VALUES(@XmlDatos, CURRENT_TIMESTAMP, @Estatus, IIF(@StatusResponse = 422, @Comentarios, @Codigo), NULL, @Codigo, @noCaso, 0, @XmlResponse, @ApiId)

	SELECT @ID = CAST(SCOPE_IDENTITY() AS BIGINT) 
	
	IF EXISTS (SELECT 1 FROM tblHeader WHERE noCaso = @noCaso)
	BEGIN
		DECLARE @COMENTARIO VARCHAR(300) = 'El número de caso existe en el flujo, codigo 100 no puede ser procesado.'
		SET @Estatus = 0
		UPDATE A SET A.status = @Estatus,
					 A.Comentarios = @COMENTARIO,
					 A.fechaValidacion = CURRENT_TIMESTAMP,
					 A.XMLRespuestaPrestoBanco = @XmlResponse
		--SELECT * 
		FROM tblDataCREa A
		WHERE A.id = @ID
		
	END
	ELSE 
	BEGIN
		INSERT INTO tblHeader(nombre, idPrograma, destino, banco, rfc, crSucursal, noCaso, bancoCte, noCliente, usrAsignado, tipoCredito, fechaRegistro)
		SELECT  
			 Header.value('nombre[1]','nvarchar(80)')  
			,Header.value('idPrograma[1]','nvarchar(50)')  
			,Header.value('destino[1]','nvarchar(50)')  
			,Header.value('banco[1]','nvarchar(50)')  
			,Header.value('rfc[1]','varchar(20)')  
			,Header.value('crSucursal[1]','nvarchar(80)')  
			,Header.value('noCaso[1]','nvarchar(50)')  
			,Header.value('bancoCte[1]','varchar(20)')  
			,Header.value('noCliente[1]','nvarchar(30)')  
			,Header.value('usrAsignado[1]','nvarchar(50)')  
			,Header.value('tipoCredito[1]','varchar(20)')  
			,current_timestamp  
		FROM @XmlDatos.nodes('//IngresoPrestovm/Header')Catalog(Header)

		
	END

	SELECT Id = @ID, Estatus = @Estatus 
END