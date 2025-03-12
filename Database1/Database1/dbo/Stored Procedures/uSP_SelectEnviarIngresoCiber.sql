-- =============================================
-- Author:		lema
-- Create date: 17Sep2015
-- Description:	Store que almacena los datos enviado por el banco en distintas tablas
--  exec uSP_SelectEnviarIngresoCiber 9
-- =============================================
CREATE PROCEDURE [dbo].[uSP_SelectEnviarIngresoCiber]
	-- Add the parameters for the stored procedure here
	 @folioPresto as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON; 
	--Datos generales


SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.nombre, dbo.tblHeader.rfc AS RFC, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblDatosPersonales.nssc, 
                         dbo.tblDatosPersonales.fechaNacimiento, dbo.tblDatosPersonales.codNacionalidad AS Nacionalidad, dbo.tblDatosPersonales.estadoCivil, 
                         dbo.tblDatosDomicilio.mail AS CorreoElectronico, dbo.tblInicioPrestoAvaluoJuridico.noCtaChequesClientes AS NumeroCuentaCheques, 
                         dbo.tblDatosPersonales.tipoParticipante, dbo.catEstadoCivil.CIVIL_DESC AS EstadoCivilCliente
FROM            dbo.catEstadoCivil RIGHT OUTER JOIN
                         dbo.tblDatosPersonales ON dbo.catEstadoCivil.CIVIL_ID = dbo.tblDatosPersonales.estadoCivil RIGHT OUTER JOIN
                         dbo.tblHeader LEFT OUTER JOIN
                         dbo.tblInicioPrestoAvaluoJuridico ON dbo.tblHeader.idPresto = dbo.tblInicioPrestoAvaluoJuridico.idPresto LEFT OUTER JOIN
                         dbo.tblDatosDomicilio ON dbo.tblHeader.idPresto = dbo.tblDatosDomicilio.idPresto ON dbo.tblDatosPersonales.idPresto = dbo.tblHeader.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto) AND (dbo.tblDatosPersonales.tipoParticipante = N'TITULAR')


--Datos del Credito

SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.rfc AS RFC, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblHeader.nombre, 
                         dbo.tblEvalucion.importe AS MontoSolicitado, dbo.tblEvalucion.tasaAplicable AS Tasa, dbo.tblEvalucion.plazo, dbo.tblEvalucion.tipoComision, 
                         dbo.tblACOCApertura.tipoCredito AS Producto, dbo.tblDatosOperacion.idSubproducto AS Subproducto, dbo.tblDatosPersonales.esquemaCredito AS Esquema, 
                         dbo.tblDatosOperacion.comisionApertura
FROM            dbo.tblHeader LEFT OUTER JOIN
                         dbo.tblDatosOperacion ON dbo.tblHeader.idPresto = dbo.tblDatosOperacion.idPresto LEFT OUTER JOIN
                         dbo.tblEvalucion ON dbo.tblHeader.idPresto = dbo.tblEvalucion.idPresto LEFT OUTER JOIN
                         dbo.tblDatosPersonales ON dbo.tblHeader.idPresto = dbo.tblDatosPersonales.idPresto LEFT OUTER JOIN
                         dbo.tblACOCApertura ON dbo.tblHeader.idPresto = dbo.tblACOCApertura.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto)AND (dbo.tblDatosPersonales.tipoParticipante = N'TITULAR')

--Datos ventas         *solo se llenan si hay broker

SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblHeader.nombre, dbo.tblHeader.rfc AS RFC, 
                         dbo.tblHeader.crSucursal AS Sucursal, dbo.tblDatosOperacion.idUsuarioBroker AS nombreEjecutivoVentas, dbo.tblDatosOperacion.idCanalVentas AS Canal, 
                         dbo.tblMemorandum.plazaCredito AS Plaza
FROM            dbo.tblHeader LEFT OUTER JOIN
                         dbo.tblMemorandum ON dbo.tblHeader.idPresto = dbo.tblMemorandum.idPresto LEFT OUTER JOIN
                         dbo.tblDatosOperacion ON dbo.tblHeader.idPresto = dbo.tblDatosOperacion.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto)
--Datos Inmueble

SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblHeader.nombre, dbo.tblHeader.rfc AS RFC, dbo.tblGarantias.calleNum AS Calle, 
                         dbo.tblGarantias.lote + ' , ' + dbo.tblGarantias.manzana AS numeroInteiorYmanzana, dbo.tblGarantias.codigoPostal, dbo.tblGarantias.estado, 
                         dbo.tblGarantias.colonia, dbo.tblGarantias.ejecutivo AS Desarrollador, dbo.catEstados.ESTADO_DESC AS EstadoInmueble
FROM            dbo.catEstados RIGHT OUTER JOIN
                         dbo.tblGarantias ON dbo.catEstados.ESTADO_DESC = dbo.tblGarantias.estado RIGHT OUTER JOIN
                         dbo.tblHeader ON dbo.tblGarantias.idPresto = dbo.tblHeader.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto)

--Datos Conyuge

SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.nombre, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblHeader.rfc AS RFC, 
                         dbo.tblDatosPersonales.conyuge AS nombreConyuge, dbo.tblDatosPersonales.rfcConyuge, dbo.tblDatosPersonales.nssc, 
                         dbo.tblDatosPersonales.tipoParticipante AS conyuge
