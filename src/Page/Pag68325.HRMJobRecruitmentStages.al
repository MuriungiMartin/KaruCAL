#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68325 "HRM-Job Recruitment Stages"
{
    PageType = ListPart;
    SourceTable = UnknownTable61277;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Recruitment Stage";"Recruitment Stage")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Stage Creteria")
            {
                Caption = 'Stage Creteria';
                action("Recruitment Stage Creteria")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recruitment Stage Creteria';
                    RunObject = Page "PRL-Short Listing Lines";
                    RunPageLink = "Requitment Stage"=field("Recruitment Stage"),
                                  "Job ID"=field("Job ID");
                }
            }
        }
    }
}

