param(
  [string]$JarPath = "$PSScriptRoot\..\target\blogging-app-apis-0.0.1-SNAPSHOT.jar",
  [string]$OutputDir = "$PSScriptRoot\..\docs"
)

if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }

$openapiJson = Join-Path $OutputDir 'openapi.json'

# Check Java
try { $javaVersionOutput = & java -version 2>&1 } catch { Write-Error "Java is not installed or not available in PATH. Please install Java 11+."; exit 1 }

# Simple parse of major version
if ($javaVersionOutput -match 'version "([0-9]+)') { $major = [int]$matches[1] } else { $major = 0 }
if ($major -lt 11) { Write-Warning "Detected Java major version $major. This project needs Java 11 to run the app and generate the docs locally." }

function Test-Health {
  try { Invoke-WebRequest -UseBasicParsing -Uri http://localhost:8080/api/v1/health -TimeoutSec 5 | Out-Null; return $true } catch { return $false }
}

if (-not (Test-Health)) {
  if (-not (Test-Path $JarPath)) { Write-Error "Jar not found at $JarPath. Build the project with 'mvn -B package -DskipTests' first."; exit 1 }
  Write-Host "Starting app from $JarPath ..."
  Start-Process -NoNewWindow -FilePath java -ArgumentList "-jar", "$JarPath"
  Start-Sleep -Seconds 5
  $tries = 0
  while (-not (Test-Health) -and $tries -lt 30) { Start-Sleep -Seconds 2; $tries++ }
  if ($tries -ge 30) { Write-Error "App didn't start in time"; exit 1 }
} else {
  Write-Host "App already running on http://localhost:8080"
}

Write-Host "Fetching Swagger JSON from /v2/api-docs ..."
try { Invoke-WebRequest -UseBasicParsing -Uri http://localhost:8080/v2/api-docs -OutFile $openapiJson -TimeoutSec 15; Write-Host "Saved OpenAPI JSON to $openapiJson" } catch { Write-Error "Failed to fetch /v2/api-docs: $_"; exit 1 }

Write-Host "To convert to Postman collection, run:
  npx openapi-to-postmanv2 -s $openapiJson -o (Join-Path $OutputDir 'postman_collection.json') -p"