FROM            dbo.tblHeader LEFT OUTER JOIN
                         dbo.tblDatosPersonales ON dbo.tblHeader.idPresto = dbo.tblDatosPersonales.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto)AND (dbo.tblDatosPersonales.tipoParticipante = N'TITULAR')

----Datos Coacreditado	
SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.nombre, dbo.tblHeader.rfc AS RFC, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblDatosPersonales.nombreParticipante, 
                         dbo.tblDatosPersonales.rfcParticipante, dbo.tblDatosPersonales.lugarNacimiento, dbo.tblDatosPersonales.estadoCivil, dbo.tblDatosPersonales.fechaNacimiento, 
                         dbo.tblDatosPersonales.codNacionalidad AS Nacionalidad, dbo.tblDatosDomicilio.tipo_tel, dbo.tblDatosDomicilio.telefono, 
                         dbo.tblDatosDomicilio.mail AS correoElectronico, dbo.tblDatosPersonales.tipoParticipante, dbo.catEstados.ESTADO_DESC AS Estado, 
                         dbo.catEstadoCivil.CIVIL_DESC AS EstadoCivilCoacreditado
FROM            dbo.tblDatosPersonales LEFT OUTER JOIN
                         dbo.catEstadoCivil ON dbo.tblDatosPersonales.estadoCivil = dbo.catEstadoCivil.CIVIL_ID LEFT OUTER JOIN
                         dbo.catEstados ON dbo.tblDatosPersonales.lugarNacimiento = dbo.catEstados.ESTADO_DESC RIGHT OUTER JOIN
                         dbo.tblHeader LEFT OUTER JOIN
                         dbo.tblDatosDomicilio ON dbo.tblHeader.idPresto = dbo.tblDatosDomicilio.idPresto ON dbo.tblDatosPersonales.idPresto = dbo.tblHeader.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto) AND (dbo.tblDatosPersonales.tipoParticipante = N'COACREDITADO')

--Datos Obligado Solidario

SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.nombre, dbo.tblHeader.rfc AS RFC, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblDatosPersonales.nombreParticipante, 
                         dbo.tblDatosPersonales.rfcParticipante, dbo.tblDatosPersonales.lugarNacimiento, dbo.tblDatosPersonales.estadoCivil, dbo.tblDatosPersonales.fechaNacimiento, 
                         dbo.tblDatosPersonales.codNacionalidad AS Nacionalidad, dbo.tblDatosDomicilio.tipo_tel, dbo.tblDatosDomicilio.telefono, 
                         dbo.tblDatosDomicilio.mail AS correoElectronico, dbo.tblDatosPersonales.tipoParticipante, dbo.catEstados.ESTADO_DESC AS Estado, 
                         dbo.catEstadoCivil.CIVIL_DESC AS EstadoCivilObliSol
FROM            dbo.tblDatosPersonales LEFT OUTER JOIN
                         dbo.catEstadoCivil ON dbo.tblDatosPersonales.estadoCivil = dbo.catEstadoCivil.CIVIL_ID LEFT OUTER JOIN
                         dbo.catEstados ON dbo.tblDatosPersonales.lugarNacimiento = dbo.catEstados.ESTADO_DESC RIGHT OUTER JOIN
                         dbo.tblHeader LEFT OUTER JOIN
                         dbo.tblDatosDomicilio ON dbo.tblHeader.idPresto = dbo.tblDatosDomicilio.idPresto ON dbo.tblDatosPersonales.idPresto = dbo.tblHeader.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto) AND (dbo.tblDatosPersonales.tipoParticipante = N'OBLIGADOSOLIDARIO')

--Datos Garante hipotecario

SELECT        dbo.tblHeader.idPresto, dbo.tblHeader.nombre, dbo.tblHeader.rfc AS RFC, dbo.tblHeader.noCaso AS FolioBanco, dbo.tblDatosPersonales.nombreParticipante, 
                         dbo.tblDatosPersonales.rfcParticipante, dbo.tblDatosPersonales.lugarNacimiento, dbo.tblDatosPersonales.estadoCivil, dbo.tblDatosPersonales.fechaNacimiento, 
                         dbo.tblDatosPersonales.codNacionalidad AS Nacionalidad, dbo.tblDatosDomicilio.tipo_tel, dbo.tblDatosDomicilio.telefono, 
                         dbo.tblDatosDomicilio.mail AS correoElectronico, dbo.tblDatosPersonales.tipoParticipante, dbo.catEstados.ESTADO_DESC AS Estado, 
                         dbo.catEstadoCivil.CIVIL_DESC AS EstadoCivilGaranHipo
FROM            dbo.tblDatosPersonales LEFT OUTER JOIN
                         dbo.catEstadoCivil ON dbo.tblDatosPersonales.estadoCivil = dbo.catEstadoCivil.CIVIL_ID LEFT OUTER JOIN
                         dbo.catEstados ON dbo.tblDatosPersonales.lugarNacimiento = dbo.catEstados.ESTADO_DESC RIGHT OUTER JOIN
                         dbo.tblHeader LEFT OUTER JOIN
                         dbo.tblDatosDomicilio ON dbo.tblHeader.idPresto = dbo.tblDatosDomicilio.idPresto ON dbo.tblDatosPersonales.idPresto = dbo.tblHeader.idPresto
WHERE        (dbo.tblHeader.idPresto = @folioPresto) AND (dbo.tblDatosPersonales.tipoParticipante = N'GARANTEHIPOTECARIO')



END

