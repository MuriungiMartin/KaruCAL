#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 567 "Dimension Selection-Change"
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
                field(Selected;Selected)
                {
                    ApplicationArea = Suite;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                }
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
                field("Dimension Value Filter";"Dimension Value Filter")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a filter by which dimensions values will be shown.';
                }
                field("New Dimension Value Code";"New Dimension Value Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the new dimension value to that you are changing to.';
                }
            }
        }
    }

    actions
    {
    }


    procedure GetDimSelBuf(var TheDimSelectionBuf: Record "Dimension Selection Buffer")
    begin
        TheDimSelectionBuf.DeleteAll;
        if Find('-') then
          repeat
            TheDimSelectionBuf := Rec;
            TheDimSelectionBuf.Insert;
          until Next = 0;
    end;


    procedure InsertDimSelBuf(NewSelected: Boolean;NewCode: Text[30];NewDescription: Text[30];NewNewDimValueCode: Code[20];NewDimValueFilter: Text[250])
    var
        Dim: Record Dimension;
        GLAcc: Record "G/L Account";
        BusinessUnit: Record "Business Unit";
    begin
        if NewDescription = '' then begin
          if Dim.Get(NewCode) then
            NewDescription := Dim.Name;
        end;

        Init;
        Selected := NewSelected;
        Code := NewCode;
        Description := NewDescription;
        if NewSelected then begin
          "New Dimension Value Code" := NewNewDimValueCode;
          "Dimension Value Filter" := NewDimValueFilter;
        end;
        case Code of
          GLAcc.TableCaption:
            "Filter Lookup Table No." := Database::"G/L Account";
          BusinessUnit.TableCaption:
            "Filter Lookup Table No." := Database::"Business Unit";
        end;
        Insert;
    end;
}

