unit PointerStream;

//License: MIT
//Author: www.xelitan.com
//
//Example:
//var Bytes: TBytes;
//begin
//Stream := TPointerStream.Create(@Bytes[0], Length(Bytes));

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPointerStream = class(TStream)
  private
    FData: PByte;
    FSize: Int64;
    FPosition: Int64;
  public
    constructor Create(AData: Pointer; ASize: Int64);

    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;

    property Memory: Pointer read FData;
    property Size: Int64 read FSize;
  end;

implementation

constructor TPointerStream.Create(AData: Pointer; ASize: Int64);
begin
  inherited Create;

  if (AData = nil) and (ASize > 0) then
    raise EStreamError.Create('TPointerStream: nil pointer with non-zero size');

  if ASize < 0 then
    raise EStreamError.Create('TPointerStream: negative size');

  FData := PByte(AData);
  FSize := ASize;
  FPosition := 0;
end;

function TPointerStream.Read(var Buffer; Count: Longint): Longint;
var
  Available: Int64;
begin
  if Count <= 0 then
    Exit(0);

  Available := FSize - FPosition;

  if Available <= 0 then
    Exit(0);

  if Count > Available then
    Count := Available;

  Move((FData + FPosition)^, Buffer, Count);
  Inc(FPosition, Count);

  Result := Count;
end;

function TPointerStream.Write(const Buffer; Count: Longint): Longint;
var
  Available: Int64;
begin
  if Count <= 0 then
    Exit(0);

  Available := FSize - FPosition;

  if Available <= 0 then
    Exit(0);

  if Count > Available then
    Count := Available;

  Move(Buffer, (FData + FPosition)^, Count);
  Inc(FPosition, Count);

  Result := Count;
end;

function TPointerStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
var
  NewPosition: Int64;
begin
  case Origin of
    soBeginning:
      NewPosition := Offset;

    soCurrent:
      NewPosition := FPosition + Offset;

    soEnd:
      NewPosition := FSize + Offset;
  else
    raise EStreamError.Create('TPointerStream: invalid seek origin');
  end;

  if NewPosition < 0 then
    NewPosition := 0
  else if NewPosition > FSize then
    NewPosition := FSize;

  FPosition := NewPosition;
  Result := FPosition;
end;

end.