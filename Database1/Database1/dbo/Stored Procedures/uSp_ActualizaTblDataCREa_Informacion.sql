CREATE procedure [dbo].[uSp_ActualizaTblDataCREa_Informacion]
as
begin
truncate table tblDataCREa_Informacion

declare @id int = 0, @contador int = 0, @i int = 0, @noCaso nvarchar(50),@xmlDataCREa XML, @repetido nvarchar(50)
create table #tblTemp (noCaso nvarchar(50),id int)
insert #tblTemp
SELECT distinct dc.noCaso , max(dc.id) id FROM tblDataCREa dc GROUP BY dc.noCaso

SET @contador = (SELECT max(id) FROM tblDataCREa where id in (select id from #tblTemp))
	WHILE @i <= @contador
	BEGIN
		select @noCaso = noCaso, @id=id from tblDataCREa where id=@i and id in (select id from #tblTemp)
		set @xmlDataCREa = (Select top 1 xmlDataCREa from tblDataCREa where noCaso=@noCaso)
		insert into tblDataCREa_Informacion
		SELECT @id as id, @noCaso as noCaso,   
		isnull(Container.ContainerCol.value('decreto[1]','nvarchar(20)'),'') AS decreto,
		Container.ContainerCol.value('fechaEvaluacion[1]','nvarchar(12)') AS fechaEvaluacion,
		isnull(Container1.ContainerCol1.value('idTipoPagoCliente[1]','nvarchar(3)'),'') AS TipoPagoCliente,
		isnull(Container1.ContainerCol1.value('idTipoPagoVendedor[1]','nvarchar(3)'),'') AS TipoPagoVendedor
		FROM   @xmlDataCREa.nodes('//DataCREa//EvalucionCREa') AS Container ( ContainerCol ),
		@xmlDataCREa.nodes('//DataCREa//InicioPrestoAvaluoJuridicoCREa') AS Container1 ( ContainerCol1 )
				set @noCaso = ''
		set @i += 1
	end

drop table	#tblTemp 

insert into [dbPrestoCibergestionBanorte]..tblDataCREa_Informacion
(idExpediente,	decreto,	fechaEvaluacion,	idTipoPagoCliente,	idTipoPagoVendedor)
select * from [dbo].[View_tblDataCREa_Informacion]
where idexpediente not in
(select idExpediente from [dbPrestoCibergestionBanorte]..tblDataCREa_Informacion)

end


