#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68440 "HRM-Appraisal Formats"
{
    PageType = ListPart;
    SourceTable = UnknownTable61326;
    SourceTableView = sorting("Appraisal Code",Sequence)
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("In Put";"In Put")
                {
                    ApplicationArea = Basic;
                }
                field("Entry By";"Entry By")
                {
                    ApplicationArea = Basic;
                }
                field("After Entry Of Prev. Group";"After Entry Of Prev. Group")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Previous Groups Rights";"Allow Previous Groups Rights")
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

