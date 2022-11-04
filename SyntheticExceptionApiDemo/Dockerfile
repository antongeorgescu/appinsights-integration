#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["SyntheticExceptionApiDemo/SyntheticExceptionApiDemo.csproj", "SyntheticExceptionApiDemo/"]
RUN dotnet restore "SyntheticExceptionApiDemo/SyntheticExceptionApiDemo.csproj"
COPY . .
WORKDIR "/src/SyntheticExceptionApiDemo"
RUN dotnet build "SyntheticExceptionApiDemo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SyntheticExceptionApiDemo.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SyntheticExceptionApiDemo.dll"]