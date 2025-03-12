-- =============================================
-- Author:		@Mexicano
-- Create date: 07/01/2022
-- Description:	Inicializa wf
--EXEC dbo.usp_InsertarActividad_Presto 1,'_RlockEtsEeW4x7dCXQSUkg',23,0,0,'"Ingreso y Valida Expediente'      
--===============================================================     

CREATE PROCEDURE [dbo].[usp_InsertarActividad_Presto]
    (
      @idExpediente BIGINT ,
      @idActividad VARCHAR(100) ,
      @idWorkFlow BIGINT ,
      @idRol int ,
      @idUsuario int ,
      @descripcion VARCHAR(100)
    )
AS 
    BEGIN          
  
  
  begin try
	begin transaction
		SET NOCOUNT OFF;

				DECLARE @idRolExiste BIGINT        
				DECLARE @idUsuarioExiste BIGINT        
				DECLARE @status VARCHAR(300)    
				DECLARE @idx INT   
				DECLARE @id INT              
              
				SET @idRolExiste = @idRol        
				SET @idUsuarioExiste = @idUsuario        
				SET @status = 'Nueva'      
          
				declare @Mostrar bit = 0

				if @idActividad='_6CiB0EtvEeW4x7dCXQSUkg' set @Mostrar=1 
      
				INSERT  INTO [dbPrestoCibergestionBanorte]..Actividades
						( idExpediente ,
						  idWorkFlow ,
						  idActividad ,
						  idRol ,
						  status ,
						  idUsuario ,
						  descripcion ,
						  fechaAsignacion ,
						  fechaInicio ,
						  fechaAlta ,
						  activo
						  ,mostrarActividad
						)
				VALUES  ( @idExpediente ,
						  @idWorkFlow ,
						  @idActividad ,
						  @idRolExiste ,
						  @status ,
						  @idUsuarioExiste ,
						  @descripcion ,
						  GETDATE() ,
						  GETDATE() ,
						  GETDATE() ,
						  1,
						  @Mostrar
						)          
 
				--Select @@IDENTITY idExpediente
	
				select [Estatus] = CAST(1 as bit), [Mensaje] ='Se ha creado la actividad:  ' +  @descripcion, [Id]= (select @@IDENTITY idExpediente)

				if exists(select 1 from dbPrestoCibergestionBanorte..tblIngreso_DatosCredito where idExpediente = @idExpediente and idSubProducto in (3, 4))
					begin
						if @idActividad = '_VzlLsFJnEeWtpogMRSYlpg' -- Cierre de Cifras
							begin
							  exec dbPrestoCibergestionBanorte..usp_InsertarActividadFovissste @idExpediente, @idWorkFlow
							end
    
						if @idActividad = '_yCdrA1JhEeWtpogMRSYlpg' -- Elabora Proyecto
							begin
									declare @id2 bigint
								  
									select @id2 = id from dbPrestoCibergestionBanorte..Actividades
									where idExpediente = @idExpediente
										and idWorkFlow = @idWorkFlow
										and idActividad = 'Cierre de Cifras Fovissste'
										and status != 'Completada'
      
									exec dbPrestoCibergestionBanorte..usp_CompletarActividad @id2
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
							ERROR_MESSAGE() AS ErrorMessage, GETDATE() AS Fecha_Error, @idUsuario AS USUARIO;
		
				DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
				SELECT @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
				select  [Estatus]=CAST(0 as bit), [Mensaje] =@ErrMsg, [Id]=0   --retonar error en el servicio
				RAISERROR(@ErrMsg, @ErrSeverity, 1)

			end
	end catch


    END
