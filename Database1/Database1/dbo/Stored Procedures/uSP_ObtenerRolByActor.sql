create PROCEDURE [dbo].[uSP_ObtenerRolByActor](@actor varchar(200))
AS
BEGIN
	  select *
	  from  dbPrestoCibergestionBanorte.dbo.Roles
	  where  actor =@actor --'_vOTfMKyXEeCsdZnrYMBSug' --
END