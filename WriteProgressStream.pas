{$mode delphi}
unit WriteProgressStream;

// Author: www.xelitan.com/
// License: MIT

interface

uses
  Classes, SysUtils;

type
  TWriteProgressEvent = procedure(BytesWritten, TotalBytes: Int64) of object;

  TWriteProgressStream = class(TStream)
  private
    FStream: TStream;
    FTotalSize: Int64;
    FBytesWritten: Int64;
    FOnProgress: TWriteProgressEvent;
  protected
    function GetSize: Int64; override;
  public
    constructor Create(AStream: TStream; ATotalSize: Int64);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    property BytesWritten: Int64 read FBytesWritten;
    property OnProgress: TWriteProgressEvent read FOnProgress write FOnProgress;
  end;

implementation

constructor TWriteProgressStream.Create(AStream: TStream; ATotalSize: Int64);
begin
  inherited Create;
  FStream := AStream;
  FTotalSize := ATotalSize;
  FBytesWritten := 0;
end;

function TWriteProgressStream.GetSize: Int64;
begin
  Result := FTotalSize;
end;

function TWriteProgressStream.Read(var Buffer; Count: Longint): Longint;
begin
  raise EStreamError.Create('TWriteProgressStream is write-only');
end;

function TWriteProgressStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := FStream.Write(Buffer, Count);
  if Result > 0 then
  begin
    Inc(FBytesWritten, Result);
    if Assigned(FOnProgress) then
      FOnProgress(FBytesWritten, FTotalSize);
  end;
end;

function TWriteProgressStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := FStream.Seek(Offset, Origin);
end;

end.
