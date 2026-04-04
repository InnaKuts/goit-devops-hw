# lesson-5 — Terraform (AWS)

Інфраструктура в **eu-north-1**: віддалений state у **S3** з блокуванням у **DynamoDB**, **VPC**, **ECR**.

## Структура

```text
lesson-5/
├── main.tf, backend.tf, outputs.tf
└── modules/
    ├── s3-backend/   # S3 + DynamoDB
    ├── vpc/            # VPC, підмережі, IGW, NAT
    └── ecr/            # репозиторій ECR
```

## Команди

З каталогу `lesson-5/` (потрібні дійсні облікові дані AWS):

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

Після зміни модулів знову виконайте `terraform init`.

## Модулі

| Модуль       | Призначення |
|-------------|-------------|
| **s3-backend** | Бакет для `terraform.tfstate` (версіювання), таблиця DynamoDB для lock. |
| **vpc**        | VPC `10.0.0.0/16`, три публічні та три приватні підмережі, Internet Gateway, NAT Gateway, route tables. |
| **ecr**        | Репозиторій образів, сканування при push, політика доступу для поточного акаунта. |

**Увага:** `terraform destroy` видаляє також бакет і таблицю, які використовує backend. У модулі **s3-backend** для бакета ввімкнено **`force_destroy`**, щоб Terraform міг при `destroy` прибрати всі **версії** об’єктів (інакше з версіонуванням часто виникає `BucketNotEmpty`).

Якщо `destroy` зірвався і з’явилось повідомлення про **state lock**, а в DynamoDB таблиці вже немає: переконайтесь, що ніхто паралельно не запускає Terraform, і виконайте **`terraform force-unlock <LOCK_ID>`** (ID з тексту помилки).

## Після повного `destroy`: як знову зробити `init`

1. **Закоментуйте** весь блок `terraform { backend "s3" { ... } }` у `backend.tf`.
2. Виконайте **`terraform init`** (Terraform працюватиме з **локальним** state).
3. **`terraform apply`** — знову створить S3, DynamoDB, VPC, ECR.
4. **Розкоментуйте** backend у `backend.tf` (ті самі `bucket`, `key`, `region`, `dynamodb_table`, що в `main.tf` / AWS).
5. **`terraform init -reconfigure`** — підтвердіть **міграцію** state у S3.

Далі знову звичайні `plan` / `apply`.
