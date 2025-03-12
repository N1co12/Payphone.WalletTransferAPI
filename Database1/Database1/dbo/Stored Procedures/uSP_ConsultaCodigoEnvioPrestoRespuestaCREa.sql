CREATE procedure uSP_ConsultaCodigoEnvioPrestoRespuestaCREa
@NoCaso varchar(max) = null
as
declare @query varchar(max) = null
select @query = ''
select @query += ' select CD.id Id,CD.noCaso NoCaso,CD.codigo Codigo,CD.fechaEnvio FechadeEnvio, CD.xmlEnvioPrestoCrea XMLEnvio '
select @query += ' , CD.fechaRespuesta FechaRespuesta, CD.xmlRespuestaCreaPresto XMLRespuesta , CD.status Estatus'
select @query += ' from tblCodigoEnvioPrestoRespuestaCREa CD where 1=1 '
if isnull(@NoCaso,'') <> '' begin
	select @query += ' and CD.noCaso = '''+ (CONVERT(nVarChar, @NoCaso))+''''
end
select @query += ' order by CD.noCaso '
exec (@query)
