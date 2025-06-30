
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## 🚀 Visão Geral

O `correcoes-efd-fiscal` é um aplicativo **Flutter** desenvolvido para simplificar e automatizar a **validação e correção de arquivos SPED EFD Fiscal**. Ele atua diretamente em inconsistências comuns que podem gerar problemas na escrituração, focando em duas frentes cruciais:

1.  **Padronização de Unidades de Medida (Registro 0200 para C170):** Identifica e aplica corretamente as unidades de medida definidas no **Registro 0200** aos respectivos itens detalhados no **Registro C170**, garantindo a consistência das informações de produtos e serviços.
2.  **Correção de País do Participante:** Verifica e corrige automaticamente a informação de país nos dados dos **Participantes** (fornecedores/clientes), preenchendo ou ajustando quando a informação está ausente ou inconsistente.

Este projeto visa otimizar o tempo de analistas fiscais e contadores, reduzindo erros manuais e facilitando a conformidade das declarações fiscais.

---

## ✨ Funcionalidades

* **Leitura de Arquivos SPED EFD Fiscal:** Capacidade de importar e processar arquivos `.txt` do SPED.
* **Correção de Unidades de Medida:** Mapeamento inteligente do Registro 0200 para aplicação correta no Registro C170.
* **Ajuste de País do Participante:** Preenchimento automático ou correção da informação de país dos participantes.
* **Geração de Arquivo Corrigido:** Exportação do arquivo SPED com as correções aplicadas.
* **Automação de Build (CI/CD):** Integração com **GitHub Actions** para automatizar o processo de build do aplicativo, garantindo entregas rápidas e consistentes.

---

## 🛠️ Tecnologias Utilizadas

* **Flutter:** Framework UI para construção de aplicativos nativos multi-plataforma.
* **Dart:** Linguagem de programação.
* **FVM (Flutter Version Management):** Gerenciador de versões do Flutter para garantir consistência no ambiente de desenvolvimento.
* **GitHub Actions:** Ferramenta de CI/CD para automação de workflows de desenvolvimento.

---

## 📥 Como Usar

Você tem duas opções para usar o `correcoes-efd-fiscal`:

### 1. Utilizando as Releases (Recomendado)

Para a forma mais fácil e rápida de usar o aplicativo, você pode fazer o download das versões compiladas para **Windows** e **Linux** diretamente na seção de **Releases** do repositório GitHub.

1.  Acesse a página de [Releases](https://github.com/manoelmarquesfor/correcoes-efd-fiscal/releases) do projeto.
2.  Baixe o pacote executável para o seu sistema operacional (Windows ou Linux).
3.  Descompacte o arquivo e siga as instruções contidas no pacote para executar o aplicativo.

### 2. Rodando o Projeto Localmente (Para Desenvolvedores)

Se você é um desenvolvedor e deseja contribuir ou explorar o código-fonte, siga os passos abaixo para configurar e executar o projeto em sua máquina:

#### Pré-requisitos

Certifique-se de ter o Flutter SDK instalado e configurado em sua máquina. Você pode encontrar as instruções de instalação [aqui](https://flutter.dev/docs/get-started/install).

#### Configuração

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/manoelmarquesfor/correcoes-efd-fiscal.git
    cd correcoes-efd-fiscal
    ```

2. **Instale e use a versão do Flutter definida pelo projeto com FVM:**

    ```bash
    fvm install
    fvm use
    ```

3.  **Obtenha as dependências:**

    ```bash
    fvm flutter pub get
    ```

4.  **Execute o aplicativo:**

    ```bash
    fvm flutter run
    ```

    O aplicativo será iniciado.


---

## 📄 Licença

Este projeto está licenciado sob a **Licença MIT** - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---


## 📧 Contato

Ficaria feliz em discutir o projeto ou qualquer dúvida! Conecte-se comigo:

* **Manoel Marques**
* **LinkedIn:** [Meu Perfil no LinkedIn](https://www.linkedin.com/in/manoel-marques-80a366278)
* **Email:** manoeltecfor@gmail.com