#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 608 "IC Partner List"
{
    ApplicationArea = Basic;
    Caption = 'IC Partner List';
    CardPageID = "IC Partner Card";
    Editable = false;
    PageType = List;
    SourceTable = "IC Partner";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Inbox Type";"Inbox Type")
                {
                    ApplicationArea = Basic;
                }
                field("Inbox Details";"Inbox Details")
                {
                    ApplicationArea = Basic;
                }
                field("Receivables Account";"Receivables Account")
                {
                    ApplicationArea = Basic;
                }
                field("Payables Account";"Payables Account")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("IC &Partner")
            {
                Caption = 'IC &Partner';
                Image = ICPartner;
                action("Dimensions-Single")
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions-Single';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(413),
                                  "No."=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                }
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        Partner: Record "IC Partner";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Partner);
        exit(SelectionFilterManagement.GetSelectionFilterForICPartner(Partner));
    end;
}

