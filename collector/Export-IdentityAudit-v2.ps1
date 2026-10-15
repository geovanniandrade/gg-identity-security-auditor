# GG Identity Security Collector v2 - AD read-only
# Uso somente com autorizacao. Escopo recomendado: OU de teste.
param(
 [Parameter(Mandatory=$true)][string]$SearchBase,
 [string]$OutputDirectory = "$env:TEMP\GG-Identity-Audit"
)
$ErrorActionPreference='Stop'
Import-Module ActiveDirectory -ErrorAction Stop
New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$now=Get-Date
$priv=@{}
$privOK=$true
# SID built-in / RID identifying privileged domain groups, recursively where supported.
$domain=Get-ADDomain
$groups=@("$($domain.DomainSID.Value)-512","$($domain.DomainSID.Value)-519","S-1-5-32-544")
foreach($sid in $groups){
 try {
  $g=Get-ADGroup -Identity $sid -ErrorAction Stop
  Get-ADGroupMember -Identity $g -Recursive -ErrorAction Stop |
   Where-Object objectClass -eq 'user' |
   ForEach-Object {$priv[$_.DistinguishedName]=$true}
 } catch { $privOK=$false; Write-Warning "Grupo privilegiado nao consultado: $sid" }
}
$users=Get-ADUser -SearchBase $SearchBase -Filter * -Properties Enabled,LastLogonDate,PasswordNeverExpires,PasswordNotRequired,LockedOut,whenCreated,PasswordLastSet,DistinguishedName
$rows=foreach($u in $users){
 [pscustomobject]@{
  User=$u.SamAccountName
  Enabled=$u.Enabled.ToString().ToLowerInvariant()
  LastLogonDays=if($u.LastLogonDate){[int](($now-$u.LastLogonDate).TotalDays)}else{''}
  IsAdmin=if(-not $privOK){''}elseif($priv.ContainsKey($u.DistinguishedName)){'true'}else{'false'}
  PasswordNeverExpires=$u.PasswordNeverExpires.ToString().ToLowerInvariant()
  PasswordNotRequired=$u.PasswordNotRequired.ToString().ToLowerInvariant()
  LockedOut=$u.LockedOut.ToString().ToLowerInvariant()
  CreatedDate=if($u.whenCreated){$u.whenCreated.ToString('yyyy-MM-dd')}else{''}
  PasswordAgeDays=if($u.PasswordLastSet){[int](($now-$u.PasswordLastSet).TotalDays)}else{''}
 }
}
$rows | Export-Csv -LiteralPath (Join-Path $OutputDirectory 'gg-identity-audit-v2.csv') -NoTypeInformation -Encoding UTF8
try {
 $pol=Get-ADDefaultDomainPasswordPolicy -ErrorAction Stop
 [pscustomobject]@{
  MinPasswordLength=$pol.MinPasswordLength
  ComplexityEnabled=$pol.ComplexityEnabled
  LockoutThreshold=$pol.LockoutThreshold
  LockoutDuration=$pol.LockoutDuration.ToString()
  PasswordHistoryCount=$pol.PasswordHistoryCount
  MaxPasswordAge=$pol.MaxPasswordAge.ToString()
  Note='Default domain policy only; FGPP/GPO/effective application not audited.'
 } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $OutputDirectory 'gg-domain-policy.json') -Encoding UTF8
} catch {Write-Warning "Politica de dominio nao coletada: $($_.Exception.Message)"}
Write-Host "Relatorios em: $OutputDirectory"
Write-Host 'LastLogonDate e aproximado; IsAdmin verifica apenas grupos selecionados. Nao presume cobertura completa.'
