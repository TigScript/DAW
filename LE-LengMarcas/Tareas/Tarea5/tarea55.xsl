<?xml version="1.0" encoding="UTF-8"?>    <!-- Declaracion de doc-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">  <!-- Declaracion de xslt-->
  <xsl:output method="html" indent="yes"/>   <!-- Salida HTML como se indica en el ejercicio-->
  <xsl:template match="/">  <!-- como Artistas representa todo el doc XML podria declarar una plantilla para artistas o para todo el doc como he hecho-->
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>Tabla de artistas</title> 
      </head>
      <body>
        <table>
          <tr>
            <th>Código</th>  <!-- th para el titulo para el primer apartado.-->
            <th>Nombre</th>
            <th>Año de nacimiento</th>
            <th>Año de fallecimiento</th>
            <th>País</th>
            <th>Página web</th>
          </tr>
          <xsl:for-each select="artistas/artista[nacimiento&gt;1500]">   <!-- se itinera sobre cada elemento de artista > que 1500 para el cuarto apartado-->
            <xsl:sort select="nacimiento"/>  <!-- ordena a los artistas por "nacimiento" para el quinto apartado-->
            <tr>  <!-- A partir de aqui extraigo los elementos de la tabla con el nombre del elemento, con excepcion de @cod-->
              <td><xsl:value-of select="@cod"/></td>
              <td><xsl:value-of select="nombreCompleto"/></td>
              <td><xsl:value-of select="nacimiento"/></td>
              <td>
                <xsl:choose>   <!--uso una estructura "choose" para mostrar el año de fallecimiento del artista si está disponible, o "Desconocido" si no lo está para el segundo apartado-->
                  <xsl:when test="fallecimiento"> <!-- Si existe fallecimiento-->
                    <xsl:value-of select="fallecimiento"/> <!-- Muestra su valor-->
                  </xsl:when>
                  <xsl:otherwise>Desconocido</xsl:otherwise>  <!-- De lo contrario, muestra "Desconocido"-->
                </xsl:choose>
              </td>
              <td><xsl:value-of select="pais"/></td> <!-- Valor de pais tal cual-->
              <td>
                <a target="_blank"> <!--_blank para que se abra el enlace en una pagina aparte-->
                  <xsl:attribute name="href">  <!--En la última columna, el valor se obtiene del elemento fichaCompleta. Debe mostrarse un vínculo a la dirección adecuada, con el texto “Saber más”.-->
                    <xsl:value-of select="fichaCompleta"/>
                  </xsl:attribute>
                  Saber más
                </a>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>