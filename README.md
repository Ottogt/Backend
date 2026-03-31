# Hábitos Atómicos — API (solo backend)

Repositorio mínimo para desplegar el backend en **Vercel** sin monorepo.

## Variables en Vercel

- `MONGODB_URI` — Atlas (con nombre de base en la URI).
- `JWT_SECRET` — secreto largo.
- Opcional: `JWT_EXPIRE` (por defecto el código usa `7d`).

**Root Directory:** déjalo vacío (la raíz de este repo **es** el backend).

## Comprobar

Tras el deploy: `GET https://tu-proyecto.vercel.app/api/health`

## Local

```bash
cp .env.example .env   # si existe; configura MONGODB_URI y JWT_SECRET
npm install
npm start
```
