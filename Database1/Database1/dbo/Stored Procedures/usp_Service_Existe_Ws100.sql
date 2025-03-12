-- =============================================
-- Author:		Mexicano
-- Create date: 08/06/2022
-- Description:	Validad si ya existe el servicio 100
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Existe_Ws100]
(
	@folioBanco VARCHAR(25)
)
AS
BEGIN 
	SET NOCOUNT ON;


	IF EXISTS (SELECT 1 FROM tblHeader WHERE noCaso = @folioBanco)
		SELECT [Estatus]= CAST(1 as bit), [Mensaje]='El número de caso existe en el flujo, codigo 100 no puede ser procesado.',[Id] =0
	ELSE
		SELECT [Estatus]= CAST(0 as bit), [Mensaje]='No existe el codigo 100',[Id] =0
		

END
