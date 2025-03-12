-- =============================================
-- Author:		igs
-- Create date: 02Septiembre2015
-- Description:	Store que consulta catalogos
-- 
-- =============================================
CREATE PROCEDURE  [dbo].[uSp_ConsultaEstado]
	-- Add the parameters for the stored procedure here
	@estado varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * from catEstados where Estado_desc=@estado




END
