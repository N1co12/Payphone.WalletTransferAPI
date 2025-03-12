CREATE procedure uSP_RespaldaTerritorial
as
declare @maxID int
declare @ID int
declare @noCaso nvarchar(30)
declare @xmlDataCREa xml
truncate table tblTerritorial
DECLARE cursor_emp CURSOR STATIC
FOR Select distinct  noCaso  from tblDataCREa where noCaso is not null and Codigo = 100 or Codigo  =140;
--Apertura del cursor
OPEN cursor_emp;
-- Primer resultado del FETCH
FETCH cursor_emp INTO @noCaso;
--Bucle de lectura
WHILE (@@FETCH_STATUS = 0 )
BEGIN;
--Transferir los registros a la nueva tabla
  set @maxID=(Select max(id)  from tblDataCREa where noCaso=@noCaso)
  set @xmlDataCREa=(Select top 1 xmlDataCREa  from tblDataCREa where id=@maxID and convert(nvarchar(max), xmlDataCREa) like '%territorial%')
  insert into dbPrestoCibergestionBanorte..tblTerritorial
  SELECT  @maxID id,@noCaso as noCaso,   
				 Container.ContainerCol.value('tipoEjecutivo[1]','nvarchar(80)') AS tipoEjecutivo,
                Container.ContainerCol.value('claveEjecutivo[1]', 'int') AS claveEjecutivo ,
                Container.ContainerCol.value('nombreEjecutivo[1]','nvarchar(80)') AS nombreEjecutivo,
				Container.ContainerCol.value('crSucursal[1]','int') AS crSucursal,
				Container.ContainerCol.value('sucursal[1]','nvarchar(25)') AS sucursal,
				Container.ContainerCol.value('regional[1]','nvarchar(25)') AS regional,
				Container.ContainerCol.value('territorial[1]','nvarchar(80)') AS territorial,
				Container.ContainerCol.value('delegacionMunicipio[1]','nvarchar(25)') AS delegacionMunicipio,
				Container.ContainerCol.value('estado[1]','nvarchar(25)') AS estado,
				Container.ContainerCol.value('email[1]','nvarchar(80)') AS email
        FROM   @xmlDataCREa.nodes('//DataCREa//EjecutivosCREa//CREaEjecutivos') AS Container ( ContainerCol ) 
--enesima iteración sobre el cursor
FETCH cursor_emp INTO @noCaso;
END;
-- Cierre del cursor
CLOSE cursor_emp
-- Limpieza
DEALLOCATE cursor_emp;
