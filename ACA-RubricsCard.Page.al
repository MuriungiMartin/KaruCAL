#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 86250 "ACA-Rubrics Card"
{
    PageType = Card;
    SourceTable = UnknownTable61739;
    SourceTableView = where("Special Programme Class"=filter(General));

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Transcript Remarks";"Transcript Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Final Year Comment";"Final Year Comment")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Manual Status Processing";"Manual Status Processing")
                {
                    ApplicationArea = Basic;
                }
                field("Order No";"Order No")
                {
                    ApplicationArea = Basic;
                }
                field("Status Msg1";"Status Msg1")
                {
                    ApplicationArea = Basic;
                }
                field("Status Msg2";"Status Msg2")
                {
                    ApplicationArea = Basic;
                }
                field("Status Msg3";"Status Msg3")
                {
                    ApplicationArea = Basic;
                }
                field("Status Msg4";"Status Msg4")
                {
                    ApplicationArea = Basic;
                }
                field("Status Msg5";"Status Msg5")
                {
                    ApplicationArea = Basic;
                }
                field("Status Msg6";"Status Msg6")
                {
                    ApplicationArea = Basic;
                }
                field("1st Year Grad. Comments";"1st Year Grad. Comments")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Year Grad. Comments";"2nd Year Grad. Comments")
                {
                    ApplicationArea = Basic;
                }
                field("3rd Year Grad. Comments";"3rd Year Grad. Comments")
                {
                    ApplicationArea = Basic;
                }
                field("4th Year Grad. Comments";"4th Year Grad. Comments")
                {
                    ApplicationArea = Basic;
                }
                field("5th Year Grad. Comments";"5th Year Grad. Comments")
                {
                    ApplicationArea = Basic;
                }
                field("6th Year Grad. Comments";"6th Year Grad. Comments")
                {
                    ApplicationArea = Basic;
                }
                field("7th Year Grad. Comments";"7th Year Grad. Comments")
                {
                    ApplicationArea = Basic;
                }
                field("Finalists Grad. Comm. Degree";"Finalists Grad. Comm. Degree")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Units Failed";"Minimum Units Failed")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Units Failed";"Maximum Units Failed")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Summary Page Caption";"Summary Page Caption")
                {
                    ApplicationArea = Basic;
                }
                field("Include Failed Units Headers";"Include Failed Units Headers")
                {
                    ApplicationArea = Basic;
                }
                field("Min/Max Based on";"Min/Max Based on")
                {
                    ApplicationArea = Basic;
                }
                field("Include Academic Year Caption";"Include Academic Year Caption")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year Text";"Academic Year Text")
                {
                    ApplicationArea = Basic;
                }
                field(Pass;Pass)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Special Programme Class":="special programme class"::General;
    end;
}

