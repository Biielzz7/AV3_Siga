package br.edu.curso.fateczl.AV3_Spring_Siga.controller;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import br.edu.curso.fateczl.AV3_Spring_Siga.persistence.GenericDAO;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.util.JRLoader;

@Controller
public class RelatoriosController {
	
	@Autowired
	GenericDAO gDAO;
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(name = "relatorio", value = "/relatorio", method = RequestMethod.POST)
	public ResponseEntity geraRelatorio(@RequestParam Map<String, String> params) {
		String erro = "";
		String botao = params.get("botao");
		String sigla = params.get("sigla");
		String turno = params.get("turno");
		
		//Definindo os elementos que serão passas como parâmetros para o Jasper
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("sigla", sigla);
		param.put("turno", turno);
		
		System.out.println(sigla +" "+ turno );
		byte[] bytes = null;
		
		//Inicializando elementos do response
		InputStreamResource resource = null;
		HttpStatus status = null;
		HttpHeaders header = new HttpHeaders();
		
		try {
			if(botao.equalsIgnoreCase("gerar relatorio faltas")) {
			Connection conn = gDAO.getConnection();
			File arquivo = ResourceUtils.getFile("classpath:reports/RelatorioFaltas.jasper");
			JasperReport report = 
					(JasperReport) JRLoader.loadObjectFromFile(arquivo.getAbsolutePath());
			bytes = JasperRunManager.runReportToPdf(report, param, conn);
			} else if (botao.equalsIgnoreCase("gerar relatorio notas")) {
				Connection conn = gDAO.getConnection();
				File arquivo = ResourceUtils.getFile("classpath:reports/RelatorioNotas.jasper");
				JasperReport report = 
						(JasperReport) JRLoader.loadObjectFromFile(arquivo.getAbsolutePath());
				bytes = JasperRunManager.runReportToPdf(report, param, conn);
				}
		} catch (FileNotFoundException | JRException | ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			erro = e.getMessage();
			status = HttpStatus.BAD_REQUEST;
		} finally {
			if (erro.equals("")) {
				InputStream inputStream = new ByteArrayInputStream(bytes);
				resource = new InputStreamResource(inputStream);
				header.setContentLength(bytes.length);
				header.setContentType(MediaType.APPLICATION_PDF);
				status = HttpStatus.OK;
			}
		}
		
		return new ResponseEntity(resource, header, status);
	}
}
