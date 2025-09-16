#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77361 "ACA-NewStud_Document Setup"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable77361;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Code";"Document Code")
                {
                    ApplicationArea = Basic;
                    OptionCaption = 'ID/Birth Certificate,KCPE Certificate,KCSE Certificate/Result Slip,Letter of Acceptance,Medical Form,Library User Form,NHIF Card,Bank Slip,Image Consent Form';
                }
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic;
                }
                field("Next Sequence";"Next Sequence")
                {
                    ApplicationArea = Basic;
                }
                field("First Stage";"First Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Final Stage";"Final Stage")
                {
                    ApplicationArea = Basic;
                }
                field(Mandatory;Mandatory)
                {
                    ApplicationArea = Basic;
                }
                field(Approvers;Approvers)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Is Hostel";"Is Hostel")
                {
                    ApplicationArea = Basic;
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic;
                }
                field("Signoff Caption";"Signoff Caption")
                {
                    ApplicationArea = Basic;
                }
                field("Hide in Report";"Hide in Report")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

