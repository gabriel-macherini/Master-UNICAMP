<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<!--   <style>
    /* Add your custom CSS styles here */
  </style> -->
</head>
<body>
  <h1>FAK interacts with and recruits DNA-PK complex members to the DNA damage repair sites in H9c2 cardiomyocytes under genotoxic stress.</h1>

  <h2>Description</h2>
  <p>
    Esse código tem o propósito de coletar dados de imagens de Super Resolution - Structured Illumination Microscopy (SR-SIM), processá-los e produzir gráficos e imagens ilustrativas para divulgação científica.
  </p>

  <h2>Table of Contents</h2>
  <ul>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#examples">Examples</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
  </ul>

  <h2 id="installation">Installation</h2>
  </p>
    <li>ImageJ macros: </li>
    </p>
    <p>
    Para rodar os macros de ImageJ é necessário ter o programa <a href="https://imagej.nih.gov/ij/download.html">ImageJ</a> instalado em seu computador, copiar do repositório o Macro.ijm desejado e abrir ele no ImageJ. É possível arrastar ele dentro do ImageJ para acesso rápido. Uma nova janela vai aparecer que o botão de run. É possível selecionar parte do código e rodar a parte selecionada parciamente, é assim que parte dos macros para fazer imagens é usado. 
  <a href="https://example.com">clickable link</a>  
    </p>    
    <p>
    Muitos dos macros rodam em "batch" de imagens de uma vez, mas necessita de ajuste manual de Threshold para segmentação de núcleos e gh2ax-foci e find maxima Threshold para selecionar os pontos. Não é exatamente uma forma 100% reprodutível como deixar no auto-threshold, mas foi o possível com a experiência em programação que consegui no momento e reduziu o tempo de segmentação que era manual de 5-10 minutos por imagem para 5 segundos ou menos, que seria feito da mesma forma. Como são mais de 1500 imagens produzidas durante todo o processo com o uso dessas ferramentas, esse código tornou possível a análise de todo o material.
    </p>
        <li>Códigos em Python usando Jupyter notebook: </li>
    </p>
    <p>
    Para usar o códigos de Python é necessário instalar O Python (recomendo instalar via o programa <a href="https://www.anaconda.com/download">Anaconda</a>) na sua máquina e em seguida instalar o <a href="https://jupyter.org/">Jupyter notebook</a>, que é simplismente falando, uma forma de usar o código de forma particionada e produzir outputs que ficam na memória até serem salvos ou usados. Após instalação, copiar os códigos do reposítorio para uma pasta que o jupyter acessa e rodar o código. Com o próprio jupyter é possível alterar o código caso quiser utilizar para um novo propósito.
    </p>    
    <p>
    Os códigos em Python servem para calcular a correlação de Pearson entre as imagens nos experimentos Pixel a Pixel, para obter as médias, checar normalidade, determinar significancia estatística com T-Test, automatizar a produção de correlação de Pearson usando a intensidade integrada dos gh2ax-foci como se fosse um ponto dentro da célula, montar gráficos para publicação.
    </p>    

  <h2 id="examples">Examples</h2>
  <p>
    Aqui existem alguns exemplos de gráficos e imagens processadas com o uso desses códigos.
  </p>
<div align="center">
  <div style="display: flex; justify-content: center;">
    <img src="https://github.com/gabriel-macherini/Master-UNICAMP/blob/master/python/pfak%20CTCF%20graph/pfak_gh2ax_ctcf_ct-dox%20sem.jpeg" alt="CTCF graph example" width="300">
    <img src="https://github.com/gabriel-macherini/Master-UNICAMP/blob/master/python/histogram%20circular_fak%20hole/histogram_fakcircular_peaktopeak_space_8.jpeg" alt="FAK hole space example" width="300">
    <img src="https://github.com/gabriel-macherini/Master-UNICAMP/blob/master/python/grafico%20das%20linhas%20nas%20imagens/ku80/plot_fak-ku80-h2ax_loci-gammah2ax_withxy_norm_13jul22_v2.jpeg" alt="ku80 line plot" width="300">
  </div>
</div>

<div align="center">
  <div style="display: flex; justify-content: center;">
    <img src="https://github.com/gabriel-macherini/Master-UNICAMP/blob/master/python/SIFAK%20swarm%20plot%20pc%20by%20cell/swarmplot_pc_cells_ku80gh2ax_ii_si%20v4.jpeg" alt="swarm pc graph example" width="300">
    <img src="https://github.com/gabriel-macherini/Master-UNICAMP/blob/master/python/gh2ax%20foci%20count%20mean%20all%20xp/inifak%20gh2axfoci%20count%20notnorm%203groups%20black%20std.jpeg" alt="gh2ax foci count example" width="300">
    <img src="https://github.com/gabriel-macherini/Master-UNICAMP/blob/master/python/gh2ax%20foci%20count%20mean%20all%20xp/sifak%20gh2ax%20loci%20countmean%20ago2022%20v5.jpeg" alt="gh2ax foci count example" width="300">
  </div>
</div>


  <h2 id="license">License</h2>
  <p>
    Esse código é publico para caso alguém necessite de uma base para começar a programar ou queira uma solução rápida para algo que tenha aqui. 
  </p>

  <h2>Authors</h2>
  <p>
    Todos os códigos que são encontrados aqui são de autoria de Gabriel Macherini Quaglia, com exceção do primeiro código para calculo da correlação de Pearson por canal da imagem o qual foi alterado para servir aos novos propósitos.

  <h2>Acknowledgments</h2>
  <p>
   Essa pesquisa foi financiada pelos orgãos brasileiros de fomento a ciência CAPES e FAPESP e foi realizada na universidade de Campinas (UNICAMP).
  </p>

