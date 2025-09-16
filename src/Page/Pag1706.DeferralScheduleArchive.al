#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1706 "Deferral Schedule Archive"
{
    Caption = 'Deferral Schedule Archive';
    DataCaptionFields = "Schedule Description";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "Deferral Header Archive";

    layout
    {
        area(content)
        {
            part("<Deferral Sched. Arch. Subform>";"Deferral Sched. Arch. Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Deferral Doc. Type"=field("Deferral Doc. Type"),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No."),
                              "Doc. No. Occurrence"=field("Doc. No. Occurrence"),
                              "Version No."=field("Version No.");
            }
        }
    }

    actions
    {
    }
}

