-- =============================================
-- Author:		igs
-- Create date: 28 sep
-- Description:	Recolectar datos a enviar a Presto en Cierre de Cifras
--exec uSP_CierreCifras 10233 
-- =============================================
CREATE PROCEDURE [dbo].[uSP_CierreCifras]
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
             
--Datos Personales
			      
			     select 	    
						Container.ContainerCol.value('esquemaCredito[1]','nvarchar(30)') as esquemaCredito
						from @xmlDataCREa.nodes('//DataCREa//DatosPersonalesCREa//DatosPersonales') AS Container(ContainerCol)

--precalificacion	
			       		
				 select	              
						Container.ContainerCol.value('montoCredFovisssteTit[1]','nvarchar(30)') as montoCredFovisssteTit,
						Container.ContainerCol.value('saldoSubcuentaVivienda[1]','nvarchar(30)') as saldoSubcuentaVivienda,
						Container.ContainerCol.value('montoCredFovisssteCony[1]','nvarchar(30)') as montoCredFovisssteCony,
						Container.ContainerCol.value('saldoSubcuentaViviendaConyuge[1]','nvarchar(30)') as saldoSubcuentaViviendaConyuge,
						Container.ContainerCol.value('montoCredInfonavitTitular[1]','nvarchar(30)') as montoCredInfonavitTitular,
						Container.ContainerCol.value('montoCredInfonavitConyuge[1]','nvarchar(30)') as montoCredInfonavitConyuge
						from @xmlDataCREa.nodes('//DataCREa//PrecalificacionCREa')  AS Container(ContainerCol)

--InicioPrestoAvaluoJuridico
			               

			      select     
						
						Container.ContainerCol.value('importe[1]','decimal(10, 2)') as importe,
						Container.ContainerCol.value('reca[1]','nvarchar(50)') as reca
						from @xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa')  AS Container(ContainerCol)
--ACOCApertura
                         select     
				        
					  Container.ContainerCol.value('importe[1]','nvarchar(50)') as importe		  
					  from @xmlDataCREa.nodes('//DataCREa//ACOCAperturaCREa')  AS Container(ContainerCol)
--ACOCDisposicion
	

	                    select    
			              
					  Container.ContainerCol.value('importe[1]','nvarchar(50)') as importe,
					  Container.ContainerCol.value('montoDisposicion[1]','nvarchar(50)') as montoDisposicion 
					  from @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa')  AS Container(ContainerCol)

END



