-- =============================================
-- Author:		igs
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec  uSp_ConsultaXMLDataCREaProduccion '201511007380154'
-- =============================================
create PROCEDURE [dbo].[uSp_ConsultaXMLDataCREaPresto]
	-- Add the paramers for the stored procedure here
	@noCaso NVARCHAR(30)
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @xmlDataCREa XML

		DECLARE @idMax BIGINT
  
        SET @idMax=(SELECT MAX(id) FROM dbo.tblDataCREa WHERE noCaso=@noCaso)
  
        

       SET @xmlDataCREa=( SELECT xmlDataCREa FROM dbo.tblDataCREa WHERE id=@idMax)

		
                       

    


    END
