#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68906 "HRM-Asset Return Form"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Misc. Article Information";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Misc. Article Code";"Misc. Article Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                }
                field("In Use";"In Use")
                {
                    ApplicationArea = Basic;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        EI: Record UnknownRecord61101;


    procedure refresh()
    begin
                        CurrPage.Update(false);
    end;
}

