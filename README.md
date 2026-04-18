# GoIT DevOps — Домашні завдання

Цей репозиторій містить декілька навчальних домашніх завдань з курсу GoIT DevOps.

Порядок у цьому README:

- **Тема 10**: Terraform-модуль `rds` (RDS / Aurora)
- **Теми 8–9**: EKS, Jenkins, Argo CD, Helm, GitOps (попереднє ДЗ)

---

## Структура моно-репозиторію

| Шлях | Призначення |
| --- | --- |
| `main.tf`, `backend.tf`, `variables.tf`, `outputs.tf` | Кореневий стек Terraform |
| `modules/vpc`, `modules/eks`, `modules/ecr`, `modules/s3-backend`, `modules/rds` | Мережа, кластер, реєстр, бакенд стейту, база даних |
| `modules/jenkins` | Helm-реліз Jenkins + IRSA для `jenkins-sa` (ECR) |
| `modules/argo-cd` | Helm-реліз Argo CD + локальний чарт застосунків |
| `charts/django-app` | Чарт застосунку (джерело для Argo + оновлення тегу з Jenkins) |
| `django-app/` | Контекст збірки Docker для Kaniko |
| `Jenkinsfile` | CI: Kaniko, ECR, коміт у Git |

---

## Домашнє завдання (тема 10): Terraform-модуль `rds` (RDS / Aurora)

У репозиторії додано універсальний модуль [`modules/rds`](modules/rds), який створює:

- **звичайну RDS instance** (PostgreSQL/MySQL), якщо `use_aurora = false`
- **Aurora cluster + writer + readers**, якщо `use_aurora = true`

В обох сценаріях створюються **DB Subnet Group**, **Security Group**, та **Parameter Group** (для Aurora — cluster parameter group).

### Приклад використання

У корені це підключено в [`main.tf`](main.tf) як `module "rds"`. Мінімум потрібних змінних:

- `rds_master_password` (sensitive) — задайте в `terraform.tfvars` або через `TF_VAR_rds_master_password`
- `rds_use_aurora` — перемикач Aurora/RDS

Приклад `terraform.tfvars` (не комітьте):

```hcl
rds_master_password = "CHANGE_ME"
rds_use_aurora      = false
```

### Змінні модуля

Модуль приймає (деталі див. у [`modules/rds/variables.tf`](modules/rds/variables.tf)):

- **`use_aurora`**: `true/false` — перемикає Aurora vs стандартний RDS
- **RDS-only**: `engine`, `engine_version`, `parameter_group_family_rds`, `allocated_storage`, `multi_az`
- **Aurora-only**: `engine_cluster`, `engine_version_cluster`, `parameter_group_family_aurora`, `aurora_replica_count`
- **Network**: `vpc_id`, `subnet_private_ids`, `subnet_public_ids`, `publicly_accessible`
- **Common**: `name`, `instance_class`, `db_name`, `username`, `password`, `backup_retention_period`, `parameters`, `tags`

### Як змінити тип БД / engine / клас інстансу

- **Перемкнути Aurora**: встановіть `rds_use_aurora = true` (це **знищить** `aws_db_instance` і створить кластер Aurora в тому ж state)
- **Змінити RDS engine**: у `module "rds"` змініть `engine` / `engine_version` і відповідний `parameter_group_family_rds`
- **Змінити Aurora engine**: змініть `engine_cluster` / `engine_version_cluster` і `parameter_group_family_aurora`
- **Змінити клас інстансу**: `instance_class = "db.t3.micro"` (або інший)

> Примітка (Free tier): у модулі дефолт `backup_retention_period = 0` для стандартного RDS (щоб не впиратися в обмеження free plan). Для Aurora значення 0 автоматично піднімається до 1 дня.

---

## Домашнє завдання (теми 8–9): EKS, Jenkins, Argo CD, Helm, GitOps

Проєкт на **Terraform**: **VPC → EKS → ECR**, встановлення **Jenkins** та **Argo CD** через **Helm**, Helm-чарт **Django** у `charts/django-app` і **Jenkinsfile** з **Kaniko → ECR → оновлення Git**, щоб **Argo CD** підтягував застосунок з репозиторію (GitOps).

**Гілка для здачі:** `lesson-8-9` (узгоджено з `gitops_target_revision` і параметром `GIT_PUSH_BRANCH` у Jenkins за замовчуванням).

---

## Схема CI/CD

```mermaid
flowchart LR
  subgraph git [Git]
    Repo[(Репозиторій)]
  end
  subgraph ci [Jenkins у EKS]
    Job[Jenkinsfile]
    Kaniko[Збірка Kaniko]
    GitPush[Git: оновлення values.yaml]
  end
  subgraph aws [AWS]
    ECR[(ECR)]
  end
  subgraph k8s [Kubernetes]
    Argo[Argo CD]
    App[Helm-реліз Django]
  end
  Repo -->|SCM / webhook| Job
  Job --> Kaniko
  Kaniko --> ECR
  Job --> GitPush
  GitPush -->|commit + push| Repo
  Repo -->|гілка / ревізія| Argo
  Argo -->|sync| App
  ECR -->|pull образу| App
```

