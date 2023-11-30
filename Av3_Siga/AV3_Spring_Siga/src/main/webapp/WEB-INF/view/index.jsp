<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset ="ISO-8859-1">
<link rel="stylesheet" type="text/css" href='<c:url value="./resources/css/styles.css"/>'>
<title>Siga</title>
</head>
<body>
      <div>
          <jsp:include page="menu.jsp"/>
      </div>
      <br>
      <br>
      <div align="center">
           <form action="relatorio" method=post target="_blank">
                 <table>
                        <tr>
			                <td>
			                     <select id="sigla" name="sigla">
			                            <option value="0">Escolha a disciplina</option>
			                            <option value="AOC">AOC</option>
			                            <option value="LabHw">LabHw</option>
			                            <option value="BD">BD</option>
			                            <option value="LabBD">LabBD</option>
			                            <option value="MPC">MPC</option>
			                            <option value="SO I">SO I</option>
			                     </select>
			                 </td>
			                 <td>
			                     <select id="turno" name="turno">
			                            <option value="0">Escolha o turno</option>
			                            <option value="T">T</option>
			                            <option value="N">N</option>
			                     </select>
			                </td>
                        </tr>
                        <tr>
                            <td><input type="submit" id="botao" name="botao" value="Gerar Relatorio Notas"></td>
                            <td><input type="submit" id="botao" name="botao" value="Gerar Relatorio Faltas"></td>
                        </tr>
                 </table>
           </form>
      </div>
      <br>
      <br> 
      <div align="center">
           <c:if test="${not empty erro }">
                 <H2><c:out value="${erro }"></c:out></H2>
           </c:if>
      </div>
</body>
</html>