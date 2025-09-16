#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 564 "Dimension Selection-Level"
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
                field(Level;Level)
                {
                    ApplicationArea = Suite;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnValidate()
                    var
                        DimSelectBuffer: Record "Dimension Selection Buffer";
                        LevelExists: Boolean;
                    begin
                        if Level <> Level::" " then begin
                          DimSelectBuffer.Copy(Rec);
                          Reset;
                          SetFilter(Code,'<>%1',DimSelectBuffer.Code);
                          SetRange(Level,DimSelectBuffer.Level);
                          LevelExists := not IsEmpty;
                          Copy(DimSelectBuffer);

                          if LevelExists then
                            Error(Text000,FieldCaption(Level));
                        end;
                    end;
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
            }
        }
    }

    actions
    {
    }

    var
        Text000: label 'This %1 already exists.';


    procedure GetDimSelBuf(var TheDimSelectionBuf: Record "Dimension Selection Buffer")
    begin
        TheDimSelectionBuf.DeleteAll;
        if Find('-') then
          repeat
            TheDimSelectionBuf := Rec;
            TheDimSelectionBuf.Insert;
          until Next = 0;
    end;


    procedure InsertDimSelBuf(NewSelected: Boolean;NewCode: Text[30];NewDescription: Text[30];NewDimValueFilter: Text[250];NewLevel: Option)
    var
        Dim: Record Dimension;
        GLAcc: Record "G/L Account";
        BusinessUnit: Record "Business Unit";
        CFAcc: Record "Cash Flow Account";
        CashFlowForecast: Record "Cash Flow Forecast";
    begin
        if NewDescription = '' then
          if Dim.Get(NewCode) then
            NewDescription := Dim.GetMLName(GlobalLanguage);

        Init;
        Selected := NewSelected;
        Code := NewCode;
        Description := NewDescription;
        if NewSelected then begin
          "Dimension Value Filter" := NewDimValueFilter;
          Level := NewLevel;
        end;
        case Code of
          GLAcc.TableCaption:
            "Filter Lookup Table No." := Database::"G/L Account";
          BusinessUnit.TableCaption:
            "Filter Lookup Table No." := Database::"Business Unit";
          CFAcc.TableCaption:
            "Filter Lookup Table No." := Database::"Cash Flow Account";
          CashFlowForecast.TableCaption:
            "Filter Lookup Table No." := Database::"Cash Flow Forecast";
        end;
        Insert;
    end;
}

