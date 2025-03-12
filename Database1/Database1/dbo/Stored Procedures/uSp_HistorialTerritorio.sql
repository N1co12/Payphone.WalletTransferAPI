CREATE procedure [dbo].[uSp_HistorialTerritorio]
as
declare @id int = 0, @contador int = 0, @i int = 1, @noCaso nvarchar(50),@xmlDataCREa XML, @valida int, @territorio int,@codigo varchar(50)
create table #tblTemp (noCaso nvarchar(50),id int)
insert #tblTemp
SELECT distinct dc.noCaso , max(dc.id) id FROM tblDataCREa dc  where dc.noCaso is not null  and  dc.xmlDataCREa is not null  group by dc.noCaso
SET @contador = (SELECT max(id) FROM tblDataCREa where id in (select id from #tblTemp))
set @territorio = (select count(*) from tblTerritorial)
if isnull(@territorio,0) = 0 begin
		WHILE @i <= @contador
		BEGIN
			select @noCaso = noCaso, @id=id, @codigo = codigo from tblDataCREa where id=@i and id in (select id from #tblTemp)
			set @xmlDataCREa = (Select top 1 xmlDataCREa from tblDataCREa where  noCaso = @noCaso and id = @id)
			select  @valida = Count(*) from tblDataCREa where convert(nvarchar(max), xmlDataCREa) like '%territorial%' and id = @id
				if isnull(@valida,0) > 0 begin
						insert into tblTerritorial
						SELECT  @id as id, @noCaso as noCaso,   
								isnull(Container.ContainerCol.value('territorial[1]','nvarchar(80)'),'') AS territorial,
								isnull(Container.ContainerCol.value('claveEjecutivo[1]', 'int'),'') AS claveEjecutivo ,
								isnull(Container.ContainerCol.value('nombreEjecutivo[1]','nvarchar(80)'),'') AS nombreEjecutivo,
								isnull(Container.ContainerCol.value('crSucursal[1]','int'),'') AS crSucursal,
								isnull(Container.ContainerCol.value('email[1]','nvarchar(80)'),'') AS email
						FROM  @xmlDataCREa.nodes('//DataCREa//EjecutivosCREa//CREaEjecutivos') AS Container ( ContainerCol ) 
						where Container.ContainerCol.value('tipoEjecutivo[1]','nvarchar(80)') = 'PROMOTOR'
				end
			set @noCaso = ''
			set @i += 1
		end
end 