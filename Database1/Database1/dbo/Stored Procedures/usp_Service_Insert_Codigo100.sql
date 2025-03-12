-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 08-12-2017
-- Description:	Insertar información de servicio 100 - Ingreso
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Codigo100]
	
	  @FolioBanco	nvarchar(25)
	, @IdXml		bigint
	, @XmlData		xml
	, @XMLDatos		xml

AS
BEGIN
	set nocount on;

	begin try
	begin transaction

			Declare @segmentoTitular varchar(500)
			Declare @segmentoCoacreditado varchar(500)
			Declare @segmentoGarante varchar(500)
			Declare @segmentoFiador varchar(500)

			Declare @codigoMensaje varchar(10)
			Declare @tieneDispersion varchar(10)

			Declare @banderaCoefEndeudamiento varchar(5)
			Declare @deudaPagar decimal(18, 2)
			Declare @deudaSinHipoteca decimal(18, 2)


			Select 
				@segmentoTitular = DatosPersonales.value('segmento[1]', 'varchar(500)') 
			from @XmlDatos.nodes('//Datos/DatosPersonales/DatosPersonalesEntity') N1 (DatosPersonales)
			where DatosPersonales.value('tipoParticipante[1]', 'varchar(100)') in ('TITULAR')

			Select 
				@segmentoCoacreditado = DatosPersonales.value('segmento[1]', 'varchar(500)') 
			from @XmlDatos.nodes('//Datos/DatosPersonales/DatosPersonalesEntity') N1 (DatosPersonales)
			where DatosPersonales.value('tipoParticipante[1]', 'varchar(100)') in ('COACREDITADO')

			Select 
				@segmentoGarante = DatosPersonales.value('segmento[1]', 'varchar(500)') 
			from @XmlDatos.nodes('//Datos/DatosPersonales/DatosPersonalesEntity') N1 (DatosPersonales)
			where DatosPersonales.value('tipoParticipante[1]', 'varchar(100)') in ('GARANTE HIPOTECARIO')

			Select 
				@segmentoFiador = DatosPersonales.value('segmento[1]', 'varchar(500)') 
			from @XmlDatos.nodes('//Datos/DatosPersonales/DatosPersonalesEntity') N1 (DatosPersonales)
			where DatosPersonales.value('tipoParticipante[1]', 'varchar(100)') in ('FIADOR SOLIDARIO')

			Select 
				@codigoMensaje = Evaluacion.value('codigoMensaje[1]', 'varchar(10)') 
			from @XmlDatos.nodes('//Datos/Evaluacion') N1 (Evaluacion)

			Select
				 @tieneDispersion = PrestoAvaluoJuridico.value('tieneDispersion[1]', 'varchar(10)') 
			from @XmlDatos.nodes('//Datos/PrestoAvaluoJuridico') N1 (PrestoAvaluoJuridico)

			Select
				 @banderaCoefEndeudamiento = DatosEvaluacion.value('banderaCoefEndeudamiento[1]', 'varchar(5)') 
			from @XmlDatos.nodes('//Datos/Evaluacion') N1 (DatosEvaluacion)

			Select
				 @deudaPagar = DatosEvaluacion.value('deudaPagar[1]', 'decimal(18, 2)') 
			from @XmlDatos.nodes('//Datos/Evaluacion') N1 (DatosEvaluacion)

			Select
				 @deudaSinHipoteca = DatosEvaluacion.value('deudaSinHipoteca[1]', 'decimal(18, 2)') 
			from @XmlDatos.nodes('//Datos/Evaluacion') N1 (DatosEvaluacion)

			declare @idExpediente bigint

			-- TITULAR
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_DatosGenerales] 
					(folioBanco, nombre, rfc, curp, nss, fechaNacimiento, idNacionalidad, idEstadoCivil, numeroCuenta, telefonoCasa, 
					 telefonoOficina, telefonoCelular, correoElectronico, empleadoBanco, idDomiciliacion, domiciliacionCuentaClabe, 
					 idBanco, sexo, activo, idUsuarioAlta, fechaAlta, ActividadSectorial, Segmento, CodigoMensaje, TieneDispersion)
				Select 
					  [FolioBanco] = Header.value('noCaso[1]', 'nvarchar(20)')
					, [Nombre] = DatosPersonales.value('nombreParticipante[1]', 'nvarchar(500)')
					, [Rfc] = DatosPersonales.value('rfcParticipante[1]', 'nvarchar(13)') --iif(DatosPersonales.value('idAfiliacion[1]', 'int') in (1), DatosPersonales.value('afiliacion[1]', 'nvarchar(13)'), null)
					, [Curp] = iif(DatosPersonales.value('idAfiliacion[1]', 'int') in (2), DatosPersonales.value('afiliacion[1]', 'nvarchar(18)'), null)
					, [Nss] = iif(DatosPersonales.value('idAfiliacion[1]', 'int') in (3, 4), DatosPersonales.value('afiliacion[1]', 'nvarchar(11)'), null)
					, [FechaNacimiento] = DatosPersonales.value('fechaNacimiento[1]', 'nvarchar(10)')
					, [IdNacionalidad] = B.Id
					, [IdEstadoCivil] = DatosPersonales.value('estadoCivil[1]', 'int')
					, [NumeroCuenta] = InicioPrestoAvaluoJuridico.value('noCtaChequesClientes[1]', 'nvarchar(16)')
					, [TelCasa] = DatosDomicilio.value('telefono[1]/Telefono[1]/telefono[1]', 'nvarchar(20)')
					, [TelOficina] = DatosDomicilio.value('telefono[1]/Telefono[2]/telefono[1]', 'nvarchar(20)')
					, [TelCelular] = DatosDomicilio.value('telefono[1]/Telefono[3]/telefono[1]', 'nvarchar(20)')
					, [CorreoElectronico] = DatosDomicilio.value('mail[1]', 'nvarchar(100)')
					, [EmpleadoBanco] = cast(0 as bit)
					, [IdDomiciliacion] = InicioPrestoAvaluoJuridico.value('idDomiciliacion[1]', 'int')
					, [DomiciliacionCuentaClabe] = InicioPrestoAvaluoJuridico.value('domiciliacionCuentaCLABE[1]', 'nvarchar(50)')
					, [IdBanco] = InicioPrestoAvaluoJuridico.value('idBanco[1]', 'int')
					, [Sexo] = iif(DatosPersonales.value('sexo[1]', 'nvarchar(1)') in ('F'), 1, 0)
					, [Activo] = cast(1 as bit)
					, [IdUsuarioAlta] = 16
					, [FechaAlta] = current_timestamp
					, [ActividadSectorial] = iif(DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)') is not null, DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)'), null)
					, [Segmento] = @segmentoTitular
					, [CodigoMensaje] = @codigoMensaje
					, [TieneDispersion] = @tieneDispersion
				from @XmlData.nodes('//DataCREa/HeaderCREa') N1(Header)
					cross apply @XmlData.nodes('//DataCREa/DatosPersonalesCREa/DatosPersonales') N2(DatosPersonales)
					cross apply @XmlData.nodes('//DataCREa/InicioPrestoAvaluoJuridicoCREa') N3(InicioPrestoAvaluoJuridico)
					cross apply @XmlData.nodes('//DataCREa/DatosDomicilioCREa/DatosDomicilio') N4(DatosDomicilio) 
					cross apply @XmlData.nodes('//DataCREa/DatosLaboralesCREa/DatosLaborales') N5(DatosLaborales) 
					left join [dbPrestoCibergestionBanorte].[dbo].[CatNacionalidad] B on B.idBanco = DatosPersonales.value('codNacionalidad[1]', 'nvarchar(3)')
				where 
					DatosPersonales.value('tipoParticipante[1]', 'nvarchar(30)') in ('TITULAR') 
					and DatosDomicilio.value('tipoParticipante[1]', 'nvarchar(30)') in ('TITULAR')
					and DatosLaborales.value('tipoParticipante[1]', 'nvarchar(30)') in ('TITULAR')
			
			-- *** Folio PRESTO ***
			set @idExpediente = cast(scope_identity() as bigint)
			-- ********************
			
			-- CONYUGE
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_ParticipantesConyuge] (IdExpediente, conyuge_Nombre, conyuge_Rfc, conyuge_Nss, idUsuarioAlta, fechaAlta)
				Select
					  [FolioPresto] = @idExpediente
					, [Nombre] = Conyuge.value('conyuge[1]', 'nvarchar(180)')
					, [Rfc] = Conyuge.value('rfcConyuge[1]', 'nvarchar(13)')
					, [Nss] = Conyuge.value('nssc[1]', 'nvarchar(11)')
					, [IdUsuarioAlta] = 16
					, [FechaAlta] = current_timestamp
				from @XmlData.nodes('//DataCREa/DatosPersonalesCREa/DatosPersonales') N1(Conyuge)
				where Conyuge.value('tipoParticipante[1]', 'nvarchar(30)') in ('TITULAR') 

			-- COACREDITADO
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_ParticipantesCoacreditado] (IdExpediente, coacreditado_nombre, coacreditado_rfc, coacreditado_curp, coacreditado_nss,
						coacreditado_fechaNacimiento, coacreditado_IdSexo, coacreditado_idNacionalidad, coacreditado_IdEdoCivil, coacreditado_telefonoCasa, coacreditado_telefonoOficina, 
						coacreditado_telefonoCelular, coacreditado_correo, idUsuarioAlta, fechaAlta, activo, ActividadSectorial, segmento)
				Select
					  [IdExpediente] = @idExpediente
					, [Nombre] = Coacreditado.value('nombreParticipante[1]', 'nvarchar(180)')
					, [Rfc] = Coacreditado.value('rfcParticipante[1]', 'nvarchar(13)') --iif(Coacreditado.value('idAfiliacion[1]', 'int') in (1), Coacreditado.value('afiliacion[1]', 'nvarchar(13)'), null)
					, [Curp] = iif(Coacreditado.value('idAfiliacion[1]', 'int') in (2), Coacreditado.value('afiliacion[1]', 'nvarchar(18)'), null)
					, [Nss] = iif(Coacreditado.value('idAfiliacion[1]', 'int') in (3, 4), Coacreditado.value('afiliacion[1]', 'nvarchar(11)'), null)
					, [FechaNacimiento] = Coacreditado.value('fechaNacimiento[1]', 'nvarchar(10)')
					, [IdSexo] = iif(Coacreditado.value('sexo[1]', 'nvarchar(1)') in ('F'), 1, 0)
					, [IdNacionalidad] = B.Id
					, [IdEstadoCivil] = Coacreditado.value('estadoCivil[1]', 'int')
					, [TelCasa] = DatosDomicilio.value('telefono[1]/Telefono[1]/telefono[1]', 'nvarchar(20)')
					, [TelOficina] = DatosDomicilio.value('telefono[1]/Telefono[2]/telefono[1]', 'nvarchar(20)')
					, [TelCelular] = DatosDomicilio.value('telefono[1]/Telefono[3]/telefono[1]', 'nvarchar(20)')
					, [CorreoElectronico] = DatosDomicilio.value('mail[1]', 'nvarchar(100)')
					, [IdUsuarioAlta] = 16
					, [FechaAltaAlta] = current_timestamp
					, [Activo] = cast(1 as bit)
					, [ActividadSectorial] = iif(DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)') is not null, DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)'), null)
					, [Segmento] = @segmentoCoacreditado
				from @XmlData.nodes('//DataCREa/DatosPersonalesCREa/DatosPersonales') N1(Coacreditado)
					left join [dbPrestoCibergestionBanorte].[dbo].[CatNacionalidad] B on B.idBanco = Coacreditado.value('codNacionalidad[1]', 'nvarchar(3)')
					cross apply @XmlData.nodes('//DataCREa/DatosDomicilioCREa/DatosDomicilio') N2(DatosDomicilio) 
					cross apply @XmlData.nodes('//DataCREa/DatosLaboralesCREa/DatosLaborales') N3(DatosLaborales) 
				where 
					Coacreditado.value('tipoParticipante[1]', 'nvarchar(30)') in ('COACREDITADO') 
					and DatosDomicilio.value('tipoParticipante[1]', 'nvarchar(30)') in ('COACREDITADO')
					and DatosLaborales.value('tipoParticipante[1]', 'nvarchar(30)') in ('COACREDITADO')

			-- GARANTE HIPOTECARIO
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_ParticipantesGarante] (IdExpediente, garante_Nombre, garante_Rfc, garante_Curp, garante_Nss,
						garante_FechaNacimiento, garante_idSexo, garante_idNacionalidad, garante_idEdoCivil, garante_telefonoCasa, garante_telefonoOficina, 
						garante_telefonoCelular, garante_correo, idUsuarioAlta, fechaAlta, activo, ActividadSectorial, segmento)
				Select
					  [IdExpediente] = @idExpediente
					, [Nombre] = Garante.value('nombreParticipante[1]', 'nvarchar(180)')
					, [Rfc] = Garante.value('rfcParticipante[1]', 'nvarchar(13)') -- iif(Garante.value('idAfiliacion[1]', 'int') in (1), Garante.value('afiliacion[1]', 'nvarchar(13)'), null)
					, [Curp] = iif(Garante.value('idAfiliacion[1]', 'int') in (2), Garante.value('afiliacion[1]', 'nvarchar(18)'), null)
					, [Nss] = iif(Garante.value('idAfiliacion[1]', 'int') in (3, 4), Garante.value('afiliacion[1]', 'nvarchar(11)'), null)
					, [FechaNacimiento] = Garante.value('fechaNacimiento[1]', 'nvarchar(10)')
					, [IdSexo] = iif(Garante.value('sexo[1]', 'nvarchar(1)') in ('F'), 1, 0)
					, [IdNacionalidad] = B.Id
					, [IdEstadoCivil] = Garante.value('estadoCivil[1]', 'int')
					, [TelCasa] = DatosDomicilio.value('telefono[1]/Telefono[1]/telefono[1]', 'nvarchar(20)')
					, [TelOficina] = DatosDomicilio.value('telefono[1]/Telefono[2]/telefono[1]', 'nvarchar(20)')
					, [TelCelular] = DatosDomicilio.value('telefono[1]/Telefono[3]/telefono[1]', 'nvarchar(20)')
					, [CorreoElectronico] = DatosDomicilio.value('mail[1]', 'nvarchar(100)')
					, [IdUsuarioAlta] = 16
					, [FechaAltaAlta] = current_timestamp
					, [Activo] = cast(1 as bit)
					, [ActividadSectorial] = iif(DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)') is not null, DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)'), null)
					, [Segmento] = @segmentoGarante
				from @XmlData.nodes('//DataCREa/DatosPersonalesCREa/DatosPersonales') N1(Garante)
					left join [dbPrestoCibergestionBanorte].[dbo].[CatNacionalidad] B on B.idBanco = Garante.value('codNacionalidad[1]', 'nvarchar(3)')
					cross apply @XmlData.nodes('//DataCREa/DatosDomicilioCREa/DatosDomicilio') N2(DatosDomicilio) 
					cross apply @XmlData.nodes('//DataCREa/DatosLaboralesCREa/DatosLaborales') N3(DatosLaborales) 
				where 
					Garante.value('tipoParticipante[1]', 'nvarchar(30)') in ('GARANTE HIPOTECARIO') 
					and DatosDomicilio.value('tipoParticipante[1]', 'nvarchar(30)') in ('GARANTE HIPOTECARIO')
					and DatosLaborales.value('tipoParticipante[1]', 'nvarchar(30)') in ('GARANTE HIPOTECARIO')

			-- FIADOR SOLIDARIO
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_ParticipantesSolidario] (IdExpediente, solidario_Nombre, solidario_Rfc, solidario_Curp, solidario_Nss,
						solidario_FechaNacimiento, solidario_idSexo, solidario_idNacionalidad, solidario_idEdoCivil, solidario_telefonoCasa, solidario_telefonoOficina, 
						solidario_telefonoCelular, solidario_correo, idUsuarioAlta, fechaAlta, activo, ActividadSectorial, Segmento)
				Select
					  [IdExpediente] = @idExpediente
					, [Nombre] = FiadorSolidario.value('nombreParticipante[1]', 'nvarchar(180)')
					, [Rfc] = FiadorSolidario.value('rfcParticipante[1]', 'nvarchar(13)') -- iif(FiadorSolidario.value('idAfiliacion[1]', 'int') in (1), FiadorSolidario.value('afiliacion[1]', 'nvarchar(13)'), null)
					, [Curp] = iif(FiadorSolidario.value('idAfiliacion[1]', 'int') in (2), FiadorSolidario.value('afiliacion[1]', 'nvarchar(18)'), null)
					, [Nss] = iif(FiadorSolidario.value('idAfiliacion[1]', 'int') in (3, 4), FiadorSolidario.value('afiliacion[1]', 'nvarchar(11)'), null)
					, [FechaNacimiento] = FiadorSolidario.value('fechaNacimiento[1]', 'nvarchar(10)')
					, [IdSexo] = iif(FiadorSolidario.value('sexo[1]', 'nvarchar(1)') in ('F'), 1, 0)
					, [IdNacionalidad] = B.Id
					, [IdEstadoCivil] = FiadorSolidario.value('estadoCivil[1]', 'int')
					, [TelCasa] = DatosDomicilio.value('telefono[1]/Telefono[1]/telefono[1]', 'nvarchar(20)')
					, [TelOficina] = DatosDomicilio.value('telefono[1]/Telefono[2]/telefono[1]', 'nvarchar(20)')
					, [TelCelular] = DatosDomicilio.value('telefono[1]/Telefono[3]/telefono[1]', 'nvarchar(20)')
					, [CorreoElectronico] = DatosDomicilio.value('mail[1]', 'nvarchar(100)')	
					, [IdUsuarioAlta] = 16
					, [FechaAltaAlta] = current_timestamp
					, [Activo] = cast(1 as bit)
					, [ActividadSectorial] = iif(DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)') is not null, DatosLaborales.value('(actividadSectorial/text())[1]', 'nvarchar(600)'), null)
					, [Segmento] = @segmentoFiador
				from @XmlData.nodes('//DataCREa/DatosPersonalesCREa/DatosPersonales') N1(FiadorSolidario)
					left join [dbPrestoCibergestionBanorte].[dbo].[CatNacionalidad] B on B.idBanco = FiadorSolidario.value('codNacionalidad[1]', 'nvarchar(3)')
					cross apply @XmlData.nodes('//DataCREa/DatosDomicilioCREa/DatosDomicilio') N2(DatosDomicilio) 
					cross apply @XmlData.nodes('//DataCREa/DatosLaboralesCREa/DatosLaborales') N3(DatosLaborales) 
				where 
					FiadorSolidario.value('tipoParticipante[1]', 'nvarchar(30)') in ('FIADOR SOLIDARIO') 
					and DatosDomicilio.value('tipoParticipante[1]', 'nvarchar(30)') in ('FIADOR SOLIDARIO')
					and DatosLaborales.value('tipoParticipante[1]', 'nvarchar(30)') in ('FIADOR SOLIDARIO')

			-- Datos crédito
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_DatosCredito] (idExpediente, montoSolicitado, tasaInteres, idPlazo, idTipoComision, idProducto,
																	idSubProducto, idEsquema, comisionApertura, comisionAdmin, factorPago, TasaTope, FactorDesempleo, comisionFinanciada,
																	idCoberturaSeguro, opcionPrepago, FechaConsultaBuro, MargenTolerancia, comisionInvestigacion, Reca,
																	idDestinoCreditoAnt, IdOrigenCreditoAnterior, IdAplicaExtraPrima, FactorExtraPrima, BanderaCoefEndeudamiento,
																	DeudaPagar, DeudaSinHipoteca, activo, idUsuarioAlta, fechaAlta)
				Select
				  [IdExpediente] = @idExpediente
				, [MontoSolicitado] = EvalucionCREa.value('importe[1]', 'decimal(18,2)')
				, [TasaInteres] = EvalucionCREa.value('tasaAplicable[1]', 'decimal(18,2)')
				, [IdPlazo] = B.Id
				, [IdComision] = C.Id
				, [IdProducto] = D.idProducto
				, [IdSubProducto] = E.idSubProducto
				, [Esquema] = F.idEsquema
				, [ComisionApertura] = DatosOperacion.value('comisionApertura[1]', 'decimal(18,2)')
				, [ComisionAdmin] = iif(DatosOperacion.value('comisionAdmin[1]','varchar(15)') = 'N/A', 0, DatosOperacion.value('comisionAdmin[1]','decimal(18,2)'))
				, [FactorPago] = cast(0 as decimal(18, 2))
				, [TasaTope] = FillerJuridico.value('FillerConciliacionJuridico1[1]', 'decimal(18,2)')
				, [FactorDesempleo] = FillerJuridico.value('FillerConciliacionJuridico2[1]', 'decimal(18,2)') -- Factor descuento
				, [ComisionFinanciada] = cast(1 as bit)
				, [IdCoberturaSeguro] = iif(DatosOperacion.value('seguroGen[1]', 'varchar(2)') in ('NO', '2'), 2, 1)
				, [OpcionPrepago] = InicioPrestoAvaluoJuridico.value('opcionPrepago[1]', 'int')
				, [FechaConsultaBuro] = Fillers.value('Filler1[1]', 'nvarchar(10)')
				, [MargenTolerancia] = Fillers.value('Filler3[1]', 'decimal(18, 2)')
				, [ComisionInvestigacion] = DatosOperacion.value('comInvest[1]', 'decimal(18, 2)')
				, [Reca] = InicioPrestoAvaluoJuridico.value('reca[1]', 'nvarchar(50)')
				, [IdDestinoCreditoAnt] = InicioPrestoAvaluoJuridico.value('idDestinoCreditoAnt[1]', 'int')
				, [IdOrigenCreditoAnterior] = InicioPrestoAvaluoJuridico.value('idOrigenCreditoAnterior[1]', 'int')
				, [IdAplicaExtraPrima] = InicioPrestoAvaluoJuridico.value('idAplicaExtraPrima[1]', 'int')
				, [FactorExtraPrima] = InicioPrestoAvaluoJuridico.value('factorExtraPrima[1]', 'decimal(18,2)')
				, [BanderaCoefEndeudamiento] = @banderaCoefEndeudamiento
				, [DeudaPagar] = @deudaPagar
				, [DeudaSinHipoteca] = @deudaSinHipoteca
				, [Activo] = cast(1 as bit)
				, [IdUsuarioAlta] = 16
				, [FechaAlta] = current_timestamp
			from @XmlData.nodes('//DataCREa/EvaluacionCREa') N1(EvalucionCREa)
				cross apply @XmlData.nodes('//DataCREa/DatosOperacionCREa') N2(DatosOperacion)
				cross apply @XmlData.nodes('//DataCREa/FillersConciliacionJuridicoCREa') N3(FillerJuridico)
				cross apply @XmlData.nodes('//DataCREa/FillersCREa') N4(Fillers)
				cross apply @XmlData.nodes('//DataCREa/InicioPrestoAvaluoJuridicoCREa') N5(InicioPrestoAvaluoJuridico)
				left join [dbPrestoCibergestionBanorte].[dbo].[catPlazos] B on B.ID_Plazo = EvalucionCREa.value('plazo[1]', 'nvarchar(3)')
				left join [dbPrestoCibergestionBanorte].[dbo].[CatTipoComision] C on upper(rtrim(C.descripcion)) = EvalucionCREa.value('tipoComision[1]', 'varchar(15)')
				left join [dbPrestoCibergestionBanorte].[dbo].[CatProducto] D on D.dest_id = DatosOperacion.value('idDestinoCredito[1]', 'int')
				left join [dbPrestoCibergestionBanorte].[dbo].[CatSubProducto] E on E.dest_id = DatosOperacion.value('idSubproducto[1]', 'int')
				left join [dbPrestoCibergestionBanorte].[dbo].[CatEsquema] F on F.dest_id = DatosOperacion.value('idProgramaConvenio[1]', 'int') and F.flag=1

			-- Datos Ventas
			Declare @territorial int = 0

			set @territorial = (Select top 1
									B.idTerritorio
								from @XmlData.nodes('//DataCREa/EjecutivosCREa/CREaEjecutivos') N1(Ejecutivos)
									inner join [dbPrestoCibergestionBanorte].[dbo].[catTerritorio] B on B.descripcionTerritorio = Ejecutivos.value('territorial[1]','nvarchar(50)') )

			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_DatosVentas] (idExpediente, idEjecutivoVentas, claveEjecutivo, idCanal, correoElectronicoDV, idSucursal,
																					idTerritorio, idIsReferenciaBroker, idBroker, idFranquiciaBroker, idAsesorBroker, fuerzaGanadora,
																					activo, idUsuarioAlta, fechaAlta)
				Select top 1
					  [IdExpediente] = @idExpediente
					, [IdEjecutivoVentas] = EvalucionCREa.value('nombreEjecutivo[1]', 'varchar(400)')
					, [ClaveEjecutivo] = EvalucionCREa.value('claveEjecutivo[1]', 'varchar(8)')

					, [IdCanal] = iif(DatosOperacion.value('(folio/text())[1]', 'varchar(50)') is not null and len(isNull(DatosLaborales.value('(folio/text())[1]', 'varchar(50)'), '')) >= 10, 
									8, 
									-- ELSE 
									iif(DatosOperacion.value('idIsReferenciaBroker[1]', 'int') not in (0), 
												2, 
												-- ELSE
												iif(InicioPrestoAvaluoJuridico.value('esCap[1]', 'int') not in (1), 
													1, 
													-- ELSE
													3)
										 )
								 )
					, [CorreoElectronicoDV] = EvalucionCREa.value('email[1]', 'varchar(50)')
					, [IdSucursal] = EvalucionCREa.value('sucursal[1]', 'varchar(400)')
					, [IdTerritorio] = isNull(@territorial, 0)
					
					, [IdIsReferenciaBroker] = DatosOperacion.value('idIsReferenciaBroker[1]','bit')
					, [IdBroker] = iif(DatosOperacion.value('idIsReferenciaBroker[1]','int') in (1), DatosOperacion.value('idUsuarioBroker[1]','int'), 0)
					, [IdFranquiciaBroker] = iif(DatosOperacion.value('idIsReferenciaBroker[1]','int') in (1), DatosOperacion.value('idFranquiciaBroker[1]','int'), 0)
					, [IdAsesorBroker] = iif(DatosOperacion.value('idIsReferenciaBroker[1]','int') in (1), DatosOperacion.value('idAsesorBroker[1]','int'), 0)
					, [FuerzaGanadora] = iif(DatosOperacion.value('idIsReferenciaBroker[1]','int') in (0), DatosOperacion.value('fuerzaGanadora[1]','nvarchar(30)'), '')

					, [Activo] = cast(1 as bit)
					, [IdUsuarioAlta] = 16
					, [FechaAlta] = convert(varchar(10), current_timestamp, 20)
				from @XmlData.nodes('//DataCREa/EjecutivosCREa/CREaEjecutivos') N1(EvalucionCREa)
					cross apply @XmlData.nodes('//DataCREa/DatosOperacionCREa') N2(DatosOperacion)
					cross apply @XmlData.nodes('//DataCREa/InicioPrestoAvaluoJuridicoCREa') N3(InicioPrestoAvaluoJuridico)
					cross apply @XmlData.nodes('//DataCREa/DatosLaboralesCREa/DatosLaborales') N4(DatosLaborales) 

			-- ValidaExpediente_Asignacion
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_ValidaExpediente_Asignacion] (IdExpediente, idUsuarioAlta, fechaAlta, activo)
				Select
					  [IdExpediente] = @idExpediente
					, [IdUsuarioAlta] = 16
					, [FechaAlta] = current_timestamp
					, [Activo] = cast(1 as bit)
				from @XmlData.nodes('//DataCREa/DatosOperacionCREa') N1(DatosOperacion)

			-- Inmueble
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_DatosInmueble] (IdExpediente, calleInmueble, numeroExterior, numeroInterior, codigoPostal,
																							ciudad, idEstado, NoGarantia, IdTieneGravamen, idUsuarioAlta, fechaAlta, activo)
				Select
					  [IdExpediente] = @idExpediente
					, [CalleInmueble] = Garantias.value('calleNum[1]', 'nvarchar(100)')
					, [NumeroExterior] = Garantias.value('lote[1]', 'nvarchar(50)')
					, [NumeroInterior] = Garantias.value('manzana[1]', 'nvarchar(50)')
					, [CodigoPostal] = right('00000' + isnull(Garantias.value('codigoPostal[1]', 'nvarchar(5)'), ''), 5)
					, [Ciudad] = Garantias.value('ciudad[1]', 'nvarchar(200)')
					, [IdEstado] = B.idEstado
					, [NoGarantia] = Garantias.value('noGarantia[1]', 'int')
					, [IdTieneGravamen] = iif(Garantias.value('idTieneGravamen[1]', 'int') in (1), cast(1 as bit), cast(0 as bit))
					, [IdUsuarioAlta] = 16
					, [FechaAlta] = current_timestamp
					, [Activo] = cast(1 as bit)
				from @XmlData.nodes('//DataCREa/GarantiasCREa/Garantias') N1(Garantias)
					left join [dbPrestoCibergestionBanorte].[dbo].[catEstadosRepublica] B on B.idBanco = Garantias.value('estado[1]', 'nvarchar(4)')
				where Garantias.value('noGarantia[1]', 'int') in (1)

			-- Gravamen
			Declare @idBancoAcreedor int = null

			Select 
				@idBancoAcreedor = Evaluacion.value('(idBancoAcreedor/text())[1]', 'int')
			from @XmlData.nodes('//DataCREa/InicioPrestoAvaluoJuridicoCREa') N1(Evaluacion)

			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblGravamen] (IdExpediente, NoGravamen, NoGarantia, Acreedor, IdBancoAcreedor, Monto, Fecha, IdTipoMoneda, FechaAlta, IdUsuarioAlta)
				Select
					  [IdExpediente] = @idExpediente
					, [NoGravamen] = Gravamen.value('noGravamen[1]', 'int')
					, [NoGarantia] = Gravamen.value('noGarantia[1]', 'int')
					, [Acreedor] = Gravamen.value('acreedor[1]', 'nvarchar(500)')
					, [IdBancoAcreedor] = @idBancoAcreedor
					, [MontoGravamen] = Gravamen.value('montoGravamen[1]', 'decimal(18,2)')
					, [FechaGravamen] = Gravamen.value('fechaGravamen[1]', 'date')
					, [IdTipoMoneda] = Gravamen.value('idTipoMoneda[1]', 'int')
					, [FechaAlta] = current_timestamp
					, [IdUsuarioAlta] = 16
				from @XmlData.nodes('//DataCREa/GravamenCREa/Gravamen') N1(Gravamen)


			-- Vendedor
			Declare @IdTipoPersona int = (Select Garantias.value('esPromotor[1]', 'nvarchar(50)') from @XmlData.nodes('//DataCREa/GarantiasCREa/Garantias') N1(Garantias) where Garantias.value('noGarantia[1]', 'int') in (1))

			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblAvaluos_Vendedor] (IdExpediente, NoVendedor, IdTipoPersona, RazonSocialEmpresa, Nombre, Rfc, TelefonoCasa,
																						TelefonoOficina, Cp, Direcccion, Colonia, Ciudad, IdBanco, NoBancoReceptor, 
																						IdPagoVendedor, IdTipoPagoVendedor, ImportePagoVendedor, NoCuentaVendedor, IdUsuarioAlta, FechaAlta)
				Select 
					  [IdExpediente] = @idExpediente
					, [NoVendedor] = Vendedor.value('noVendedor[1]', 'int')
					, [IdTipoPersona] = @IdTipoPersona
					, [RazonSocialEmpresa] = Vendedor.value('nombreVendedor[1]', 'nvarchar(300)')
					, [Nombre] = Vendedor.value('nombreVendedor[1]', 'nvarchar(300)')
					, [Rfc] = Vendedor.value('rfcVendedor[1]', 'nvarchar(20)')
					, [TelefonoCasa] = Vendedor.value('telCasaVendedor[1]', 'nvarchar(20)')
					, [TelefonoOficina] = Vendedor.value('telOficinaVendedor[1]', 'nvarchar(20)')
					, [CodigoPostal] = right('00000' + isnull(Vendedor.value('cpVendedor[1]', 'nvarchar(10)'), ''), 5)
					, [Direccion] = Vendedor.value('direccionVendedor[1]', 'nvarchar(500)')
					, [Colonia] = Vendedor.value('coloniaVendedor[1]', 'nvarchar(200)')
					, [Ciudad] = Vendedor.value('ciudadEstadoVendedor[1]', 'nvarchar(200)')
					, [IdBanco] = Vendedor.value('(idBanco/text())[1]', 'int')
					, [NoBancoReceptor] = Vendedor.value('noBancoReceptor[1]', 'nvarchar(50)')
					, [IdPagoVendedor] = Vendedor.value('idPagoVendedor[1]', 'int')
					, [IdTipoPagoVendedor] = Vendedor.value('idTipoPagoVendedor[1]', 'int')
					, [ImportePagoVendedor] = Vendedor.value('(importePagoVendedor/text())[1]', 'decimal(18, 2)')
					, [NoCuentaVendedor] = Vendedor.value('noCuentaVendedor[1]', 'nvarchar(45)')
					, [IdUsuarioAlta] = 16
					, [FechaAlta] = current_timestamp
				from @XmlData.nodes('//DataCREa/VendedorCREa/Vendedor') N1(Vendedor)

			
			-- tblTerritorial
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblTerritorial] (id, noCaso, idExpediente, tipoEjecutivo, claveEjecutivo, nombreEjecutivo, crSucursal, 
																				  sucursal, regional, territorial, delegacionMunicipio, estado, email, noCliente)
				Select 
					  @IdXml
					, @FolioBanco
					, @idExpediente
					, [TipoEjecutivo]		= Ejecutivos.value('tipoEjecutivo[1]', 'nvarchar(50)')
					, [ClaveEjecutivo]		= Ejecutivos.value('claveEjecutivo[1]', 'int')
					, [NombreEjecutivo]		= Ejecutivos.value('nombreEjecutivo[1]','nvarchar(100)')
					, [CrSucursal]			= Ejecutivos.value('crSucursal[1]', 'nvarchar(50)')
					, [Sucursal]			= Ejecutivos.value('sucursal[1]', 'nvarchar(200)')
					, [Regional]			= Ejecutivos.value('regional[1]', 'nvarchar(200)')
					, [Territorial]			= Ejecutivos.value('territorial[1]','nvarchar(50)')
					, [DelegacionMunicipio]	= Ejecutivos.value('delegacionMunicipio[1]','nvarchar(200)')
					, [Estado]				= Ejecutivos.value('estado[1]', 'nvarchar(100)')
					, [Email]				= Ejecutivos.value('email[1]', 'nvarchar(100)')
					, [NoCliente]			= Header.value('noCliente[1]', 'int')
				from @XmlData.nodes('//DataCREa/EjecutivosCREa/CREaEjecutivos') N1(Ejecutivos)
					cross apply @XmlData.nodes('//DataCREa/HeaderCREa') N2(Header)

			-- **** INICIO:	Ajuste por Cr Incorrecto ****
				if exists (Select 1 from [dbPrestoCibergestionBanorte].[dbo].[tblTerritorialCr] where noCaso = @FolioBanco and Procesado in ('false'))
					begin
						-- 1. Actualizar tipo ejecutivo
						Update [dbPrestoCibergestionBanorte].[dbo].[tblTerritorial] set 
							tipoEjecutivo = 'COORDINADOR'
						where noCaso = @FolioBanco and idExpediente = @idExpediente

						-- 2. Obtener info de tblTerritorialCr e insertar en tblTerritorial
						Insert into [dbPrestoCibergestionBanorte].[dbo].[tblTerritorial] (id, noCaso, tipoEjecutivo, claveEjecutivo, 
									nombreEjecutivo, crSucursal, sucursal, regional, territorial, delegacionMunicipio, estado, 
									email, noCliente, idExpediente)
							Select @IdXml, noCaso, tipoEjecutivo, claveEjecutivo, nombreEjecutivo, crSucursal, sucursal,
								regional, territorial, delegacionMunicipio, estado, email, noCliente, @idExpediente
							from [dbPrestoCibergestionBanorte].[dbo].[tblTerritorialCr] where noCaso = @FolioBanco

						-- 3. Actualizar info de proceso en tabla tblTerritorialCr
						Update [dbPrestoCibergestionBanorte].[dbo].[tblTerritorialCr] set 
							  IdExpediente = @idExpediente
							, FechaProceso = current_timestamp
							, Procesado = cast(1 as bit)
						where noCaso = @FolioBanco
					end
			-- **** FIN:	Ajuste por Cr Incorrecto ****
				
			-- tblDataCREa_Informacion
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa_Informacion] (idExpediente, decreto, fechaEvaluacion, idTipoPagoCliente, idTipoPagoVendedor, bancoCte, 
																							tipoComision, porcentajeComision, comisionMinistracion, filler4, FolioDesarrollo)
				Select top 1
					  [IdExpediente] = @idExpediente
					, [Decreto] = Evaluacion.value('decreto[1]', 'nvarchar(20)')
					, [FechaEvaluacion] = Evaluacion.value('fechaEvaluacion[1]', 'nvarchar(10)')
					, [IdTipoPagoCliente] = InicioPrestoJuridico.value('idTipoPagoCliente[1]', 'int')
					, [IdTipoPagoVendedor] = Vendedor.value('idTipoPagoVendedor[1]', 'int')
					, [BancoCte] = Header.value('bancoCte[1]', 'nvarchar(50)')
					, [TipoComision] = B.descripcion
					, [ComisionApertura] = DatosOperacion.value('comisionApertura[1]', 'decimal(10,2)')
					, [ComisionMinistracion] = DatosOperacion.value('comisionMinistracion[1]', 'decimal(18,2)')
					, [FechaCreacion] = Fillers.value('Filler4[1]', 'date')
					, [FolioDesarrollo] = DatosOperacion.value('folio[1]', 'varchar(50)')
				from @XmlData.nodes('//DataCREa/EvaluacionCREa') N1(Evaluacion)
					cross apply @XmlData.nodes('//DataCREa/InicioPrestoAvaluoJuridicoCREa') N2(InicioPrestoJuridico)
					cross apply @XmlData.nodes('//DataCREa/VendedorCREa/Vendedor') N3(Vendedor)
					cross apply @XmlData.nodes('//DataCREa/HeaderCREa')	N4(Header)
					cross apply @XmlData.nodes('//DataCREa/DatosOperacionCREa')	N5(DatosOperacion)
						inner join [dbPrestoCibergestionBanorte].[dbo].[CatTipoComision] B on B.Id = DatosOperacion.value('idTipoComision[1]', 'int')
					cross apply @XmlData.nodes('//DataCREa/FillersCREa') N6(Fillers)

			-- tblSegurosBanco
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblSegurosBanco] (IdExpediente, IdPaqueteSegurosBanco, IdSeguroVidaBanco, IdSeguroDanosBanco, IdSeguroDesempleoBanco,
																				aseguradoraVida, aseguradoraDanios, aseguradoraDesempleo, CuantiaVida, CuantiaDanos, CuantiaDesempleo, 
																				idUsuarioAlta, fechaAlta)
				Select 
					  [IdExpediente] = @idExpediente
					, [IdPaqueteSeguros] = Evaluacion.value('idPaqueteSeguros[1]', 'int')
					, [IdSeguroVida] = Evaluacion.value('idSeguroVida[1]', 'int')
					, [IdSeguroDanios] = Evaluacion.value('idSeguroDanios[1]', 'int')
					, [IdSeguroDesempleo] = Evaluacion.value('idSeguroDesempleo[1]', 'int')
					, [AseguradoraVida] = Evaluacion.value('aseguradoraVida[1]', 'varchar(999)')
					, [AseguradoraDanos] = Evaluacion.value('aseguradoraDanos[1]', 'varchar(999)')
					, [AseguradoraDesempleo] = Evaluacion.value('aseguradoraDesempleo[1]', 'varchar(999)')
					, [CuantiaVida] = Evaluacion.value('cuantiaVida[1]', 'decimal(18,2)')
					, [CuantiaDanios] = Evaluacion.value('cuantiaDanios[1]', 'decimal(18,2)')
					, [CuantiaDesempleo] = Evaluacion.value('cuantiaDesempleo[1]', 'decimal(18,2)')
					, [IdUsuarioAlta] = 16
					, [FechaAlta] = current_timestamp					
				from @XmlData.nodes('//DataCREa/InicioPrestoAvaluoJuridicoCREa') N1(Evaluacion)
			
			-- [tblBiometria
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblBiometria] (IdExpediente, EstatusVerificacion, MensajeVerificacion, TipoValidacion, TipoValidacionDesc, FolioUnicoIdentificador
													, FolioInterno, TipoIdentificacion1, TipoIdentificacionDesc1, NumeroIdentificacion1, TipoIdentificacion2, TipoIdentificacionDesc2
													, NumeroIdentificacion2, EjecutarVerificacionBiometrica, FechaAlta, Activo)
				Select 
					  @idExpediente
					, Biometria.value('estatusVerificacion[1]', 'varchar(100)') 
					, Biometria.value('mensajeVerificacion[1]', 'varchar(1000)')
					, Biometria.value('tipoValidacion[1]', 'varchar(10)') 
					, Biometria.value('tipoValidacionDesc[1]', 'varchar(1000)') 
					, Biometria.value('folioUnicoIdentificador[1]', 'varchar(500)')
					, Biometria.value('folioInterno[1]', 'varchar(100)') 
					, Biometria.value('tipoIdentificacion1[1]', 'varchar(10)') 
					, Biometria.value('tipoIdentificacionDesc1[1]', 'varchar(1000)')
					, Biometria.value('numeroIdentificacion1[1]', 'varchar(1000)') 
					, Biometria.value('tipoIdentificacion2[1]', 'varchar(10)') 
					, Biometria.value('tipoIdentificacionDesc2[1]', 'varchar(1000)')
					, Biometria.value('numeroIdentificacion2[1]', 'varchar(1000)')
					, Biometria.value('EjecutarVerificacionBiometrica[1]', 'varchar(10)')
					, current_timestamp
					, 1
				from @XmlDatos.nodes('//Datos/Biometria') N1 (Biometria)

			Delete from [dbPrestoCibergestionBanorte].[dbo].[tblXmlDatos_DatosOperacion] where IdExpediente = @idExpediente
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblXmlDatos_DatosOperacion] (IdExpediente, FolioCreditoPreautorizado, IdDesarrolladorEspecial, IdDesarrolloEspecial, IdCampana, FechaAlta)
				Select 
					  @idExpediente
					, DatosOperacion.value('folioCreditoPreAutorizado[1]', 'nvarchar(100)')
					, DatosOperacion.value('idDesarrolladorEspecial[1]', 'nvarchar(50)')
					, DatosOperacion.value('idDesarrolloEspecial[1]', 'nvarchar(50)')
					, DatosOperacion.value('idCampania[1]', 'nvarchar(50)')
					, current_timestamp
				from @XmlDatos.nodes('//Datos/DatosOperacion') N1 (DatosOperacion)
                
			-- Registro de XML en BD de Negocio
			Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa]
				(xmlDataCREa, codigo, idExpediente, noCaso, [status], fechaRegistro)
			values
				(@XmlData, 100, @idExpediente, @FolioBanco, 1, current_timestamp)

			--Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREaServicio]
			--	(xmlDataCREa, codigo, idExpediente, noCaso, [status], idtblDataCREaServicio, fechaRegistro) ja
			--values
			--	(@XmlData, 100, @idExpediente, @FolioBanco, 1, @IdXml, current_timestamp)
			
			-- Cambio de estatus de código 100
			Update [dbo].[tblDataCREa] set enviadoPresto = cast(1 as bit) where id = @IdXml

			-- Result
			Select [IdExpediente] = @idExpediente

			-- Se comenta por el requerimiento 386
			---- Módulo EXCEPCIÓN NOTARIA POR BROKER (Roles 28 y 29)
			--if exists (Select 1 from dbPrestoCibergestionBanorte.dbo.tblSolicitudExcepcionNotariaBroker where FolioBanco = @FolioBanco and activo in ('true'))
			--	begin
			--		declare @esBroker bit = (Select idIsReferenciaBroker from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosVentas where idExpediente = @idExpediente)

			--		if(@esBroker in ('false'))
			--			begin
			--				update dbPrestoCibergestionBanorte.dbo.tblSolicitudExcepcionNotariaBroker set 
			--					  Activo = 0
			--					, IdUsuarioInactiva = 16
			--					, FechaInactiva = current_timestamp
			--				where FolioBanco = @FolioBanco and Activo in ('true')

			--				exec dbPrestoCibergestionBanorte.dbo.usp_Insert_Email_Info 48, @idExpediente, 16, null
			--			end
			--	end


			-- Requerimiento  386 -->Mejora de Hipoteca 
			-- Se añade la validacion para deshabilitar o eliminar las excepciones Para el producto mejora de Hipoteca
			 Exec dbPrestoCibergestionBanorte.dbo.usp_select_excepciones_mejoras_hipoteca @FolioBanco


			--Log Prefirma	29/03/2022
			EXEC dbPrestoCibergestionBanorte.dbo.usp_Insert_Historial_LogPrefirma @FolioBanco, @idExpediente, 100, NULL, NULL, NULL



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

