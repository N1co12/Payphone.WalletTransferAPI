CREATE PROCEDURE SP_SELECT_SERVICIO_NODO_CAMPO
(
	@IdServicio INT
) AS 
BEGIN 

	SELECT 
		A.IdServicio,
		B.Nombre,
		B.Codigo CodigoServicio,
		C.NombreNodo,
		C.NombreCampo,
		C.TipoDato,
		C.[Min],
		C.[Max],
		C.Formato,
		A.Requerido,
		A.Dependencias,
		A.Condicion
	FROM [CatCamposServicioMapeo] A
		INNER JOIN CatServicio B
			ON A.IdServicio = A.IdServicio
		INNER JOIN CatCamposServicio C
			ON A.IdCampo = C.IdCampo
	WHERE B.IdServicio = @IdServicio AND A.EsActivo = 1 AND B.EsActivo = 1 AND C.Activo = 1 AND
		A.Eliminado = 0 AND B.Eliminado = 0 AND C.Eliminado = 0
END