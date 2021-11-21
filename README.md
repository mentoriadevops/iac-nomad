##  Template Modulo Terraform
Este repositorio deve conter a estrutura básica para a criação de uma modulo do [terraform](https://www.terraform.io/). 

 $`` module-example/``
 
 |--- main.tf  
 |--- variable.tf  
 |--- outputs.tf  
 |--- version.tf

 Esses são os nomes de arquivos recomendados para um modulo mínimo, mesmo se estiverem vazios. 
 
 ``main.tf`` deve ser o ponto de entrada principal.
 Para um modulo simples, pode ser aqui que todos os recursos que são criados. Para uma modulo complexo pode ser divido em varios arquivos.
 
 ``variables.tf e outputs.tf`` deve conter as declarações das variaves e as saidas respectivamente.
 
 ``versions.tf`` deve contem as versões dos recursos/provedores

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 0.13.0 |

## Providers
  
| Name | Version |
|------|---------|
| local | n/a |

## Resources

| Name | Type |
|------|------|
| local_file | resource |
| local_file | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|ferramenta_1 | exemplo de variavel | `string` | `"terraform"` | no |
|ferramenta_2 | exemplo de variavel | `string` | `"ansible"` | no |
|programa | exemplo de variavel | `string` | `"mentoria-iac"` | no |

## Outputs
 
| Name | Description |
|------|-------------|
|ferramentas | exemplo de saida |

## Testar localmente

Aqui você descreve como a pessoa que utilizar esse módulo pode testar localmente. Coloque todos os detalhes necessários para executar localmente.

## Exemplos

A pasta ``how-to-use-this-module`` contém exemplos de utilização do módulo. Esta abordagem é interessante para auxiliar na exeperiência de quem for utilizar este módulo no futuro. Já foi criado um arquivo terraform chamado `terrafile.tf` e ele deve ser usado como referência pra colocar dentro deste diretório de exemplos.

## Variaveis de pipeline

GCP_KEY -> Conteudo completo do JSON de credenciais do GCP.

A variavel secret do Actions deve ter o conteúdo completo do JSON conforme exemplo abaixo.

```JSON
{
  "type": "service_account",
  "project_id": "project_id",
  "private_key_id": "3acc6c457asdasdasdasdasd5df2d4d4a3d1a3d62b086d7de9308c2",
  "private_key": "-----BEGIN PRIVATE KEY-----\ashduashduahsduhasudhasudhasduahsdahsduhasd@!@&*#HGSHGD\n-----END PRIVATE KEY-----\n",
  "client_email": "terraform@project-id.iam.gserviceaccount.com",
  "client_id": "1231231256546456456",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/terraform%40project_id.iam.gserviceaccount.com"
}

```

TF_VAR_project -> Project ID cadastrado na GCP que será utilizado na Terraform.