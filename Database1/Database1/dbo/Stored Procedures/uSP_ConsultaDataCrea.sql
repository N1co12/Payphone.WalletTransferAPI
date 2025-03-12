CREATE procedure [dbo].[uSP_ConsultaDataCrea]
@NoCaso varchar(max) = null,
@id varchar(max) = null
as
declare @query varchar(max) = null
select @query = ''
select @query += ' select DC.id Id,DC.noCaso NoCaso,DC.codigo Codigo, DC.xmlDataCrea XML, DC.fechaRegistro FechadeRegistro '
select @query += ' , DC.status Estatus,DC.Comentarios, DC.enviadoPresto EnviadoPresto '
select @query += ' from tblDataCREa DC where 1=1 '
if isnull(@NoCaso,'') <> '' begin
	select @query += ' and DC.noCaso = '''+ (CONVERT(nVarChar, @NoCaso))+''''
end
if isnull(@id,'') <> '' begin
	select @query += ' and DC.id = '''+ (CONVERT(nVarChar, @id))+''''
end
exec(@query)
