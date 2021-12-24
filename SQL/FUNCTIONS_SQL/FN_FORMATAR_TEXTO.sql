CREATE FUNCTION [dbo].[FN_FORMATAR_TEXTO]
(
    @TEXTO VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
 
    DECLARE @TEXTO_FORMATADO VARCHAR(MAX)
     
    -- O trecho abaixo possibilita que caracteres como "º" ou "ª"
    -- sejam convertidos para "o" ou "a", respectivamente
    SET @TEXTO_FORMATADO = UPPER(@TEXTO)
        COLLATE sql_latin1_general_cp1250_ci_as
 
    -- O trecho abaixo remove acentos e outros caracteres especiais,
    -- substituindo os mesmos por letras normais
    SET @TEXTO_FORMATADO = @TEXTO_FORMATADO
        COLLATE sql_latin1_general_cp1251_ci_as

	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'»','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'«','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'.','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'/','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,',','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'"','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'''','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'∗','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,':','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'?','')
 	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'-','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'0','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'1','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'2','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'3','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'4','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'5','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'6','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'7','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'8','')
	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,'9','')



	set @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO,' ','')

	  DECLARE @badStrings VARCHAR(100);
         DECLARE @increment INT= 1;
         WHILE @increment <= DATALENGTH(@TEXTO_FORMATADO)
             BEGIN
                 IF(ASCII(SUBSTRING(@TEXTO_FORMATADO, @increment, 1)) < 33)
                     BEGIN
                         SET @badStrings = CHAR(ASCII(SUBSTRING(@TEXTO_FORMATADO, @increment, 1)));
                         SET @TEXTO_FORMATADO = REPLACE(@TEXTO_FORMATADO, @badStrings, '');
                 END;
                 SET @increment = @increment + 1;
             END;


	SET @TEXTO_FORMATADO = LOWER( @TEXTO_FORMATADO)
    RETURN @TEXTO_FORMATADO
 
END
GO