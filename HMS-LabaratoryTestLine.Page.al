#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68581 "HMS-Labaratory Test Line"
{
    PageType = ListPart;
    SourceTable = UnknownTable61417;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Laboratory Test Code";"Laboratory Test Code")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Test Name";"Laboratory Test Name")
                {
                    ApplicationArea = Basic;
                }
                field("Specimen Code";"Specimen Code")
                {
                    ApplicationArea = Basic;
                }
                field("Specimen Name";"Specimen Name")
                {
                    ApplicationArea = Basic;
                }
                field("Collection Date";"Collection Date")
                {
                    ApplicationArea = Basic;
                }
                field("Collection Time";"Collection Time")
                {
                    ApplicationArea = Basic;
                }
                field("Measuring Unit Code";"Measuring Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("Measuring Unit Name";"Measuring Unit Name")
                {
                    ApplicationArea = Basic;
                }
                field("Count Value";"Count Value")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Completed;Completed)
                {
                    ApplicationArea = Basic;
                }
                field(Positive;Positive)
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
            action("Results Parameters")
            {
                ApplicationArea = Basic;
                Caption = 'Results Parameters';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Lab Test Results Parameter";
                RunPageLink = "Laboratory Test Code"=field("Laboratory Test Code"),
                              "Laboratory No."=field("Laboratory No.");

                trigger OnAction()
                begin
                     /*
                    Receip.RESET;
                    Receip.SETRANGE(Receip."Receipt No.","Receipt No.");
                    IF Receip.FIND('-') THEN
                    REPORT.RUN(39005962,TRUE,FALSE,Receip);
                    //REPORT.RUN(39005902,TRUE,FALSE,Receip);
                     */

                end;
            }
        }
    }
}

