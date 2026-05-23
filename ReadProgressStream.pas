{$mode delphi}
unit ReadProgressStream;

// Author: www.xelitan.com/
// License: MIT

interface

uses
  Classes, SysUtils;

type
  TReadProgressEvent = procedure(BytesRead, TotalBytes: Int64) of object;

  TReadProgressStream = class(TStream)
  private
    FStream: TStream;
    FOnProgress: TReadProgressEvent;
  protected
    function GetSize: Int64; override;
  public
    constructor Create(AStream: TStream);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    property OnProgress: TReadProgressEvent read FOnProgress write FOnProgress;
  end;

implementation

constructor TReadProgressStream.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
end;

function TReadProgressStream.GetSize: Int64;
begin
  Result := FStream.Size;
end;

function TReadProgressStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := FStream.Read(Buffer, Count);
  if Assigned(FOnProgress) and (Result > 0) then
    FOnProgress(FStream.Position, FStream.Size);
end;

function TReadProgressStream.Write(const Buffer; Count: Longint): Longint;
begin
  raise EStreamError.Create('TReadProgressStream is read-only');
end;

function TReadProgressStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := FStream.Seek(Offset, Origin);
end;

end.
