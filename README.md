# ReadProgressStream

Wherever TStream is used, you can easily attach this class to monitor the progress of data reading.

```
var
  fs: TFileStream;
  ps: TReadProgressStream;

procedure OnProgress(BytesRead, TotalBytes: Int64);
begin
  WriteLn(Format('%d / %d bytes', [BytesRead, TotalBytes]));
end;

begin
  fs := TFileStream.Create('big.zip', fmOpenRead);
  ps := TReadProgressStream.Create(fs);
  ps.OnProgress := OnProgress;

  SomeDecompressor.ReadFrom(ps);   // progress fires transparently

  ps.Free;
  fs.Free;
end;
```

# WriteProgressStream

Wherever TStream is used, you can easily attach this class to monitor the progress of data writing.

```
var
  fs: TFileStream;
  ws: TWriteProgressStream;

procedure OnProgress(BytesWritten, TotalBytes: Int64);
begin
  ProgressBar.Position := Round(BytesWritten / TotalBytes * 100);
end;

begin
  fs := TFileStream.Create('out.bin', fmCreate);
  ws := TWriteProgressStream.Create(fs, UncompressedSize);
  ws.OnProgress := OnProgress;

  SomeDecompressor.WriteTo(ws);

  ws.Free;
  fs.Free;
end;
```
