-- =============================================
-- Author:		igs
-- Create date: 28 sep
-- Description:	Recolectar datos a enviar a Presto en Ingreso
--exec uSP_IngresoExpediente 10233 
-- =============================================
CREATE PROCEDURE [dbo].[uSP_IngresoExpediente]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 decLARE @xmlDataCREa xml

set @xmlDataCREa=(select xmlDataCREa from tblDataCREa where id=@id) --10233


--flujo
			   
			    select 
						Container.ContainerCol.value('resultadopaso[1]','int') as resultadopaso,
						Container.ContainerCol.value('idTipoRechazo[1]','smallint') as idTipoRechazo,
						Container.ContainerCol.value('idmotivorechazo[1]','int') as idmotivorechazo,
						Container.ContainerCol.value('resultadoNotificacion[1]','bit') as resultadoNotificacion,
						Container.ContainerCol.value('comentarios[1]','nvarchar(3000)') as comentarios,
						Container.ContainerCol.value('fecha[1]','nvarchar(20)') as fecha,
						Container.ContainerCol.value('status[1]','bit') as status,
						Container.ContainerCol.value('mensaje[1]','nvarchar(3000)') as mensaje
	                    from @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container(ContainerCol)
--header
			   
			    select   
						Container.ContainerCol.value('nombre[1]','nvarchar(80)') as nombre,
						Container.ContainerCol.value('idPrograma[1]','nvarchar(50)') as idPrograma,
						Container.ContainerCol.value('destino[1]','nvarchar(50)') as destino,					
						Container.ContainerCol.value('rfc[1]','varchar(20)') as rfc,
						Container.ContainerCol.value('crSucursal[1]','nvarchar(80)') as crSucursal,
						Container.ContainerCol.value('noCaso[1]','nvarchar(50)') as noCaso		
					    from @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container(ContainerCol)





--Datos Personales
			      
			    select 
					    Container.ContainerCol.value('tipoParticipante[1]','nvarchar(30)') as tipoParticipante,
						Container.ContainerCol.value('nombreParticipante[1]','nvarchar(80)') as nombreParticipante,	
						Container.ContainerCol.value('bancoCteParticipante[1]','nvarchar(50)') as bancoCteParticipante,					
						Container.ContainerCol.value('estadoCivil[1]','smallint') as estadoCivil,
						Container.ContainerCol.value('codNacionalidad[1]','nvarchar(50)') as codNacionalidad,
						Container.ContainerCol.value('idAfiliacion[1]','int') as idAfiliacion,
						Container.ContainerCol.value('afiliacion[1]','nvarchar(30)') as afiliacion,
						convert(date,Container.ContainerCol.value('fechaNacimiento[1]','nvarchar(10)'),103) as fechaNacimiento,		
						Container.ContainerCol.value('sexo[1]','nvarchar(15)') as sexo,					
						Container.ContainerCol.value('conyuge[1]','nvarchar(50)') as conyuge,
						Container.ContainerCol.value('rfcConyuge[1]','varchar(25)') as rfcConyuge,
						Container.ContainerCol.value('nssc[1]','nvarchar(30)') as nssc
						from @xmlDataCREa.nodes('//DataCREa//DatosPersonalesCREa//DatosPersonales') AS Container(ContainerCol)

--Datos Domicilio
			   
				 select 
						Container.ContainerCol.value('tipoParticipante[1]','nvarchar(50)') as tipoParticipante,
						Container.ContainerCol.value('mail[1]','nvarchar(100)') as mail,
						Container.ContainerCol.value('tipo_tel1[1]','nvarchar(50)') as tipo_tel,
						Container.ContainerCol.value('telefono1[1]','nvarchar(30)') as telefono,						
						Container.ContainerCol.value('tipo_tel2[1]','nvarchar(50)') as tipo_tel,
						Container.ContainerCol.value('telefono2[1]','nvarchar(30)') as telefono,				
						Container.ContainerCol.value('tipo_tel3[1]','nvarchar(50)') as tipo_tel,
						Container.ContainerCol.value('telefono3[1]','nvarchar(30)') as telefono
						from @xmlDataCREa.nodes('//DataCREa//DatosDomicilioCREa//DatosDomicilio') AS Container(ContainerCol)


