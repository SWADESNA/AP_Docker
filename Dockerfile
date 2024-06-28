#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
#USER app
WORKDIR /app
USER app
EXPOSE 80
#USER app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Deedforge/Deedforge/Deedforge.csproj", "Deedforge/Deedforge/"]
COPY ["Deedforge.Domain/Deedforge.Domain.csproj", "Deedforge.Domain/"]
COPY ["Deedforge.Shared/Deedforge.Shared.csproj", "Deedforge.Shared/"]
COPY ["Deedforge/Deedforge.Client/Deedforge.Client.csproj", "Deedforge/Deedforge.Client/"]
RUN dotnet restore "./Deedforge/Deedforge/Deedforge.csproj"
COPY . .
WORKDIR "/src/Deedforge/Deedforge"
RUN dotnet build "./Deedforge.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
RUN dotnet publish "./Deedforge.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Deedforge.dll"]
