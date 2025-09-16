#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 693 "Program Selection"
{
    Caption = 'Program Selection';
    DataCaptionExpression = STRSUBSTNO(Text001,AllObjWithCaption."Object Caption",Name);
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Send-To Program";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the program to send data to from Dynamics NAV.';
                }
                field(Executable;Executable)
                {
                    ApplicationArea = Basic;
                    Caption = 'Executable';
                    Editable = false;
                    ToolTip = 'Specifies the name of the executable file that launches the program.';
                    Visible = false;
                }
                field(StylesheetName;StylesheetName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Style Sheet';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupStylesheet;
                    end;

                    trigger OnValidate()
                    begin
                        ValidateStylesheet;
                        StylesheetNameOnAfterValidate;
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetDefaultStylesheet;
    end;

    trigger OnAfterGetRecord()
    begin
        GetDefaultStylesheet;
    end;

    var
        AllObjWithCaption: Record AllObjWithCaption;
        StylesheetName: Text[250];
        ObjType: Integer;
        ObjectID: Integer;
        StylesheetID: Guid;
        Text001: label 'Send %1 to %2';


    procedure SetObjectID(NewObjectType: Integer;NewObjectID: Integer)
    begin
        ObjType := NewObjectType;
        ObjectID := NewObjectID;
        if not AllObjWithCaption.Get(AllObjWithCaption."object type"::Page,NewObjectID) then
          AllObjWithCaption.Init;
    end;


    procedure GetSelectedStyleSheetID(): Guid
    begin
        GetDefaultStylesheet;
        exit(StylesheetID);
    end;

    local procedure LookupStylesheet()
    var
        Stylesheet: Record "Style Sheet";
        Stylesheets: Page "Style Sheets";
    begin
        Stylesheet.SetRange("Program ID","Program ID");
        Stylesheet.SetRange("Object Type",ObjType);
        Stylesheet.SetFilter("Object ID",'%1|%2',0,ObjectID);
        if StylesheetName <> '' then begin
          Stylesheet.SetRange(Name,StylesheetName);
          if Stylesheet.FindFirst then
            Stylesheets.SetRecord(Stylesheet);
          Stylesheet.SetRange(Name);
        end;
        Stylesheets.SetParams(ObjectID,Name);
        Stylesheets.LookupMode := true;
        Stylesheets.SetTableview(Stylesheet);
        if Stylesheets.RunModal = Action::LookupOK then begin
          Stylesheets.GetRecord(Stylesheet);
          SetDefaultStylesheet(Stylesheet);
        end;
    end;

    local procedure ValidateStylesheet()
    var
        Stylesheet: Record "Style Sheet";
    begin
        Stylesheet.SetRange("Program ID","Program ID");
        Stylesheet.SetRange("Object Type",ObjType);
        Stylesheet.SetFilter("Object ID",'%1|%2',0,ObjectID);
        Stylesheet.SetRange(Name,StylesheetName);
        if not Stylesheet.FindFirst then begin
          Stylesheet.SetFilter(Name,'*@' + StylesheetName + '*');
          Stylesheet.FindFirst
        end;
        SetDefaultStylesheet(Stylesheet);
    end;

    local procedure GetDefaultStylesheet()
    var
        UserDefaultStylesheet: Record "User Default Style Sheet";
        Stylesheet: Record "Style Sheet";
        Found: Boolean;
    begin
        if UserDefaultStylesheet.Get(UpperCase(UserId),ObjType,ObjectID,"Program ID") then
          Found := Stylesheet.Get(UserDefaultStylesheet."Style Sheet ID");

        if not Found then begin
          Stylesheet.SetRange("Object ID",ObjectID);
          Stylesheet.SetRange("Object Type",ObjType);
          Stylesheet.SetRange("Program ID","Program ID");
          Found := Stylesheet.FindFirst;
          if not Found then begin
            Stylesheet.SetRange("Object ID",0);
            Found := Stylesheet.FindFirst;
          end;
        end;
        if Found then begin
          StylesheetID := Stylesheet."Style Sheet ID";
          StylesheetName := Stylesheet.Name;
        end else begin
          Clear(StylesheetID);
          StylesheetName := '';
        end;
    end;

    local procedure SetDefaultStylesheet(var Stylesheet: Record "Style Sheet")
    var
        UserDefaultStylesheet: Record "User Default Style Sheet";
    begin
        StylesheetID := Stylesheet."Style Sheet ID";
        StylesheetName := Stylesheet.Name;

        UserDefaultStylesheet.SetRange("User ID",UpperCase(UserId));
        UserDefaultStylesheet.SetRange("Object Type",Stylesheet."Object Type");
        UserDefaultStylesheet.SetRange("Object ID",ObjectID);
        UserDefaultStylesheet.SetRange("Program ID",Stylesheet."Program ID");
        UserDefaultStylesheet.DeleteAll;

        UserDefaultStylesheet."User ID" := UpperCase(UserId);
        UserDefaultStylesheet."Object Type" := Stylesheet."Object Type";
        UserDefaultStylesheet."Object ID" := ObjectID;
        UserDefaultStylesheet."Program ID" := Stylesheet."Program ID";
        UserDefaultStylesheet."Style Sheet ID" := Stylesheet."Style Sheet ID";
        UserDefaultStylesheet.Insert;
    end;

    local procedure StylesheetNameOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

