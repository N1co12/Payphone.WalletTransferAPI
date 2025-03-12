-- =============================================
-- Author:		igs
-- Create date: 28 sep
-- Description:	Recolectar datos a enviar a Presto en Notarial
-- exec uSP_ProgramacionFirma 10233 
-- =============================================
CREATE PROCEDURE [dbo].[uSP_ProgramacionFirma]
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
             
--InicioPrestoAvaluoJuridico


				 select     
						
						Container.ContainerCol.value('idTipoPagoCliente[1]','int') as idTipoPagoCliente,
						Container.ContainerCol.value('importePagoVendedor[1]','nvarchar(30)') as importePagoVendedor,
						Container.ContainerCol.value('idTipoPagoVendedor[1]','nvarchar(30)') as idTipoPagoVendedor,
						Container.ContainerCol.value('noCuentaVendedor[1]','nvarchar(30)') as noCuentaVendedor
						from @xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa')  AS Container(ContainerCol)

--InicioPrestoFechaFirmas
			       
			      select     
						convert(date,Container.ContainerCol.value('fechaFirma[1]','nvarchar(12)'),103) as fechaFirma,
                        Container.ContainerCol.value('horaFirma[1]','decimal(10, 2)') as horaFirma
						from @xmlDataCREa.nodes('//DataCREa//InicioPrestoFechaFirmasCrea')  AS Container(ContainerCol)

--Memorandum
                  

				  select    						
						Container.ContainerCol.value('numeroContrato[1]','nvarchar(10)') as numeroContrato,
						convert(date,Container.ContainerCol.value('fechaPrimerPago[1]','nvarchar(10)'),103) as fechaPrimerPago					
						from @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')  AS Container(ContainerCol)


--presto           
				     
				select     
						Container.ContainerCol.value('plazaAsignacion[1]','nvarchar(50)') as plazaAsignacion,
						Container.ContainerCol.value('sucursalAsignacion[1]','nvarchar(50)') as sucursalAsignacion
						from @xmlDataCREa.nodes('//DataCREa//PrestoCREa')  AS Container(ContainerCol)

--ACOCApertura
  

                select     
					    Container.ContainerCol.value('noCredito[1]','nvarchar(50)') as noCredito,
						Container.ContainerCol.value('ctaCheques[1]','nvarchar(50)') as ctaCheques,
						Container.ContainerCol.value('comApertura[1]','nvarchar(50)') as comApertura,
						Container.ContainerCol.value('formaPago[1]','nvarchar(50)') as formaPago
						from @xmlDataCREa.nodes('//DataCREa//ACOCAperturaCREa')  AS Container(ContainerCol)

--ACOCDisposicion
			         
			    select    
				        Container.ContainerCol.value('noCredito[1]','nvarchar(50)') as noCredito,				
						Container.ContainerCol.value('idFormaPago[1]','nvarchar(50)') as idFormaPago,
						Container.ContainerCol.value('fechaFirma[1]','nvarchar(50)') as fechaFirma,
						Container.ContainerCol.value('montoChequeCaja[1]','nvarchar(50)') as montoChequeCaja,					
						Container.ContainerCol.value('noCtaChequesAcred[1]','nvarchar(50)') as noCtaChequesAcred,
						Container.ContainerCol.value('idPagoVendedor[1]','int') as idPagoVendedor,
						Container.ContainerCol.value('idTipoPagoVendedor[1]','nvarchar(30)') as idTipoPagoVendedor,
						Container.ContainerCol.value('ctaChequesVendedor[1]','nvarchar(30)') as ctaChequesVendedor,
						Container.ContainerCol.value('importePagoVendedor[1]','nvarchar(50)') as importePagoVendedor,
						Container.ContainerCol.value('importeGastosNotario[1]','nvarchar(50)') as importeGastosNotario,
						Container.ContainerCol.value('cuentaHonorariosNotario[1]','nvarchar(50)') as cuentaHonorariosNotario,
						Container.ContainerCol.value('noCuenta[1]','nvarchar(50)') as noCuenta,					
						Container.ContainerCol.value('numeroCredito[1]','nvarchar(50)') as numeroCredito				
						from @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa')  AS Container(ContainerCol)


END




