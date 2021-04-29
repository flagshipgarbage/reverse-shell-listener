Param(
    [parameter(mandatory=$true)][Alias("i")][String]$IPAddress,
    [parameter(mandatory=$true)][Alias("p")][int]$Port
)

try {
    # Start Listener
    $listener = New-Object System.Net.Sockets.TcpListener($IPAddress, $Port)
    $listener.start()
    Write-Host ("[*] Waiting for connection on " + $IPAddress + ":" + $Port)

    # Establish Connection
    $connectionHandler = $listener.BeginAcceptTcpClient($null, $null)
    While (!$connectionHandler.IsCompleted) {}
    $client = $listener.EndAcceptTcpClient($connectionHandler);
    Write-Host ("[*] Connected with " + $client.Client.RemoteEndPoint.Address.IPAddressToString)

    # Prepare Necessary Elements
    $stream = $client.GetStream()
    while(!$stream.DataAvailable){}
    $bufferSize = $client.ReceiveBufferSize
    $buffer = (New-Object System.Byte[] $bufferSize)
    $encoding = New-Object System.Text.ASCIIEncoding    
    $writer = New-Object System.IO.StreamWriter($stream)

    # Start Communication    
    while($client.Connected)
    {
        while($stream.DataAvailable)
        {
            $streamReading = $stream.BeginRead($buffer, 0, $bufferSize, $null, $null)
            while(!$streamReading.IsCompleted){}
            $readBytes = $stream.EndRead($streamReading)
            $receivedData = $buffer[0..([int]$readBytes - 1)]
            $output = $encoding.GetString($receivedData)       
            Write-Host -NoNewline ($output)
        }

        $cmd = Read-Host
        if($cmd -eq "exit"){break}
        $writer.Writeline($cmd) 
        $writer.Flush()
        while(!$stream.DataAvailable){}
    }
} 
finally
{
    if($client -ne $null){$client.Close()}
    if($listener -ne $null){$listener.Stop()}
}