package br.edu.curso.fateczl.AV3_Spring_Siga.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.edu.curso.fateczl.AV3_Spring_Siga.model.Notas_Turma;

@Repository
public class NotasDAO implements INotasDAO{

	@Autowired
	GenericDAO gDAO;
	
	@Override
	public String inserir_Notas(String nome_aluno, String sigla_disciplina, String turno, String tipo_avaliacao,
			float nota) throws SQLException, ClassNotFoundException {
		Connection c = gDAO.getConnection();
		String sql = "{CALL p_insercao_notas(?, ?, ?, ?, ?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, nome_aluno);
		cs.setString(2, sigla_disciplina);
		cs.setString(3, turno);
		cs.setString(4, tipo_avaliacao);
		cs.setFloat(5, nota);
		cs.execute();
		
		cs.close();
		c.close();
		
		return "Nota Inserida";
	}

	@Override
	public List<Notas_Turma> buscar_notas_turma(String sigla_disciplina, String turno) throws SQLException, ClassNotFoundException {
		Connection c = gDAO.getConnection();
		List<Notas_Turma> lista_notas = new ArrayList<>();
		String sql = "SELECT Ra_Aluno, "
				          + "Nome_Aluno, "
				          + "Nota1, "
				          + "Nota2, "
				          + "Nota3, "
				          + "Trabalho, "
				          + "Monografia_Completa, "
				          + "Monografia_Resumida, "
				          + "Media_Final, "
				          + "Situacao "
				          + "FROM dbo.fn_notas_turma(?, ?)\r\n"
				+ "";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, sigla_disciplina);
		ps.setString(2, turno);
		ResultSet rs = ps.executeQuery();
		
		while(rs.next()) {
			Notas_Turma nt = new Notas_Turma();
			nt.setRa_aluno(rs.getInt("Ra_Aluno"));
			nt.setNome_aluno(rs.getString("Nome_Aluno"));
			nt.setNota1(rs.getString("Nota1"));
			nt.setNota2(rs.getString("Nota2"));
			nt.setNota3(rs.getString("Nota3"));
			nt.setTrabalho(rs.getString("Trabalho"));
			nt.setMonografia_completa(rs.getString("Monografia_Completa"));
			nt.setMonografia_resumida(rs.getString("Monografia_Resumida"));
			nt.setMedia_final(rs.getFloat("Media_Final"));
			nt.setSituacao(rs.getString("Situacao"));
			
			lista_notas.add(nt);
		}
		
		rs.close();
		ps.close();
		c.close();
		return lista_notas;
	}

}
