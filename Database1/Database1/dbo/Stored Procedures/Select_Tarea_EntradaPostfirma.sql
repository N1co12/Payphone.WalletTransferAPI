
-- =============================================
-- Create date: 06-08-2021
-- Description:	Folio dispuesto no enviado a postfirma
-- =============================================
--	exec	Select_Tarea_EntradaPostfirma
CREATE  PROCEDURE [dbo].[Select_Tarea_EntradaPostfirma]
		
AS
BEGIN
	SET NOCOUNT ON;

	--mejoras en caso de que no se registre en la recepcion del codigo 195, registrar los casos dispuestos del dia

	insert into [dbPrestoCibergestionBanorte].[dbo].[tblHistorial_Entrada_WsPostFirma]
		select 
				 DC.nocaso
				 ,(SELECT top 1 idExpediente from [dbPrestoCibergestionBanorte].[dbo].[tbldatacrea] where nocaso=DC.nocaso)
				 ,0
				 ,'No se registro en la recepcion del 195'
				 ,''
				 , DC.fechaRegistro
				 ,null
				 ,null
		from tbldatacrea DC
		left join  [dbPrestoCibergestionBanorte].[dbo].[tblHistorial_Entrada_WsPostFirma] EP ON EP.folioBanco = DC.nocaso
		where 
					DC.codigo=195 
			and		status=1  
			and		CONVERT(varchar,DC.fecharegistro,3) =  CONVERT(varchar,getdate(),3) 
			AND		isnull(EP.idExpediente,0)=0




	Select idExpediente from [dbPrestoCibergestionBanorte].[dbo].[tblHistorial_Entrada_WsPostFirma] WHERE estatus=0 order by fechaAlta

END

