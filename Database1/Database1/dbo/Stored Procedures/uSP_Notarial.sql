-- =============================================
-- Author:		igs
-- Create date: 28 sep
-- Description:	Recolectar datos a enviar a Presto en Notarial
-- exec uSP_Notarial 10233 
-- =============================================
CREATE PROCEDURE [dbo].[uSP_Notarial]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 decLARE @xmlDataCREa xml

set @xmlDataCREa=(select xmlDataCREa from tblDataCREa where id=@id) --10233


--flujo
			   
			    select 
						Container.ContainerCol.value('resultadopaso[1]','int') as resultadopaso,
						Container.ContainerCol.value('idTipoRechazo[1]','smallint') as idTipoRechazo,
						Container.ContainerCol.value('idmotivorechazo[1]','int') as idmotivorechazo,
						Container.ContainerCol.value('resultadoNotificacion[1]','bit') as resultadoNotificacion,
						Container.ContainerCol.value('comentarios[1]','nvarchar(3000)') as comentarios,
						Container.ContainerCol.value('fecha[1]','nvarchar(20)') as fecha,
						Container.ContainerCol.value('status[1]','bit') as status,
						Container.ContainerCol.value('mensaje[1]','nvarchar(3000)') as mensaje
	                    from @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container(ContainerCol)
             
--Memorandum
                

				select    					
						Container.ContainerCol.value('nombreNotario[1]','nvarchar(120)') as nombreNotario,
						Container.ContainerCol.value('razonSocial[1]','nvarchar(120)') as razonSocial,
						Container.ContainerCol.value('numeroNotaria[1]','nvarchar(120)') as numeroNotaria,
						Container.ContainerCol.value('entidad[1]','int') as entidad,
						Container.ContainerCol.value('notariaPadron[1]','int') as notariaPadron					
						from @xmlDataCREa.nodes('//DataCREa//MemorandumCREa')  AS Container(ContainerCol)
--ACOCDisposicion
			       

			       select    
						Container.ContainerCol.value('nombreNotario[1]','nvarchar(50)') as nombreNotario,
						Container.ContainerCol.value('importeHonorariosNotario[1]','nvarchar(50)') as importeHonorariosNotario
						from @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa')  AS Container(ContainerCol)

END



