#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78030 StudUnits
{
    PageType = List;
    SourceTable = UnknownTable61549;
    SourceTableView = where(Semester=filter("SEM2 19/20"),
                            "Balance Due"=filter(>0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field("Balance Due";"Balance Due")
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

