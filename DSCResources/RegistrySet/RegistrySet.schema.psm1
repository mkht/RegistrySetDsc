Configuration RegistrySet
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [string]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [string]
        $Key,

        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $RegParams
    )

    $UniqueKey = [guid]::NewGuid().ToString().SubString(0, 8)

    $TemplateString = @'
    xRegistry RegistrySet_{0}_{3}
    {{
        Ensure = '{1}'
        Key = '{2}'
        ValueName = '{3}'
        Force = $true
'@

    $ResourceString = ($RegParams | ForEach-Object {
            $Resource = ($TemplateString -f $UniqueKey, $Ensure, $Key, $_.Name)
            if ($null -ne $_.Data) { $Resource += ("`r`n" + ("ValueData = '{0}'" -f $_.Data)) }
            if ($null -ne $_.Type) { $Resource += ("`r`n" + ("ValueType = '{0}'" -f $_.Type)) }
            $Resource += "`r`n }"
            $Resource
        }) -join "`r`n"

    . ([ScriptBlock]::Create($ResourceString))
}