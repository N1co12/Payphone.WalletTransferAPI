CREATE PROCEDURE [dbo].[usp_Select_Reproceso_Info_CambioCE]
	
	@IdActividad varchar(30)

AS
BEGIN
	set nocount on;
	set transaction isolation level read uncommitted

    Select 
		  [IdReproceso] = A.Id
		, [IdCasoReproceso] = A.IdCasoReproceso
		, [MarcadoTibco] = A.MarcadoTibco
		, [Transicion] = B.TransicionAvanzar
	from [dbPrestoCibergestionBanorte].[dbo].[CatReprocesoCasosUso] A 
		inner join [dbPrestoCibergestionBanorte].[dbo].[CatReprocesoCasosUso_Regreso] B on B.IdCasoReproceso = A.IdCasoReproceso
	where NombreReproceso = 'Cambio en monto CE' and IdActividad = @IdActividad

END
