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
