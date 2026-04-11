# Helm-чарти (заняття 7)

## 1. Metrics Server (спочатку; для всього кластера, HPA)

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
cd charts/metrics-server
helm dependency update   # можна пропустити, якщо вже є charts/metrics-server-*.tgz
helm upgrade --install metrics-server . -n kube-system --create-namespace
cd ../..
```

Перевірка: `kubectl top nodes`

## 2. Django + PostgreSQL

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
cd charts/django-app
helm dependency update   # можна пропустити, якщо вже є charts/postgresql-*.tgz
helm upgrade --install my-django . -n app --create-namespace
cd ../..
```

Одноразове налаштування БД:

```bash
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql -n app --timeout=300s
kubectl exec -n app deploy/my-django-django -- python manage.py migrate
```

URL застосунку: `kubectl get svc -n app my-django-django` → відкрийте **EXTERNAL-IP** (або hostname) на порту **80**.

## Видалення

```bash
helm uninstall my-django -n app
helm uninstall metrics-server -n kube-system
```
