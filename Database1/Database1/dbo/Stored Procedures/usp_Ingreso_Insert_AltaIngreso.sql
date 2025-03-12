--[usp_Ingreso_Insert_AltaIngreso] ''
CREATE PROCEDURE [dbo].[usp_Ingreso_Insert_AltaIngreso] 
(
	@xmlIngreso XML
)
AS BEGIN
 EXEC dbPrestoCibergestionBanorte.dbo.usp_Ingreso_Insert_AltaIngreso @xmlIngreso
END




