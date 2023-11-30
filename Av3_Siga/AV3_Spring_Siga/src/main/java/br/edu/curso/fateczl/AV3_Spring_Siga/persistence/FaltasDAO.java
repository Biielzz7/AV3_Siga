package br.edu.curso.fateczl.AV3_Spring_Siga.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FaltasDAO implements IFaltasDAO {

	@Autowired
	GenericDAO gDAO;
	
	@Override
	public String inserir_faltas(String nome_aluno, String sigla, String turno, String data, String presenca)
			throws SQLException, ClassNotFoundException {
		Connection c = gDAO.getConnection();
		String sql = "{CALL p_insere_faltas_presencas(?, ?, ?, ?, ?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, nome_aluno);
		cs.setString(2, sigla);
		cs.setString(3, turno);
		cs.setString(4, data);
		cs.setString(5, presenca);
		cs.execute();
		
		cs.close();
		c.close();
		
		return "Presenca Inserida";
	}

}
