CREATE procedure uSP_RespaldaTerritorio
@parametroid int = null,
@parammetroNoCaso varchar(30) = null
as
declare @codigo int = 0, @xmlDataCREa xml
create table #tblTerritorial(id int,noCaso nvarchar(50),territorial nvarchar(50), claveEjecutivo int, nombreEjecutivo nvarchar(50), crSucursal int, email nvarchar(50))
begin
set @xmlDataCREa = (Select top 1 xmlDataCREa from tblDataCREa where noCaso = @parammetroNoCaso and id = @parametroid)
select  @codigo = Codigo from tblDataCREa where id = @parametroid
if isnull(@codigo,0) = 100 begin
--Respalda un noCaso con 100 en tblTerritorio
	insert into tblTerritorial
	SELECT  @parametroid as id, @parammetroNoCaso as noCaso,   
			isnull(Container.ContainerCol.value('territorial[1]','nvarchar(80)'),'') AS territorial,
			isnull(Container.ContainerCol.value('claveEjecutivo[1]', 'int'),'') AS claveEjecutivo ,
			isnull(Container.ContainerCol.value('nombreEjecutivo[1]','nvarchar(80)'),'') AS nombreEjecutivo,
			isnull(Container.ContainerCol.value('crSucursal[1]','int'),'') AS crSucursal,
			isnull(Container.ContainerCol.value('email[1]','nvarchar(80)'),'') AS email
	FROM  @xmlDataCREa.nodes('//DataCREa//EjecutivosCREa//CREaEjecutivos') AS Container ( ContainerCol ) 
	where Container.ContainerCol.value('tipoEjecutivo[1]','nvarchar(80)') = 'PROMOTOR'
end else if isnull(@codigo,0) = 140 begin
	insert into #tblTerritorial
	SELECT  @parametroid as id, @parammetroNoCaso as noCaso,   
			isnull(Container.ContainerCol.value('territorial[1]','nvarchar(80)'),'') AS territorial,
			isnull(Container.ContainerCol.value('claveEjecutivo[1]', 'int'),'') AS claveEjecutivo ,
			isnull(Container.ContainerCol.value('nombreEjecutivo[1]','nvarchar(80)'),'') AS nombreEjecutivo,
			isnull(Container.ContainerCol.value('crSucursal[1]','int'),'') AS crSucursal,
			isnull(Container.ContainerCol.value('email[1]','nvarchar(80)'),'') AS email
	FROM  @xmlDataCREa.nodes('//DataCREa//EjecutivosCREa//CREaEjecutivos') AS Container ( ContainerCol ) 
	where Container.ContainerCol.value('tipoEjecutivo[1]','nvarchar(80)') = 'PROMOTOR'
--Actualiza un noCaso con 140 en tblTerritorio
	update tblTerritorial set 
			territorial = (select territorial from #tblTerritorial), 
			claveEjecutivo = (select claveEjecutivo from #tblTerritorial),
			nombreEjecutivo = (select nombreEjecutivo from #tblTerritorial),
			crSucursal = (select crSucursal from #tblTerritorial), 
			email = (select email from #tblTerritorial)
			where id = @parametroid and noCaso = @parammetroNoCaso

	drop table #tblTerritorial
	end
end 
