-- =============================================
-- Author:		igs
-- Create date: 02Septiembre2015
-- Description:	Store que consulta catalogos
-- exec [dbo].[uSP_RegistraCatalogo] '','Estados'
-- =============================================
CREATE PROCEDURE  [dbo].[uSP_RegistraCatalogo]
	-- Add the parameters for the stored procedure here
	 @xmlCat xml,
     @nombreCatalogo nvarchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	if(@nombreCatalogo='Estados')
	  begin
	     set @xmlCat='<ArrayOfEstados>
  <Estados>
    <ESTADO_DESC>Aguascalientes</ESTADO_DESC>
    <ESTADO_ID>AGS</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Baja California Norte</ESTADO_DESC>
    <ESTADO_ID>BCN</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Baja California Sur</ESTADO_DESC>
    <ESTADO_ID>BCS</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Campeche</ESTADO_DESC>
    <ESTADO_ID>CAM</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Chiapas</ESTADO_DESC>
    <ESTADO_ID>CHI</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Chihuahua</ESTADO_DESC>
    <ESTADO_ID>CHS</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Coahuila</ESTADO_DESC>
    <ESTADO_ID>COA</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Colima</ESTADO_DESC>
    <ESTADO_ID>COL</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Distrito Federal</ESTADO_DESC>
    <ESTADO_ID>DF</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Durango</ESTADO_DESC>
    <ESTADO_ID>DGO</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Estado De Mexico</ESTADO_DESC>
    <ESTADO_ID>EM</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Guerrero</ESTADO_DESC>
    <ESTADO_ID>GRO</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Guanajuato</ESTADO_DESC>
    <ESTADO_ID>GTO</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Hidalgo</ESTADO_DESC>
    <ESTADO_ID>HGO</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Jalisco</ESTADO_DESC>
    <ESTADO_ID>JAL</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Michoacan</ESTADO_DESC>
    <ESTADO_ID>MICH</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Morelos</ESTADO_DESC>
    <ESTADO_ID>MOR</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Nayarit</ESTADO_DESC>
    <ESTADO_ID>NAY</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Nuevo León</ESTADO_DESC>
    <ESTADO_ID>NL</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Oaxaca</ESTADO_DESC>
    <ESTADO_ID>OAX</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Puebla</ESTADO_DESC>
    <ESTADO_ID>PUE</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Querétaro</ESTADO_DESC>
    <ESTADO_ID>QR</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Quintana Roo</ESTADO_DESC>
    <ESTADO_ID>QRO</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Sinaloa</ESTADO_DESC>
    <ESTADO_ID>SIN</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>San Luis Potosi</ESTADO_DESC>
    <ESTADO_ID>SLP</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Sonora</ESTADO_DESC>
    <ESTADO_ID>SON</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Tabasco</ESTADO_DESC>
    <ESTADO_ID>TAB</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Tamaulipas</ESTADO_DESC>
    <ESTADO_ID>TAM</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Tlaxcala</ESTADO_DESC>
    <ESTADO_ID>TLAX</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Veracruz</ESTADO_DESC>
    <ESTADO_ID>VER</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Yucatán</ESTADO_DESC>
    <ESTADO_ID>YUC</ESTADO_ID>
  </Estados>
  <Estados>
    <ESTADO_DESC>Zacatecas</ESTADO_DESC>
    <ESTADO_ID>ZAC</ESTADO_ID>
  </Estados>
</ArrayOfEstados>'
			
			truncate table [dbo].[catEstados]

			insert into [dbo].[catEstados] ([ESTADO_ID],[ESTADO_DESC], [FLAG])
			select Container.ContainerCol.value('ESTADO_ID[1]','nvarchar(20)') ,
				Container.ContainerCol.value('ESTADO_DESC[1]','nvarchar(30)') ,
				1
	             from @xmlCat.nodes('//ArrayOfEstados//Estados') AS Container(ContainerCol)

				

			
	  end




END
