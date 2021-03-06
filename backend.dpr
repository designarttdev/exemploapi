program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses Horse, Horse.Jhonson, System.JSON, Horse.Commons, System.SysUtils;

var Users: TJSONArray;

begin
  THorse.Use(Jhonson());

  Users := TJSONArray.Create;

  THorse.Get('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send<TJSONAncestor>(Users.Clone);
    end);

  THorse.Post('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      User : TJSONObject;
    begin
      User := Req.Body<TJSONObject>.Clone as TJSONObject;
      Users.AddElement(User);
      Res.Send<TJSONAncestor>(User.Clone).Status(THTTPStatus.Created);
    end);

  THorse.Delete('/users/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      Id: Integer;
    begin
      Id := Req.Params.Items['id'].ToInteger;
      Users.Remove(Pred(Id)).Free;
      Res.Send<TJSONAncestor>(Users.Clone).Status(THTTPStatus.NoContent);
    end);

  THorse.Listen(9000);
end.
