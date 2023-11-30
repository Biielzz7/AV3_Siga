<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href='<c:url value="./resources/css/styles.css"/>'>
<title>Inserir Faltas</title>
</head>
<body>
      <div>
          <jsp:include page="menu.jsp"/>
      </div>
      <div align= "center">
           <form action="inserir_faltas" method="post">
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
                 <td><input type="date" id="data" name="data" placeholder="Escolha a Data"></td>
                 <td>
                    <select id="presenca" name="presenca">
                            <option value="0">Defina a Presença</option>
                            <option value="PPPP">PPPP</option>
                            <option value="FPPP">FPPP</option>
                            <option value="FFPP">FFPP</option>
                            <option value="FFFP">FFFP</option>
                            <option value="FFFF">FFFF</option>
                            <option value="FFFP">FFFP</option>
                            <option value="FFPP">FFPP</option>
                            <option value="FPPP">FPPP</option>
                            
                            <option value="PP">PP</option>
                            <option value="FP">FP</option>
                            <option value="FF">FF</option>
                            <option value="PF">PF</option>
                    </select>
                 </td>                
                 
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