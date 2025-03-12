-- =============================================
-- Author:		igs
-- Create date: 04Sep2016
-- Description:	Store que recupera los XML a enviar a SOC
-- exec [uSP_RegistraDataCREaSep27] ''
-- =============================================
create PROCEDURE [dbo].[uSP_Select_XMLEnviarServicioSOC]
AS 
    BEGIN
        SET NOCOUNT ON;

        DECLARE @idMax INTEGER

        SET @idMax = ( SELECT   MAX(id)
                       FROM     tblDataCreaServicioSOC
                     )

        SELECT top 1  aa.id ,
                aa.noCaso ,
				aa.codigo,
                aa.xmlDataCREa ,
                aa.fechaRegistro
        FROM    tblDataCREa AA
                CROSS APPLY AA.xmlDataCREa.nodes('/DataCREa//DatosOperacionCREa[1]')
                AS co ( datosOperacion )
        WHERE   datosOperacion.value('idUsuarioBroker[1]', 'int') = 18
                AND fechaRegistro >= '2016-09-01'
                AND codigo IN ( 100, 140 )
                AND aa.id > @idMax

    END