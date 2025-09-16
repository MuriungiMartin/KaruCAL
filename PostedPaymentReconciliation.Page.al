#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1295 "Posted Payment Reconciliation"
{
    Caption = 'Posted Payment Reconciliation';
    Editable = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Bank,Matching';
    SaveValues = false;
    SourceTable = "Posted Payment Recon. Hdr";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank account that the posted payment was processed for.';
                }
                field("Statement No.";"Statement No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank statement that contained the line that represented the posted payment.';
                }
            }
            part(StmtLine;"Pstd. Pmt. Recon. Subform")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Lines';
                SubPageLink = "Bank Account No."=field("Bank Account No."),
                              "Statement No."=field("Statement No.");
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
}

