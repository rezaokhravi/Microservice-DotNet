FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Services/Catalog/Catalog.Api.csproj", "Catalog.Api/"]
RUN dotnet restore "./Catalog.Api/Catalog.Api.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "./Catalog.Api/Catalog.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./Catalog.Api/Catalog.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#CMD ["--urls", "http://0.0.0.0:80"]
ENTRYPOINT ["dotnet", "Catalog.Api.dll"]
