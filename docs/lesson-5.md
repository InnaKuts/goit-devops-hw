# Terraform (AWS) — lesson-7 у репозиторії

Інфраструктура в **eu-north-1**: віддалений state у **S3**, блокування state через **нативний S3 lock** (`use_lockfile`, Terraform **≥ 1.10**), **VPC**, **ECR**.

## Структура

```text
lesson-7/
├── main.tf, backend.tf, outputs.tf
└── modules/
    ├── s3-backend/   # S3 (версіювання)
    ├── vpc/          # VPC, підмережі, IGW, NAT
    └── ecr/          # репозиторій ECR
```

## Команди

З каталогу `lesson-7/` (потрібні дійсні облікові дані AWS):

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

Після зміни модулів або backend знову виконайте `terraform init` (за потреби з `-reconfigure`).

## Модулі

| Модуль         | Призначення |
|----------------|-------------|
| **s3-backend** | Бакет для `terraform.tfstate` (версіювання). Lock — окремий об’єкт у тому ж бакеті (Terraform `use_lockfile`). |
| **vpc**        | VPC `10.0.0.0/16`, три публічні та три приватні підмережі, Internet Gateway, NAT Gateway, route tables. |
| **ecr**        | Репозиторій образів, сканування при push, політика доступу для поточного акаунта. |

**Увага:** `terraform destroy` видаляє бакет зі state. У **s3-backend** для бакета ввімкнено **`force_destroy`**, щоб при `destroy` прибрати всі версії об’єктів (інакше часто `BucketNotEmpty`).

Якщо з’явилось повідомлення про **state lock**, а процес Terraform уже не працює: **`terraform force-unlock <LOCK_ID>`** (лише якщо впевнені, що паралельних `apply` немає).

## Міграція backend з DynamoDB на `use_lockfile`

1. Оновити `backend.tf`: прибрати `dynamodb_table`, додати `use_lockfile = true`, `required_version = ">= 1.10.0"`.
2. **`terraform init -reconfigure`** — підтвердити зміни backend.
3. **`terraform apply`** — з конфігурації зникне ресурс DynamoDB; Terraform **видалить таблицю** в AWS (якщо вона була в цьому root-модулі).

## Після повного `destroy`: як знову зробити `init`

1. **Закоментуйте** блок `terraform { backend "s3" { ... } }` у `backend.tf` (залиште лише `required_version`, якщо потрібно, або тимчасово приберіть увесь `terraform {}` — зручніше закоментувати лише `backend "s3"`).
2. **`terraform init`** — локальний state.
3. **`terraform apply`** — знову S3, VPC, ECR.
4. **Розкоментуйте** backend (той самий `bucket`, `key`, `region`, `encrypt`, `use_lockfile`).
5. **`terraform init -reconfigure`** — міграція state у S3.

Далі знову `plan` / `apply`.
