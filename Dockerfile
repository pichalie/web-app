# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["razor-web/razor-web.csproj", "razor-web/"]
COPY ["razor-web.test/razor-web.test.csproj", "razor-web.test/"]

RUN dotnet restore "razor-web/razor-web.csproj"
COPY . .
WORKDIR "/src/razor-web"
RUN dotnet build "./razor-web.csproj" -c $BUILD_CONFIGURATION -o /app/build

WORKDIR "/src/razor-web.test"
RUN dotnet test "./razor-web.test.csproj"
WORKDIR "/src/razor-web"

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./razor-web.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "razor-web.dll"]