#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68587 "HMS-Radiology Test Line Image"
{
    PageType = Document;
    SourceTable = UnknownTable61420;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Radiology no.";"Radiology no.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Radiology Type Code";"Radiology Type Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Radiology Type Name";"Radiology Type Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Performed Date";"Performed Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Performed Time";"Performed Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Completed;Completed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1102760000;"HMS-Radiology Test Line Images")
            {
                SubPageLink = "Radiology No."=field("Radiology no."),
                              "Radiology Type Code"=field("Radiology Type Code");
            }
        }
    }

    actions
    {
    }
}

