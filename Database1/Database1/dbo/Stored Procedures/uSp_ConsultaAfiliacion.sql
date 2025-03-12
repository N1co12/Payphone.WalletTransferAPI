-- =============================================
-- Author:		igs
-- Create date: 02Septiembre2015
-- Description:	Store que consulta catalogos
-- 
-- =============================================
CREATE PROCEDURE  [dbo].[uSp_ConsultaAfiliacion]
	-- Add the parameters for the stored procedure here
	@afilacion int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * from catAfiliacion where IDAFILIACION=@afilacion




END
