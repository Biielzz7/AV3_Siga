package br.edu.curso.fateczl.AV3_Spring_Siga.persistence;

import java.sql.SQLException;

public interface IFaltasDAO {
	public String inserir_faltas(String nome_aluno, String sigla, String turno, String data, String presenca) throws SQLException, ClassNotFoundException;

}
