# GG Identity Security Auditor - AD export (read-only)
# Run only with approval and AD read access. No passwords or secrets exported.
param([string]$OutputPath = (Join-Path ([Environment]::GetFolderPath('Desktop')) 'gg-identity-audit.csv'))
$ErrorActionPreference='Stop'
Import-Module ActiveDirectory -ErrorAction Stop
$today=Get-Date
$privileged=@{}
# Snapshot of direct membership only; nested/effective privileges are NOT evaluated.
foreach($group in @('Domain Admins','Enterprise Admins','Administrators')) {
 try { Get-ADGroupMember -Identity $group -ErrorAction Stop |
   Where-Object {$_.objectClass -eq 'user'} |
   ForEach-Object {$privileged[$_.DistinguishedName]=$true}
 } catch { Write-Warning "Cannot read group $group; administrative flags may be incomplete." }
}
Get-ADUser -Filter * -Properties LastLogonDate,Enabled,DistinguishedName |
 ForEach-Object {
  [pscustomobject]@{
   User=$_.SamAccountName
   Enabled=($_.Enabled.ToString().ToLowerInvariant())
   LastLogonDays=if($_.LastLogonDate){[int](($today-$_.LastLogonDate).TotalDays)}else{''}
   IsAdmin=if($privileged.ContainsKey($_.DistinguishedName)){'true'}else{'false'}
  }
 } | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "CSV created: $OutputPath"
Write-Host 'LastLogonDate is replicated/approximate; IsAdmin represents limited direct group checks only.'
Write-Host 'Review and protect identity data; use only approved internal workflows.'
