package br.edu.curso.fateczl.AV3_Spring_Siga.model;

public class Notas_Turma {
	
	  private int ra_aluno;
	  private String nome_aluno;
	  private String nota1;
	  private String nota2;
	  private String nota3;
	  private String trabalho;
	  private String monografia_completa;
	  private String monografia_resumida;
	  private float media_final;
	  private String situacao;
	  
	public int getRa_aluno() {
		return ra_aluno;
	}
	public void setRa_aluno(int ra_aluno) {
		this.ra_aluno = ra_aluno;
	}
	public String getNome_aluno() {
		return nome_aluno;
	}
	public void setNome_aluno(String nome_aluno) {
		this.nome_aluno = nome_aluno;
	}
	public String getNota1() {
		return nota1;
	}
	public void setNota1(String nota1) {
		this.nota1 = nota1;
	}
	public String getNota2() {
		return nota2;
	}
	public void setNota2(String nota2) {
		this.nota2 = nota2;
	}
	public String getNota3() {
		return nota3;
	}
	public void setNota3(String nota3) {
		this.nota3 = nota3;
	}
	public String getTrabalho() {
		return trabalho;
	}
	public void setTrabalho(String trabalho) {
		this.trabalho = trabalho;
	}
	public String getMonografia_completa() {
		return monografia_completa;
	}
	public void setMonografia_completa(String monografia_completa) {
		this.monografia_completa = monografia_completa;
	}
	public String getMonografia_resumida() {
		return monografia_resumida;
	}
	public void setMonografia_resumida(String monografia_resumida) {
		this.monografia_resumida = monografia_resumida;
	}
	public float getMedia_final() {
		return media_final;
	}
	public void setMedia_final(float media_final) {
		this.media_final = media_final;
	}
	public String getSituacao() {
		return situacao;
	}
	public void setSituacao(String situacao) {
		this.situacao = situacao;
	}
	
	
	@Override
	public String toString() {
		return "Notas_Turma [ra_aluno=" + ra_aluno + ", nome_aluno=" + nome_aluno + ", nota1=" + nota1 + ", nota2="
				+ nota2 + ", nota3=" + nota3 + ", trabalho=" + trabalho + ", monografia_completa=" + monografia_completa
				+ ", monografia_resumida=" + monografia_resumida + ", media_final=" + media_final + ", situacao="
				+ situacao + "]";
	}
	  
	  
	

	
}