--Datos laborales
			      
			    select	
						Container.ContainerCol.value('tipoParticipante[1]','nvarchar(50)') as tipoParticipante,
						Container.ContainerCol.value('dirLabNumeroTelefonoDireccion[1]','nvarchar(20)') as dirLabNumeroTelefonoDireccion
						from @xmlDataCREa.nodes('//DataCREa//DatosLaboralesCREa//DatosLaborales') AS Container(ContainerCol)
             
--Datos operacion  
		         

		         select	
                        Container.ContainerCol.value('idSubproducto[1]','nvarchar(50)') as idSubproducto,
						Container.ContainerCol.value('idProgramaConvenio[1]','int') as idProgramaConvenio,
						Container.ContainerCol.value('idDestinoCredito[1]','int') as idDestinoCredito,
						Container.ContainerCol.value('idPlazo[1]','int') as idPlazo,
						Container.ContainerCol.value('idTipoComision[1]','int') as idTipoComision,
						Container.ContainerCol.value('importe[1]','decimal(12, 2)') as importe,	
						Container.ContainerCol.value('comisionApertura[1]','decimal(18, 0)') as comisionApertura,
						Container.ContainerCol.value('idAsesorBroker[1]','nvarchar(30)') as idAsesorBroker,
						Container.ContainerCol.value('idCanalVentas[1]','int') as idCanalVentas
						from @xmlDataCREa.nodes('//DataCREa//DatosOperacionCREa') AS Container(ContainerCol)
											

--garantias
			      
				 select   			                        
						
						Container.ContainerCol.value('idMarcaComercial[1]','nvarchar(50)') as idMarcaComercial,					
						Container.ContainerCol.value('calleNum[1]','nvarchar(50)') as calleNum,
						Container.ContainerCol.value('colonia[1]','nvarchar(50)') as colonia,		
						Container.ContainerCol.value('estado[1]','nvarchar(50)') as estado,
						Container.ContainerCol.value('codigoPostal[1]','int') as codigoPostal,
						Container.ContainerCol.value('lote[1]','nchar(3)') as lote,
						Container.ContainerCol.value('manzana[1]','nchar(3)') as manzana					
						from @xmlDataCREa.nodes('//DataCREa//GarantiasCREa')  AS Container(ContainerCol)
            
--evaluacion
			         
			    select    
						Container.ContainerCol.value('importe[1]','nvarchar(50)') as importe,
						Container.ContainerCol.value('tasaAplicable[1]','nvarchar(50)') as tasaAplicable,
						Container.ContainerCol.value('plazo[1]','nvarchar(50)') as plazo,
						Container.ContainerCol.value('tipoComision[1]','nvarchar(50)') as tipoComision,
						Container.ContainerCol.value('comisionApertura[1]','nvarchar(50)') as comisionApertura	
						from @xmlDataCREa.nodes('//DataCREa//EvalucionCREa')  AS Container(ContainerCol)


--InicioPrestoAvaluoJuridico
			               

				 select     
						Container.ContainerCol.value('noCtaChequesClientes[1]','int') as noCtaChequesClientes		
						from @xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa')  AS Container(ContainerCol)

--Memorandum
  

				 select     						
						Container.ContainerCol.value('plazaCredito[1]','nvarchar(30)') as plazaCredito						
						from @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')  AS Container(ContainerCol)


--ACOCApertura
 
                select      
						Container.ContainerCol.value('tipoCredito[1]','nvarchar(50)') as tipoCredito,					
						Container.ContainerCol.value('tasa[1]','nvarchar(50)') as tasa,			
						Container.ContainerCol.value('plazo[1]','nvarchar(50)') as plazo,		
						Container.ContainerCol.value('noCaso[1]','nvarchar(50)') as noCaso		
						from @xmlDataCREa.nodes('//DataCREa//ACOCAperturaCREa')  AS Container(ContainerCol)

--ACOCDisposicion
			
			    select      
						Container.ContainerCol.value('idComision[1]','int') as idComision,					
						Container.ContainerCol.value('crSucursal[1]','nvarchar(50)') as crSucursal,
						Container.ContainerCol.value('tipoCredito[1]','nvarchar(50)') as tipoCredito,					
						Container.ContainerCol.value('nombreCliente[1]','nvarchar(50)') as nombreCliente
						from @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa')  AS Container(ContainerCol)


END

