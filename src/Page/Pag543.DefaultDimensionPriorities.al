#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 543 "Default Dimension Priorities"
{
    ApplicationArea = Basic;
    Caption = 'Default Dimension Priorities';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Default Dimension Priority";
    SourceTableView = sorting("Source Code",Priority);
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CurrentSourceCode;CurrentSourceCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Code';
                    Lookup = true;
                    TableRelation = "Source Code".Code;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SaveRecord;
                        LookupSourceCode(CurrentSourceCode,Rec);
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    var
                        SourceCode: Record "Source Code";
                    begin
                        SourceCode.Get(CurrentSourceCode);
                        CurrentSourceCodeOnAfterValida;
                    end;
                }
            }
            repeater(Control1)
            {
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the table ID for the account type, if you want to prioritize an account type.';

                    trigger OnValidate()
                    begin
                        TableIDOnAfterValidate;
                    end;
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the table name for the account type you wish to prioritize.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority of an account type, with the highest priority being 1.';

                    trigger OnValidate()
                    begin
                        PriorityOnAfterValidate;
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

    trigger OnAfterGetRecord()
    begin
        PriorityOnFormat(Format(Priority));
    end;

    trigger OnOpenPage()
    begin
        OpenSourceCode(CurrentSourceCode,Rec);
    end;

    var
        Text000: label '<auto>';
        Text001: label 'You need to define a source code.';
        CurrentSourceCode: Code[20];

    local procedure OpenSourceCode(var CurrentSourceCode: Code[20];var DefaultDimPriority: Record "Default Dimension Priority")
    begin
        CheckSourceCode(CurrentSourceCode);
        with DefaultDimPriority do begin
          FilterGroup := 2;
          SetRange("Source Code",CurrentSourceCode);
          FilterGroup := 0;
        end;
    end;

    local procedure CheckSourceCode(var CurrentSourceCode: Code[20])
    var
        SourceCode: Record "Source Code";
    begin
        if not SourceCode.Get(CurrentSourceCode) then
          if SourceCode.FindFirst then
            CurrentSourceCode := SourceCode.Code
          else
            Error(Text001);
    end;


    procedure SetSourceCode(CurrentSourceCode: Code[20];var DefaultDimPriority: Record "Default Dimension Priority")
    begin
        with DefaultDimPriority do begin
          FilterGroup := 2;
          SetRange("Source Code",CurrentSourceCode);
          FilterGroup := 0;
          if Find('-') then;
        end;
    end;

    local procedure LookupSourceCode(var CurrentSourceCode: Code[20];var DefaultDimPriority: Record "Default Dimension Priority")
    var
        SourceCode: Record "Source Code";
    begin
        Commit;
        SourceCode.Code := DefaultDimPriority.GetRangemax("Source Code");
        if Page.RunModal(0,SourceCode) = Action::LookupOK then begin
          CurrentSourceCode := SourceCode.Code;
          SetSourceCode(CurrentSourceCode,DefaultDimPriority);
        end;
    end;

    local procedure TableIDOnAfterValidate()
    begin
        CalcFields("Table Caption");
    end;

    local procedure PriorityOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure CurrentSourceCodeOnAfterValida()
    begin
        CurrPage.SaveRecord;
        SetSourceCode(CurrentSourceCode,Rec);
        CurrPage.Update(false);
    end;

    local procedure PriorityOnFormat(Text: Text[1024])
    begin
        if Priority = 0 then
          Text := Text000;
    end;
}

