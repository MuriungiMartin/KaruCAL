#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69087 "CAT-Cafe. Rec. List (Filtered)"
{
    CardPageID = "CAT-Cafe. Recpts Card";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61783;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Doc. No.";"Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Recept Total";"Recept Total")
                {
                    ApplicationArea = Basic;
                }
                field(User;User)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
          Rec.SetFilter("Receipt Date",'=%1',Today);
          Rec.SetFilter(User,'=%1',UserId);
    end;
}

