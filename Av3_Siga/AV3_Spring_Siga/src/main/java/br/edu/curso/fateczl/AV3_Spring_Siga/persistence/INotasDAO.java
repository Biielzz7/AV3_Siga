package br.edu.curso.fateczl.AV3_Spring_Siga.persistence;

import java.sql.SQLException;
import java.util.List;

import br.edu.curso.fateczl.AV3_Spring_Siga.model.Notas_Turma;

public interface INotasDAO {
	
	public String inserir_Notas(String nome_aluno, String sigla_disciplina, String turno, String tipo_avaliacao, float nota) throws SQLException, ClassNotFoundException;
    public List<Notas_Turma> buscar_notas_turma(String sigla_disciplina, String turno) throws SQLException, ClassNotFoundException;
}
