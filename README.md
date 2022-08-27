# Terraform Backend S3

Um Backend terraform determina como o arquivo de estado é armazenado.
Nesse caso usamos o S3 para salvar o estado remotamente, num Bucket S3 da AWS.

- Criar o arquivo **bucket-s3.tf**

```javascript
provider "aws" {
    profile    = "defaults"
    region     = "sa-east-1"
}
resource "aws_s3_bucket" "bucket-backend" {
    bucket = "bucket-backend-s3"
    versioning {
        enabled = true
    }
    lifecycle {
        prevent_destroy = true
    }
    tags = {
        Name = "backend-S3"
    }
}
```

- Altere os nomes das chaves, **Bucket** e **Profile**.

	**Bucket** – Nome único para o seu bucket.
	
	**Profile** – Nome do profile criado no seu AWS-CLI.

No diretório onde você criou o arquivo, use os comandos abaixo para criar o bucket na AWS:
```shell
terraform init
```
```shell
terraform apply
```

- Criar o arquivo **backend.tf** no mesmo diretório onde recursos estão:

```javascript
terraform {
    backend "s3" {
        profile    = "defaults"
        bucket = "bucket-backend-s3"
        region = "sa-east-1"
        encrypt = "true"
        key = "project-name/terraform.tfstate"
    }
}
```

- Alterar o nome do **Bucket**, a **Região** e principalmente a **Key** que indica como será a organização dos estados no bucket.

No exemplo a **key** vai criar uma pasta chamada **project-name** dentro do seu bucket e o arquivo de estado será salvo dentro dela. Dessa forma você pode utilizar só um bucket e usa-lo como backend para vários projetos.

```shell
terraform init
```

## Bloqueio de estados
Ao usar o backend remoto os estados da infraestrutura podem ficar disponíveis para mais pessoas de uma equipe. Então, para evitar possíveis imprevistos no caso da realização de alterações na mesma infraestrutura simultaneamente vamos utilizar uma tabela do DinamoDB para bloquear nossos arquivos de estado.

Basta criar o arquivo **dinamodb-table.tf** com o seguinte conteúdo:

```javascript
resource "aws_dynamodb_table" "dynamodb-backend" {
  name = "dynamodb-backend"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  } 
  tags = {
    Name = "dynamodb-backend"
  }
}
```

E no arquivo de configuração do backend é necessário indicar o uso da tabela criada.

O arquivo **backend.tf** deve ficar assim:

```javascript
terraform {
    backend "s3" {
        profile    = "defaults"
        bucket = "bucket-backend-s3"
        region = "sa-east-1"
        encrypt = "true"
        dynamodb_table = "dynamodb-backend"
        key = "project-name/terraform.tfstate"e
    }
}
```
