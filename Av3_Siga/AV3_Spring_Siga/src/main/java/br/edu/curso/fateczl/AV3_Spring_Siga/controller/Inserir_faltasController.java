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

import br.edu.curso.fateczl.AV3_Spring_Siga.persistence.FaltasDAO;

@Controller
public class Inserir_faltasController {
	
	@Autowired
	FaltasDAO fDAO;
	
	@RequestMapping(name = "inserir_faltas", value = "/inserir_faltas", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("inserir_faltas");		
	}
	
	@RequestMapping(name = "inserir_faltas", value = "/inserir_faltas", method = RequestMethod.POST)
	public ModelAndView inserir_faltas(ModelMap model, @RequestParam Map<String, String> allParam) {
		String botao = allParam.get("botao");
		String nome_aluno = allParam.get("nome_aluno");
		String sigla = allParam.get("sigla");
		String turno = allParam.get("turno");
		String data = allParam.get("data");
		String presenca = allParam.get("presenca");
		
		String saida = "";
		String erro = "";
		
		try {
			if(botao.equalsIgnoreCase("inserir")) {
			System.out.println(nome_aluno +" "+ sigla +" "+ turno +" "+ data +" "+  presenca);	
			saida = fDAO.inserir_faltas(nome_aluno, sigla, turno, data, presenca);
				
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("erro",erro);
			model.addAttribute("saida", saida);
		}
		
		
		return new ModelAndView("inserir_faltas");		
	}	
}
