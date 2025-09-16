#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69009 "HRM-Appraisal Goal Setting"
{
    PageType = List;
    SourceTable = UnknownTable61616;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Planned Targets/Objectives";"Planned Targets/Objectives")
                {
                    ApplicationArea = Basic;
                }
                field("Success Measures";"Success Measures")
                {
                    ApplicationArea = Basic;
                }
                field(Timeline;Timeline)
                {
                    ApplicationArea = Basic;
                }
                field("Support Neede";"Support Neede")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Functions")
            {
                Caption = '&Functions';
            }
        }
        area(processing)
        {
            action("&Next Page")
            {
                ApplicationArea = Basic;
                Caption = '&Next Page';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "HRM-Appraisal Training Develop";
                RunPageLink = "Appraisal No"=field("Appraisal No");

                trigger OnAction()
                begin
                    //FORM.RUNMODAL(39005843
                    //PAGE.RUN(39003985,Rec);
                end;
            }
        }
    }
}

