-- =============================================
-- Author:		igs
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--update [dbPrestoBanorte]..tblDataCREa set enviadoPresto=0 where id=10181
--exec uSp_ConsultaXMLDataCREaNoCasoRevisado '201511007389593'
--Select * from tblDataCREa where noCaso='201509000001000'
--update tblDataCREa set enviadoPresto=0 where id=81
-- =============================================
CREATE PROCEDURE [dbo].[uSp_ConsultaXMLDataCREaNoCasoRevisado]
	-- Add the parameters for the stored procedure here
    @noCaso nVARCHAR(25)
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @xmlDataCREa XML

		
        DECLARE @idExpediente BIGINT

	

		IF(Exists(SELECT * FROM    dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales WHERE folioBanco =@noCaso))
		  BEGIN
				SET @idExpediente = ( SELECT TOP 1 idExpediente FROM    dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales  WHERE   ( folioBanco = @noCaso ))
		  END
		ELSE
		  begin
		    SET @idExpediente =0
		  end        

    
        SET @xmlDataCREa = ( SELECT xmlDataCREa
                             FROM   tblDataCREa
                             WHERE noCaso = @noCaso AND status=1 AND enviadoPresto=0
                           )

         UPDATE tblDataCREa SET enviadoPresto=1 WHERE noCaso=@noCaso AND enviadoPresto=0 AND status=1


			 --flujo 0
			   
        SELECT @idExpediente AS idExpediente,
		        Container.ContainerCol.value('resultadopaso[1]', 'int') AS resultadopaso ,
                Container.ContainerCol.value('idTipoRechazo[1]', 'smallint') AS idTipoRechazo ,
                Container.ContainerCol.value('idmotivorechazo[1]', 'int') AS idmotivorechazo ,
                Container.ContainerCol.value('resultadoNotificacion[1]', 'bit') AS resultadoNotificacion ,
                Container.ContainerCol.value('comentarios[1]','nvarchar(3000)') AS comentarios ,
                Container.ContainerCol.value('fecha[1]', 'nvarchar(20)') AS fecha ,
                Container.ContainerCol.value('status[1]', 'bit') AS status ,
                Container.ContainerCol.value('mensaje[1]', 'nvarchar(3000)') AS mensaje
        FROM    @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container ( ContainerCol )



				--header  1
        SELECT  Container.ContainerCol.value('nombre[1]', 'nvarchar(80)') AS nombre ,
                Container.ContainerCol.value('idPrograma[1]', 'nvarchar(30)') AS idPrograma ,
                Container.ContainerCol.value('destino[1]', 'nvarchar(50)') AS destino ,
                Container.ContainerCol.value('banco[1]', 'nvarchar(50)') AS banco ,
                Container.ContainerCol.value('rfc[1]', 'varchar(20)') AS rfc ,
                Container.ContainerCol.value('crSucursal[1]', 'nvarchar(180)') AS crSucursal ,
                Container.ContainerCol.value('noCaso[1]', 'nvarchar(30)') AS noCaso ,
                Container.ContainerCol.value('bancoCte[1]', 'varchar(20)') AS bancoCte ,
                Container.ContainerCol.value('noCliente[1]', 'nvarchar(30)') AS noCliente ,
                Container.ContainerCol.value('usrAsignado[1]', 'nvarchar(50)') AS usrAsignado ,
                Container.ContainerCol.value('tipoCredito[1]', 'varchar(20)') AS tipoCredito ,
                GETDATE() AS fechaRegistro
        FROM    @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container ( ContainerCol )


			----Datos Personales 2
			   
        SELECT  Container.ContainerCol.value('tipoParticipante[1]',
                                             'nvarchar(30)') AS tipoParticipante ,
                Container.ContainerCol.value('nombreParticipante[1]',
                                             'nvarchar(80)') AS nombreParticipante ,
                Container.ContainerCol.value('noClienteParticipante[1]',
                                             'varchar(20)') AS noClienteParticipante ,
                Container.ContainerCol.value('rfcParticipante[1]',
                                             'varchar(20)') AS rfcParticipante ,
                Container.ContainerCol.value('bancoCteParticipante[1]',
                                             'nvarchar(30)') AS bancoCteParticipante ,
                Container.ContainerCol.value('lugarNacimiento[1]',
                                             'nvarchar(10)') AS lugarNacimiento ,
                Container.ContainerCol.value('estadoCivil[1]', 'smallint') AS estadoCivil ,
                Container.ContainerCol.value('codNacionalidad[1]',
                                             'nvarchar(10)') AS codNacionalidad ,
                Container.ContainerCol.value('idAfiliacion[1]', 'int') AS idAfiliacion ,
                Container.ContainerCol.value('afiliacion[1]', 'nvarchar(30)') AS afiliacion ,
                CONVERT(DATE, Container.ContainerCol.value('fechaNacimiento[1]',
                                                           'nvarchar(14)'), 103) AS fechaNacimiento ,
                Container.ContainerCol.value('edad[1]', 'int') AS edad ,
                Container.ContainerCol.value('sexo[1]', 'nvarchar(20)') AS sexo ,
                Container.ContainerCol.value('esquemaCredito[1]',
                                             'nvarchar(30)') AS esquemaCredito ,
                Container.ContainerCol.value('conyuge[1]', 'nvarchar(80)') AS conyuge ,
                Container.ContainerCol.value('rfcConyuge[1]', 'varchar(25)') AS rfcConyuge ,
                Container.ContainerCol.value('nssc[1]', 'nvarchar(30)') AS nssc
        FROM    @xmlDataCREa.nodes('//DataCREa//DatosPersonalesCREa//DatosPersonales')
                AS Container ( ContainerCol )


			----Datos Domicilio 3
			         
        SELECT  Container.ContainerCol.value('tipoParticipante[1]',
                                             'nvarchar(50)') AS tipoParticipante ,
                Container.ContainerCol.value('calle[1]', 'nvarchar(100)') AS calle ,
                Container.ContainerCol.value('numero[1]', 'nchar(10)') AS numero ,
                Container.ContainerCol.value('dirColoniaPoblacion[1]',
                                             'nvarchar(100)') AS dirColoniaPoblacion ,
                Container.ContainerCol.value('codCiudad[1]', 'nvarchar(100)') AS codCiudad ,
                Container.ContainerCol.value('municipio[1]', 'nvarchar(50)') AS municipio ,
                Container.ContainerCol.value('estado[1]', 'nvarchar(50)') AS estado ,
                Container.ContainerCol.value('pais[1]', 'nvarchar(50)') AS pais ,
                Container.ContainerCol.value('codigoPostal[1]', 'int') AS codigoPostal ,
                Container.ContainerCol.value('tipoDomicilio[1]',
                                             'nvarchar(50)') AS tipoDomicilio ,
                Container.ContainerCol.value('tipoVivienda[1]',
                                             'nvarchar(100)') AS tipoVivienda ,
                Container.ContainerCol.value('departamento[1]',
                                             'nvarchar(100)') AS departamento ,
                Container.ContainerCol.value('mail[1]', 'nvarchar(100)') AS mail ,
                Container2.ContainerCol2.value('tipo_tel[1]', 'nvarchar(50)') AS tipo_tel ,
                Container2.ContainerCol2.value('telefono[1]', 'nvarchar(30)') AS telefono ,
                Container2.ContainerCol2.value('ext[1]', 'nvarchar(30)') AS ext
        FROM    @xmlDataCREa.nodes('//DataCREa//DatosDomicilioCREa//DatosDomicilio')
                AS Container ( ContainerCol ),  @xmlDataCREa.nodes('//DataCREa//DatosDomicilioCREa//DatosDomicilio//telefono//Telefono') AS Container2 ( ContainerCol2 )

	


			--Datos laborales 4
			   

        SELECT  Container.ContainerCol.value('tipoParticipante[1]',
                                             'nvarchar(50)') AS tipoParticipante ,
                Container.ContainerCol.value('dirLabNumeroTelefonoDireccion[1]',
                                             'nvarchar(20)') AS dirLabNumeroTelefonoDireccion ,
                Container.ContainerCol.value('dirLabExtensionTelefonica[1]',
                                             'int') AS dirLabExtensionTelefonica
        FROM    @xmlDataCREa.nodes('//DataCREa//DatosLaboralesCREa//DatosLaborales')
                AS Container ( ContainerCol )
           
		--Datos operacion -- 5
		      

        SELECT  Container.ContainerCol.value('idSubproducto[1]',
                                             'nvarchar(50)') AS idSubproducto ,
                Container.ContainerCol.value('idProgramaConvenio[1]', 'int') AS idProgramaConvenio ,
                Container.ContainerCol.value('idDestinoCredito[1]', 'int') AS idDestinoCredito ,
                Container.ContainerCol.value('idGpoPlazo[1]', 'int') AS idGpoPlazo ,
                Container.ContainerCol.value('idPlazo[1]', 'int') AS idPlazo ,
                Container.ContainerCol.value('idCondicionSpecial[1]', 'int') AS idCondicionSpecial ,
                Container.ContainerCol.value('idModalidad[1]', 'int') AS idModalidad ,
                Container.ContainerCol.value('idTipoTasa[1]', 'int') AS idTipoTasa ,
                Container.ContainerCol.value('idTipoComision[1]', 'int') AS idTipoComision ,
                Container.ContainerCol.value('idComisionInvestigacion[1]',
                                             'nvarchar(50)') AS idComisionInvestigacion ,
                Container.ContainerCol.value('idMoneda[1]', 'int') AS idMoneda ,
                Container.ContainerCol.value('importe[1]', 'decimal(12, 2)') AS importe ,
                Container.ContainerCol.value('valorEstimadoInmueble[1]',
                                             'decimal(18, 0)') AS valorEstimadoInmueble ,
                Container.ContainerCol.value('comisionApertura[1]',
                                             'decimal(18, 0)') AS comisionApertura ,
                Container.ContainerCol.value('comisionAdmin[1]',
                                             'nvarchar(30)') AS comisionAdmin ,
                Container.ContainerCol.value('comisionMinistracion[1]',
                                             'nvarchar(30)') AS comisionMinistracion ,
                Container.ContainerCol.value('comisionPrepago[1]',
                                             'nvarchar(30)') AS comisionPrepago ,
                Container.ContainerCol.value('comInvest[1]', 'nvarchar(30)') AS comInvest ,
                Container.ContainerCol.value('ivacominvest[1]', 'int') AS ivacominvest ,
                Container.ContainerCol.value('seguroGen[1]', 'nvarchar(50)') AS seguroGen ,
                Container.ContainerCol.value('idIsReferenciaBroker[1]', 'int') AS idIsReferenciaBroker ,
                Container.ContainerCol.value('idUsuarioBroker[1]',
                                             'nvarchar(30)') AS idUsuarioBroker ,
                Container.ContainerCol.value('idFranquiciaBroker[1]',
                                             'nvarchar(30)') AS idFranquiciaBroker ,
                Container.ContainerCol.value('idAsesorBroker[1]',
                                             'nvarchar(30)') AS idAsesorBroker ,
                Container.ContainerCol.value('idCorredorInmobiliario[1]',
                                             'int') AS idCorredorInmobiliario ,
                Container.ContainerCol.value('idFranquiciaCl[1]', 'int') AS idFranquiciaCl ,
                Container.ContainerCol.value('idAsesorInmobiliario[1]', 'int') AS idAsesorInmobiliario ,
                Container.ContainerCol.value('idCanalVentas[1]', 'int') AS idCanalVentas ,
                Container.ContainerCol.value('folio[1]', 'nvarchar(50)') AS folio ,
                Container.ContainerCol.value('fuerzaGanadora[1]',
                                             'nvarchar(30)') AS fuerzaGanadora ,
                Container.ContainerCol.value('valorPrimerInmueble[1]',
                                             'decimal(18, 0)') AS valorPrimerInmueble ,
                Container.ContainerCol.value('valorSegInmueble[1]',
                                             'decimal(18, 0)') AS valorSegInmueble ,
                Container.ContainerCol.value('valorTercerInmueble[1]',
                                             'decimal(18, 0)') AS valorTercerInmueble ,
                Container.ContainerCol.value('ecotecnologia[1]',
                                             'nvarchar(50)') AS ecotecnologia
        FROM    @xmlDataCREa.nodes('//DataCREa//DatosOperacionCREa') AS Container ( ContainerCol )
								
								
			--		--precalificacion	 6
			   
        SELECT  Container.ContainerCol.value('montoCredFovisssteTit[1]',
                                             'nvarchar(30)') AS montoCredFovisssteTit ,
                Container.ContainerCol.value('saldoSubcuentaVivienda[1]',
                                             'nvarchar(30)') AS saldoSubcuentaVivienda ,
                Container.ContainerCol.value('montoCredFovisssteCony[1]',
                                             'nvarchar(30)') AS montoCredFovisssteCony ,
                Container.ContainerCol.value('saldoSubcuentaViviendaConyuge[1]',
                                             'nvarchar(30)') AS saldoSubcuentaViviendaConyuge ,
                Container.ContainerCol.value('montoCredInfonavitTitular[1]',
                                             'nvarchar(30)') AS montoCredInfonavitTitular ,
                Container.ContainerCol.value('montoCredInfonavitConyuge[1]',
                                             'nvarchar(30)') AS montoCredInfonavitConyuge
        FROM    @xmlDataCREa.nodes('//DataCREa//PrecalificacionCREa') AS Container ( ContainerCol )

			--	   --garantias 7
			  
        SELECT  Container.ContainerCol.value('noGarantia[1]', 'int') AS noGarantia ,
                Container.ContainerCol.value('esPromotor[1]', 'int') AS esPromotor ,
                Container.ContainerCol.value('propietario[1]', 'nvarchar(50)') AS propietario ,
                Container.ContainerCol.value('idMarcaComercial[1]',
                                             'nvarchar(50)') AS idMarcaComercial ,
                Container.ContainerCol.value('ejecutivo[1]', 'nvarchar(100)') AS ejecutivo ,
                Container.ContainerCol.value('calleNum[1]', 'nvarchar(50)') AS calleNum ,
                Container.ContainerCol.value('colonia[1]', 'nvarchar(50)') AS colonia ,
                Container.ContainerCol.value('ciudad[1]', 'nvarchar(20)') AS ciudad ,
                Container.ContainerCol.value('estado[1]', 'nvarchar(50)') AS estado ,
                Container.ContainerCol.value('codigoPostal[1]', 'int') AS codigoPostal ,
                Container.ContainerCol.value('ubicacion[1]', 'nvarchar(50)') AS ubicacion ,
                Container.ContainerCol.value('idTipoInmueble[1]', 'int') AS idTipoInmueble ,
                Container.ContainerCol.value('lote[1]', 'nchar(3)') AS lote ,
                Container.ContainerCol.value('manzana[1]', 'nchar(3)') AS manzana ,
                Container.ContainerCol.value('m2construccion[1]',
                                             'decimal(6, 2)') AS m2construccion ,
                Container.ContainerCol.value('m2terreno[1]', 'decimal(6, 2)') AS m2terreno ,
                Container.ContainerCol.value('ruv[1]', 'int') AS ruv ,
                Container.ContainerCol.value('latitud[1]', 'decimal(7, 2)') AS latitud ,
                Container.ContainerCol.value('longitud[1]', 'decimal(7, 2)') AS longitud ,
                Container.ContainerCol.value('idEsDomicilioTitular[1]', 'int') AS idEsDomicilioTitular ,
                Container.ContainerCol.value('idEsGarantiaCony[1]', 'int') AS idEsGarantiaCony ,
                Container.ContainerCol.value('idGarantiaFuePropiedad[1]',
                                             'int') AS idGarantiaFuePropiedad
        FROM    @xmlDataCREa.nodes('//DataCREa//GarantiasCREa//Garantias') AS Container ( ContainerCol )
            
		--	--   --evaluacion 8
			       
  --      SELECT  Container.ContainerCol.value('importe[1]', 'nvarchar(50)') AS importe ,
  --              Container.ContainerCol.value('valorEstimadoInmueble[1]',
  --                                           'nvarchar(50)') AS valorEstimadoInmueble ,
  --              Container.ContainerCol.value('bonificacionEfect[1]',
  --                                           'nvarchar(50)') AS bonificacionEfect ,
  --              Container.ContainerCol.value('porcentajeFinanciamiento[1]',
  --                                           'nvarchar(50)') AS porcentajeFinanciamiento ,
  --              Container.ContainerCol.value('montoEnganche[1]',
  --                                           'nvarchar(50)') AS montoEnganche ,
  --              Container.ContainerCol.value('tasaAplicable[1]',
  --                                           'nvarchar(50)') AS tasaAplicable ,
  --              Container.ContainerCol.value('plazo[1]', 'nvarchar(50)') AS plazo ,
  --              Container.ContainerCol.value('tipoComision[1]', 'nvarchar(50)') AS tipoComision ,
  --              Container.ContainerCol.value('comisionApertura[1]',
  --                                           'nvarchar(50)') AS comisionApertura ,
  --              Container.ContainerCol.value('comisionAdmin[1]',
  --                                           'nvarchar(50)') AS comisionAdmin ,
  --              Container.ContainerCol.value('comisionMinistracion[1]',
  --                                           'nvarchar(50)') AS comisionMinistracion ,
  --              Container.ContainerCol.value('comisionPrepago[1]',
  --                                           'nvarchar(50)') AS comisionPrepago ,
  --              Container.ContainerCol.value('comInvest[1]', 'nvarchar(50)') AS comInvest ,
  --              Container.ContainerCol.value('fechaEvaluacion[1]', 'date') AS fechaEvaluacion
  --      FROM    @xmlDataCREa.nodes('//DataCREa//EvalucionCREa') AS Container ( ContainerCol )

		--	--	     --fillers      9
					  

  --      SELECT  Container.ContainerCol.value('Filler1[1]', 'nvarchar(50)') AS Filler1 ,
  --              Container.ContainerCol.value('Filler2[1]', 'nvarchar(50)') AS Filler2 ,
  --              Container.ContainerCol.value('Filler3[1]', 'nvarchar(50)') AS Filler3 ,
  --              Container.ContainerCol.value('Filler4[1]', 'nvarchar(50)') AS Filler4 ,
  --              Container.ContainerCol.value('Filler5[1]', 'nvarchar(50)') AS Filler5 ,
  --              Container.ContainerCol.value('Filler6[1]', 'nvarchar(50)') AS Filler6 ,
  --              Container.ContainerCol.value('Filler7[1]', 'nvarchar(50)') AS Filler7 ,
  --              Container.ContainerCol.value('Filler8[1]', 'nvarchar(50)') AS Filler8 ,
  --              Container.ContainerCol.value('Filler[1]', 'nvarchar(50)') AS Filler ,
  --              Container.ContainerCol.value('Filler50[1]', 'nvarchar(50)') AS Filler50
  --      FROM    @xmlDataCREa.nodes('//DataCREa//FillersCREa') AS Container ( ContainerCol )

  -- --                  --fillersconAva 10
                        

  --      SELECT  Container.ContainerCol.value('FillerConciliacionAvaluo1[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionAvaluo1 ,
  --              Container.ContainerCol.value('FillerConciliacionAvaluo2[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionAvaluo2 ,
  --              Container.ContainerCol.value('FillerConciliacionAvaluo[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionAvaluo ,
  --              Container.ContainerCol.value('FillerConciliacionAvaluo10[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionAvaluo10
  --      FROM    @xmlDataCREa.nodes('//DataCREa//FillersConciliacionAvaluoCREa')
  --              AS Container ( ContainerCol )

		--	--		--fillerconJur  11
					  

  --      SELECT  Container.ContainerCol.value('FillerConciliacionJuridico1[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionJuridico1 ,
  --              Container.ContainerCol.value('FillerConciliacionJuridico2[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionJuridico2 ,
  --              Container.ContainerCol.value('FillerConciliacionJuridico[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionJuridico ,
  --              Container.ContainerCol.value('FillerConciliacionJuridico10[1]',
  --                                           'nvarchar(10)') AS FillerConciliacionJuridico10
  --      FROM    @xmlDataCREa.nodes('//DataCREa//FillersConciliacionJuridicoCREa')
  --              AS Container ( ContainerCol )
					
		--	----InicioPrestoAvaluoJuridico 12
			           

  --      SELECT  Container.ContainerCol.value('noCtaChequesClientes[1]', 'int') AS noCtaChequesClientes ,
  --              Container.ContainerCol.value('opcionPrepago[1]', 'int') AS opcionPrepago ,
  --              Container.ContainerCol.value('importe[1]', 'decimal(10, 2)') AS importe ,
  --              Container.ContainerCol.value('esCap[1]', 'int') AS esCap ,
  --              Container.ContainerCol.value('crCap[1]', 'nvarchar(30)') AS crCap ,
  --              Container.ContainerCol.value('idTipoPagoCliente[1]', 'int') AS idTipoPagoCliente ,
  --              Container.ContainerCol.value('idPagoVendedor[1]', 'int') AS idPagoVendedor ,
  --              Container.ContainerCol.value('importePagoVendedor[1]',
  --                                           'nvarchar(30)') AS importePagoVendedor ,
  --              Container.ContainerCol.value('idTipoPagoVendedor[1]',
  --                                           'nvarchar(30)') AS idTipoPagoVendedor ,
  --              Container.ContainerCol.value('noCuentaVendedor[1]',
  --                                           'nvarchar(30)') AS noCuentaVendedor ,
  --              Container.ContainerCol.value('nombreVendedor[1]',
  --                                           'nvarchar(200)') AS nombreVendedor ,
  --              Container.ContainerCol.value('rfcVendedor[1]', 'nchar(13)') AS rfcVendedor ,
  --              Container.ContainerCol.value('direccionVendedor[1]',
  --                                           'nvarchar(200)') AS direccionVendedor ,
  --              Container.ContainerCol.value('coloniaVendedor[1]',
  --                                           'nvarchar(150)') AS coloniaVendedor ,
  --              Container.ContainerCol.value('ciudadEstadoVendedor[1]',
  --                                           'nvarchar(100)') AS ciudadEstadoVendedor ,
  --              Container.ContainerCol.value('cpVendedor[1]', 'int') AS cpVendedor ,
  --              Container.ContainerCol.value('telCasaVendedor[1]',
  --                                           'nvarchar(30)') AS telCasaVendedor ,
  --              Container.ContainerCol.value('telOficinaVendedor[1]',
  --                                           'nvarchar(30)') AS telOficinaVendedor ,
  --              Container.ContainerCol.value('reca[1]', 'nvarchar(50)') AS reca
  --      FROM    @xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa')
  --              AS Container ( ContainerCol )
		       
		--	--   --InicioPrestoFechaFirmas  13
			      
  --      SELECT  CONVERT(DATE, Container.ContainerCol.value('fechaFirma[1]',
  --                                                         'nvarchar(12)'), 103) AS fechaFirma ,
  --              Container.ContainerCol.value('horaFirma[1]', 'decimal(10, 2)') AS horaFirma
  --      FROM    @xmlDataCREa.nodes('//DataCREa//InicioPrestoFechaFirmasCrea')
  --              AS Container ( ContainerCol )
		   
		-- --        --Avaluo  14
				 

  --      SELECT  Container.ContainerCol.value('valorAvaluoPrimerInmueble[1]',
  --                                           'numeric(10, 2)') AS valorAvaluoPrimerInmueble ,
  --              Container.ContainerCol.value('numeroAvaluo[1]', 'nchar(10)') AS numeroAvaluo ,
  --              CONVERT(DATE, Container.ContainerCol.value('fechaAvaluoPrimerInmueble[1]',
  --                                                         'nvarchar(10)'), 103) AS fechaAvaluoPrimerInmueble ,
  --              Container.ContainerCol.value('valorAvaluoSegInmueble[1]',
  --                                           'numeric(10, 2)') AS valorAvaluoSegInmueble ,
  --              Container.ContainerCol.value('numeroAvaluoSegundoInmu[1]',
  --                                           'int') AS numeroAvaluoSegundoInmu ,
  --              CONVERT(DATE, Container.ContainerCol.value('fechaAvaluoSeguInmueble[1]',
  --                                                         'nvarchar(10)'), 103) AS fechaAvaluoSeguInmueble ,
  --              Container.ContainerCol.value('valorAvaluoTercerInmueble[1]',
  --                                           'numeric(10, 2)') AS valorAvaluoTercerInmueble ,
  --              Container.ContainerCol.value('numeroAvaluoTercerInmu[1]',
  --                                           'int') AS numeroAvaluoTercerInmu ,
  --              CONVERT(DATE, Container.ContainerCol.value('fechaAvaluoTercInmueble[1]',
  --                                                         'nvarchar(10)'), 103) AS fechaAvaluoTercInmueble ,
  --              Container.ContainerCol.value('sumaValorAvaluos[1]',
  --                                           'numeric(10, 2)') AS sumaValorAvaluos ,
  --              Container.ContainerCol.value('montoPrimerMinistracion[1]',
  --                                           'numeric(10, 2)') AS montoPrimerMinistracion
  --      FROM    @xmlDataCREa.nodes('//DataCREa//AvaluoCREa') AS Container ( ContainerCol )

  -- --                --Memorandum  15
  --      DECLARE @vigentePreventivo NVARCHAR(10)
  --      DECLARE @fechaPrimerPago NVARCHAR(10)

						
							
  --      IF ( ISDATE(( SELECT    Container.ContainerCol.value('vigentePreventivo[1]',
  --                                                           'nvarchar(10)')
  --                    FROM      @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')
  --                              AS Container ( ContainerCol )
  --                  )) = '1' ) 
  --          BEGIN
  --              SET @vigentePreventivo = ( SELECT   CONVERT(DATE, Container.ContainerCol.value('vigentePreventivo[1]',
  --                                                            'nvarchar(10)'), 103)
  --                                         FROM     @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')
  --                                                  AS Container ( ContainerCol )
  --                                       )
  --          END
  --      ELSE 
  --          BEGIN
  --              SET @vigentePreventivo = NULL
  --          END

  --      IF ( ISDATE(( SELECT    Container.ContainerCol.value('fechaPrimerPago[1]',
  --                                                           'nvarchar(10)')
  --                    FROM      @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')
  --                              AS Container ( ContainerCol )
  --                  )) = '1' ) 
  --          BEGIN
  --              SET @fechaPrimerPago = ( SELECT CONVERT(DATE, Container.ContainerCol.value('fechaPrimerPago[1]',
  --                                                            'nvarchar(10)'), 103)
  --                                       FROM   @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')
  --                                              AS Container ( ContainerCol )
  --                                     )
  --          END
  --      ELSE 
  --          BEGIN
  --              SET @fechaPrimerPago = NULL
  --          END

  --      SELECT  Container.ContainerCol.value('claveNotaria[1]', 'nvarchar(10)') AS claveNotaria ,
  --              Container.ContainerCol.value('nombreNotario[1]',
  --                                           'nvarchar(120)') AS nombreNotario ,
  --              Container.ContainerCol.value('razonSocial[1]', 'nvarchar(120)') AS razonSocial ,
  --              Container.ContainerCol.value('numeroNotaria[1]',
  --                                           'nvarchar(120)') AS numeroNotaria ,
  --              Container.ContainerCol.value('entidad[1]', 'int') AS entidad ,
  --              Container.ContainerCol.value('notariaPadron[1]', 'int') AS notariaPadron ,
  --              @vigentePreventivo AS vigentePreventivo ,
  --              Container.ContainerCol.value('numeroContrato[1]',
  --                                           'nvarchar(10)') AS numeroContrato ,
  --              @fechaPrimerPago AS fechaPrimerPago ,
  --              Container.ContainerCol.value('acreedor[1]', 'nvarchar(120)') AS acreedor ,
  --              Container.ContainerCol.value('plazaCredito[1]', 'nvarchar(30)') AS plazaCredito ,
  --              Container.ContainerCol.value('cartaInstruccionIrrevocable[1]',
  --                                           'int') AS cartaInstruccionIrrevocable ,
  --              Container.ContainerCol.value('gtsNotariales[1]',
  --                                           'numeric(12, 2)') AS gtsNotariales ,
  --              Container.ContainerCol.value('cuentaAbonoGtsNotariales[1]',
  --                                           'int') AS cuentaAbonoGtsNotariales ,
  --              Container.ContainerCol.value('honrsNotariales[1]',
  --                                           'numeric(10, 2)') AS honrsNotariales ,
  --              Container.ContainerCol.value('cuentaAbonoHonrsNotariales[1]',
  --                                           'int') AS cuentaAbonoHonrsNotariales ,
  --              Container.ContainerCol.value('gravamen[1]', 'int') AS gravamen
  --      FROM    @xmlDataCREa.nodes('//DataCREa//MemorandumCREa') AS Container ( ContainerCol )

  ---- --                  --ACOCApertura  16
                     

  --      SELECT  Container.ContainerCol.value('noCredito[1]', 'nvarchar(50)') AS noCredito ,
  --              Container.ContainerCol.value('cr[1]', 'nvarchar(50)') AS cr ,
  --              Container.ContainerCol.value('importe[1]', 'nvarchar(50)') AS importe ,
  --              Container.ContainerCol.value('tipoCredito[1]', 'nvarchar(50)') AS tipoCredito ,
  --              Container.ContainerCol.value('ctaCheques[1]', 'nvarchar(50)') AS ctaCheques ,
  --              Container.ContainerCol.value('comApertura[1]', 'nvarchar(50)') AS comApertura ,
  --              Container.ContainerCol.value('idPeriodicidad[1]', 'int') AS idPeriodicidad ,
  --              Container.ContainerCol.value('tasa[1]', 'nvarchar(50)') AS tasa ,
  --              Container.ContainerCol.value('cat[1]', 'nvarchar(50)') AS cat ,
  --              Container.ContainerCol.value('modalidad[1]', 'nvarchar(50)') AS modalidad ,
  --              Container.ContainerCol.value('moneda[1]', 'nvarchar(50)') AS moneda ,
  --              Container.ContainerCol.value('plazo[1]', 'nvarchar(50)') AS plazo ,
  --              Container.ContainerCol.value('idGracia[1]', 'int') AS idGracia ,
  --              Container.ContainerCol.value('formaPago[1]', 'nvarchar(50)') AS formaPago ,
  --              Container.ContainerCol.value('idTipoCargo[1]', 'int') AS idTipoCargo ,
  --              Container.ContainerCol.value('noCaso[1]', 'nvarchar(50)') AS noCaso ,
  --              Container.ContainerCol.value('fechaPrimerPago[1]',
  --                                           'nvarchar(50)') AS fechaPrimerPago ,
  --              Container.ContainerCol.value('opcionPrepago[1]',
  --                                           'nvarchar(50)') AS opcionPrepago ,
  --              Container.ContainerCol.value('idPagoIVA[1]', 'int') AS idPagoIVA ,
  --              Container.ContainerCol.value('gastosInvest[1]', 'nvarchar(50)') AS gastosInvest ,
  --              Container.ContainerCol.value('seguroDesempleo[1]',
  --                                           'nvarchar(50)') AS seguroDesempleo ,
  --              Container.ContainerCol.value('baseCalculoSeguro[1]',
  --                                           'nchar(13)') AS baseCalculoSeguro ,
  --              Container.ContainerCol.value('ValorVivienda[1]',
  --                                           'nvarchar(50)') AS ValorVivienda ,
  --              Container.ContainerCol.value('pzoPagaBcoSeguro[1]', 'int') AS pzoPagaBcoSeguro ,
  --              Container.ContainerCol.value('idBonificacion[1]', 'int') AS idBonificacion
  --      FROM    @xmlDataCREa.nodes('//DataCREa//ACOCAperturaCREa') AS Container ( ContainerCol )

		--	--	   --ACOCDisposicion  17
			          

  --      SELECT  Container.ContainerCol.value('noCredito[1]', 'nvarchar(50)') AS noCredito ,
  --              Container.ContainerCol.value('fechaDisposicion[1]', 'date') AS fechaDisposicion ,
  --              Container.ContainerCol.value('importe[1]', 'nvarchar(50)') AS importe ,
  --              Container.ContainerCol.value('montoDisposicion[1]',
  --                                           'nvarchar(50)') AS montoDisposicion ,
  --              Container.ContainerCol.value('comisionMinistracion[1]',
  --                                           'nvarchar(50)') AS comisionMinistracion ,
  --              Container.ContainerCol.value('idComision[1]', 'int') AS idComision ,
  --              Container.ContainerCol.value('gastosinvest[1]', 'nvarchar(50)') AS gastosinvest ,
  --              Container.ContainerCol.value('idFormaPago[1]', 'nvarchar(50)') AS idFormaPago ,
  --              Container.ContainerCol.value('fechaFirma[1]', 'nvarchar(50)') AS fechaFirma ,
  --              Container.ContainerCol.value('montoChequeCaja[1]',
  --                                           'nvarchar(50)') AS montoChequeCaja ,
  --              Container.ContainerCol.value('cuentaConcentradora[1]',
  --                                           'nvarchar(50)') AS cuentaConcentradora ,
  --              Container.ContainerCol.value('fechaVigencia[1]',
  --                                           'nvarchar(50)') AS fechaVigencia ,
  --              Container.ContainerCol.value('nombreVendedor[1]',
  --                                           'nvarchar(50)') AS nombreVendedor ,
  --              Container.ContainerCol.value('nombreNotario[1]',
  --                                           'nvarchar(50)') AS nombreNotario ,
  --              Container.ContainerCol.value('noCtaChequesAcred[1]',
  --                                           'nvarchar(50)') AS noCtaChequesAcred ,
  --              Container.ContainerCol.value('idPagoVendedor[1]', 'int') AS idPagoVendedor ,
  --              Container.ContainerCol.value('idTipoPagoVendedor[1]',
  --                                           'nvarchar(30)') AS idTipoPagoVendedor ,
  --              Container.ContainerCol.value('ctaChequesVendedor[1]',
  --                                           'nvarchar(30)') AS ctaChequesVendedor ,
  --              Container.ContainerCol.value('importePagoVendedor[1]',
  --                                           'nvarchar(50)') AS importePagoVendedor ,
  --              Container.ContainerCol.value('importeGastosNotario[1]',
  --                                           'nvarchar(50)') AS importeGastosNotario ,
  --              Container.ContainerCol.value('cuentaHonorariosNotario[1]',
  --                                           'nvarchar(50)') AS cuentaHonorariosNotario ,
  --              Container.ContainerCol.value('noCuenta[1]', 'nvarchar(50)') AS noCuenta ,
  --              Container.ContainerCol.value('tipoCaso[1]', 'nvarchar(50)') AS tipoCaso ,
  --              Container.ContainerCol.value('crSucursal[1]', 'nvarchar(50)') AS crSucursal ,
  --              Container.ContainerCol.value('tipoCredito[1]', 'nvarchar(50)') AS tipoCredito ,
  --              Container.ContainerCol.value('modalidad[1]', 'nvarchar(50)') AS modalidad ,
  --              Container.ContainerCol.value('nombreCliente[1]',
  --                                           'nvarchar(50)') AS nombreCliente ,
  --              Container.ContainerCol.value('numeroCredito[1]',
  --                                           'nvarchar(50)') AS numeroCredito ,
  --              Container.ContainerCol.value('noAcreditado[1]', 'nvarchar(50)') AS noAcreditado
  --      FROM    @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa') AS Container ( ContainerCol )
			
		--	--     --presto           18
				   
  --      SELECT  Container.ContainerCol.value('plazaAsignacion[1]',
  --                                           'nvarchar(50)') AS plazaAsignacion ,
  --              Container.ContainerCol.value('sucursalAsignacion[1]',
  --                                           'nvarchar(50)') AS sucursalAsignacion ,
  --              Container.ContainerCol.value('idUsuarioPresto[1]',
  --                                           'nvarchar(50)') AS idUsuarioPresto ,
  --              Container.ContainerCol.value('nombreUsuarioPresto[1]',
  --                                           'nvarchar(50)') AS nombreUsuarioPresto
  --      FROM    @xmlDataCREa.nodes('//DataCREa//PrestoCREa') AS Container ( ContainerCol )
									
		-- --        --SLApresto      19
		       
  --      SELECT  Container.ContainerCol.value('idPasoPresto[1]', 'nvarchar(50)') AS idPasoPresto ,
  --              Container.ContainerCol.value('nombrePasoPresto[1]',
  --                                           'nvarchar(50)') AS nombrePasoPresto ,
  --              Container.ContainerCol.value('tiempoEjecucion[1]',
  --                                           'nvarchar(50)') AS tiempoEjecucion
  --      FROM    @xmlDataCREa.nodes('//DataCREa//PrestoCREa') AS Container ( ContainerCol )

  --      --        arreglo telefono      20

		--	SELECT  Container2.ContainerCol2.value('tipoParticipante[1]',
  --                                           'nvarchar(50)') AS tipoParticipante ,
                
  --              Container.ContainerCol.value('tipo_tel[1]', 'nvarchar(50)') AS tipo_tel ,
  --              Container.ContainerCol.value('telefono[1]', 'nvarchar(30)') AS telefono ,
  --              Container.ContainerCol.value('ext[1]', 'nvarchar(30)') AS ext
  --      FROM    @xmlDataCREa.nodes('//DataCREa//DatosDomicilioCREa//DatosDomicilio//telefono//Telefono')
  --              AS Container ( ContainerCol ), @xmlDataCREa.nodes('//DataCREa//DatosDomicilioCREa//DatosDomicilio') AS Container2 ( ContainerCol2 )


		----- 21 CREaEjecutivos        
  --      SELECT  Container.ContainerCol.value('tipoEjecutivo[1]', 'nvarchar(50)') AS tipoEjecutivo ,
  --              Container.ContainerCol.value('claveEjecutivo[1]', 'nvarchar(25)') AS claveEjecutivo ,
  --              Container.ContainerCol.value('nombreEjecutivo[1]','nvarchar(80)') AS nombreEjecutivo,
		--		Container.ContainerCol.value('crSucursal[1]','nvarchar(25)') AS crSucursal,
		--		Container.ContainerCol.value('sucursal[1]','nvarchar(80)') AS sucursal,
		--		Container.ContainerCol.value('regional[1]','nvarchar(80)') AS regional,
		--		Container.ContainerCol.value('territorial[1]','nvarchar(80)') AS territorial,
		--		Container.ContainerCol.value('delegacionMunicipio[1]','nvarchar(80)') AS delegacionMunicipio,
		--		Container.ContainerCol.value('estado[1]','nvarchar(80)') AS estado,
		--		Container.ContainerCol.value('email[1]','nvarchar(80)') AS email
				
  --      FROM    @xmlDataCREa.nodes('//DataCREa//EjecutivosCREa//CREaEjecutivos') AS Container ( ContainerCol )



    END
