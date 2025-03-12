--EXEC [SP_InsertarActividad] 10035,'_3hLfwBEhEeWlN-UHR0q9aw',37874,14,0,'HSBC Verifica Politicas de Aceptacion Garantia'      
      
CREATE PROCEDURE [dbo].[uSP_InsertarActividad]
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
      
        DECLARE @idRolExiste BIGINT        
        DECLARE @idUsuarioExiste BIGINT        
        DECLARE @status VARCHAR(300)    
        DECLARE @idx INT   
        DECLARE @id INT              
              
        SET @idRolExiste = @idRol        
        SET @idUsuarioExiste = @idUsuario        
        SET @status = 'Nueva'      
          
           declare @Mostrar bit = 0

			 if @idActividad='_6CiB0EtvEeW4x7dCXQSUkg'
			 begin 
			 set @Mostrar=1 
			 end

      
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
 
     Select @@IDENTITY idExpediente
	
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

    END