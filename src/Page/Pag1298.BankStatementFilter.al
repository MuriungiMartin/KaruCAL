#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1298 "Bank Statement Filter"
{
    Caption = 'Bank Statement Filter';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(FromDate;FromDate)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'From Date';
                ToolTip = 'Specifies the first date that the bank statement must contain transactions for.';
            }
            field(ToDate;ToDate)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'To Date';
                ToolTip = 'Specifies the last date that the bank statement must contain transactions for.';
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not (CloseAction in [Action::OK,Action::LookupOK]) then
          exit(true);

        if FromDate > ToDate then begin
          Message(DateInputTxt);
          exit(false);
        end;
    end;

    var
        FromDate: Date;
        ToDate: Date;
        DateInputTxt: label 'The value in the From Date field must not be greater than the value in the To Date field.';


    procedure GetDates(var ResultFromDate: Date;var ResultToDate: Date)
    begin
        ResultFromDate := FromDate;
        ResultToDate := ToDate;
    end;


    procedure SetDates(NewFromDate: Date;NewToDate: Date)
    begin
        if NewFromDate > NewToDate then
          Error(DateInputTxt);

        FromDate := NewFromDate;
        ToDate := NewToDate;
    end;
}

