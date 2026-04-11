# Helm — Kubernetes (Django, PostgreSQL, Metrics Server)

Чарти для розгортання застосунку в **EKS** (або іншому кластері з `kubectl`). Шляхи нижче — **від кореня репозиторію**.

Основний чарт **`django-app`**: Deployment (образ з ECR, `envFrom` → ConfigMap), Service **LoadBalancer**, **HPA** (2–6 реплік, CPU70%), ConfigMap з env теми 4; **PostgreSQL** — залежність Bitnami (сервіс `db`).

Окремий чарт **`metrics-server`** — для `kubectl top` і роботи HPA (встановлюється в `kube-system`).

## Передумови

- Налаштований контекст **`kubectl`** на потрібний кластер (`aws eks update-kubeconfig ...`).
- Образ Django уже в **ECR**; у `charts/django-app/values.yaml` поля `image.repository` / `image.tag` відповідають вашому репозиторію.
- Після зміни **`Chart.yaml`** (залежності) або першого клону без локальних `.tgz`: `helm dependency update` у відповідному каталозі чарта (див. нижче; архіви `charts/*/charts/*.tgz` у Git не комітяться — див. кореневий `.gitignore`).

## 1. Metrics Server (спочатку; для всього кластера, HPA)

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
cd charts/metrics-server
helm dependency update
helm upgrade --install metrics-server . -n kube-system --create-namespace
cd ../..
```

Перевірка: `kubectl top nodes`

## 2. Django + PostgreSQL

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
cd charts/django-app
helm dependency update
helm upgrade --install my-django . -n app --create-namespace
cd ../..
```

Одноразове налаштування БД:

```bash
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql -n app --timeout=300s
kubectl exec -n app deploy/my-django-django -- python manage.py migrate
```

URL застосунку: `kubectl get svc -n app my-django-django` → **EXTERNAL-IP** або hostname NLB на порту **80**.

## Видалення релізів

```bash
helm uninstall my-django -n app
helm uninstall metrics-server -n kube-system
```
