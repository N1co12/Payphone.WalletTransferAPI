-- =============================================
-- Author:		Eduardo
-- Create date: 31-Agosto-2015
-- Description:	Store que almacena los datos enviado por el banco en formato XML sin Procesarlo
-- exec [uSP_RegistraDataCREaSep27] ''
-- =============================================
CREATE PROCEDURE [dbo].[uSP_RegistraDataCREa]

    @xmlDataCREa XML

AS 
    BEGIN

        SET NOCOUNT ON;

        Declare @resultadopaso INT
        Declare @noCaso NVARCHAR(30)
        Declare @id INT
        Declare @idExpediente BIGINT

		SET @resultadopaso = (Select Container.ContainerCol.value('resultadopaso[1]', 'int')
								from @xmlDataCREa.nodes('//DataCREa//FlujoCREa') AS Container(ContainerCol))

        SET @noCaso = (Select Container.ContainerCol.value('noCaso[1]', 'nvarchar(30)')
						from @xmlDataCREa.nodes('//DataCREa//HeaderCREa') AS Container (ContainerCol))

		Insert into [dbo].[tblDataCREa] (xmlDataCREa, fechaRegistro, codigo, noCaso)
			values (@xmlDataCREa, current_timestamp, @resultadopaso,  @noCaso)

        set @id = @@identity

        if(@resultadopaso not in (100))
            begin
                set @idExpediente = (Select top 1 idExpediente from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where folioBanco = @noCaso) 

                if(@idExpediente > 0) 
					begin
                        if(@resultadopaso in (200))				-- Cancelar folio
                            begin
                                exec dbPrestoCibergestionBanorte.dbo.usp_Update_Expediente_Cancelar @idExpediente
                            end
						else if(@resultadopaso in (195))		-- Disposición de crédito
							begin
								Update dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosCredito set
										  numeroAcreditado = ACOCDisposicionCREa.value('noAcreditado[1]','nvarchar(30)')
										, numeroCredito = ACOCDisposicionCREa.value('numeroCredito[1]','nvarchar(30)')
									from @xmlDataCREa.nodes('//DataCREa//ACOCDisposicionCREa')Catalog(ACOCDisposicionCREa)
								where idExpediente = @idExpediente
							end
						else if(@resultadopaso in (180))
							begin
								if exists(select 1 from dbPrestoCibergestionBanorte.dbo.tblCierreCifras where idExpediente = @idExpediente)
									begin
										Update dbPrestoCibergestionBanorte.dbo.tblCierreCifras set
											cat = isNull(ACOCAperturaCREa.value('(cat/text())[1]', 'decimal(18, 2)'), 0)
										from @xmlDataCrea.nodes('//DataCREa//ACOCAperturaCREa') as nodo01(ACOCAperturaCREa)
										where idExpediente = @idExpediente
									end
							end
                        else
                            begin
								if(@resultadopaso in (140))
									begin
										-- Reactivar folio rechazado
										exec dbPrestoCibergestionBanorte.dbo.usp_Update_Rechazo_Reactivar @noCaso

										-- Actualizar información de pago al vendedor (aplica una vez que se encuentra o pasa por programación firma)
										if exists (Select 1 from dbPrestoCibergestionBanorte.dbo.tblProgramacionFirma_CuentasDispersion where idExpediente = @idExpediente and figura = 'vendedor')
											begin
												Update dbPrestoCibergestionBanorte.dbo.tblProgramacionFirma_CuentasDispersion 
													set 
														  idBanco			= iif(Vendedor.value('(idPagoVendedor/text())[1]'	, 'int') in (1), dbPrestoCibergestionBanorte.dbo.tblProgramacionFirma_CuentasDispersion.idBanco, 0)
														, idTipoDispersion	= iif(Vendedor.value('(idPagoVendedor/text())[1]'	, 'int') in (1), B.id, 0)
														, cuenta			= Vendedor.value('(noCuentaVendedor/text())[1]'		, 'nvarchar(20)')
														, montoPago			= isNull(Vendedor.value('(importePagoVendedor/text())[1]'	, 'decimal(18, 2)'), 0)
														, idUsuarioModifica = 0
														, fechaModifica		= current_timestamp
													from @xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa')Catalog(Vendedor)
														left join dbPrestoCibergestionBanorte.dbo.CatFormasPago B on B.tipo = 2 and B.idForma = isNull(Vendedor.value('(idTipoPagoVendedor/text())[1]', 'int'), 0)
												where 
													figura = 'vendedor' and idExpediente = @idExpediente
											end

										if exists(select 1 from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosCredito where idExpediente = @idExpediente)
											begin
												Update dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosCredito set
													  FechaConsultaBuro	= fillers.value('(Filler1/text())[1]','nvarchar(10)')
													, MargenTolerancia	= iif(fillers.value('(Filler3/text())[1]','nvarchar(15)') is not null, fillers.value('(Filler3/text())[1]', 'decimal(18,2)'), 0)
													, OpcionPrepago		= isNull(juridicoCrea.value('(opcionPrepago/text())[1]','int'), 0)
                          , comisionInvestigacion = case ISNUMERIC(OperacionCREa.value('(comInvest/text())[1]','nvarchar(20)')) when 0 then 0 else OperacionCREa.value('(comInvest/text())[1]','decimal(18, 2)') end
												from @xmlDataCrea.nodes('//DataCREa//FillersCREa') as nodo01(fillers)
													cross apply @xmlDataCrea.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa') as nodo02(juridicoCrea)
                          cross apply @xmlDataCrea.nodes('/DataCREa/DatosOperacionCREa[1]') as y(OperacionCREa)
												where dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosCredito.idExpediente = @idExpediente
											end

										if exists(select 1 from dbPrestoCibergestionBanorte.dbo.tblCierreCifras where idExpediente = @idExpediente)
											begin
												Update dbPrestoCibergestionBanorte.dbo.tblCierreCifras set
													cat = isNull(ACOCAperturaCREa.value('(cat/text())[1]', 'decimal(18, 2)'), 0)
												from @xmlDataCrea.nodes('//DataCREa//ACOCAperturaCREa') as nodo01(ACOCAperturaCREa)
												where idExpediente = @idExpediente
											end

										if exists(select 1 from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where idExpediente = @idExpediente)
										begin
											update dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales set
												domiciliacionCuentaClabe = juridicoCrea.value('(domiciliacionCuentaCLABE/text())[1]','nvarchar(25)')
											from @xmlDataCrea.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa') as nodo02(juridicoCrea)
											where dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales.idExpediente = @idExpediente
										end
                    
                    if exists(select 1 from dbPrestoCibergestionBanorte..tblIngreso_DatosCredito where idExpediente = @idExpediente and idProducto in (2, 9, 10))
                    begin
                      exec dbPrestoCibergestionBanorte.dbo.usp_Select_SolicitudMinistracion @idExpediente
                    end
									end

                                --Insert into dbo.tblAvanzarCodigo values (@noCaso, @idExpediente, @resultadopaso, current_timestamp, 1)
                            end
                    end
            end      

        Select  isNull(@resultadopaso, 0) as resultado, @id as id

    END
