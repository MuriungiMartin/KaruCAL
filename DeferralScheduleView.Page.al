#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1704 "Deferral Schedule View"
{
    Caption = 'Deferral Schedule View';
    DataCaptionFields = "Start Date";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "Posted Deferral Header";

    layout
    {
        area(content)
        {
            part("<Deferral Shedule View Subform>";"Deferral Schedule View Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Deferral Doc. Type"=field("Deferral Doc. Type"),
                              "Gen. Jnl. Document No."=field("Gen. Jnl. Document No."),
                              "Account No."=field("Account No."),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
            }
        }
    }

    actions
    {
    }
}

