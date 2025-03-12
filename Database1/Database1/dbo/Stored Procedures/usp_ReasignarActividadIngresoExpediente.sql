-- =============================================
-- Author:	igs
-- Create date: 26 Enero 2016
-- Description:	Reasiga usuario en actividades cuando ingresa un expediente WebService
--exec usp_ReasignarActividadIngresoExpediente 213
-- =============================================
CREATE PROCEDURE [dbo].[usp_ReasignarActividadIngresoExpediente] @IdExpediente BIGINT
AS 
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
            SET NOCOUNT OFF;
			
            DECLARE @codigoPostal VARCHAR(5)
            DECLARE @idEstado VARCHAR(2)
            DECLARE @menosAsignaciones INT
            DECLARE @idUsuarioAsignar INT

            SET @codigoPostal = ( SELECT TOP 1
                                            codigoPostal
                                  FROM      dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosInmueble
                                  WHERE     idExpediente = @IdExpediente
                                )

            IF ( LEN(@codigoPostal) = 4 ) 
                BEGIN
                    SET @codigoPostal = '0' + @codigoPostal
                END
	
            SELECT TOP 1
                    @idEstado = idEstado
            FROM    dbPrestoCibergestionBanorte.dbo.CatColonias
            WHERE   codigoPostal = @codigoPostal

            SET @menosAsignaciones = ( SELECT   MIN(asignaciones)
                                       FROM     dbPrestoCibergestionBanorte.[dbo].[View_AsignacionesIngresoRol1]
                                       WHERE    estadoRepublica LIKE '%|'
                                                + CAST(@idEstado AS NVARCHAR(2))
                                                + '|%'
                                     )

            SET @idUsuarioAsignar = ( SELECT TOP 1
                                                idUsuario
                                      FROM      dbPrestoCibergestionBanorte.[dbo].[View_AsignacionesIngresoRol1]
                                      WHERE     estadoRepublica LIKE '%|'
                                                + CAST(@idEstado AS NVARCHAR(2))
                                                + '|%'
                                                AND asignaciones = @menosAsignaciones
                                    )

            
			--falta colocar el estatus de la actividad

			-----

            UPDATE  dbPrestoCibergestionBanorte.dbo.Actividades
            SET     idUsuario = ISNULL( @idUsuarioAsignar,0)
            WHERE   idExpediente = @idExpediente
                    AND idUsuario IN ( 16, 0 )
                    AND idActividad = '_RlockEtsEeW4x7dCXQSUkg'
                    AND status <> 'Completada'
                    AND idRol = 1

			

            SET @menosAsignaciones = ( SELECT   MIN(asignaciones)
                                       FROM     dbPrestoCibergestionBanorte.[dbo].[View_AsignacionesIngresoRol4]
                                       WHERE    estadoRepublica LIKE '%|'
                                                + CAST(@idEstado AS NVARCHAR(2))
                                                + '|%'
                                     )
            SET @idUsuarioAsignar = ( SELECT TOP 1
                                                idUsuario
                                      FROM      dbPrestoCibergestionBanorte.[dbo].[View_AsignacionesIngresoRol4]
                                      WHERE     estadoRepublica LIKE '%|'
                                                + CAST(@idEstado AS NVARCHAR(2))
                                                + '|%'
                                                AND asignaciones = @menosAsignaciones
                                    )
					
            UPDATE  dbPrestoCibergestionBanorte.dbo.Actividades
            SET     idUsuario =ISNULL( @idUsuarioAsignar,0)
            WHERE   idExpediente = @idExpediente
                    AND idActividad = '_6CiB0EtvEeW4x7dCXQSUkg'
                    AND status <> 'Completada'
                    AND idRol = 4

-- Después de insertar información en tabla tblIngreso_ValidaExpediente_Asignacion
-- Técnico de avalúos
	
            DECLARE @idTecnicoAvaluos INT
            SET @idTecnicoAvaluos = ( SELECT TOP 1
                                                idUsuario
                                      FROM      dbPrestoCibergestionBanorte.dbo.Actividades
                                      WHERE     idActividad = '_6CiB0EtvEeW4x7dCXQSUkg'
                                                AND idExpediente = @idExpediente
                                      ORDER BY  id DESC
                                    )
            UPDATE  dbPrestoCibergestionBanorte.dbo.tblIngreso_ValidaExpediente_Asignacion
            SET     idTecnicoAvaluo = ISNULL(@idTecnicoAvaluos, 0)
            WHERE   idExpediente = @idExpediente


			--DECLARE @fechaAsignacion DATETIME

   --         SELECT TOP 1 @fechaAsignacion=fechaAsignacion FROM dbPrestoCibergestionBanorte.dbo.Actividades WHERE idActividad = '_4fBQVMPDEeWPlbcvKjZuiw' AND idExpediente=@idExpediente

			--UPDATE dbPrestoCibergestionBanorte.dbo.Actividades SET fechaAsignacion=@fechaAsignacion, fechaAlta=@fechaAsignacion, fechaInicio=@fechaAsignacion WHERE idExpediente=@idExpediente AND idActividad IN('_RlockEtsEeW4x7dCXQSUkg','_6CiB0EtvEeW4x7dCXQSUkg') AND status<>'Completada'

			
            COMMIT
        END TRY

        BEGIN CATCH
            IF ( @@trancount > 0 ) 
                BEGIN    
                    ROLLBACK  TRANSACTION
                    INSERT  INTO dbPrestoCibergestionBanorte.dbo.tblError
                            SELECT  ERROR_NUMBER() AS ErrorNumber ,
                                    ERROR_SEVERITY() AS ErrorSeverity ,
                                    ERROR_STATE() AS ErrorState ,
                                    ERROR_PROCEDURE() AS ErrorProcedure ,
                                    ERROR_LINE() AS ErrorLine ,
                                    ERROR_MESSAGE() AS ErrorMessage ,
                                    GETDATE() AS Fecha_Error ,
                                    16 AS USUARIO;
		
                    DECLARE @ErrMsg NVARCHAR(4000) ,
                        @ErrSeverity INT
                    SELECT  @ErrMsg = ERROR_MESSAGE() ,
                            @ErrSeverity = ERROR_SEVERITY()
                    RAISERROR(@ErrMsg, @ErrSeverity, 1)
                END
        END CATCH
    END