**Кроки:**

1. Зміни в коді потрапляють у Git; Jenkins запускає пайплайн з `Jenkinsfile`.
2. **Kaniko** збирає образ з `django-app/Dockerfile` і пушить у **ECR** (агент використовує **`jenkins-sa`** + **IRSA**).
3. Етап **Git** оновлює `charts/django-app/values.yaml` (`image.repository` / `image.tag`) і пушить у вказану гілку (за замовчуванням `lesson-8-9`).
4. **Application** у Argo CD стежить за тим самим шляхом у репо; увімкнено **автосинхронізацію** (`prune`, `selfHeal` у `modules/argo-cd/argo_cd.tf`).

---

## Що потрібно перед стартом

- **Terraform** `>= 1.10`
- **AWS CLI** (`aws configure` або змінні оточення) з правами на ресурси, які створюють модулі (EKS, EC2, IAM, ECR, S3 тощо)
- **kubectl**; **Helm** — бажано для перевірки релізів
- **GitHub:** токен (PAT) з правами на репозиторій для кроку пушу в пайплайні

**Стейт Terraform:** у `backend.tf` вказано S3-бакет `goit-devops-hw-tfstate-001001` у регіоні `eu-north-1`. Модуль `s3_backend` створює бакет у тому ж стеку. Якщо на **новому** акаунті `terraform init` скаржиться на відсутній бакет — один раз створіть бакет вручну або тимчасово використайте локальний backend і перенесіть стейт (див. [документацію Terraform про S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)).

---

## Як застосувати Terraform

З кореня репозиторію:

```bash
cd /шлях/до/goit-devops-hw
terraform init
terraform plan
terraform apply
```

Якщо ваш fork інший за значення за замовчуванням у `variables.tf`:

```bash
export TF_VAR_gitops_repo_url="https://github.com/<ВИ>/<РЕПО>.git"
terraform apply
```

Секрети в `terraform.tfvars` **не комітьте**.

Після успішного `apply` підключіть **kubeconfig**:

```bash
aws eks update-kubeconfig --region eu-north-1 --name goit-devops-hw-eks
```

Корисні виходи:

```bash
terraform output ecr_repository_url
terraform output eks_configure_kubeconfig
terraform output argo_cd_admin_password_command
```

---

## Як перевірити Jenkins job

1. **Веб-інтерфейс:** подивіться зовнішню адресу контролера (у чарті — `LoadBalancer`, див. `modules/jenkins/values.yaml`):

   ```bash
   kubectl get svc -n jenkins
   ```

   Відкрийте `http://<EXTERNAL-IP>:80`. Логін і пароль адміністратора — як у `modules/jenkins/values.yaml`.

2. **Плагін Kubernetes:** якщо агенти не стартують, перевірте налаштування **Kubernetes cloud** у Jenkins (інколи потрібна одноразова конфігурація в UI).

3. **Облікові дані:** у Jenkins додайте облікові записи з ID **`github-token`** (логін GitHub + PAT) — їх використовує `Jenkinsfile`.

4. **Pipeline:** створіть job типу Pipeline з **SCM**, вкажіть цей репозиторій і гілку `lesson-8-9`, шлях до скрипта — **`Jenkinsfile`**.

5. **Запуск:** виконайте збірку; мають пройти етапи **Checkout → Resolve ECR → Build and push (Kaniko) → Bump Helm values and push** (параметри описані на початку `Jenkinsfile`).

---

## Як побачити результат в Argo CD

1. **kubectl** уже налаштований (див. вище).

2. **URL сервера:** Argo CD сервер виставлений як `LoadBalancer` (`modules/argo-cd/values.yaml`):

   ```bash
   kubectl get svc -n argocd
   ```

   Використовуйте **EXTERNAL-IP**, підключення по **HTTPS**, порт **443** (як у values).

3. **Початковий пароль адміна:**

   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret \
     -o jsonpath="{.data.password}" | base64 -d
   echo
   ```

   Користувач: **`admin`**.

4. **Application:** у UI відкрийте **Applications** → застосунок **`django-app`** (ім’я з `modules/argo-cd/variables.tf`). Очікуйте статуси **Synced** та **Healthy**, коли в Git коректний чарт і образ.

---

## Примітка про малі ноди EKS (`t3.micro`)

У модулі `modules/eks` за замовчуванням можуть використовуватись інстанси **`t3.micro`**: мало оперативної пам’яті та низька щільність подів на ноду. У **Jenkins** контейнер **`init`** завантажує плагіни через Java; при малому ліміті пам’яті можливий **`OutOfMemoryError`** під час роботи з `plugin-versions.json`. Для стабільного запуску потрібні більші типи інстансів, більше нод, менший набір плагінів або образ Jenkins з уже встановленими плагінами.
