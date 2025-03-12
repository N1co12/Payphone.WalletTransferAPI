-- =============================================
-- Author:		igs
-- Create date: 07Sep2015
-- Description:	Store que almacena los datos enviado por el banco en distintas tablas
--  exec uSP_RegistraExpedienteCREa true, '', '07/09/2015',16,''
-- =============================================
CREATE PROCEDURE [dbo].[uSP_RegistraExpedienteCREa]
	-- Add the parameters for the stored procedure here
	 @status bit,
     @Comentarios nvarchar(500),
	 @idTblDataCREa int,
	 @xmlDataCREa xml

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @resultadopaso int
	declare @idPresto int

begin try
	begin transaction

	



	--Actualiza el estatus del xml enviado por el banco.
	update tblDataCREa set status=@status, Comentarios=@Comentarios, fechaValidacion=getdate() where id=@idTblDataCREa


	--Distribucion del xml en distintas tablas

	set @resultadopaso=( select Container.ContainerCol.value('resultadopaso[1]','int') 
	             from @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container(ContainerCol))


	if( @resultadopaso =100)
	  begin
	    declare @noCaso nvarchar(30)

		set @noCaso=( select Container.ContainerCol.value('noCaso[1]','nvarchar(30)') 
	             from @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container(ContainerCol))
		print @noCaso
        
		 if(Exists(Select * from [dbo].[tblHeader] where [noCaso]=@noCaso))
		   begin
		     
			  update [dbo].[tblDataCREa] set [status]=0,[Comentarios]='El número de caso existe en el flujo, por codigo 100 no puede ser procesado', fechaValidacion=getdate() where id=@idTblDataCREa
			  --Respuesta
			  Select 0 as ResultadoPaso, 'El número de caso existe en el flujo, por codigo 100 no puede ser procesado' as Comentarios, getdate() as FechaHrEnvio
		   end
		 else
		   begin
		     

			--  --header
			   insert into [dbo].[tblHeader] (nombre,idPrograma,destino,banco,rfc,crSucursal,noCaso,bancoCte,noCliente,usrAsignado,tipoCredito,fechaRegistro)
			    select   
						Container.ContainerCol.value('nombre[1]','nvarchar(80)') as nombre,
						Container.ContainerCol.value('idPrograma[1]','nvarchar(50)') as idPrograma,
						Container.ContainerCol.value('destino[1]','nvarchar(50)') as destino,
						Container.ContainerCol.value('banco[1]','nvarchar(50)') as banco,
						Container.ContainerCol.value('rfc[1]','varchar(20)') as rfc,
						Container.ContainerCol.value('crSucursal[1]','nvarchar(80)') as crSucursal,
						Container.ContainerCol.value('noCaso[1]','nvarchar(50)') as noCaso,
						Container.ContainerCol.value('bancoCte[1]','varchar(20)') as bancoCte,
						Container.ContainerCol.value('noCliente[1]','nvarchar(30)') as noCliente,
						Container.ContainerCol.value('usrAsignado[1]','nvarchar(50)') as usrAsignado,
						Container.ContainerCol.value('tipoCredito[1]','varchar(20)') as tipoCredito,
						getdate()  as fechaRegistro
					  from @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container(ContainerCol)

				
				 set @idPresto=@@IDENTITY
				 print @idPresto
			     
				 Select 1 as ResultadoPaso, 'Caso Registrado Con Éxito, folio:'+ cast(@idTblDataCREa as nvarchar(20)) as Comentarios, getdate() as FechaHrEnvio
		   end
		   
	     
	  end
commit
	end try
	begin catch
		if(@@trancount > 0)      
			begin    
				rollback  transaction
				INSERT INTO tblError SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity,
							ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine,
							ERROR_MESSAGE() AS ErrorMessage, GETDATE() AS Fecha_Error, 0 AS USUARIO;
		
				DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
				SELECT @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			end
	end catch

END
