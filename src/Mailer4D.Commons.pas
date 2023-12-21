unit Mailer4D.Commons;

interface

uses
  System.SysUtils,
  System.RegularExpressions;

const
  {original pattern     =  src\s*=\s*["']data:image\/[^;]+;base64,([^"']+)["']}
  C_REGEX_INLINE_BASE64     = 'src\s*=\s*["'']data:image\/[^;]+;base64,([^"'']+)["'']';
  C_REGEXP_BASE64_EXTENSION = 'data:image\/(\w+);base64,';


  function MatchInlineImages(ABody: String): TMatchCollection;
  function Base64Src(AValue: String): String;
  function Base64Extension(AValue: String): String;

implementation

function MatchInlineImages(ABody: String): TMatchCollection;
begin
  Result:= TRegex.Matches(ABody, C_REGEX_INLINE_BASE64, [roIgnoreCase]);
end;

function Base64Src(AValue: String): String;
var
  LMatch: TMatch;
begin
  Result:= EmptyStr;

  LMatch:= TRegex.Match(AValue, C_REGEX_INLINE_BASE64, [roIgnoreCase]);

  Result:= LMatch.Groups[1].Value;
end;

function Base64Extension(AValue: String): String;
begin
  Result:= TRegEx.Match(AValue, C_REGEXP_BASE64_EXTENSION, [roIgnoreCase]).Groups[1].Value;
end;

end.
