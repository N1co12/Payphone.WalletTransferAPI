-- =============================================
-- Author:		igs
-- Create date: 28 sep
-- Description:	Recolectar datos a enviar a Presto en Avaluos
--exec uSP_Avaluos 10233 
-- =============================================
CREATE PROCEDURE [dbo].[uSP_Avaluos]
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
             
--Datos operacion  
		         
		         select	
                        
						Container.ContainerCol.value('valorEstimadoInmueble[1]','decimal(18, 0)') as valorEstimadoInmueble,
						Container.ContainerCol.value('idCorredorInmobiliario[1]','int') as idCorredorInmobiliario,			
						Container.ContainerCol.value('valorPrimerInmueble[1]','decimal(18, 0)') as valorPrimerInmueble,
						Container.ContainerCol.value('valorSegInmueble[1]','decimal(18, 0)') as valorSegInmueble,
						Container.ContainerCol.value('valorTercerInmueble[1]','decimal(18, 0)') as valorTercerInmueble	
						from @xmlDataCREa.nodes('//DataCREa//DatosOperacionCREa') AS Container(ContainerCol)
											

--garantias
			      
				 select   			                        
						
						Container.ContainerCol.value('noGarantia[1]','int') as noGarantia,
						Container.ContainerCol.value('esPromotor[1]','int') as esPromotor,
						Container.ContainerCol.value('propietario[1]','nvarchar(50)') as propietario,					
						Container.ContainerCol.value('ubicacion[1]','nvarchar(50)') as ubicacion,
						Container.ContainerCol.value('idTipoInmueble[1]','int') as idTipoInmueble,
						Container.ContainerCol.value('m2construccion[1]','decimal(6, 2)') as m2construccion,
						Container.ContainerCol.value('m2terreno[1]','decimal(6, 2)') as m2terreno,
						Container.ContainerCol.value('ruv[1]','int') as ruv						
						from @xmlDataCREa.nodes('//DataCREa//GarantiasCREa')  AS Container(ContainerCol)
            
--evaluacion
			         
			    select    
						Container.ContainerCol.value('valorEstimadoInmueble[1]','nvarchar(50)') as valorEstimadoInmueble
						from @xmlDataCREa.nodes('//DataCREa//EvalucionCREa')  AS Container(ContainerCol)


--InicioPrestoAvaluoJuridico
			               

				 select     
						
						Container.ContainerCol.value('nombreVendedor[1]','nvarchar(200)') as nombreVendedor,
						Container.ContainerCol.value('rfcVendedor[1]','nchar(13)') as rfcVendedor,
						Container.ContainerCol.value('telCasaVendedor[1]','nvarchar(30)') as telCasaVendedor,
						Container.ContainerCol.value('telOficinaVendedor[1]','nvarchar(30)') as telOficinaVendedor
						from @xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa')  AS Container(ContainerCol)

--Avaluo
				 

				 select     
						Container.ContainerCol.value('valorAvaluoPrimerInmueble[1]','numeric(10, 2)') as valorAvaluoPrimerInmueble,
						Container.ContainerCol.value('numeroAvaluo[1]','nchar(10)') as numeroAvaluo,
						convert(date,Container.ContainerCol.value('fechaAvaluoPrimerInmueble[1]','nvarchar(10)'),103) as fechaAvaluoPrimerInmueble,
						Container.ContainerCol.value('valorAvaluoSegInmueble[1]','numeric(10, 2)') as valorAvaluoSegInmueble,
						Container.ContainerCol.value('numeroAvaluoSegundoInmu[1]','int') as numeroAvaluoSegundoInmu,
						convert(date,Container.ContainerCol.value('fechaAvaluoSeguInmueble[1]','nvarchar(10)'),103) as fechaAvaluoSeguInmueble,
						Container.ContainerCol.value('valorAvaluoTercerInmueble[1]','numeric(10, 2)') as valorAvaluoTercerInmueble,
						Container.ContainerCol.value('numeroAvaluoTercerInmu[1]','int') as numeroAvaluoTercerInmu,
						Convert(date,Container.ContainerCol.value('fechaAvaluoTercInmueble[1]','nvarchar(10)'),103) as fechaAvaluoTercInmueble,
						Container.ContainerCol.value('sumaValorAvaluos[1]','numeric(10, 2)') as sumaValorAvaluos						
						from @xmlDataCREa.nodes('//DataCREa//AvaluoCREa')  AS Container(ContainerCol)

 --ACOCApertura
                       

                         select    
						Container.ContainerCol.value('ValorVivienda[1]','nvarchar(50)') as ValorVivienda
						from @xmlDataCREa.nodes('//DataCREa//ACOCAperturaCREa')  AS Container(ContainerCol)

--ACOCDisposicion
			
			      select    		
	  					Container.ContainerCol.value('nombreVendedor[1]','nvarchar(50)') as nombreVendedor
	  					from @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa')  AS Container(ContainerCol)

END


