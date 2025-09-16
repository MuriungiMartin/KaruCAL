#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 568 "Dimension Selection"
{
    Caption = 'Dimension Selection';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Dimension Selection Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for the dimension.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the dimension.';
                }
            }
        }
    }

    actions
    {
    }


    procedure GetDimSelCode(): Text[30]
    begin
        exit(Code);
    end;


    procedure InsertDimSelBuf(NewSelected: Boolean;NewCode: Text[30];NewDescription: Text[30])
    var
        Dim: Record Dimension;
        GLAcc: Record "G/L Account";
        BusinessUnit: Record "Business Unit";
    begin
        if NewDescription = '' then begin
          if Dim.Get(NewCode) then
            NewDescription := Dim.GetMLName(GlobalLanguage);
        end;

        Init;
        Selected := NewSelected;
        Code := NewCode;
        Description := NewDescription;
        case Code of
          GLAcc.TableCaption:
            "Filter Lookup Table No." := Database::"G/L Account";
          BusinessUnit.TableCaption:
            "Filter Lookup Table No." := Database::"Business Unit";
        end;
        Insert;
    end;
}

