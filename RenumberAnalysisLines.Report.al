#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7110 "Renumber Analysis Lines"
{
    Caption = 'Renumber Analysis Lines';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartRowRefNo;RowRefNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Row Ref. No.';
                        ToolTip = 'Specifies that the row reference numbers are filled.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message(Text000);
    end;

    trigger OnPreReport()
    begin
        with AnalysisLine do
          if Find('-') then
            repeat
              Validate("Row Ref. No.",RowRefNo);
              Modify;
              RowRefNo := IncStr(RowRefNo);
            until Next = 0;
    end;

    var
        AnalysisLine: Record "Analysis Line";
        RowRefNo: Code[20];
        Text000: label 'The reference numbers were successfully changed.';


    procedure Init(var AnalysisLine2: Record "Analysis Line")
    begin
        AnalysisLine.Copy(AnalysisLine2);
    end;
}

