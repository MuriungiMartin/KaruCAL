#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5991 "Troubleshooting List"
{
    ApplicationArea = Basic;
    Caption = 'Troubleshooting List';
    CardPageID = Troubleshooting;
    Editable = false;
    PageType = List;
    SourceTable = "Troubleshooting Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the troubleshooting issue.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the troubleshooting issue.';
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
        area(navigation)
        {
            group("T&roublesh.")
            {
                Caption = 'T&roublesh.';
                Image = Setup;
                action(Setup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup';
                    Image = Setup;

                    trigger OnAction()
                    begin
                        TblshtgSetup.Reset;
                        TblshtgSetup.SetCurrentkey("Troubleshooting No.");
                        TblshtgSetup.SetRange("Troubleshooting No.","No.");
                        Page.RunModal(Page::"Troubleshooting Setup",TblshtgSetup)
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        TblshtgSetup: Record "Troubleshooting Setup";
}

