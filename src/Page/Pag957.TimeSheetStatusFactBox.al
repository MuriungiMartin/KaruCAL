#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 957 "Time Sheet Status FactBox"
{
    Caption = 'Time Sheet Status';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field(Comment;Comment)
            {
                ApplicationArea = Basic;
                Caption = 'Comment';
            }
            field(OpenQty;OpenQty)
            {
                ApplicationArea = Jobs;
                Caption = 'Open';
                Editable = false;
                ToolTip = 'Specifies the sum of time sheet hours for open time sheets.';
            }
            field(SubmittedQty;SubmittedQty)
            {
                ApplicationArea = Jobs;
                Caption = 'Submitted';
                Editable = false;
                ToolTip = 'Specifies the sum of time sheet hours for submitted time sheets.';
            }
            field(RejectedQty;RejectedQty)
            {
                ApplicationArea = Jobs;
                Caption = 'Rejected';
                Editable = false;
                ToolTip = 'Specifies the sum of time sheet hours for rejected time sheets.';
            }
            field(ApprovedQty;ApprovedQty)
            {
                ApplicationArea = Jobs;
                Caption = 'Approved';
                Editable = false;
                ToolTip = 'Specifies the sum of time sheet hours for approved time sheets.';
            }
            field(TotalQuantity;TotalQuantity)
            {
                ApplicationArea = Jobs;
                Caption = 'Total';
                Editable = false;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the sum of time sheet hours for time sheets of all statuses.';
            }
            field(PostedQty;PostedQty)
            {
                ApplicationArea = Jobs;
                Caption = 'Posted';
                Editable = false;
                ToolTip = 'Specifies the sum of time sheet hours for posted time sheets.';
            }
        }
    }

    actions
    {
    }

    var
        TimeSheetMgt: Codeunit "Time Sheet Management";
        OpenQty: Decimal;
        SubmittedQty: Decimal;
        RejectedQty: Decimal;
        ApprovedQty: Decimal;
        PostedQty: Decimal;
        TotalQuantity: Decimal;
        Comment: Boolean;


    procedure UpdateData(TimeSheetHeader: Record "Time Sheet Header")
    begin
        TimeSheetMgt.CalcStatusFactBoxData(
          TimeSheetHeader,
          OpenQty,
          SubmittedQty,
          RejectedQty,
          ApprovedQty,
          PostedQty,
          TotalQuantity);

        TimeSheetHeader.CalcFields(Comment);
        Comment := TimeSheetHeader.Comment;
        CurrPage.Update(false);
    end;
}

