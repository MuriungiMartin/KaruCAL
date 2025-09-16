#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78014 "HelpDesk (Assigned Issues)"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable78012;
    SourceTableView = where(Status=filter(Closed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sender ID";"Sender ID")
                {
                    ApplicationArea = Basic;
                }
                field(Question;Question)
                {
                    ApplicationArea = Basic;
                }
                field(Response;Response)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Request Date";"Request Date")
                {
                    ApplicationArea = Basic;
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                }
                field(RespondedBy;RespondedBy)
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Personel";"Assigned Personel")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Personel Name";"Assigned Personel Name")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Resolution Date";"Expected Resolution Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Resolution Time";"Expected Resolution Time")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Mark as Closed")
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Closed';
                Image = BankAccountStatement;
                Promoted = true;
                PromotedIsBig = true;
            }
        }
    }
}

