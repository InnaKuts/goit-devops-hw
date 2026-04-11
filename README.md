# GoIT DevOps — домашні роботи

Репозиторій з **семантичною структурою каталогів** (не за номерами занять): інфраструктура, застосунок і Helm окремо, щоб було простіше підтримувати й здавати як один проєкт.

## Структура

| Каталог | Призначення |
|---------|-------------|
| **`terraform/`** | AWS: віддалений state (S3 + `use_lockfile`), VPC, ECR, **EKS** |
| **`charts/`** | Helm: Django (`django-app`), Metrics Server, залежність PostgreSQL (Bitnami) |
| **`django/`** | Код Django і **Dockerfile** (образ для ECR) |
| **`docker-compose.yml`** | Локальний запуск Django + Postgres + nginx |
| **`ai/`** | Оригінальні формулювання завдань курсу (для звірки) |

## Документація

- **[Terraform (AWS)](terraform/README.md)** — `init` / `apply`, модулі, kubeconfig, витрати, `destroy`
- **[Helm (Kubernetes)](charts/README.md)** — Metrics Server, реліз застосунку, `migrate`, видалення релізів

Усі команди в дочірніх README передбачають роботу **з кореня репозиторію**, якщо не вказано інше.

## Зв’язок із вимогами курсу

Деякі завдання описують каталог на кшталт `lesson-7/` — у цьому репо відповідний корінь Terraform — **`terraform/`**, чарти — **`charts/`**. Зміст (EKS, ECR, Helm) той самий; відмінність лише в іменах шляхів.
