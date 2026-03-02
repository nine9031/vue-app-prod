# ใช้ Node.js เพื่อติดตั้งและ Build Vue.js
FROM node:18 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
ARG VITE_BASE_URL=/
ENV VITE_BASE_URL=$VITE_BASE_URL
RUN npm run build

# ตรวจสอบว่าไฟล์ถูกสร้างจริง
RUN ls -la /app/dist

# ใช้ Nginx เพื่อเสิร์ฟไฟล์ Static
FROM nginx:latest
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]