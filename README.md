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
    Para usar o códigos de Python é necessário instalar O Python (recomendo instalar via o programa <a href="https://www.anaconda.com/download">Anaconda</a>) na sua máquina e em seguida instalar o <a href="https://jupyter.org/">Jupyter notebook</a>, que é simplismente falando, uma forma de usar o código de forma particionada e produzir outputs que ficam na memória até serem salvos ou usados.
    </p>    
    <p>
    Os códigos em Python servem para calcular a correlação de Pearson entre as imagens nos experimentos Pixel a Pixel, para obter as médias, checar normalidade, determinar significancia estatística com T-Test, automatizar a produção de correlação de Pearson usando a intensidade integrada dos gh2ax-foci como se fosse um ponto dentro da célula, montar gráficos para publicação.
    </p>    

  <h2 id="usage">Usage</h2>
  <p>
    Explain how users can use your code and provide relevant examples. Include command-line instructions, code snippets, or screenshots to guide users through the process.
  </p>

  <h2 id="features">Features</h2>
  <ul>
    <li>Feature 1: Description of feature 1.</li>
    <li>Feature 2: Description of feature 2.</li>
    <!-- Add more features here -->
  </ul>

  <h2 id="examples">Examples</h2>
  <p>
    Provide examples or use cases to demonstrate the effectiveness of your research code. Include code snippets, input/output examples, or visualizations.
  </p>

  <h2 id="contributing">Contributing</h2>
  <p>
    Let others know how they can contribute to your research project. Include guidelines for bug reports, feature requests, and pull requests. Mention any coding style or contribution standards you follow.
  </p>

  <h2 id="license">License</h2>
  <p>
    Specify the license under which your research code is released. Mention any usage restrictions, if applicable.
  </p>

  <h2>Authors</h2>
  <p>
    List the names of the authors or contributors involved in the research project. You can also provide links to their profiles or websites.
  </p>

  <h2>Acknowledgments</h2>
  <p>
    If you received help or support from individuals or organizations, acknowledge them here.
  </p>

  <h2>References</h2>
  <p>
    Include any references to related papers, articles, or external resources that are relevant to your research project.
  </p>
</body>
</html>
