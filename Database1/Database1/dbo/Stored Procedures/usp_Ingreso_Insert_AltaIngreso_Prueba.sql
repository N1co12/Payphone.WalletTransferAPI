--[usp_Ingreso_Insert_AltaIngreso_Prueba] ''
CREATE PROCEDURE [dbo].[usp_Ingreso_Insert_AltaIngreso_Prueba] 
(
	@xmlIngreso XML
)
AS BEGIN

set @xmlIngreso='
<IngresoModel>
  <idExpediente>0</idExpediente>
  <folioBanco>20152012</folioBanco>
  <nombre>IRMA VALDEZ IZQUIERDO</nombre>
  <apellidoPaterno />
  <apellidoMaterno />
  <rfc>VAII500112MI0</rfc>
  <nss />
  <fechaNacimiento>02/11/1945 12:00:00 a. m.</fechaNacimiento>
  <idNacionalidad>1</idNacionalidad>
  <idEstadoCivil>3</idEstadoCivil>
  <idRegimenMatrimonial>1</idRegimenMatrimonial>
  <numeroCuenta>201434479</numeroCuenta>
  <telefonoCasa>015555517481</telefonoCasa>
  <correoElectronico>sin_email@sinemail.com</correoElectronico>
  <empleadoBanco>false</empleadoBanco>
  <montoSolicitado>0.00</montoSolicitado>
  <tasaInteres>0.00</tasaInteres>
  <idPlazo>0</idPlazo>
  <idTipoComision>0</idTipoComision>
  <idProducto>0</idProducto>
  <idSubProducto>0</idSubProducto>
  <idEsquema>0</idEsquema>
  <comisionApertura>0</comisionApertura>
  <factorPago>0</factorPago>
  <idEjecutivoVentas>0</idEjecutivoVentas>
  <idCanal>0</idCanal>
  <idSucursal>0</idSucursal>
  <idPlaza>0</idPlaza>
  <idPromocionEspecial>0</idPromocionEspecial>
  <idTerritorio>0</idTerritorio>
  <idUsuarioRegistra>0</idUsuarioRegistra>
  <idEstado>0</idEstado>
  <idDelegacionMunicipio>0</idDelegacionMunicipio>
  <idColonia>0</idColonia>
  <idDesarrollador>0</idDesarrollador>
  <idEjecutivoAnalista>0</idEjecutivoAnalista>
  <idTecnicoAvaluos>0</idTecnicoAvaluos>
  <dictaminacionR1>false</dictaminacionR1>
  <dictaminacionR2>false</dictaminacionR2>
  <dictaminacionR3>false</dictaminacionR3>
  <dictaminacionR4>false</dictaminacionR4>
  <dictaminacionR5>false</dictaminacionR5>
  <dictaminacionR6>false</dictaminacionR6>
  <dictaminacionR7>false</dictaminacionR7>
  <dictaminacionR8>false</dictaminacionR8>
  <idMotivoRechazoR1>0</idMotivoRechazoR1>
  <idMotivoRechazoR2>0</idMotivoRechazoR2>
  <idMotivoRechazoR3>0</idMotivoRechazoR3>
  <idMotivoRechazoR4>0</idMotivoRechazoR4>
  <idMotivoRechazoR5>0</idMotivoRechazoR5>
  <idMotivoRechazoR6>0</idMotivoRechazoR6>
  <idMotivoRechazoR7>0</idMotivoRechazoR7>
  <idMotivoRechazoR8>0</idMotivoRechazoR8>
  <valorCompraVenta>0.00</valorCompraVenta>
  <idEstatusGeneral>0</idEstatusGeneral>
  <conyuge_idSexo>0</conyuge_idSexo>
  <conyuge_idNacionalidad>0</conyuge_idNacionalidad>
  <coacreditado_cuentaHabiente>false</coacreditado_cuentaHabiente>
  <coacreditado_idSexo>0</coacreditado_idSexo>
  <coacreditado_idNacionalidad>0</coacreditado_idNacionalidad>
  <coacreditado_idEdoCivil>0</coacreditado_idEdoCivil>
  <coacreditado_idRegimenMatrimonial>0</coacreditado_idRegimenMatrimonial>
  <coacreditado_idParentesco>0</coacreditado_idParentesco>
  <coacreditado_idCompruebaIngresos>0</coacreditado_idCompruebaIngresos>
  <solidario_cuentaHabiente>false</solidario_cuentaHabiente>
  <solidario_idSexo>0</solidario_idSexo>
  <solidario_idNacionalidad>0</solidario_idNacionalidad>
  <solidario_idEdoCivil>0</solidario_idEdoCivil>
  <solidario_idRegimenMatrimonial>0</solidario_idRegimenMatrimonial>
  <solidario_idParentesco>0</solidario_idParentesco>
  <solidario_idCompruebaIngresos>0</solidario_idCompruebaIngresos>
  <garante_cuentaHabiente>false</garante_cuentaHabiente>
  <garante_idSexo>0</garante_idSexo>
  <garante_idNacionalidad>0</garante_idNacionalidad>
  <garante_idEdoCivil>0</garante_idEdoCivil>
  <garante_idRegimenMatrimonial>0</garante_idRegimenMatrimonial>
  <garante_idParentesco>0</garante_idParentesco>
  <garante_idCompruebaIngresos>0</garante_idCompruebaIngresos>
</IngresoModel>
'
	
		
	    EXEC [dbPrestoCibergestionBanorte].[dbo].[usp_Ingreso_Insert_AltaIngreso] @xmlIngreso

END




