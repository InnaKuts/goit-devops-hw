# Terraform — AWS (VPC, ECR, EKS, remote state)

Інфраструктура в регіоні **`eu-north-1`**: віддалений state у **S3**, блокування через **нативний S3 lock** (`use_lockfile`, Terraform **≥ 1.10**), **VPC**, **ECR**, **EKS** у тій самій VPC.

## Структура

```text
terraform/
├── main.tf, backend.tf, outputs.tf
└── modules/
    ├── s3-backend/   # S3 для tfstate (версіювання)
    ├── vpc/            # VPC, підмережі, IGW, NAT
    ├── ecr/            # репозиторій образів
    └── eks/            # кластер EKS у приватних підмережах VPC
```

## Команди

З каталогу **`terraform/`** (потрібні облікові дані AWS):

```bash
cd terraform
terraform init
terraform plan
terraform apply
terraform destroy
```

Після зміни модулів або `backend` знову виконайте `terraform init` (за потреби з `-reconfigure`).

Конфіг **`kubectl`** для EKS (приклад; ім’я кластера та регіон — з вашого `outputs.tf` / консолі):

```bash
terraform output eks_configure_kubeconfig
# або
aws eks update-kubeconfig --region eu-north-1 --name lesson-7-eks
```

## Модулі

| Модуль | Призначення |
|--------|-------------|
| **s3-backend** | Бакет для `terraform.tfstate` (версіювання). Lock — об’єкт у тому ж бакеті (`use_lockfile`). **DynamoDB у цьому проєкті не використовується.** |
| **vpc** | VPC `10.0.0.0/16`, три публічні та три приватні підмережі, Internet Gateway, NAT Gateway, route tables. |
| **ecr** | Репозиторій образів, сканування при push, політика доступу для поточного акаунта. |
| **eks** | Кластер Kubernetes і managed node group у **приватних** підмережах; публічний API за замовчуванням для `kubectl` з ноутбука. |

**Витрати:** EKS, NAT, EC2 для нод — платні; після перевірки варто **`terraform destroy`**, якщо курс це дозволяє.

**Увага:** `terraform destroy` видаляє бакет зі state. У **s3-backend** для бакета ввімкнено **`force_destroy`**, щоб при `destroy` прибрати всі версії об’єктів (інакше часто `BucketNotEmpty`).

Якщо з’явилось повідомлення про **state lock**, а процес Terraform уже не працює: **`terraform force-unlock <LOCK_ID>`** (лише якщо впевнені, що паралельних `apply` немає).

## Після повного `destroy`: як знову зробити `init`

1. **Закоментуйте** блок `terraform { backend "s3" { ... } }` у `backend.tf`.
2. **`terraform init`** — локальний state.
3. **`terraform apply`** — знову S3, VPC, ECR, EKS.
4. **Розкоментуйте** backend (той самий `bucket`, `key`, `region`, `encrypt`, `use_lockfile`).
5. **`terraform init -reconfigure`** — міграція state у S3.

Далі знову `plan` / `apply`.

## Образ Django і ECR

1. Збірка з кореня репозиторію: `docker build -t <ecr_url>:latest ./django`
2. Логін і push: `aws ecr get-login-password ... | docker login ...` і `docker push`
3. URL репозиторію: `terraform output ecr_repository_url`
