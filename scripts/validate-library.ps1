param(
    [string]$Path = "library.json"
)

$allowedCategories = @(
    "Animation",
    "Integration",
    "Productivity",
    "Media",
    "SystemUtility",
    "Theme",
    "Widget",
    "Fun",
    "Other"
)

$versionPattern = '^\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?$'
$shaPattern = '^[A-Fa-f0-9]{64}$'
$errors = New-Object System.Collections.Generic.List[string]

function Add-ValidationError {
    param([string]$Message)

    $script:errors.Add($Message)
}

function Test-RequiredString {
    param(
        [object]$Value,
        [string]$Name
    )

    if ([string]::IsNullOrWhiteSpace([string]$Value)) {
        Add-ValidationError "$Name is required."
        return $false
    }

    return $true
}

function Test-HttpsUrl {
    param(
        [object]$Value,
        [string]$Name,
        [bool]$AllowEmpty = $false
    )

    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) {
        if ($AllowEmpty) {
            return $true
        }

        Add-ValidationError "$Name is required."
        return $false
    }

    $uri = $null
    if (-not [System.Uri]::TryCreate($text, [System.UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -ne "https") {
        Add-ValidationError "$Name must be an absolute https URL."
        return $false
    }

    return $true
}

if (-not (Test-Path -LiteralPath $Path)) {
    throw "Could not find '$Path'."
}

try {
    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $library = $raw | ConvertFrom-Json
}
catch {
    throw "Failed to parse '$Path' as JSON. $($_.Exception.Message)"
}

if (-not (Test-RequiredString $library.version "version")) {
}

if ($null -eq $library.plugins) {
    Add-ValidationError "plugins array is required."
}
elseif (-not ($library.plugins -is [System.Array])) {
    Add-ValidationError "plugins must be an array."
}
else {
    $seenIds = @{}
    $index = 0

    foreach ($plugin in $library.plugins) {
        $prefix = "plugins[$index]"

        if ($null -eq $plugin) {
            Add-ValidationError "$prefix must not be null."
            $index++
            continue
        }

        $requiredFields = @(
            "id",
            "name",
            "version",
            "author",
            "description",
            "minimumWinNotchVersion",
            "downloadUrl",
            "homepage",
            "category"
        )

        foreach ($field in $requiredFields) {
            $null = Test-RequiredString $plugin.$field "$prefix.$field"
        }

        if (-not [string]::IsNullOrWhiteSpace([string]$plugin.id)) {
            if ($seenIds.ContainsKey($plugin.id)) {
                Add-ValidationError "$prefix.id duplicates plugin id '$($plugin.id)'."
            }
            else {
                $seenIds[$plugin.id] = $true
            }
        }

        if (-not [string]::IsNullOrWhiteSpace([string]$plugin.version) -and $plugin.version -notmatch $versionPattern) {
            Add-ValidationError "$prefix.version must use semantic version format."
        }

        if (-not [string]::IsNullOrWhiteSpace([string]$plugin.minimumWinNotchVersion) -and $plugin.minimumWinNotchVersion -notmatch $versionPattern) {
            Add-ValidationError "$prefix.minimumWinNotchVersion must use semantic version format."
        }

        $null = Test-HttpsUrl $plugin.downloadUrl "$prefix.downloadUrl"
        $null = Test-HttpsUrl $plugin.homepage "$prefix.homepage"
        $null = Test-HttpsUrl $plugin.iconUrl "$prefix.iconUrl" $true

        if (-not [string]::IsNullOrWhiteSpace([string]$plugin.category) -and $allowedCategories -notcontains [string]$plugin.category) {
            Add-ValidationError "$prefix.category must be one of: $($allowedCategories -join ', ')."
        }

        if ($null -eq $plugin.permissions) {
            Add-ValidationError "$prefix.permissions must be an array."
        }
        elseif (-not ($plugin.permissions -is [System.Array])) {
            Add-ValidationError "$prefix.permissions must be an array."
        }

        if ($null -eq $plugin.dependencies) {
            Add-ValidationError "$prefix.dependencies must be an array."
        }
        elseif (-not ($plugin.dependencies -is [System.Array])) {
            Add-ValidationError "$prefix.dependencies must be an array."
        }

        if ($null -ne $plugin.sha256 -and -not [string]::IsNullOrWhiteSpace([string]$plugin.sha256) -and $plugin.sha256 -notmatch $shaPattern) {
            Add-ValidationError "$prefix.sha256 must be a 64-character hexadecimal SHA-256 hash."
        }

        if ($null -ne $plugin.releaseDate -and -not [string]::IsNullOrWhiteSpace([string]$plugin.releaseDate)) {
            $parsedDate = [System.DateTimeOffset]::MinValue
            if (-not [System.DateTimeOffset]::TryParse([string]$plugin.releaseDate, [ref]$parsedDate)) {
                Add-ValidationError "$prefix.releaseDate must be a valid ISO 8601 date-time."
            }
        }

        if ($null -eq $plugin.isVerified -or ($plugin.isVerified -isnot [bool])) {
            Add-ValidationError "$prefix.isVerified must be a boolean."
        }

        $index++
    }
}

if ($errors.Count -gt 0) {
    foreach ($errorMessage in $errors) {
        Write-Error $errorMessage
    }

    exit 1
}

$pluginCount = 0
if ($null -ne $library.plugins) {
    $pluginCount = @($library.plugins).Count
}

Write-Host "library.json validation passed for $pluginCount plugin(s)."
