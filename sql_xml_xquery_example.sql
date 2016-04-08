DECLARE @text nvarchar(255) = 'The quick brown fox jumps over the lazy dog.';

SET @text = CONCAT('<word>', REPLACE(LTRIM(RTRIM(@text)), SPACE(1), '</word><word>'), '</word>');

DECLARE @xml xml = CONVERT(xml, @text);

SELECT 
	c.value('.', 'nvarchar(16)') as word
FROM @xml.nodes('//word') t(c);


GO


CREATE FUNCTION dbo.fnSplit (@input nvarchar(1024))
RETURNS TABLE
AS
RETURN (
	WITH cte
	AS (
		SELECT CONVERT(xml, CONCAT('<word>', REPLACE(LTRIM(RTRIM(@input)), SPACE(1), '</word><word>'), '</word>')) AS xml
	)

	SELECT 
		c.value('.', 'nvarchar(16)') as word
	FROM cte
	CROSS APPLY xml.nodes('//word') t(c)
);
