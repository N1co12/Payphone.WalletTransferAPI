-- =============================================
-- Author:		igs
-- Create date: 07Sep2015
-- Description:	Store que almacena los datos enviado por el banco en distintas tablas
--  exec uSP_RegistraExpedienteCREa true, '', '07/09/2015',16,''
-- =============================================
create PROCEDURE [dbo].[uSP_RegistraExpedienteCREa_Respaldo]
	-- Add the parameters for the stored procedure here
	 @status bit,
     @Comentarios nvarchar(500),
     @FechaHrEnvio datetime,
	 @idTblDataCREa int,
	 @xmlDataCREa xml

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @resultadopaso int
	declare @idPresto int

begin try
	begin transaction

	
	--Actualiza el estatus del xml enviado por el banco.
	update tblDataCREa set status=@status, Comentarios=@Comentarios, fechaValidacion=getdate() where id=@idTblDataCREa


	--Distribucion del xml en distintas tablas

	set @resultadopaso=( select Container.ContainerCol.value('resultadopaso[1]','int') 
	             from @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container(ContainerCol))


	if( @resultadopaso =100)
	  begin
	    declare @noCaso nvarchar(30)

		set @noCaso=( select Container.ContainerCol.value('noCaso[1]','nvarchar(30)') 
	             from @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container(ContainerCol))
		print @noCaso
        
		 if(Exists(Select * from [dbo].[tblHeader] where [noCaso]=@noCaso))
		   begin
		     
			  update [dbo].[tblDataCREa] set [status]=0,[Comentarios]='El número de caso existe en el flujo, por codigo 100 no puede ser procesado', fechaValidacion=getdate() where id=@idTblDataCREa
			  --Respuesta
			  Select 0 as ResultadoPaso, 'El número de caso existe en el flujo, por codigo 100 no puede ser procesado' as Comentarios, getdate() as FechaHrEnvio
		   end
		 else
		   begin
		     

			--  --header
			   insert into [dbo].[tblHeader] (nombre,idPrograma,destino,banco,rfc,crSucursal,noCaso,bancoCte,noCliente,usrAsignado,tipoCredito,fechaRegistro)
			    select   
						Container.ContainerCol.value('nombre[1]','nvarchar(80)') as nombre,
						Container.ContainerCol.value('idPrograma[1]','nvarchar(50)') as idPrograma,
						Container.ContainerCol.value('destino[1]','nvarchar(50)') as destino,
						Container.ContainerCol.value('banco[1]','nvarchar(50)') as banco,
						Container.ContainerCol.value('rfc[1]','varchar(20)') as rfc,
						Container.ContainerCol.value('crSucursal[1]','nvarchar(80)') as crSucursal,
						Container.ContainerCol.value('noCaso[1]','nvarchar(50)') as noCaso,
						Container.ContainerCol.value('bancoCte[1]','varchar(20)') as bancoCte,
						Container.ContainerCol.value('noCliente[1]','nvarchar(30)') as noCliente,
						Container.ContainerCol.value('usrAsignado[1]','nvarchar(50)') as usrAsignado,
						Container.ContainerCol.value('tipoCredito[1]','varchar(20)') as tipoCredito,
						getdate()  as fechaRegistro
					  from @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container(ContainerCol)

				
				 set @idPresto=@@IDENTITY
				 print @idPresto
			  --flujo
			   insert into [dbo].[tblFlujo] (idPresto,resultadopaso,idTipoRechazo,idmotivorechazo,resultadoNotificacion,comentarios,fecha,status,mensaje)
			    select  @idPresto   as idPresto,
						Container.ContainerCol.value('resultadopaso[1]','int') as resultadopaso,
						Container.ContainerCol.value('idTipoRechazo[1]','smallint') as idTipoRechazo,
						Container.ContainerCol.value('idmotivorechazo[1]','int') as idmotivorechazo,
						Container.ContainerCol.value('resultadoNotificacion[1]','bit') as resultadoNotificacion,
						Container.ContainerCol.value('comentarios[1]','nvarchar(100)') as comentarios,
						Container.ContainerCol.value('fecha[1]','nvarchar(20)') as fecha,
						Container.ContainerCol.value('status[1]','bit') as status,
						Container.ContainerCol.value('mensaje[1]','nvarchar(500)') as mensaje
	                    from @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container(ContainerCol)
				

			----Datos Personales
			      insert into [dbo].[tblDatosPersonales] (idPresto,tipoParticipante,nombreParticipante,noClienteParticipante,rfcParticipante,bancoCteParticipante,lugarNacimiento,estadoCivil,codNacionalidad,idAfiliacion,afiliacion,fechaNacimiento,edad,sexo,esquemaCredito,conyuge,rfcConyuge,nssc)
			            select @idPresto   as idPresto,
					    Container.ContainerCol.value('tipoParticipante[1]','nvarchar(30)') as tipoParticipante,
						Container.ContainerCol.value('nombreParticipante[1]','nvarchar(80)') as nombreParticipante,
						Container.ContainerCol.value('noClienteParticipante[1]','varchar(20)') as noClienteParticipante,
						Container.ContainerCol.value('rfcParticipante[1]','varchar(20)') as rfcParticipante,
						Container.ContainerCol.value('bancoCteParticipante[1]','nvarchar(50)') as bancoCteParticipante,
						Container.ContainerCol.value('lugarNacimiento[1]','nvarchar(40)') as lugarNacimiento,
						Container.ContainerCol.value('estadoCivil[1]','smallint') as estadoCivil,
						Container.ContainerCol.value('codNacionalidad[1]','nvarchar(50)') as codNacionalidad,
						Container.ContainerCol.value('idAfiliacion[1]','int') as idAfiliacion,
						Container.ContainerCol.value('afiliacion[1]','nvarchar(30)') as afiliacion,
						convert(date,Container.ContainerCol.value('fechaNacimiento[1]','nvarchar(10)'),103) as fechaNacimiento,
						Container.ContainerCol.value('edad[1]','int') as edad,
						Container.ContainerCol.value('sexo[1]','nvarchar(15)') as sexo,
						Container.ContainerCol.value('esquemaCredito[1]','nvarchar(30)') as esquemaCredito,
						Container.ContainerCol.value('conyuge[1]','nvarchar(50)') as conyuge,
						Container.ContainerCol.value('rfcConyuge[1]','varchar(25)') as rfcConyuge,
						Container.ContainerCol.value('nssc[1]','nvarchar(30)') as nssc
						from @xmlDataCREa.nodes('//DataCREa//DatosPersonalesCREa//DatosPersonales') AS Container(ContainerCol)

			----Datos Domicilio
			          insert into [dbo].[tblDatosDomicilio](idPresto,tipoParticipante,calle,numero,dirColoniaPoblacion,codCiudad,municipio,estado,pais,codigoPostal,tipoDomicilio,tipoVivienda,departamento,mail,tipo_tel1,telefono1,ext1,tipo_tel2,telefono2,ext2,tipo_tel3,telefono3,ext3)
						  select @idPresto as idPresto,
								Container.ContainerCol.value('tipoParticipante[1]','nvarchar(50)') as tipoParticipante,
								Container.ContainerCol.value('calle[1]','nvarchar(100)') as calle,
								Container.ContainerCol.value('numero[1]','nchar(10)') as numero,
								Container.ContainerCol.value('dirColoniaPoblacion[1]','nvarchar(100)') as dirColoniaPoblacion,
								Container.ContainerCol.value('codCiudad[1]','nvarchar(100)') as codCiudad,
								Container.ContainerCol.value('municipio[1]','nvarchar(50)') as municipio,
								Container.ContainerCol.value('estado[1]','nvarchar(50)') as estado,
								Container.ContainerCol.value('pais[1]','nvarchar(50)') as pais,
								Container.ContainerCol.value('codigoPostal[1]','int') as codigoPostal,
								Container.ContainerCol.value('tipoDomicilio[1]','nvarchar(50)') as tipoDomicilio,
								Container.ContainerCol.value('tipoVivienda[1]','nvarchar(100)') as tipoVivienda,
								Container.ContainerCol.value('departamento[1]','nvarchar(100)') as departamento,
								Container.ContainerCol.value('mail[1]','nvarchar(100)') as mail,
								Container.ContainerCol.value('tipo_tel1[1]','nvarchar(50)') as tipo_tel,
								Container.ContainerCol.value('telefono1[1]','nvarchar(30)') as telefono,
								Container.ContainerCol.value('ext1[1]','nvarchar(30)') as ext,
								Container.ContainerCol.value('tipo_tel2[1]','nvarchar(50)') as tipo_tel,
								Container.ContainerCol.value('telefono2[1]','nvarchar(30)') as telefono,
								Container.ContainerCol.value('ext2[1]','nvarchar(30)') as ext,
								Container.ContainerCol.value('tipo_tel3[1]','nvarchar(50)') as tipo_tel,
								Container.ContainerCol.value('telefono3[1]','nvarchar(30)') as telefono,
								Container.ContainerCol.value('ext3[1]','nvarchar(30)') as ext
								from @xmlDataCREa.nodes('//DataCREa//DatosDomicilioCREa//DatosDomicilio') AS Container(ContainerCol)
			------Datos laborales
			      insert into [dbo].[tblDatosLaborales](idPresto,tipoParticipante,dirLabNumeroTelefonoDireccion,dirLabExtensionTelefonica)
			           select	@idPresto as idPresto,
								Container.ContainerCol.value('tipoParticipante[1]','nvarchar(50)') as tipoParticipante,
								Container.ContainerCol.value('dirLabNumeroTelefonoDireccion[1]','nvarchar(20)') as dirLabNumeroTelefonoDireccion,
								Container.ContainerCol.value('dirLabExtensionTelefonica[1]','int') as dirLabExtensionTelefonica
								from @xmlDataCREa.nodes('//DataCREa//DatosLaboralesCREa//DatosLaborales') AS Container(ContainerCol)
        --     
		--Datos operacion -- 
		         insert into [dbo].[tblDatosOperacion] (idPresto,idSubproducto,idProgramaConvenio,idDestinoCredito,idGpoPlazo,idPlazo,idCondicionSpecial,idModalidad,idTipoTasa,idTipoComision,idComisionInvestigacion,idMoneda,importe,valorEstimadoInmueble,comisionApertura,comisionAdmin,comisionMinistracion,comisionPrepago,comInvest,ivacominvest,seguroGen,idlsReferenciaBroker,idUsuarioBroker,idFranquiciaBroker,idAsesorBroker,idCorredorInmobiliario,idFranquiciaCl,idAsesorInmobiliario,idCanalVentas,folio,fuerzaGanadora,valorPrimerInmueble,valorSegInmueble,valorTercerInmueble,ecotecnologia)

		                select	@idPresto as idPresto,    
                                Container.ContainerCol.value('idSubproducto[1]','nvarchar(50)') as idSubproducto,
								Container.ContainerCol.value('idProgramaConvenio[1]','int') as idProgramaConvenio,
								Container.ContainerCol.value('idDestinoCredito[1]','int') as idDestinoCredito,
								Container.ContainerCol.value('idGpoPlazo[1]','int') as idGpoPlazo,
								Container.ContainerCol.value('idPlazo[1]','int') as idPlazo,
								Container.ContainerCol.value('idCondicionSpecial[1]','int') as idCondicionSpecial,
								Container.ContainerCol.value('idModalidad[1]','int') as idModalidad,
								Container.ContainerCol.value('idTipoTasa[1]','int') as idTipoTasa,
								Container.ContainerCol.value('idTipoComision[1]','int') as idTipoComision,
								Container.ContainerCol.value('idComisionInvestigacion[1]','nvarchar(50)') as idComisionInvestigacion,
								Container.ContainerCol.value('idMoneda[1]','int') as idMoneda,
								Container.ContainerCol.value('importe[1]','decimal(12, 2)') as importe,
								Container.ContainerCol.value('valorEstimadoInmueble[1]','decimal(18, 0)') as valorEstimadoInmueble,
								Container.ContainerCol.value('comisionApertura[1]','decimal(18, 0)') as comisionApertura,
								Container.ContainerCol.value('comisionAdmin[1]','nvarchar(30)') as comisionAdmin,
								Container.ContainerCol.value('comisionMinistracion[1]','nvarchar(30)') as comisionMinistracion,
								Container.ContainerCol.value('comisionPrepago[1]','nvarchar(30)') as comisionPrepago,
								Container.ContainerCol.value('comInvest[1]','nvarchar(30)') as comInvest,
								Container.ContainerCol.value('ivacominvest[1]','int') as ivacominvest,
								Container.ContainerCol.value('seguroGen[1]','nvarchar(50)') as seguroGen,
								Container.ContainerCol.value('idlsReferenciaBroker[1]','int') as idlsReferenciaBroker,
								Container.ContainerCol.value('idUsuarioBroker[1]','nvarchar(30)') as idUsuarioBroker,
								Container.ContainerCol.value('idFranquiciaBroker[1]','nvarchar(30)') as idFranquiciaBroker,
								Container.ContainerCol.value('idAsesorBroker[1]','nvarchar(30)') as idAsesorBroker,
								Container.ContainerCol.value('idCorredorInmobiliario[1]','int') as idCorredorInmobiliario,
								Container.ContainerCol.value('idFranquiciaCl[1]','int') as idFranquiciaCl,
								Container.ContainerCol.value('idAsesorInmobiliario[1]','int') as idAsesorInmobiliario,
								Container.ContainerCol.value('idCanalVentas[1]','int') as idCanalVentas,
								Container.ContainerCol.value('folio[1]','nvarchar(50)') as folio,
								Container.ContainerCol.value('fuerzaGanadora[1]','nvarchar(30)') as fuerzaGanadora,
								Container.ContainerCol.value('valorPrimerInmueble[1]','decimal(18, 0)') as valorPrimerInmueble,
								Container.ContainerCol.value('valorSegInmueble[1]','decimal(18, 0)') as valorSegInmueble,
								Container.ContainerCol.value('valorTercerInmueble[1]','decimal(18, 0)') as valorTercerInmueble,
								Container.ContainerCol.value('ecotecnologia[1]','nvarchar(50)') as ecotecnologia

								from @xmlDataCREa.nodes('//DataCREa//DatosOperacionCREa') AS Container(ContainerCol)
								
								
			--		--precalificacion	
			       insert into [dbo].[tblPrecalificacion] (idPresto,montoCredFovisssteTit,saldoSubcuentaVivienda,montoCredFovisssteCony,saldoSubcuentaViviendaConyuge,montoCredInfonavitTitular,montoCredInfonavitConyuge)		
					         select	      @idPresto as idPresto,        
					          
									Container.ContainerCol.value('montoCredFovisssteTit[1]','nvarchar(30)') as montoCredFovisssteTit,
									Container.ContainerCol.value('saldoSubcuentaVivienda[1]','nvarchar(30)') as saldoSubcuentaVivienda,
									Container.ContainerCol.value('montoCredFovisssteCony[1]','nvarchar(30)') as montoCredFovisssteCony,
									Container.ContainerCol.value('saldoSubcuentaViviendaConyuge[1]','nvarchar(30)') as saldoSubcuentaViviendaConyuge,
									Container.ContainerCol.value('montoCredInfonavitTitular[1]','nvarchar(30)') as montoCredInfonavitTitular,
									Container.ContainerCol.value('montoCredInfonavitConyuge[1]','nvarchar(30)') as montoCredInfonavitConyuge
									from @xmlDataCREa.nodes('//DataCREa//PrecalificacionCREa')  AS Container(ContainerCol)

			--	   --garantias
			      insert into [dbo].[tblGarantias] (idPresto,noGarantia,esPromotor,propietario,idMarcaComercial,ejecutivo,calleNum,colonia,ciudad,estado,codigoPostal,ubicacion,idTipoInmueble,lote,manzana,m2construccion,m2terreno,ruv,latitud,longitud,idEsDomicilioTitular,idEsGarantiaCony,idGarantiaFuePropiedad)
				                    select   @idPresto as idPresto,
				                        
									Container.ContainerCol.value('noGarantia[1]','int') as noGarantia,
									Container.ContainerCol.value('esPromotor[1]','int') as esPromotor,
									Container.ContainerCol.value('propietario[1]','nvarchar(50)') as propietario,
									Container.ContainerCol.value('idMarcaComercial[1]','nvarchar(50)') as idMarcaComercial,
									Container.ContainerCol.value('ejecutivo[1]','nvarchar(100)') as ejecutivo,
									Container.ContainerCol.value('calleNum[1]','nvarchar(50)') as calleNum,
									Container.ContainerCol.value('colonia[1]','nvarchar(50)') as colonia,
									Container.ContainerCol.value('ciudad[1]','nvarchar(20)') as ciudad,
									Container.ContainerCol.value('estado[1]','nvarchar(50)') as estado,
									Container.ContainerCol.value('codigoPostal[1]','int') as codigoPostal,
									Container.ContainerCol.value('ubicacion[1]','nvarchar(50)') as ubicacion,
									Container.ContainerCol.value('idTipoInmueble[1]','int') as idTipoInmueble,
									Container.ContainerCol.value('lote[1]','nchar(3)') as lote,
									Container.ContainerCol.value('manzana[1]','nchar(3)') as manzana,
									Container.ContainerCol.value('m2construccion[1]','decimal(6, 2)') as m2construccion,
									Container.ContainerCol.value('m2terreno[1]','decimal(6, 2)') as m2terreno,
									Container.ContainerCol.value('ruv[1]','int') as ruv,
									Container.ContainerCol.value('latitud[1]','decimal(2, 2)') as latitud,
									Container.ContainerCol.value('longitud[1]','decimal(2, 2)') as longitud,
									Container.ContainerCol.value('idEsDomicilioTitular[1]','int') as idEsDomicilioTitular,
									Container.ContainerCol.value('idEsGarantiaCony[1]','int') as idEsGarantiaCony,
									Container.ContainerCol.value('idGarantiaFuePropiedad[1]','int') as idGarantiaFuePropiedad
									from @xmlDataCREa.nodes('//DataCREa//GarantiasCREa')  AS Container(ContainerCol)
            
			--   --evaluacion
			         insert into [dbo].[tblEvalucion] (idPresto,importe,valorEstimadoInmueble,bonificacionEfect,porcentajeFinanciamiento,montoEnganche,tasaAplicable,plazo,tipoComision,comisionApertura,comisionAdmin,comisionMinistracion,comisionPrepago,comInvest,fechaEvaluacion)
			             select     @idPresto as idPresto,
									Container.ContainerCol.value('importe[1]','nvarchar(50)') as importe,
									Container.ContainerCol.value('valorEstimadoInmueble[1]','nvarchar(50)') as valorEstimadoInmueble,
									Container.ContainerCol.value('bonificacionEfect[1]','nvarchar(50)') as bonificacionEfect,
									Container.ContainerCol.value('porcentajeFinanciamiento[1]','nvarchar(50)') as porcentajeFinanciamiento,
									Container.ContainerCol.value('montoEnganche[1]','nvarchar(50)') as montoEnganche,
									Container.ContainerCol.value('tasaAplicable[1]','nvarchar(50)') as tasaAplicable,
									Container.ContainerCol.value('plazo[1]','nvarchar(50)') as plazo,
									Container.ContainerCol.value('tipoComision[1]','nvarchar(50)') as tipoComision,
									Container.ContainerCol.value('comisionApertura[1]','nvarchar(50)') as comisionApertura,
									Container.ContainerCol.value('comisionAdmin[1]','nvarchar(50)') as comisionAdmin,
									Container.ContainerCol.value('comisionMinistracion[1]','nvarchar(50)') as comisionMinistracion,
									Container.ContainerCol.value('comisionPrepago[1]','nvarchar(50)') as comisionPrepago,
									Container.ContainerCol.value('comInvest[1]','nvarchar(50)') as comInvest,
									Container.ContainerCol.value('fechaEvaluacion[1]','date') as fechaEvaluacion
									from @xmlDataCREa.nodes('//DataCREa//EvalucionCREa')  AS Container(ContainerCol)

			--	     --fillers      
					       insert into [dbo].[tblFillers] (idPresto,Filler1,Filler2,Filler3,Filler4,Filler5,Filler6,Filler7,Filler8,Filler,Filler50)

						 select     @idPresto as idPresto,
									Container.ContainerCol.value('Filler1[1]','nvarchar(50)') as Filler1,
									Container.ContainerCol.value('Filler2[1]','nvarchar(50)') as Filler2,
									Container.ContainerCol.value('Filler3[1]','nvarchar(50)') as Filler3,
									Container.ContainerCol.value('Filler4[1]','nvarchar(50)') as Filler4,
									Container.ContainerCol.value('Filler5[1]','nvarchar(50)') as Filler5,
									Container.ContainerCol.value('Filler6[1]','nvarchar(50)') as Filler6,
									Container.ContainerCol.value('Filler7[1]','nvarchar(50)') as Filler7,
									Container.ContainerCol.value('Filler8[1]','nvarchar(50)') as Filler8,
									Container.ContainerCol.value('Filler[1]','nvarchar(50)') as Filler,
									Container.ContainerCol.value('Filler50[1]','nvarchar(50)') as Filler50
									from @xmlDataCREa.nodes('//DataCREa//FillersCREa')  AS Container(ContainerCol)

   --                  --fillersconAva
                         --insert into [dbo].[tblFillersConciliacionAvaluo] (idPresto,FillerConciliacionAvaluo1,FillerConciliacionAvaluo2,FillerConciliacionAvaluo,FillerConciliacionAvaluo10)

					     select     @idPresto as idPresto,
									Container.ContainerCol.value('FillerConciliacionAvaluo1[1]','nvarchar(10)') as FillerConciliacionAvaluo1,
									Container.ContainerCol.value('FillerConciliacionAvaluo2[1]','nvarchar(10)') as FillerConciliacionAvaluo2,
									Container.ContainerCol.value('FillerConciliacionAvaluo[1]','nvarchar(10)') as FillerConciliacionAvaluo,
									Container.ContainerCol.value('FillerConciliacionAvaluo10[1]','nvarchar(10)') as FillerConciliacionAvaluo10
									from @xmlDataCREa.nodes('//DataCREa//FillersConciliacionAvaluoCREa')  AS Container(ContainerCol)

			--		--fillerconJur
					    insert into [dbo].[tblFillersConciliacionJuridico] (idPresto,FillerConciliacionJuridico1,FillerConciliacionJuridico2,FillerConciliacionJuridico,FillerConciliacionJuridico10)

						 select     @idPresto as idPresto,
									Container.ContainerCol.value('FillerConciliacionJuridico1[1]','nvarchar(10)') as FillerConciliacionJuridico1,
									Container.ContainerCol.value('FillerConciliacionJuridico2[1]','nvarchar(10)') as FillerConciliacionJuridico2,
									Container.ContainerCol.value('FillerConciliacionJuridico[1]','nvarchar(10)') as FillerConciliacionJuridico,
									Container.ContainerCol.value('FillerConciliacionJuridico10[1]','nvarchar(10)') as FillerConciliacionJuridico10
							    	from @xmlDataCREa.nodes('//DataCREa//FillersConciliacionJuridicoCREa')  AS Container(ContainerCol)
					
			----InicioPrestoAvaluoJuridico
			               insert into [dbo].[tblInicioPrestoAvaluoJuridico] (idPresto,noCtaChequesClientes,opcionPrepago,importe,esCap,crCap,idTipoPagoCliente,idPagoVendedor,importePagoVendedor,idTipoPagoVendedor,noCuentaVendedor,nombreVendedor,rfcVendedor,direccionVendedor,coloniaVendedor,ciudadEstadoVendedor,cpVendedor,telCasaVendedor,telOficinaVendedor,reca)

					     select     @idPresto as idPresto,
									Container.ContainerCol.value('noCtaChequesClientes[1]','int') as noCtaChequesClientes,
									Container.ContainerCol.value('opcionPrepago[1]','int') as opcionPrepago,
									Container.ContainerCol.value('importe[1]','decimal(10, 2)') as importe,
									Container.ContainerCol.value('esCap[1]','int') as esCap,
									Container.ContainerCol.value('crCap[1]','nvarchar(30)') as crCap,
									Container.ContainerCol.value('idTipoPagoCliente[1]','int') as idTipoPagoCliente,
									Container.ContainerCol.value('idPagoVendedor[1]','int') as idPagoVendedor,
									Container.ContainerCol.value('importePagoVendedor[1]','nvarchar(30)') as importePagoVendedor,
									Container.ContainerCol.value('idTipoPagoVendedor[1]','nvarchar(30)') as idTipoPagoVendedor,
									Container.ContainerCol.value('noCuentaVendedor[1]','nvarchar(30)') as noCuentaVendedor,
									Container.ContainerCol.value('nombreVendedor[1]','nvarchar(200)') as nombreVendedor,
									Container.ContainerCol.value('rfcVendedor[1]','nchar(13)') as rfcVendedor,
									Container.ContainerCol.value('direccionVendedor[1]','nvarchar(200)') as direccionVendedor,
									Container.ContainerCol.value('coloniaVendedor[1]','nvarchar(150)') as coloniaVendedor,
									Container.ContainerCol.value('ciudadEstadoVendedor[1]','nvarchar(100)') as ciudadEstadoVendedor,
									Container.ContainerCol.value('cpVendedor[1]','int') as cpVendedor,
									Container.ContainerCol.value('telCasaVendedor[1]','nvarchar(30)') as telCasaVendedor,
									Container.ContainerCol.value('telOficinaVendedor[1]','nvarchar(30)') as telOficinaVendedor,
									Container.ContainerCol.value('reca[1]','nvarchar(50)') as reca
									from @xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa')  AS Container(ContainerCol)
		       
			--   --InicioPrestoFechaFirmas
			--       insert into [dbo].[tblInicioPrestoFechaFirmas] (idPresto,fechaFirma,horaFirma)
			--            select     @idPresto as idPresto,
			--			          convert(date, Container.ContainerCol.value('fechaFirma[1]','nvarchar(12)'),103) as fechaFirma,
   --                                Container.ContainerCol.value('horaFirma[1]','decimal(10, 2)') as horaFirma
			--					   from @xmlDataCREa.nodes('//DataCREa//InicioPrestoFechaFirmasCrea')  AS Container(ContainerCol)
		   
		 ----        --Avaluo
			--	  insert into [dbo].[tblAvaluo] (idPresto,valorAvaluoPrimerInmueble,numeroAvaluo,fechaAvaluoPrimerInmueble,valorAvaluoSegInmueble,numeroAvaluoSegundoInmu,fechaAvaluoSeguInmueble,valorAvaluoTercerInmueble,numeroAvaluoTercerInmu,fechaAvaluoTercInmueble,sumaValorAvaluos,montoPrimerMinistracion)

			--			 select     @idPresto as idPresto,
			--						Container.ContainerCol.value('valorAvaluoPrimerInmueble[1]','numeric(10, 2)') as valorAvaluoPrimerInmueble,
			--						Container.ContainerCol.value('numeroAvaluo[1]','nchar(10)') as numeroAvaluo,
			--						convert(date,Container.ContainerCol.value('fechaAvaluoPrimerInmueble[1]','nvarchar(10)'),103) as fechaAvaluoPrimerInmueble,
			--						Container.ContainerCol.value('valorAvaluoSegInmueble[1]','numeric(10, 2)') as valorAvaluoSegInmueble,
			--						Container.ContainerCol.value('numeroAvaluoSegundoInmu[1]','int') as numeroAvaluoSegundoInmu,
			--						convert(date,Container.ContainerCol.value('fechaAvaluoSeguInmueble[1]','nvarchar(10)'),103) as fechaAvaluoSeguInmueble,
			--						Container.ContainerCol.value('valorAvaluoTercerInmueble[1]','numeric(10, 2)') as valorAvaluoTercerInmueble,
			--						Container.ContainerCol.value('numeroAvaluoTercerInmu[1]','int') as numeroAvaluoTercerInmu,
			--						Convert(date,Container.ContainerCol.value('fechaAvaluoTercInmueble[1]','nvarchar(10)'),103) as fechaAvaluoTercInmueble,
			--						Container.ContainerCol.value('sumaValorAvaluos[1]','numeric(10, 2)') as sumaValorAvaluos,
			--						Container.ContainerCol.value('montoPrimerMinistracion[1]','numeric(10, 2)') as montoPrimerMinistracion
			--						from @xmlDataCREa.nodes('//DataCREa//AvaluoCREa')  AS Container(ContainerCol)

   ----                --Memorandum
   --                insert into [dbo].[tblMemorandum] (idPresto,claveNotaria,nombreNotario,razonSocial,numeroNotaria,entidad,notariaPadron,vigentePreventivo,numeroContrato,fechaPrimerPago,acreedor,plazaCredito,cartaInstruccionIrrevocable,gtsNotariales,cuentaAbonoGtsNotariales,honrsNotariales,cuentaAbonoHonrsNotariales,gravamen)

			--	         select     @idPresto as idPresto,
			--						Container.ContainerCol.value('claveNotaria[1]','nvarchar(10)') as claveNotaria,
			--						Container.ContainerCol.value('nombreNotario[1]','nvarchar(120)') as nombreNotario,
			--						Container.ContainerCol.value('razonSocial[1]','nvarchar(120)') as razonSocial,
			--						Container.ContainerCol.value('numeroNotaria[1]','nvarchar(120)') as numeroNotaria,
			--						Container.ContainerCol.value('entidad[1]','int') as entidad,
			--						Container.ContainerCol.value('notariaPadron[1]','int') as notariaPadron,
			--						convert(date,Container.ContainerCol.value('vigentePreventivo[1]','nvarchar(10)'),103) as vigentePreventivo,
			--						Container.ContainerCol.value('numeroContrato[1]','nvarchar(10)') as numeroContrato,
			--						convert(date,Container.ContainerCol.value('fechaPrimerPago[1]','nvarchar(10)'),103) as fechaPrimerPago,
			--						Container.ContainerCol.value('acreedor[1]','nvarchar(120)') as acreedor,
			--						Container.ContainerCol.value('plazaCredito[1]','nvarchar(30)') as plazaCredito,
			--						Container.ContainerCol.value('cartaInstruccionIrrevocable[1]','int') as cartaInstruccionIrrevocable,
			--						Container.ContainerCol.value('gtsNotariales[1]','numeric(12, 2)') as gtsNotariales,
			--						Container.ContainerCol.value('cuentaAbonoGtsNotariales[1]','int') as cuentaAbonoGtsNotariales,
			--						Container.ContainerCol.value('honrsNotariales[1]','numeric(10, 2)') as honrsNotariales,
			--						Container.ContainerCol.value('cuentaAbonoHonrsNotariales[1]','int') as cuentaAbonoHonrsNotariales,
			--						Container.ContainerCol.value('gravamen[1]','int') as gravamen
			--						from @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')  AS Container(ContainerCol)

   ----                  --ACOCApertura
   --                    insert into [dbo].[tblACOCApertura] (idPresto,noCredito,cr,importe,tipoCredito,ctaCheques,comApertura,idPeriodicidad,tasa,cat,modalidad,moneda,plazo,idGracia,formaPago,idTipoCargo,noCaso,fechaPrimerPago,opcionPrepago,idPagoIVA,gastosInvest,seguroDesempleo,baseCalculoSeguro,ValorVivienda,pzoPagaBcoSeguro,idBonificacion)

   --                      select     @idPresto as idPresto,
			--		                Container.ContainerCol.value('noCredito[1]','nvarchar(50)') as noCredito,
			--						Container.ContainerCol.value('cr[1]','nvarchar(50)') as cr,
			--						Container.ContainerCol.value('importe[1]','nvarchar(50)') as importe,
			--						Container.ContainerCol.value('tipoCredito[1]','nvarchar(50)') as tipoCredito,
			--						Container.ContainerCol.value('ctaCheques[1]','nvarchar(50)') as ctaCheques,
			--						Container.ContainerCol.value('comApertura[1]','nvarchar(50)') as comApertura,
			--						Container.ContainerCol.value('idPeriodicidad[1]','int') as idPeriodicidad,
			--						Container.ContainerCol.value('tasa[1]','nvarchar(50)') as tasa,
			--						Container.ContainerCol.value('cat[1]','nvarchar(50)') as cat,
			--						Container.ContainerCol.value('modalidad[1]','nvarchar(50)') as modalidad,
			--						Container.ContainerCol.value('moneda[1]','nvarchar(50)') as moneda,
			--						Container.ContainerCol.value('plazo[1]','nvarchar(50)') as plazo,
			--						Container.ContainerCol.value('idGracia[1]','int') as idGracia,
			--						Container.ContainerCol.value('formaPago[1]','nvarchar(50)') as formaPago,
			--						Container.ContainerCol.value('idTipoCargo[1]','int') as idTipoCargo,
			--						Container.ContainerCol.value('noCaso[1]','nvarchar(50)') as noCaso,
			--						Container.ContainerCol.value('fechaPrimerPago[1]','nvarchar(50)') as fechaPrimerPago,
			--						Container.ContainerCol.value('opcionPrepago[1]','nvarchar(50)') as opcionPrepago,
			--						Container.ContainerCol.value('idPagoIVA[1]','int') as idPagoIVA,
			--						Container.ContainerCol.value('gastosInvest[1]','nvarchar(50)') as gastosInvest,
			--						Container.ContainerCol.value('seguroDesempleo[1]','nvarchar(50)') as seguroDesempleo,
			--						Container.ContainerCol.value('baseCalculoSeguro[1]','nchar(13)') as baseCalculoSeguro,
			--						Container.ContainerCol.value('ValorVivienda[1]','nvarchar(50)') as ValorVivienda,
			--						Container.ContainerCol.value('pzoPagaBcoSeguro[1]','int') as pzoPagaBcoSeguro,
			--						Container.ContainerCol.value('idBonificacion[1]','int') as idBonificacion
			--						from @xmlDataCREa.nodes('//DataCREa//ACOCAperturaCREa')  AS Container(ContainerCol)

			----	   --ACOCDisposicion
			--                    insert into [dbo].[tblACOCDisposicion] (idPresto,noCredito,fechaDisposicion,importe,montoDisposicion,comisionMinistracion,idComision,gastosinvest,idFormaPago,fechaFirma,montoChequeCaja,cuentaConcentradora,fechaVigencia,nombreVendedor,nombreNotario,noCtaChequesAcred,idPagoVendedor,idTipoPagoVendedor,ctaChequesVendedor,importePagoVendedor,importeGastosNotario,cuentaHonorariosNotario,noCuenta,tipoCaso,crSucursal,tipoCredito,modalidad,nombreCliente,numeroCredito,noAcreditado)

			--              select    @idPresto as idPresto,
			--	                    Container.ContainerCol.value('noCredito[1]','nvarchar(50)') as noCredito,
			--						Container.ContainerCol.value('fechaDisposicion[1]','date') as fechaDisposicion,
			--						Container.ContainerCol.value('importe[1]','nvarchar(50)') as importe,
			--						Container.ContainerCol.value('montoDisposicion[1]','nvarchar(50)') as montoDisposicion,
			--						Container.ContainerCol.value('comisionMinistracion[1]','nvarchar(50)') as comisionMinistracion,
			--						Container.ContainerCol.value('idComision[1]','int') as idComision,
			--						Container.ContainerCol.value('gastosinvest[1]','nvarchar(50)') as gastosinvest,
			--						Container.ContainerCol.value('idFormaPago[1]','nvarchar(50)') as idFormaPago,
			--						Container.ContainerCol.value('fechaFirma[1]','nvarchar(50)') as fechaFirma,
			--						Container.ContainerCol.value('montoChequeCaja[1]','nvarchar(50)') as montoChequeCaja,
			--						Container.ContainerCol.value('cuentaConcentradora[1]','nvarchar(50)') as cuentaConcentradora,
			--						Container.ContainerCol.value('fechaVigencia[1]','nvarchar(50)') as fechaVigencia,
			--						Container.ContainerCol.value('nombreVendedor[1]','nvarchar(50)') as nombreVendedor,
			--						Container.ContainerCol.value('nombreNotario[1]','nvarchar(50)') as nombreNotario,
			--						Container.ContainerCol.value('noCtaChequesAcred[1]','nvarchar(50)') as noCtaChequesAcred,
			--						Container.ContainerCol.value('idPagoVendedor[1]','int') as idPagoVendedor,
			--						Container.ContainerCol.value('idTipoPagoVendedor[1]','nvarchar(30)') as idTipoPagoVendedor,
			--						Container.ContainerCol.value('ctaChequesVendedor[1]','nvarchar(30)') as ctaChequesVendedor,
			--						Container.ContainerCol.value('importePagoVendedor[1]','nvarchar(50)') as importePagoVendedor,
			--						Container.ContainerCol.value('importeGastosNotario[1]','nvarchar(50)') as importeGastosNotario,
			--						Container.ContainerCol.value('cuentaHonorariosNotario[1]','nvarchar(50)') as cuentaHonorariosNotario,
			--						Container.ContainerCol.value('noCuenta[1]','nvarchar(50)') as noCuenta,
			--						Container.ContainerCol.value('tipoCaso[1]','nvarchar(50)') as tipoCaso,
			--						Container.ContainerCol.value('crSucursal[1]','nvarchar(50)') as crSucursal,
			--						Container.ContainerCol.value('tipoCredito[1]','nvarchar(50)') as tipoCredito,
			--						Container.ContainerCol.value('modalidad[1]','nvarchar(50)') as modalidad,
			--						Container.ContainerCol.value('nombreCliente[1]','nvarchar(50)') as nombreCliente,
			--						Container.ContainerCol.value('numeroCredito[1]','nvarchar(50)') as numeroCredito,
			--						Container.ContainerCol.value('noAcreditado[1]','nvarchar(50)') as noAcreditado
			--						from @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa')  AS Container(ContainerCol)
			
			----     --presto           
			--	     insert into [dbo].[tblPresto] (idPresto,plazaAsignacion,sucursalAsignacion,idUsuarioPresto,nombreUsuarioPresto)
			--			 select     @idPresto as idPresto,
			--						Container.ContainerCol.value('plazaAsignacion[1]','nvarchar(50)') as plazaAsignacion,
			--						Container.ContainerCol.value('sucursalAsignacion[1]','nvarchar(50)') as sucursalAsignacion,
			--						Container.ContainerCol.value('idUsuarioPresto[1]','nvarchar(50)') as idUsuarioPresto,
			--						Container.ContainerCol.value('nombreUsuarioPresto[1]','nvarchar(50)') as nombreUsuarioPresto
			--						from @xmlDataCREa.nodes('//DataCREa//PrestoCREa')  AS Container(ContainerCol)
									
		 ----        --SLApresto      
		 --        insert into [dbo].[tblSLAPresto] (idPresto,idPasoPresto,nombrePasoPresto,tiempoEjecucion)
			--	         select     @idPresto as idPresto,
			--						Container.ContainerCol.value('idPasoPresto[1]','nvarchar(50)') as idPasoPresto,
			--						Container.ContainerCol.value('nombrePasoPresto[1]','nvarchar(50)') as nombrePasoPresto,
			--						Container.ContainerCol.value('tiempoEjecucion[1]','nvarchar(50)') as tiempoEjecucion
			--						from @xmlDataCREa.nodes('//DataCREa//PrestoCREa')  AS Container(ContainerCol)
		   
		  

		   end
		   
	     
	  end
commit
	end try
	begin catch
		if(@@trancount > 0)      
			begin    
				rollback  transaction
				INSERT INTO tblError SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity,
							ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine,
							ERROR_MESSAGE() AS ErrorMessage, GETDATE() AS Fecha_Error, 0 AS USUARIO;
		
				DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
				SELECT @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			end
	end catch

END
