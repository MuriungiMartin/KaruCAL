#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68892 "HRM-Appraisal Evaluation Areas"
{
    PageType = List;
    SourceTable = UnknownTable61236;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = true;
                field("Categorize As";"Categorize As")
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field("Sub Category";"Sub Category")
                {
                    ApplicationArea = Basic;
                }
                field(Group;Group)
                {
                    ApplicationArea = Basic;
                }
                field("Assign To";"Assign To")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Include in Evaluation Form";"Include in Evaluation Form")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

