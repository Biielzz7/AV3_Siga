<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href='<c:url value="./resources/css/styles.css"/>'>
<title>Inserir Notas</title>
</head>
<body>
      <div>
          <jsp:include page="menu.jsp"/>
      </div>
      
      <div align= "center">
           <form action="inserir_notas" method="post">
                <table>
                 <br>
                 <tr>
                 <td><input type="text" id="nome_aluno" name="nome_aluno" placeholder="Digite o Nome do Aluno"></td>
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
                  <td>
                    <select id="tipo_avaliacao" name="tipo_avaliacao">
                            <option value="0">Escolha o tipo de avaliaçao</option>
                            <option value="P1">P1</option>
                            <option value="P2">P2</option>
                            <option value="P3">P3</option>
                            <option value="Trabalho">Trabalho</option>
                            <option value="Monografia Completa">Monografia Completa</option>
                            <option value="Monografia Resumida">Monografia Resumida</option>
                    </select>                   
                 </td>
                 <td><input type="number" min="0" step="0.1" id="nota" name="nota" placeholder="Informe a Nota"></td>                
                 <td><input type="submit" id="botao" name="botao" value="Inserir"><td>
                 </tr>
                </table>
           </form>
      </div>
      
	  <div align="center">
		<c:if test="${not empty erro }">
			<H2><c:out value="${erro }" /></H2>
		</c:if>
		<c:if test="${not empty saida }">
			<H2><c:out value="${saida }" /></H2>
		</c:if>
	 </div>      
</body>
</html>