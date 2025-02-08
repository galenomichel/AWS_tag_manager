# AWS Tagging Script 🚀

Este script permite listar e atualizar tags de recursos na AWS diretamente no **AWS CloudShell**, sem necessidade de configuração local.

## 📌 Requisitos

Antes de usar o script, certifique-se de:
- Ter acesso ao **AWS CloudShell** ([Acesse aqui](https://console.aws.amazon.com/cloudshell)).
- Ter permissões suficientes para listar e modificar tags na AWS.

## 🚀 Como Usar no AWS CloudShell

1. **Acesse o AWS CloudShell**:
   - Vá para o console da AWS e abra o **CloudShell**.

2. **Baixar o script**:
   No terminal do CloudShell, execute:
   ```bash
   curl -O https://raw.githubusercontent.com/SEU_USUARIO/aws-tagging-script/main/aws-tagging.sh
   ```
Tornar o script executável:
  ```bash
  chmod +x aws-tagging.sh
  ```
Executar o script:
```bash
./aws-tagging.sh
```
Instruções de uso:
- O script solicitará um ARN de recurso.
- Em seguida, exibirá as tags atuais do recurso.
- Perguntará se deseja adicionar ou atualizar tags (Y/n).
- Se optar por adicionar tags, pedirá os valores de:
  - Environment (Prd, Hml, Dev) → Escolha com as setas.
  - Project (texto livre).
  - Application (texto livre).
  - Hostname (apenas se for uma instância EC2).
Saída esperada:
  ```bash
  Digite o ARN do recurso: arn:aws:ec2:us-east-1:123456789012:instance/i-08dbabdb57f4d4612
  Tags atuais: Environment=Hml, Project=ProjetoX, Application=AppY
  Deseja atualizar as tags? (Y/n): 
  Selecione o ambiente: [Prd, Hml, Dev]
  Digite o nome do projeto: ProjetoNovo
  Digite o nome da aplicação: MinhaApp
  ```
## 🔍 Como validar se as tags foram adicionadas?
Para listar as tags do recurso novamente, use:
  ```bash
  aws resourcegroupstaggingapi get-resources --resource-arn-list "ARN_DO_RECURSO" --query "ResourceTagMappingList[].Tags"
  ```
Ou, em formato de tabela:
  ```bash
  aws resourcegroupstaggingapi get-resources --resource-arn-list "ARN_DO_RECURSO" --output table
  ```

## ❌ Como remover uma tag específica?
Se precisar remover uma tag de um recurso, utilize:
```bash
aws resourcegroupstaggingapi untag-resources --resource-arn-list "ARN_DO_RECURSO" --tag-keys "NOME_DA_TAG"
```

Exemplo para remover Hostname:
```bash
aws resourcegroupstaggingapi untag-resources --resource-arn-list "arn:aws:ec2:us-east-1:123456789012:instance/i-08dbabdb57f4d4612" --tag-keys "Hostname"
```

## 🛠 Melhorias futuras
Automatizar a remoção de tags.
Suporte a múltiplos recursos em um só comando.

## 📌 Contribuições são bem-vindas! 😃
Dúvidas? Abra uma issue ou entre em contato!
