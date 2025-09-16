#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68002 "ELECT Election Result List"
{
    PageType = List;
    SourceTable = UnknownTable61463;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Election;Election)
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student name";"Student name")
                {
                    ApplicationArea = Basic;
                }
                field(ElectionName;ElectionName)
                {
                    ApplicationArea = Basic;
                }
                field(Voted;Voted)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Time;Time)
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

