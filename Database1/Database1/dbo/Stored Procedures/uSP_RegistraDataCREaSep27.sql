-- =============================================
-- Author:		Eduardo
-- Create date: 31Agosto2015
-- Description:	Store que almacena los datos enviado por el banco en formato XML sin Procesarlo
-- exec [uSP_RegistraDataCREaSep27] ''
-- =============================================
CREATE PROCEDURE [dbo].[uSP_RegistraDataCREaSep27]
	-- Add the parameters for the stored procedure here
	@xmlDataCREa xml
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @resultadopaso int
	declare @noCaso nvarchar(30)
	declare @id int

set @xmlDataCREa='<DataCREa>
  <FlujoCREa>
    <id>0</id>
    <idPresto>0</idPresto>
    <resultadopaso>100</resultadopaso>
    <idTipoRechazo>0</idTipoRechazo>
    <idmotivorechazo>0</idmotivorechazo>
    <resultadoNotificacion />
    <comentarios />
    <fecha>20150924101112</fecha>
    <status>false</status>
    <mensaje />
  </FlujoCREa>
  <HeaderCREa>
    <nombre>JOSE HERNANDO VALVERDE GUTIERREZ</nombre>
    <idPrograma>Respalda2</idPrograma>
    <destino>Adquisición de Vivienda</destino>
    <banco>BANORTE</banco>
    <rfc>VAGH7711211C1</rfc>
    <crSucursal>1017 GUADALUPE</crSucursal>
    <noCaso>201508001070314</noCaso>
    <bancoCte>IXE</bancoCte>
    <noCliente>51766768</noCliente>
    <usrAsignado>Usuario Generico Sucursal</usrAsignado>
    <tipoCredito>Hipotecario</tipoCredito>
  </HeaderCREa>
  <DatosPersonalesCREa>
    <DatosPersonales>
      <tipoParticipante>TITULAR</tipoParticipante>
      <nombreParticipante>JOSE HERNANDO VALVERDE GUTIERREZ</nombreParticipante>
      <noClienteParticipante>51766768</noClienteParticipante>
      <rfcParticipante>VAGH7711211C1</rfcParticipante>
      <bancoCteParticipante>IXE</bancoCteParticipante>
      <lugarNacimiento>DF</lugarNacimiento>
      <estadoCivil>2</estadoCivil>
      <codNacionalidad>001</codNacionalidad>
      <idAfiliacion>0</idAfiliacion>
      <afiliacion />
      <fechaNacimiento>21/11/1977</fechaNacimiento>
      <edad>37</edad>
      <sexo>M</sexo>
      <esquemaCredito />
      <conyuge />
      <rfcConyuge />
      <nssc />
    </DatosPersonales>
  </DatosPersonalesCREa>
  <DatosDomicilioCREa>
    <DatosDomicilio>
      <tipoParticipante>TITULAR</tipoParticipante>
      <calle>RCASTAOSM</calle>
      <numero>12</numero>
      <dirColoniaPoblacion>AURORA PRIMERA SECC BENITO JUAREZ</dirColoniaPoblacion>
      <codCiudad>058</codCiudad>
      <municipio>NEZAHUALCOYOTL</municipio>
      <estado>EM</estado>
      <pais>MEX</pais>
      <codigoPostal>57000</codigoPostal>
      <tipoDomicilio>1</tipoDomicilio>
      <tipoVivienda>INVERSION PLUS</tipoVivienda>
      <departamento>201</departamento>
      <mail>JHVALVERDEGUT@HOTMAIL.COM</mail>
      <telefono>
        <Telefono>
          <tipoParticipante />
          <tipo_tel />
        </Telefono>
      </telefono>
    </DatosDomicilio>
  </DatosDomicilioCREa>
  <DatosLaboralesCREa>
    <DatosLaborales>
      <tipoParticipante>TITULAR</tipoParticipante>
      <dirLabNumeroTelefonoDireccion>8143934859</dirLabNumeroTelefonoDireccion>
      <dirLabExtensionTelefonica />
    </DatosLaborales>
  </DatosLaboralesCREa>
  <DatosOperacionCREa>
    <idSubproducto>7</idSubproducto>
    <idProgramaConvenio>1</idProgramaConvenio>
    <idDestinoCredito>1</idDestinoCredito>
    <idGpoPlazo>240</idGpoPlazo>
    <idPlazo>180</idPlazo>
    <idCondicionEspecial>0</idCondicionEspecial>
    <idModalidad>70102</idModalidad>
    <idTipoTasa>1</idTipoTasa>
    <idTipoComision>2</idTipoComision>
    <idComisionInvestigacion>S</idComisionInvestigacion>
    <idMoneda>2</idMoneda>
    <importe>750000</importe>
    <valorEstimadoInmueble>1200000</valorEstimadoInmueble>
    <comisionApertura>1</comisionApertura>
    <comisionAdmin>299</comisionAdmin>
    <comisionMinistracion>N/A</comisionMinistracion>
    <comisionPrepago>N/A</comisionPrepago>
    <comInvest>500</comInvest>
    <ivacominvest>1</ivacominvest>
    <seguroGen>Si</seguroGen>
    <idIsReferenciaBroker>0</idIsReferenciaBroker>
    <idUsuarioBroker />
    <idFranquiciaBroker />
    <idAsesorBroker />
    <idCorredorInmobiliario>0</idCorredorInmobiliario>
    <idFranquiciaCI>0</idFranquiciaCI>
    <idAsesorInmobiliario>0</idAsesorInmobiliario>
    <idCanalVentas>0</idCanalVentas>
    <folio />
    <fuerzaGanadora>12</fuerzaGanadora>
    <valorPrimerInmueble>1200000</valorPrimerInmueble>
    <valorSegInmueble>0</valorSegInmueble>
    <valorTercerInmueble>0</valorTercerInmueble>
    <ecotecnologia>N</ecotecnologia>
  </DatosOperacionCREa>
  <PrecalificacionCREa>
    <montoCredFovisssteTit>400000</montoCredFovisssteTit>
    <saldoSubcuentaVivienda />
    <montoCredFovisssteCony>0</montoCredFovisssteCony>
    <saldoSubcuentaViviendaConyuge />
    <montoCredInfonavitTitular>0</montoCredInfonavitTitular>
    <montoCredInfonavitConyuge>0</montoCredInfonavitConyuge>
  </PrecalificacionCREa>
  <GarantiasCREa>
    <Garantias>
      <noGarantia>1</noGarantia>
      <esPromotor>1</esPromotor>
      <propietario>19</propietario>
      <idMarcaComercial>0</idMarcaComercial>
      <ejecutivo>RESIDENCIAL ARBOLEDAS DE GUADALUPE</ejecutivo>
      <calleNum>FRESNO 123</calleNum>
      <colonia>RESIDENCIAL ARBOLEDAS DE GUADALUPE</colonia>
      <ciudad>GUADALUPE</ciudad>
      <estado>NL</estado>
      <codigoPostal>65636</codigoPostal>
      <ubicacion>NO</ubicacion>
      <idTipoInmueble>1</idTipoInmueble>
      <lote>23</lote>
      <manzana>43</manzana>
      <m2construccion>110</m2construccion>
      <m2terreno>200</m2terreno>
      <ruv>0</ruv>
      <latitud>0</latitud>
      <longitud>0</longitud>
      <idEsDomicilioTitular>2</idEsDomicilioTitular>
      <idEsGarantiaCony>2</idEsGarantiaCony>
      <idGarantiaFuePropiedad>2</idGarantiaFuePropiedad>
    </Garantias>
  </GarantiasCREa>
  <EvalucionCREa>
    <importe>750000</importe>
    <valorEstimadoInmueble>1200000</valorEstimadoInmueble>
    <bonificacionEfect>N/A</bonificacionEfect>
    <porcentajeFinanciamiento>62.50</porcentajeFinanciamiento>
    <montoEnganche>450000</montoEnganche>
    <tasaAplicable>10.41</tasaAplicable>
    <plazo>240</plazo>
    <tipoComision>Contado</tipoComision>
    <comisionApertura>1</comisionApertura>
    <comisionAdmin>299</comisionAdmin>
    <comisionMinistracion>N/A</comisionMinistracion>
    <comisionPrepago>N/A</comisionPrepago>
    <comInvest>$ 500.00 IVA Incluido</comInvest>
    <fechaEvaluacion>2015-09-03</fechaEvaluacion>
  </EvalucionCREa>
  <FillersCREa>
    <Filler1>03/09/2015</Filler1>
    <Filler2>OPCIONAL</Filler2>
    <Filler3>OPCIONAL</Filler3>
    <Filler4>OPCIONAL</Filler4>
    <Filler5>OPCIONAL</Filler5>
    <Filler6>OPCIONAL</Filler6>
    <Filler7>OPCIONAL</Filler7>
    <Filler8>OPCIONAL</Filler8>
    <Filler>OPCIONAL</Filler>
    <Filler50>OPCIONAL</Filler50>
  </FillersCREa>
  <FillersConciliacionAvaluoCREa>
    <FillerConciliacionAvaluo1>OPCIONAL</FillerConciliacionAvaluo1>
    <FillerConciliacionAvaluo2>OPCIONAL</FillerConciliacionAvaluo2>
    <FillerConciliacionAvaluo>OPCIONAL</FillerConciliacionAvaluo>
    <FillerConciliacionAvaluo10>OPCIONAL</FillerConciliacionAvaluo10>
  </FillersConciliacionAvaluoCREa>
  <FillersConciliacionJuridicoCREa>
    <FillerConciliacionJuridico1>OPCIONAL</FillerConciliacionJuridico1>
    <FillerConciliacionJuridico2>OPCIONAL</FillerConciliacionJuridico2>
    <FillerConciliacionJurídico>OPCIONAL</FillerConciliacionJurídico>
    <FillerConciliacionJuridico10>OPCIONAL</FillerConciliacionJuridico10>
  </FillersConciliacionJuridicoCREa>
  <AvaluoCREa>
    <valorAvaluoPrimerInmueble>0</valorAvaluoPrimerInmueble>
    <numeroAvaluo>0</numeroAvaluo>
    <fechaAvaluoPrimerInmueble>07/09/2015</fechaAvaluoPrimerInmueble>
    <valorAvaluoSegInmueble>0</valorAvaluoSegInmueble>
    <numeroAvaluoSegundoInmu>0</numeroAvaluoSegundoInmu>
    <fechaAvaluoSeguInmueble>07/09/2015</fechaAvaluoSeguInmueble>
    <valorAvaluoTercerInmueble>0</valorAvaluoTercerInmueble>
    <numeroAvaluoTercerInmu>0</numeroAvaluoTercerInmu>
    <fechaAvaluoTercInmueble>07/09/2015</fechaAvaluoTercInmueble>
    <sumaValorAvaluos>0</sumaValorAvaluos>
    <montoPrimerMinistracion>0</montoPrimerMinistracion>
  </AvaluoCREa>
  <MemorandumCREa>
    <claveNotaria>N</claveNotaria>
    <nombreNotario>N</nombreNotario>
    <razonSocial>N</razonSocial>
    <numeroNotaria>N</numeroNotaria>
    <entidad>0</entidad>
    <notariaPadron>0</notariaPadron>
    <vigentePreventivo>07/09/2015</vigentePreventivo>
    <numeroContrato>N</numeroContrato>
    <fechaPrimerPago>N</fechaPrimerPago>
    <acreedor />
    <plazaCredito>N</plazaCredito>
    <cartaInstruccionIrrevocable>0</cartaInstruccionIrrevocable>
    <gtsNotariales>0</gtsNotariales>
    <cuentaAbonoGtsNotariales>0</cuentaAbonoGtsNotariales>
    <honrsNotariales>0</honrsNotariales>
    <cuentaAbonoHonrsNotariales>0</cuentaAbonoHonrsNotariales>
    <gravamen>0</gravamen>
  </MemorandumCREa>
  <PrestoCREa>
    <plazaAsignacion>N</plazaAsignacion>
    <sucursalAsignacion>N</sucursalAsignacion>
    <idUsuarioPresto>N</idUsuarioPresto>
    <nombreUsuarioPresto>N</nombreUsuarioPresto>
  </PrestoCREa>
  <SLAPrestoCREa>
    <idPasoPresto>N</idPasoPresto>
    <nombrePasoPresto>N</nombrePasoPresto>
    <tiempoEjecucion>N</tiempoEjecucion>
  </SLAPrestoCREa>
  <InicioPrestoAvaluoJuridicoCREa>
    <noCtaChequesClientes>15119467</noCtaChequesClientes>
    <opcionPrepago>3</opcionPrepago>
    <importe>750000</importe>
    <esCap>2</esCap>
    <crCap />
    <idTipoPagoCliente>1</idTipoPagoCliente>
    <idPagoVendedor>2</idPagoVendedor>
    <importePagoVendedor />
    <idTipoPagoVendedor />
    <noCuentaVendedor />
    <nombreVendedor>ABC Y CONSTRUCCIONES SA DE CV</nombreVendedor>
    <rfcVendedor>AYC950525AB1</rfcVendedor>
    <direccionVendedor>MADERO 123</direccionVendedor>
    <coloniaVendedor>CENTRO</coloniaVendedor>
    <ciudadEstadoVendedor>MONTERREY, NUEVO LEON</ciudadEstadoVendedor>
    <cpVendedor>0</cpVendedor>
    <telCasaVendedor>8183838292</telCasaVendedor>
    <telOficinaVendedor>8112345678</telOficinaVendedor>
    <reca>0351-138-014592/03-06754-1014</reca>
  </InicioPrestoAvaluoJuridicoCREa>
  <InicioPrestoFechaFirmasCrea>
    <fechaFirma />
    <horaFirma>0</horaFirma>
  </InicioPrestoFechaFirmasCrea>
  <ACOCAperturaCREa>
    <id>0</id>
    <noCredito>N</noCredito>
    <cr>N</cr>
    <importe>N</importe>
    <tipoCredito>N</tipoCredito>
    <ctaCheques>N</ctaCheques>
    <comApertura>N</comApertura>
    <idPeriodicidad>0</idPeriodicidad>
    <tasa>N</tasa>
    <cat>N</cat>
    <modalidad>N</modalidad>
    <moneda>N</moneda>
    <plazo>N</plazo>
    <idGracia>0</idGracia>
    <formaPago>N</formaPago>
    <idTipoCargo>0</idTipoCargo>
    <noCaso>N</noCaso>
    <fechaPrimerPago>N</fechaPrimerPago>
    <opcionPrepago>N</opcionPrepago>
    <idPagoIVA>0</idPagoIVA>
    <gastosInvest>N</gastosInvest>
    <seguroDesempleo>N</seguroDesempleo>
    <baseCalculoSeguro>N</baseCalculoSeguro>
    <valorVivienda>N</valorVivienda>
    <pzoPagaBcoSeguro>0</pzoPagaBcoSeguro>
    <idBonificacion>0</idBonificacion>
  </ACOCAperturaCREa>
  <ACOCDisposicionCREa>
    <id>0</id>
    <noCredito>N</noCredito>
    <fechaDisposicion>07/09/2015</fechaDisposicion>
    <importe>N</importe>
    <montoDisposicion>N</montoDisposicion>
    <comisionMinistracion>N</comisionMinistracion>
    <idComision>0</idComision>
    <gastosInvest>N</gastosInvest>
    <idFormaPago>N</idFormaPago>
    <fechaFirma>N</fechaFirma>
    <montoChequeCaja>N</montoChequeCaja>
    <cuentaConcentradora>N</cuentaConcentradora>
    <fechaVigencia>N</fechaVigencia>
    <nombreVendedor>N</nombreVendedor>
    <nombreNotario>N</nombreNotario>
    <noCtaChequesAcred>N</noCtaChequesAcred>
    <idPagoVendedor>0</idPagoVendedor>
    <idTipoPagoVendedor>0</idTipoPagoVendedor>
    <ctaChequesVendedor>0.0</ctaChequesVendedor>
    <importePagoVendedor>N</importePagoVendedor>
    <importeGastosNotario>N</importeGastosNotario>
    <cuentaGastosNotario>N</cuentaGastosNotario>
    <cuentaHonorariosNotario>N</cuentaHonorariosNotario>
    <importeHonorariosNotario>N</importeHonorariosNotario>
    <noCuenta>N</noCuenta>
    <tipoCaso>N</tipoCaso>
    <crSucursal>N</crSucursal>
    <tipoCredito>N</tipoCredito>
    <modalidad>N</modalidad>
    <nombreCliente>N</nombreCliente>
    <numeroCredito>N</numeroCredito>
    <noAcreditado>N</noAcreditado>
  </ACOCDisposicionCREa>
</DataCREa>'

	insert into [dbo].[tblDataCREa]([xmlDataCREa],fechaRegistro) values(@xmlDataCREa,getdate());

	 set @id= @@identity


set @resultadopaso=( select Container.ContainerCol.value('resultadopaso[1]','int') 
	             from @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container(ContainerCol))

set @noCaso=( select Container.ContainerCol.value('noCaso[1]','nvarchar(30)') 
	             from @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container(ContainerCol))

update  [dbo].[tblDataCREa] set codigo=@resultadopaso, noCaso=@noCaso, status=0 where id=@id


	Select isnull(@resultadopaso,0)as  resultado, @id as id

END
