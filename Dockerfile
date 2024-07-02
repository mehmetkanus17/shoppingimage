# Resmi Nginx temel imajını kullanın
FROM nginx:latest

# Özel HTML dosyasını ekleyin
COPY index.html /usr/share/nginx/html/index.html

# Docker içinde çalışacak komutu belirtin
CMD ["nginx", "-g", "daemon off;"]