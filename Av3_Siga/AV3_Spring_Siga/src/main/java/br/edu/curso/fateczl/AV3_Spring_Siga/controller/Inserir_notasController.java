package br.edu.curso.fateczl.AV3_Spring_Siga.controller;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import br.edu.curso.fateczl.AV3_Spring_Siga.persistence.NotasDAO;

@Controller
public class Inserir_notasController {
	
	@Autowired
	NotasDAO nDAO;

	@RequestMapping(name = "inserir_notas", value = "/inserir_notas", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("inserir_notas");
	}
	
	@RequestMapping(name = "inserir_notas", value = "/inserir_notas", method = RequestMethod.POST)
	public ModelAndView inserir_notas(ModelMap model, @RequestParam Map<String, String> allParam) {
		String botao = allParam.get("botao");
		
		String nome_aluno = allParam.get("nome_aluno");
		String sigla = allParam.get("sigla");
		String turno = allParam.get("turno");
		String tipo_avaliacao = allParam.get("tipo_avaliacao");
		String nota = allParam.get("nota");
		
		String saida = "";
		String erro = "";
		System.out.println(nome_aluno +" "+ sigla +" "+ turno +" "+ tipo_avaliacao +" "+ nota);
		try {
			if(botao.equalsIgnoreCase("inserir")) {
				
			float nota_aluno = Float.parseFloat(nota);
			System.out.println(nome_aluno +" "+ sigla +" "+ turno +" "+ tipo_avaliacao +" "+ nota_aluno);
			saida = nDAO.inserir_Notas(nome_aluno, sigla, turno, tipo_avaliacao, nota_aluno);
			
			}
		} catch(SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
		
			model.addAttribute("erro", erro);
			model.addAttribute("saida", saida);
		}
		
		return new ModelAndView("inserir_notas");
    }
	
}
	