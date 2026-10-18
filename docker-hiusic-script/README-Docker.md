# Hiusic Microservices Docker Setup

This repository contains the Docker Compose setup for running all Hiusic microservices with Azure SQL Database.

## Services

- **auth-hiusic-service**: Authentication service (Port 7777)
- **product-hiusic-service**: Product management service (Port 8888)
- **redis**: Cache used by Product Service (Port 6379)
- **bakery-hiusic-ui**: Angular frontend application (Port 4200)

## Prerequisites

- Docker Desktop installed and running
- At least 4GB RAM available for Docker
- Ports 6379, 7777, 8888, and 80 available
- **Azure SQL Database** configured and accessible
- Valid Azure SQL Database credentials

## Quick Start

1. **Clone and navigate to the project directory**
   ```bash
   cd w:\Hiusic\docker-hiusic-script
   ```

2. **Create environment file**
   Create a `.env` file with your Azure SQL Database configuration:
   ```bash
   # Create .env file
   notepad .env
   ```

3. **Configure Azure SQL Database**
   Add the following to your `.env` file:
   ```env
   # Azure SQL Database Configuration
   AZURE_SQL_SERVER_NAME=your-server-name
   AZURE_SQL_DATABASE_NAME=hiusic-database
   AZURE_SQL_USERNAME=your-username
   AZURE_SQL_PASSWORD=your-password
   JWT_SECRET_KEY=mySecretKey123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
   ```

4. **Start all services**
   ```bash
   docker-compose up -d
   ```

5. **Check service status**
   ```bash
   docker-compose ps
   ```

## Service URLs

Once all services are running, you can access:

- **Frontend**: http://localhost:80
- **Auth Service API**: http://localhost:7777
- **Product Service API**: http://localhost:8888
- **Redis**: localhost:6379

### API Documentation (Swagger)

- **Auth Service**: http://localhost:7777/swagger-ui/index.html
- **Product Service**: http://localhost:8888/swagger-ui/index.html

## Azure SQL Database Connection

Services connect to Azure SQL Database using the following configuration:

- **Server**: {AZURE_SQL_SERVER_NAME}.database.windows.net
- **Port**: 1433
- **Database**: {AZURE_SQL_DATABASE_NAME}
- **Username**: {AZURE_SQL_USERNAME}
- **Password**: {AZURE_SQL_PASSWORD}
- **Connection**: Encrypted with SSL enabled

**Example connection string:**
```
jdbc:sqlserver://hiusic-server.database.windows.net:1433;database=hiusic-database;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
```

## Common Commands

### Start services
```bash
docker-compose up -d
```

### Stop services
```bash
docker-compose down
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f auth-hiusic-service
```

### Rebuild services
```bash
# Rebuild all services
docker-compose up -d --build

# Rebuild specific service
docker-compose up -d --build auth-hiusic-service
```

### Clean up (remove containers, networks, and volumes)
```bash
docker-compose down -v
docker system prune -f
```

## Development

### Building individual services

**Java Services:**
```bash
# Auth service
cd auth-hiusic-service
./gradlew clean bootJar

# Product service
cd product-hiusic-service
./gradlew clean bootJar

**Angular Frontend:**
```bash
cd bakery-hiusic-ui
npm install
npm run build
```

## Troubleshooting

### Service won't start
1. Check if ports are available
2. Check Docker logs: `docker-compose logs [service-name]`
3. Verify Azure SQL Database connectivity

### Product Service cannot connect to Redis
1. Check Redis health with `docker compose ps redis`
2. Check Redis logs with `docker compose logs redis`
3. Keep `REDIS_HOST=redis` when Product Service runs inside this Compose stack

### Database connection issues
1. **Check Azure SQL Database connectivity**
   ```bash
   # Test connection to Azure SQL Database
   docker run --rm mcr.microsoft.com/mssql-tools /opt/mssql-tools/bin/sqlcmd -S {your-server}.database.windows.net -U {username} -P {password} -Q "SELECT 1"
   ```

2. **Verify environment variables**
   - Check `.env` file exists and contains correct values
   - Ensure Azure SQL Database credentials are valid
   - Verify server name format: `server-name.database.windows.net`

3. **Common Azure SQL Database issues**
   - **Firewall**: Add your IP address to Azure SQL Database firewall rules
   - **Database exists**: Ensure the database exists in Azure SQL Server
   - **Credentials**: Verify username/password are correct
   - **SSL**: Azure SQL Database requires encrypted connections

### Frontend can't connect to backend
1. Check if all backend services are running
2. Verify nginx proxy configuration in nginx.conf
3. Check browser console for CORS errors

### Memory issues
1. Increase Docker Desktop memory allocation
2. Close unnecessary applications
3. Consider running services individually if needed

## Architecture

```
┌─────────────────┐    ┌─────────────────┐
│  Frontend       │    │  Auth Service   │
│  (Angular)      │    │  (Port 7777)    │
│  Port 80        │    └─────────────────┘
└─────────────────┘              │
         │                       │
         │                       ▼
         │              ┌─────────────────┐
         └─────────────▶│ Azure SQL DB    │
                        │ (Cloud)         │
         ┌─────────────▶│ Encrypted SSL   │
         │              └─────────────────┘
         │                       ▲
┌─────────────────┐              │
│  Product Service│              │
│  (Port 8888)    │──────────────┘
└─────────────────┘  
```

## Environment Configuration

You can modify the `.env` file to customize:

### Required Environment Variables
- `AZURE_SQL_SERVER_NAME`: Your Azure SQL Server name (without .database.windows.net)
- `AZURE_SQL_DATABASE_NAME`: Your Azure SQL Database name
- `AZURE_SQL_USERNAME`: Your Azure SQL Database username
- `AZURE_SQL_PASSWORD`: Your Azure SQL Database password
- `JWT_SECRET_KEY`: Secret key for JWT token generation

### Example .env file:
```env
AZURE_SQL_SERVER_NAME=hiusic-sql-server
AZURE_SQL_DATABASE_NAME=hiusic-database
AZURE_SQL_USERNAME=hiusicadmin
AZURE_SQL_PASSWORD=YourStrong!Passw0rd123
JWT_SECRET_KEY=mySecretKey123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
```

## Production Considerations

For production deployment, consider:
1. **Security**:
   - Use Docker secrets or Azure Key Vault for sensitive data
   - Implement proper SSL/TLS certificates
   - Configure Azure SQL Database firewall rules appropriately
   - Use managed identities for Azure SQL Database authentication

2. **Monitoring & Logging**:
   - Implement centralized logging (Azure Monitor, ELK Stack)
   - Set up Azure Application Insights for application monitoring
   - Configure Azure SQL Database performance monitoring

3. **Scalability**:
   - Set up container orchestration (Azure Container Instances, Kubernetes)
   - Configure Azure SQL Database auto-scaling
   - Implement load balancing for microservices

4. **Backup & Disaster Recovery**:
   - Azure SQL Database provides automated backups
   - Configure point-in-time recovery
   - Set up geo-replication for disaster recovery

5. **Performance**:
   - Configure Azure SQL Database performance tiers appropriately
   - Implement connection pooling
   - Use Azure Redis Cache for caching layer
