-- =============================================
-- Author:		igs
-- Create date: 02Septiembre2015
-- Description:	Store que consulta estatus de la actividad de un folio en especifico
-- [uSp_EstatusActividadPresto] '201509001070531'
-- =============================================
CREATE PROCEDURE  [dbo].[uSp_EstatusActividadPresto]
	-- Add the parameters for the stored procedure here
	@folioBanco nchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @idExpediente int;

	set @idExpediente=(select top 1 idExpediente from dbPrestoCibergestionBanorte..tblIngreso_DatosGenerales where dbPrestoCibergestionBanorte..tblIngreso_DatosGenerales.folioBanco=@folioBanco);
	--Print @idExpediente

	if(exists(select top 1 idExpediente from dbPrestoCibergestionBanorte..tblIngreso_DatosGenerales where dbPrestoCibergestionBanorte..tblIngreso_DatosGenerales.folioBanco=@folioBanco))
	  begin
		   SELECT        @folioBanco as noCaso, dbPrestoCibergestionBanorte.dbo.Actividades.descripcion, dbPrestoCibergestionBanorte.dbo.Actividades.status as estatusActividad, 
								 dbPrestoCibergestionBanorte.dbo.Actividades.fechaAsignacion as fechaInicio, dbPrestoCibergestionBanorte.dbo.Actividades.fechaTermino, dbPrestoCibergestionBanorte.dbo.Usuarios.usuario, 
								 dbPrestoCibergestionBanorte.dbo.Roles.rol, '' AS ComentariosBitacora
		FROM            dbPrestoCibergestionBanorte.dbo.Actividades INNER JOIN
								 dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales ON 
								 dbPrestoCibergestionBanorte.dbo.Actividades.idExpediente = dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales.idExpediente RIGHT OUTER JOIN
								 dbPrestoCibergestionBanorte.dbo.Roles ON dbPrestoCibergestionBanorte.dbo.Actividades.idRol = dbPrestoCibergestionBanorte.dbo.Roles.idRol LEFT OUTER JOIN
								 dbPrestoCibergestionBanorte.dbo.Usuarios ON dbPrestoCibergestionBanorte.dbo.Actividades.idUsuario = dbPrestoCibergestionBanorte.dbo.Usuarios.idUsuario
		WHERE        (dbPrestoCibergestionBanorte.dbo.Actividades.idExpediente = @idExpediente)
		ORDER BY dbPrestoCibergestionBanorte.dbo.Actividades.fechaInicio
	end
	else
	  begin
        declare @FechaInicio datetime
	   set  @idExpediente =(  select top 1    idPresto from tblHeader where nocaso=@folioBanco)
	   set @FechaInicio =( select top 1  fechaRegistro   from tblHeader where nocaso=@folioBanco)
	      
		  if (exists(select top 1    idPresto from tblHeader where nocaso=@folioBanco))
		    begin
		   SELECT        @folioBanco as noCaso, 'Ingreso y Valida Expediente' descripcion, 'Nueva' as  estatusActividad, 
			 @FechaInicio fechaInicio, '' fechaTermino, '' usuario, 
								 'Tecnico Prefirma CG' rol, '' AS ComentariosBitacora
		   end
		   else
		     begin
			   SELECT        '' noCaso, '' descripcion, ' ' as estatusActividad, 
			 '' fechaInicio, '' fechaTermino, '' usuario, 
								 '' rol, 'El número de caso no a ingresado a presto' AS ComentariosBitacora
			 end
		
	  end



END
