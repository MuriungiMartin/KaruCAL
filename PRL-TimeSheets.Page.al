#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68071 "PRL-TimeSheets"
{
    PageType = Card;
    SourceTable = UnknownTable61109;

    layout
    {
        area(content)
        {
            field("Schedule Code";"Schedule Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Primary File Path";"Primary File Path")
            {
                ApplicationArea = Basic;
                Style = Standard;
                StyleExpr = true;
            }
            field("Secondary File Path";"Secondary File Path")
            {
                ApplicationArea = Basic;
                Style = Standard;
                StyleExpr = true;
            }
            field("Delete After Import";"Delete After Import")
            {
                ApplicationArea = Basic;
            }
            label(Control1102755014)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19036653;
            }
            label(Control1102755000)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19075848;
            }
            label(Control1102755001)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19037672;
            }
            label(Control1102755003)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19057798;
            }
        }
    }

    actions
    {
    }

    var
        objOcx: Codeunit "BankAcc.Recon. PostNew";
        Text19057798: label 'e.g   C:\monte\Timesheets\main folder\';
        Text19037672: label 'e.g   E:\monte\Back Up\Timesheets\';
        Text19075848: label 'NB:  if ticked, system deletes the imported files from the "Primary Directory"';
        Text19036653: label 'To view imported details, go to: "Salary Card" > "Other Info" > "Cost Centers"';
}

